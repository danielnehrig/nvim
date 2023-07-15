#!/usr/bin/env python3

import subprocess
import traceback
import os
import sys
from typing import TypedDict, Union
from getpass import getuser
from datetime import datetime


# run a command
def cmd(call: str) -> bool:
    # find in call if there is a "|" if yes error
    # this is due to the fact how python handles call we would need  to do a command chain with stdout=subprocess.PIPE
    if "|" in call:
        log.Error("Piping is not supported")
        return False

    try:
        cmdArr = call.split()
        stdout = subprocess.DEVNULL
        exit_code = 1

        if cli_options["debug"]:
            exit_code = subprocess.call(cmdArr)
        else:
            exit_code = subprocess.call(
                cmdArr, stderr=subprocess.DEVNULL, stdout=stdout
            )

        if exit_code == 0:
            return True

        log.Error("Failed to {0}".format(call))
        return False
    except subprocess.CalledProcessError as err:
        log.Error("Failed to execute {0}".format(call))
        log.Error("Trace {0}".format(err))
        return False


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
    debug: bool


cli_options: CliOptions = {
    "sudo": (
        True if "--sudo" in sys.argv else False,
        sys.argv[sys.argv.index("--sudo") + 1] if "--sudo" in sys.argv else "",
    ),
    "debug": True if "--debug" in sys.argv else False,
    "update": True if "--update" in sys.argv else False,
    "force": True if "--force" in sys.argv else False,
    "mode": "update" if "--update" in sys.argv else "install",
    "uninstall": True if "--uninstall" in sys.argv else False,
}


# The PackageManger that installs your packages
class PackageManagerDict(TypedDict):
    # cli tool name (package manager name)
    cli_tool: str
    # index[0] is the package name index[1] is the bin name in path or None if dependency
    packages: list[tuple[str, Union[str, None]]]
    # the mode key is the internal compression check for behaviour in doing cli commands
    # on a package manager and the value is the command passed to the package manager
    modes: Modes
    # package listing string
    package_listing: list[str] | None


# This Manager offers the ability to use custom installers as well as generic cones
# obviously not every package manager has the same way to display what kind of lib has been installed
# while with binarys its easier where you can just check if its in path
class PackageManager:
    package_manager: PackageManagerDict

    def __init__(
        self,
        package_manager: PackageManagerDict,
    ):
        self.package_manager = package_manager

    # check if package is installed in package manager
    # utilising the built in package listing command
    def is_package_installed(self, package: str) -> bool:
        try:
            if self.package_manager["package_listing"] is not None:
                command = " ".join(self.package_manager["package_listing"])
                if cli_options["debug"]:
                    log.Debug("Executing {0} in is_package_installed for {1}".format(command, package))

                result = subprocess.check_output(command.split()).decode("utf-8")

                find = str.find(result, package)
                if find == -1:
                    return False

                return True
            return False
        except subprocess.CalledProcessError as e:
            log.Error(
                "Failed to check if {0}{1}{2} is installed with code {3}".format(
                    Colors.FAIL, package, Colors.ENDC, e.returncode
                )
            )
            return False

    # installs all cli packages in the manager
    def install_cli_packages(self):
        if not is_installed(self.package_manager["cli_tool"]):
            log.Error(
                "Package Manager {0}{1} not in path skipping installing".format(
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
            try:
                isForce = cli_options["force"] or cli_options["update"]

                # this check checks if a package has a bin name attached to it
                if package[1] is not None:
                    if not is_installed(package[1]) or isForce:
                        log.Info(
                            "Installing CLI Package {0}{1}".format(
                                Colors.OKGREEN, package[0]
                            )
                        )
                        install = "{0}{1} {2} {3}".format(
                            sudo,
                            self.package_manager["cli_tool"],
                            self.package_manager["modes"][mode],
                            package[0],
                        )
                        log.Info(
                            "Executing {0}{1}{2}".format(
                                Colors.WARNING, install, Colors.ENDC
                            )
                        )
                        if cmd(install):
                            log.Success(
                                "Success Installing package {0}{1}".format(
                                    Colors.OKGREEN, package[0]
                                )
                            )
                    else:
                        log.Skip(
                            "CLI Package {0}{1}{2} is installed Skip".format(
                                Colors.OKBLUE, package[0], Colors.ENDC
                            )
                        )
                else:
                    # Installing package manager dependencies if no bin name is specified it indicates its a dependency
                    if not self.is_package_installed(package[0]) or isForce:
                        log.Info(
                            "Installing CLI Package {0}{1}".format(
                                Colors.OKGREEN, package[0]
                            )
                        )
                        install = "{0}{1} {2} {3}".format(
                            sudo,
                            self.package_manager["cli_tool"],
                            self.package_manager["modes"][mode],
                            package[0],
                        )
                        log.Info(
                            "Executing {0}{1}{2}".format(
                                Colors.WARNING, install, Colors.ENDC
                            )
                        )
                        if cmd(install):
                            log.Success(
                                "Success Installing package {0}{1}".format(
                                    Colors.OKGREEN, package[0]
                                )
                            )
                    else:
                        log.Skip(
                            "CLI Package {0}{1}{2} is installed Skip".format(
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
        "package_listing": ["npm", "list", "-g"],
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
            ("prettier", "prettier"),
            ("eslint_d", "eslint_d"),
        ],
    }
)

# Go Go Package Manager
go: PackageManager = PackageManager(
    {
        "cli_tool": "go",
        "modes": {"install": "install", "update": "install"},
        "package_listing": None,
        "packages": [
            ("mvdan.cc/sh/v3/cmd/shfmt@latest", "shfmt"),
            ("github.com/mattn/efm-langserver@latest", "efm-langserver"),
            ("golang.org/x/tools/gopls@latest", "gopls"),
            ("golang.org/x/tools/cmd/goimports@latest", "goimports"),
            ("github.com/segmentio/golines@latest", "golines"),
        ],
    }
)

# Rust Cargo Package Manager
rust: PackageManager = PackageManager(
    {
        "cli_tool": "cargo",
        "modes": {"install": "install", "update": "install"},
        "package_listing": ["cargo", "install", "--list"],
        "packages": [
            ("blackd-client", "blackd-client"),
            ("stylua", "stylua"),
            ("rslint_cli", "rslint"),
        ],
    }
)

# Rustup for rust lsp
rust_up: PackageManager = PackageManager(
    {
        "cli_tool": "rustup",
        "modes": {"install": "+nightly component add", "update": "+nightly component add"},
        "package_listing": ["rustup", "component", "list", "--installed"],
        "packages": [("rust-analyzer", None)],
    }
)

# Rustup for rust lsp
lua: PackageManager = PackageManager(
    {
        "cli_tool": "luarocks",
        "modes": {"install": "--local install", "update": "--local install"},
        "packages": [("luacheck", "luacheck")],
        "package_listing": ["luarocks", "list"],
    }
)

# Python PIP Package Manager
python: PackageManager = PackageManager(
    {
        "cli_tool": "pip",
        "modes": {"install": "install", "update": "install"},
        "package_listing": ["pip", "list"],
        "packages": [
            ("black", "black"),
            ("pynvim", None),
            ("aiohttp", None),
            ("aiohttp-cors", None),
        ],
    }
)

# lua-language-server
brew = PackageManager(
    {
        "cli_tool": "brew",
        "modes": {"install": "install", "update": "upgrade"},
        "package_listing": ["brew", "list"],
        "packages": [
            ("lua-language-server", "lua-language-server"),
            ("languagetool", "languagetool"),
            ("vale", "vale"),
            ("jq", "jq"),
        ],
    }
)

# Arch community package manager (uses pacman internally)
yay: PackageManager = PackageManager(
    {
        "cli_tool": "yay",
        "package_listing": ["yay", "-Q"],
        "modes": {
            "install": "--save --nocleanmenu --nodiffmenu --noconfirm -S",
            "update": "--save --nocleanmenu --nodiffmenu --noconfirm -Yu",
        },
        "packages": [
            ("nuspell", "nuspell"),
            ("hunspell-en_us", None),
            ("hunspell-de", None),
            ("vale-git", "vale"),
            ("languagetool", "languagetool"),
            ("jq", "jq"),
            ("jdtls", "jdtls"),
            ("groovy-language-server", "groovy-language-server"),
            ("lua-language-server", "lua-language-server"),
            ("dotnet-sdk", "dotnet"),
        ],
    }
)


# check if binary/symbolic link is in one of the paths folders
def is_installed(package: str) -> bool:
    for path in os.environ["PATH"].split(os.pathsep):
        if os.path.exists(os.path.join(path, package)):
            return True
    return False


class SysManager:
    package_list: list[PackageManager]
    os: str

    def is_cli_packages_installed(self):
        for manager in self.package_list:
            # check if package manager is installed
            if is_installed(manager.package_manager["cli_tool"]):
                for package in manager.package_manager["packages"]:
                    # check if package has a executable
                    if package[1] is not None:
                        # check if package is installed
                        if not is_installed(package[1]):
                            log.Warning(
                                "Binary {} not found in path".format(package[1])
                            )
                    else:
                        if not manager.is_package_installed(package[0]):
                            log.Warning(
                                "Dependency {} is not installed".format(package[0])
                            )
            else:
                log.Warning(
                    "Package Manager {} not found in path".format(
                        manager.package_manager["cli_tool"]
                    )
                )
                for package in manager.package_manager["packages"]:
                    log.Warning(
                        "Package {} is not installed because missing manager tool".format(
                            package[0]
                        )
                    )

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
user: str = getuser()

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


class Log:
    counter: int = 1
    max_steps: int = 0
    skip: int = 0

    def set_max_step(self, steps: int):
        self.max_steps = steps

    def now(self) -> str:
        time: datetime = datetime.now()
        return time.strftime("%H:%M:%S")

    def buildLogString(self, kind: str, color: str) -> str:
        start: str = "{2} {0} " + color + "{1}:" + kind + "\t" + Colors.ENDC
        attach: str = Colors.BOLD + "\t--> {3}" + Colors.ENDC
        return start + attach

    def buildStepString(self, kind: str, color: str) -> str:
        start: str = "{2} {0} " + color + "{1}:" + kind + "\t{4}/" + "{5}" + Colors.ENDC
        attach: str = Colors.BOLD + "\t--> {3}" + Colors.ENDC
        return start + attach

    def Success(self, string: str) -> None:
        st: str = self.buildStepString("SUCCESS", Colors.OKGREEN)
        print(st.format(self.now(), user, arrow, string, self.counter, self.max_steps))
        self.counter = self.counter + 1

    def Warning(self, string: str) -> None:
        st: str = self.buildLogString("WARNING", Colors.WARNING)
        print(st.format(self.now(), user, arrow, string))

    def Debug(self, string: str | CliOptions) -> None:
        st: str = self.buildLogString("DEBUG", Colors.WARNING)
        print(st.format(self.now(), user, arrow + arrow, string))

    def Error(self, string: str) -> None:
        st: str = self.buildLogString("ERROR", Colors.FAIL)
        print(st.format(self.now(), user, arrow, string))

    def Info(self, string: str) -> None:
        st: str = self.buildLogString("INFO", Colors.OKBLUE)
        print(st.format(self.now(), user, arrow, string))

    def Skip(self, string: str) -> None:
        st: str = self.buildStepString("SUCCESS", Colors.OKGREEN)
        print(st.format(self.now(), user, arrow, string, self.counter, self.max_steps))
        self.counter = self.counter + 1
        self.skip = self.skip + 1

    def Step(self, string: str) -> None:
        st: str = self.buildStepString("STEP", Colors.OKBLUE)
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
                "  --uninstall \t| will uninstall all packages\n"
                "  --sudo [user], -s\t| run yay as sudo\n"
                "  --debug, -d\t| run yay as sudo\n"
            )
            sys.exit(0)


def main():
    help()
    log.Info("Detected system is {0}".format(sys.platform))
    if cli_options["debug"]:
        log.Debug(cli_options)

    try:
        for sysmanager in supported_os:
            if sysmanager.os == sys.platform:
                log.set_max_step(sysmanager.count_packages())
                for manager in sysmanager.package_list:
                    manager.install_cli_packages()

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
