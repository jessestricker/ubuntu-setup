import subprocess
import sys
from typing import NoReturn
from pathlib import Path
from datetime import datetime

SUPPORTED_DISTROS = {"debian", "ubuntu"}
REPO_AND_SUITE_FMTS = {
    "debian": [
        "http://deb.debian.org/debian {0}",
        "http://deb.debian.org/debian-security/ {0}/updates",
        "http://deb.debian.org/debian {0}-updates",
        "http://deb.debian.org/debian {0}-backports",
    ],
    "ubuntu": [
        "http://archive.ubuntu.com/ubuntu {0}",
        "http://archive.ubuntu.com/ubuntu {0}-security",
        "http://archive.ubuntu.com/ubuntu {0}-updates",
        "http://archive.ubuntu.com/ubuntu {0}-backports",
    ],
}
COMPONENTS = {
    "debian": ["main", "contrib", "non-free"],
    "ubuntu": ["main", "restricted", "universe", "multiverse"],
}
SOURCE_FILE_PATH = Path("/etc/apt/sources.list")

assert set(REPO_AND_SUITE_FMTS.keys()) == SUPPORTED_DISTROS
assert set(COMPONENTS.keys()) == SUPPORTED_DISTROS


def run_cmd(cmdline: str) -> str:
    proc = subprocess.run(cmdline.split(), capture_output=True, check=True, text=True)
    return str(proc.stdout).strip()


def exit_error(msg: str) -> NoReturn:
    print(f"error: {msg}", file=sys.stderr)
    exit(1)


def main():
    # gather distro information
    distro = run_cmd("lsb_release --short --id").lower()
    code_name = run_cmd("lsb_release --short --codename").lower()

    if distro not in SUPPORTED_DISTROS:
        exit_error(f"distro {distro} is not supported")

    print("distro:", distro)
    print("code name:", code_name)

    # build source.list file lines
    repo_and_suites = [fmt.format(code_name) for fmt in REPO_AND_SUITE_FMTS[distro]]
    lines = []
    for repo_and_suite in repo_and_suites:
        components = " ".join(COMPONENTS[distro])
        line = f"deb {repo_and_suite} {components}"
        lines += [line]

    print("proposed source.list:")
    for line in lines:
        print(f"    {line}")

    # write to file
    ans = input(f"back up and overwrite {SOURCE_FILE_PATH}? [y/n]: ")
    if ans.lower() != "y":
        print("aborted by user")
        exit(1)

    date_str = datetime.utcnow().strftime("%Y-%m-%d_%H-%M-%S_UTC")
    bak_path = SOURCE_FILE_PATH.with_suffix(f".list.bak_{date_str}")
    SOURCE_FILE_PATH.rename(bak_path)
    print(f"backed up to {bak_path}")

    with open(SOURCE_FILE_PATH, "w") as f:
        for line in lines:
            f.write(line + "\n")


if __name__ == "__main__":
    main()
