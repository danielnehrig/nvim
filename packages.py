#!/usr/bin/env python

import subprocess
import os
import sys
from typing import TypedDict
from typing import Union
from getpass import getuser
from datetime import datetime
from distutils.spawn import find_executable

# Modes available to Package managers
class Modes(TypedDict):
    # Install Packages
    install: str
    # Update Packages hint: update can also be install as a value
    # becouse some package managers don't do update commands
    # might make this optional
    update: str


class PackageManager(TypedDict):
    # cli tool name (package manager name)
    cli_tool: str
    # index[0] is the package name index[1] is the bin name in path
    packages: list[tuple[str, Union[str, None]]]
    # the mode key is the internal compression check for behaviour in doing cli commands
    # on a package manager and the value is the command passed to the package manager
    modes: Modes
    # dependencies list that have nothing to do with binarys
    dependencies: Union[list[str], None]


# Node NPM Package Manager
node: PackageManager = {
    "cli_tool": "npm",
    "modes": {"install": "install -g", "update": "upgrade -g"},
    "packages": [
        ("typescript-language-server", "typescript-language-server"),
        ("vscode-html-languageserver-bin", "html-languageserver"),
        ("vscode-langservers-extracted", "vscode-css-language-server"),
        ("svelte-language-server", "svelteserver"),
        ("bash-language-server", "bash-language-server"),
        ("yaml-language-server", "yaml-language-server"),
        ("intelephense", "intelephense"),
        ("dockerfile-language-server-nodejs", "docker-langserver"),
        ("dprint", "dprint"),
        ("pyright", "pyright"),
        ("@fsouza/prettierd", "prettierd"),
        ("eslint_d", "eslint_d"),
    ],
    "dependencies": None,
}

# Go Go Package Manager
go: PackageManager = {
    "cli_tool": "go",
    "modes": {"install": "install", "update": "install"},
    "packages": [
        ("mvdan.cc/sh/v3/cmd/shfmt@latest", "shfmt"),
        ("github.com/mattn/efm-langserver@latest", "efm-langserver"),
        ("golang.org/x/tools/gopls@latest", "gopls"),
        ("golang.org/x/tools/cmd/goimports@latest", "goimports"),
        ("github.com/segmentio/golines@latest", "golines"),
    ],
    "dependencies": None,
}

# Rust Cargo Package Manager
rust: PackageManager = {
    "cli_tool": "cargo",
    "modes": {"install": "install", "update": "install"},
    "packages": [("blackd-client", "blackd-client"), ("stylua", "stylua")],
    "dependencies": None,
}

# Rustup for rust lsp
rust_up: PackageManager = {
    "cli_tool": "rustup",
    "modes": {"install": "+nightly component add", "update": "+nightly update"},
    "packages": [("rust-analyzer-preview", "rust-analyzer-preview")],
    "dependencies": None,
}

# Rustup for rust lsp
lua: PackageManager = {
    "cli_tool": "luarocks",
    "modes": {"install": "--local install", "update": "--local install"},
    "packages": [("luacheck", "luacheck")],
    "dependencies": None,
}

# Python PIP Package Manager
python: PackageManager = {
    "cli_tool": "pip",
    "modes": {"install": "install", "update": "install"},
    "packages": [
        ("black", "black"),
        ("aiohttp", None),
        ("aiohttp_cors", None),
    ],
    "dependencies": None,
}

# Arch community package manager (uses pacman internally)
yay: PackageManager = {
    "cli_tool": "yay",
    "modes": {
        "install": "--save --answerclean=All --answerdiff=None -S",
        "update": "--save --answerclean=All --answerdiff=None -Yu",
    },
    "packages": [
        ("nuspell", "nuspell"),
        ("hunspell-en_us", None),
        ("hunspell-de", None),
        ("jdtls", "jdtls"),
        ("groovy-language-server", "groovy-language-server"),
        ("dotnet-sdk", "dotnet"),
    ],
    "dependencies": None,
}

darwin_setup = [node, rust, rust_up, go, lua, python]
linux_setup = [yay, node, rust, rust_up, go, lua, python]
windows_setup = [node, rust, rust_up, go, lua, python]

steps: int = (
    len(python["packages"])
    + len(rust["packages"])
    + len(rust_up["packages"])
    + len(lua["packages"])
    + len(go["packages"])
    + len(node["packages"])
)
now: datetime = datetime.now()
current_time: str = now.strftime("%H:%M:%S")
current_folder: str = os.path.abspath(os.getcwd())
user: str = getuser()
home: str = "{0}{1}".format(os.environ.get("HOME"), "/")
dap_path: str = home + ".local/share/nvim/dapinstall/"
lsp_path: str = home + ".local/share/nvim/lsp/"

arrow: str = "==>"


class Colors:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


class Log(Colors):
    user: str = getuser()
    counter: int = 1
    # TODO
    loglevel: str = "info"

    def now(self) -> str:
        time: datetime = datetime.now()
        return time.strftime("%H:%M:%S")

    def buildLogString(self, kind: str, color: str) -> str:
        start: str = "{2} {0} " + color + "{1}:" + kind + "\t" + self.ENDC
        attach: str = self.BOLD + "\t--> {3}" + self.ENDC
        return start + attach

    def buildStepString(self, kind: str, color: str) -> str:
        start: str = "{2} {0} " + color + "{1}:" + kind + "\t{4}/" + "{5}" + self.ENDC
        attach: str = self.BOLD + "\t--> {3}" + self.ENDC
        return start + attach

    def Success(self, string: str) -> None:
        st: str = self.buildStepString("SUCCESS", self.OKGREEN)
        print(st.format(self.now(), self.user, arrow, string, self.counter, steps))
        self.counter = self.counter + 1

    def Warning(self, string: str) -> None:
        st: str = self.buildLogString("WARNING", self.WARNING)
        print(st.format(self.now(), self.user, arrow, string))

    def Error(self, string: str) -> None:
        st: str = self.buildLogString("ERROR", self.FAIL)
        print(st.format(self.now(), self.user, arrow, string))

    def Critical(self, string: str) -> None:
        st: str = self.buildLogString("CRITICAL", self.FAIL)
        print(st.format(self.now(), self.user, arrow, string))

    def Info(self, string: str) -> None:
        st: str = self.buildLogString("INFO", self.OKBLUE)
        print(st.format(self.now(), self.user, arrow, string))

    def Skip(self, string: str) -> None:
        st: str = self.buildStepString("SKIP", self.OKBLUE)
        print(st.format(self.now(), self.user, arrow, string, self.counter, steps))
        self.counter = self.counter + 1

    def Step(self, string: str) -> None:
        st: str = self.buildStepString("STEP", self.OKBLUE)
        print(st.format(self.now(), self.user, arrow, string, self.counter, steps))


log: Log = Log()


def cmd(call: str) -> None:
    try:
        log.Info("Executing {0}{1}{2}".format(Colors.WARNING, call, Colors.ENDC))
        cmdArr = call.split()
        with open(os.devnull, "w") as f:
            subprocess.call(cmdArr, stdout=f)
            f.close()
    except subprocess.CalledProcessError as err:
        log.Error("Failed to execute {0}".format(call))
        log.Error("Trace {0}".format(err))


def in_path(cmd: str) -> bool:
    inPath = False
    try:
        inPath = find_executable(cmd) is not None
    except subprocess.CalledProcessError as e:
        log.Error(
            "Call Check {0} Failed with return code {1}".format(cmd, e.returncode)
        )

    return inPath


def install_cli_packages(package_manager: PackageManager):
    if not in_path(package_manager["cli_tool"]):
        log.Error(
            "{0}{1}{2} not in path skipping installing".format(
                Colors.FAIL, package_manager["cli_tool"]
            )
        )
        return
    mode = get_package_mode()
    for package in package_manager["packages"]:
        install = "{0} {1} {2}".format(
            package_manager["cli_tool"], package_manager["modes"][mode], package[0]
        )
        try:
            if package[1]:
                inPath = in_path(package[1])
            else:
                inPath = False
            isForce = mode == "update" and True or False
            for _, option in enumerate(sys.argv):
                if option == "--force":
                    isForce = True

            if not inPath or isForce:
                log.Info(
                    "Installing CLI Package {0}{1}".format(Colors.OKGREEN, package[0])
                )
                cmd(install)
                log.Success(
                    "Success Installing package {0}{1}".format(
                        Colors.OKGREEN, package[0]
                    )
                )
            else:
                log.Skip(
                    "CLI Package {0}{1}{2} in path".format(
                        Colors.OKBLUE, package[0], Colors.ENDC
                    )
                )
        except subprocess.CalledProcessError as e:
            log.Error(
                "Failed to install {0}{1}{2} with code {3}".format(
                    Colors.FAIL, package, Colors.ENDC, e.returncode
                )
            )


def Darwin() -> None:
    for manager in darwin_setup:
        install_cli_packages(manager)


def Cygwin() -> None:
    log.Error("Not Supported")


def Linux() -> None:
    for manager in linux_setup:
        install_cli_packages(manager)


def Win32() -> None:
    for manager in windows_setup:
        install_cli_packages(manager)


def help() -> None:
    for option in sys.argv:
        if option == "--help" or option == "-h":
            print("Usage:")
            print("  ./packages.py [OPTIONS]")
            print("")
            print("OPTIONS:")
            print(
                "  --force, -f\t| will force install without check if already installed\n"
                "  --update, -u\t| will update packages\n"
            )
            sys.exit(0)


def get_package_mode() -> str:
    mode = "install"
    for option in sys.argv:
        if option == "--update" or option == "-u":
            mode = "update"

    return mode


if __name__ == "__main__":
    log.Info("Detected system is {0}".format(sys.platform))
    help()

    try:
        if sys.platform == "win32":
            Win32()

        if sys.platform == "cygwin":
            Cygwin()

        if sys.platform == "darwin":
            Darwin()

        if sys.platform == "linux":
            Linux()

    except:
        log.Error("Error While Installing")
