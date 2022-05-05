#!/usr/bin/env python

import subprocess
import traceback
import os
import sys
from typing import TypedDict, Union, Callable
from getpass import getuser
from datetime import datetime


def which(program):
    import os

    def is_exe(fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, _ = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None


def cmd(call: str) -> int:
    try:
        log.Info("Executing {0}{1}{2}".format(Colors.WARNING, call, Colors.ENDC))
        cmdArr = call.split()
        with open(os.devnull, "w") as f:
            # subprocess.call(cmdArr, stdout=f)
            result = subprocess.call(
                cmdArr, shell=True, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL
            )
            f.close()
            return result
    except subprocess.CalledProcessError as err:
        log.Error("Failed to execute {0}".format(call))
        log.Error("Trace {0}".format(err))
        return err.returncode


# Modes available to Package managers
class Modes(TypedDict):
    # Install Packages
    install: str
    # Update Packages hint: update can also be install as a value
    # becouse some package managers don't do update commands
    # might make this optional
    update: str


# CliOptions struct
class CliOptions(TypedDict):
    sudo: tuple[bool, str]
    update: bool
    force: bool
    uninstall: bool
    mode: str


cli_options: CliOptions = {
    "sudo": (
        True if "--sudo" or "-s" in sys.argv else False,
        sys.argv[sys.argv.index("--sudo") + 1] if "--sudo" in sys.argv else "",
    ),
    "update": True if "--update" or "-u" in sys.argv else False,
    "force": True if "--force" or "-f" in sys.argv else False,
    "mode": "update" if "--update" in sys.argv else "install",
    "uninstall": True if "--uninstall" in sys.argv else False,
}

# The PackageManger that installs your packages
class PackageManagerDict(TypedDict):
    # cli tool name (package manager name)
    cli_tool: str
    # index[0] is the package name index[1] is the bin name in path
    packages: list[tuple[str, Union[str, None]]]
    # the mode key is the internal compression check for behaviour in doing cli commands
    # on a package manager and the value is the command passed to the package manager
    modes: Modes
    # dependencies list that has nothing to do with binarys but are rather libs
    dependencies: Union[list[str], None]


# This Manager offers the ability to use custom installers as well as generic cones
# obviously not every package manager has the same way to display what kind of lib has been installed
# while with binarys its easier where you can just check if its in path
class PackageManager:
    package_manager: PackageManagerDict
    dependencies_installer: Union[Callable, None] = None

    def __init__(
        self,
        package_manager: PackageManagerDict,
        dependencies_installer: Union[Callable, None] = None,
    ):
        self.package_manager = package_manager
        self.dependencies_installer = dependencies_installer

    def install_cli_packages(self):
        if not which(self.package_manager["cli_tool"]):
            log.Error(
                "{0}{1} not in path skipping installing".format(
                    Colors.FAIL, self.package_manager["cli_tool"]
                )
            )
            return
        mode = cli_options["mode"]

        sudo = ""
        if self.package_manager["cli_tool"] == "yay":
            if cli_options["sudo"][0]:
                sudo = "sudo -u {0} ".format(cli_options["sudo"][1])

        for package in self.package_manager["packages"]:
            install = "{0}{1} {2} {3}".format(
                sudo,
                self.package_manager["cli_tool"],
                self.package_manager["modes"][mode],
                package[0],
            )
            try:
                if package[1]:
                    inPath = which(package[1])
                else:
                    inPath = False

                isForce = cli_options["force"] or cli_options["update"]

                if not inPath or isForce:
                    log.Info(
                        "Installing CLI Package {0}{1}".format(
                            Colors.OKGREEN, package[0]
                        )
                    )
                    cmd(install)
                    log.Success(
                        "Success Installing package {0}{1}".format(
                            Colors.OKGREEN, package[0]
                        )
                    )
                else:
                    log.Skip(
                        "CLI Package {0}{1}{2} in path SKIP".format(
                            Colors.OKBLUE, package[0], Colors.ENDC
                        )
                    )
            except subprocess.CalledProcessError as e:
                log.Error(
                    "Failed to install {0}{1}{2} with code {3}".format(
                        Colors.FAIL, package, Colors.ENDC, e.returncode
                    )
                )


# Node NPM Package Manager
node: PackageManager = PackageManager(
    {
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
            ("neovim", None),
            ("@fsouza/prettierd", "prettierd"),
            ("eslint_d", "eslint_d"),
        ],
        "dependencies": ["neovim"],
    }
)

# Go Go Package Manager
go: PackageManager = PackageManager(
    {
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
)

# Rust Cargo Package Manager
rust: PackageManager = PackageManager(
    {
        "cli_tool": "cargo",
        "modes": {"install": "install", "update": "install"},
        "packages": [
            ("blackd-client", "blackd-client"),
            ("stylua", "stylua"),
            ("rslint_cli", "rslint"),
        ],
        "dependencies": None,
    }
)

# Rustup for rust lsp
rust_up: PackageManager = PackageManager(
    {
        "cli_tool": "rustup",
        "modes": {"install": "+nightly component add", "update": "+nightly update"},
        "packages": [("rust-analyzer-preview", None)],
        "dependencies": None,
    }
)

# Rustup for rust lsp
lua: PackageManager = PackageManager(
    {
        "cli_tool": "luarocks",
        "modes": {"install": "--local install", "update": "--local install"},
        "packages": [("luacheck", "luacheck")],
        "dependencies": None,
    }
)


def py_dep():
    result = cmd("pip3.9 list | grep 'NOPE'")
    print(result)


# Python PIP Package Manager
python: PackageManager = PackageManager(
    {
        "cli_tool": "pip",
        "modes": {"install": "install", "update": "install"},
        "packages": [
            ("black", "black"),
            ("pynvim", None),
            ("aiohttp", None),
            ("aiohttp_cors", None),
        ],
        "dependencies": ["pynvim", "aiohttp", "aiohttp_cors"],
    }
)

# lua-language-server
brew = PackageManager(
    {
        "cli_tool": "brew",
        "modes": {"install": "install", "update": "update"},
        "packages": [
            ("lua-language-server", "lua-language-server"),
        ],
        "dependencies": None,
    }
)

# Arch community package manager (uses pacman internally)
yay: PackageManager = PackageManager(
    {
        "cli_tool": "yay",
        "modes": {
            "install": "--save --nocleanmenu --nodiffmenu --noconfirm -S",
            "update": "--save --nocleanmenu --nodiffmenu --noconfirm -Yu",
        },
        "packages": [
            ("nuspell", "nuspell"),
            ("hunspell-en_us", None),
            ("hunspell-de", None),
            ("jdtls", "jdtls"),
            ("groovy-language-server", "groovy-language-server"),
            ("lua-language-server", "lua-language-server"),
            ("dotnet-sdk", "dotnet"),
        ],
        "dependencies": None,
    }
)


class SysManager:
    package_list: list[PackageManager]
    os: str

    def is_cli_packages_installed(self):
        for list in self.package_list:
            for package in list.package_manager["packages"]:
                if package[1]:
                    if not which(package[1]):
                        log.Warning("Binary {} not found in path".format(package[1]))

    def count_packages(self) -> int:
        steps: int = 0
        for list in self.package_list:
            for _ in list.package_manager["packages"]:
                steps = steps + 1
        return steps

    def __init__(self, os: str, package_list: list[PackageManager]):
        self.os = os
        self.package_list = package_list


darwin_setup = SysManager("darwin", [brew, node, rust, rust_up, go, lua, python])
linux_setup = SysManager("linux", [yay, node, rust, rust_up, go, lua, python])
windows_setup = SysManager("win32", [node, rust, rust_up, go, lua, python])
supported_os = [darwin_setup, linux_setup, windows_setup]

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
    counter: int = 1
    max_steps: int = 0
    skip: int = 0

    def set_max_step(self, steps: int):
        self.max_steps = steps

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
        print(st.format(self.now(), user, arrow, string, self.counter, self.max_steps))
        self.counter = self.counter + 1

    def Warning(self, string: str) -> None:
        st: str = self.buildLogString("WARNING", self.WARNING)
        print(st.format(self.now(), user, arrow, string))

    def Error(self, string: str) -> None:
        st: str = self.buildLogString("ERROR", self.FAIL)
        print(st.format(self.now(), user, arrow, string))

    def Info(self, string: str) -> None:
        st: str = self.buildLogString("INFO", self.OKBLUE)
        print(st.format(self.now(), user, arrow, string))

    def Skip(self, string: str) -> None:
        st: str = self.buildStepString("SUCCESS", self.OKGREEN)
        print(st.format(self.now(), user, arrow, string, self.counter, self.max_steps))
        self.counter = self.counter + 1
        self.skip = self.skip + 1

    def Step(self, string: str) -> None:
        st: str = self.buildStepString("STEP", self.OKBLUE)
        print(st.format(self.now(), user, arrow, string, self.counter, self.max_steps))


log: Log = Log()


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
                "  --uninstall, -u\t| will uninstall all packages\n"
                "  --sudo [user], -u\t| run yay as sudo\n"
            )
            sys.exit(0)


def main():
    help()
    log.Info("Detected system is {0}".format(sys.platform))

    try:

        for sysmanager in supported_os:
            if sysmanager.os == sys.platform:
                log.set_max_step(sysmanager.count_packages())
                for manager in sysmanager.package_list:
                    manager.install_cli_packages()

                    if manager.dependencies_installer:
                        manager.dependencies_installer()

                sysmanager.is_cli_packages_installed()

                if log.skip > (log.max_steps / 2):
                    log.Info(
                        "Consider Updating Packages that got skipped with the --update flag"
                    )

                return
        log.Error("{0} is not Supported".format(sys.platform))

    except Exception as err:
        log.Error("Error While Installing: {0}".format(err))
        log.Error("{0}".format(traceback.print_exc()))
        sys.exit(1)


if __name__ == "__main__":
    main()
