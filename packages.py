#!/usr/bin/env python

import subprocess
import os
import sys
from typing import TypedDict
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
    packages: list[list[str]]
    # the mode key is the internal compression check for behaviour in doing cli commands
    # on a package manager and the value is the command passed to the package manager
    modes: Modes


# Node NPM Package Manager
node: PackageManager = {
    "cli_tool": "npm",
    "modes": {"install": "install -g", "update": "upgrade -g"},
    "packages": [
        ["typescript-language-server", "typescript-language-server"],
        ["vscode-html-languageserver-bin", "html-languageserver"],
        ["vscode-langservers-extracted", "vscode-css-language-server"],
        ["svelte-language-server", "svelteserver"],
        ["bash-language-server", "bash-language-server"],
        ["yaml-language-server", "yaml-language-server"],
        ["intelephense", "intelephense"],
        ["dockerfile-language-server-nodejs", "docker-langserver"],
        ["dprint", "dprint"],
        ["pyright", "pyright"],
        ["prettier_d_slim", "prettier_d_slim"],
        ["eslint_d", "eslint_d"],
    ],
}

# Go Go Package Manager
go: PackageManager = {
    "cli_tool": "go",
    "modes": {"install": "install", "update": "install"},
    "packages": [
        ["mvdan.cc/sh/v3/cmd/shfmt@latest", "shfmt"],
        ["github.com/mattn/efm-langserver@latest", "efm-langserver"],
        ["golang.org/x/tools/gopls@latest", "gopls"]
    ],
}

# Rust Cargo Package Manager
rust: PackageManager = {
    "cli_tool": "cargo",
    "modes": {"install": "install", "update": "install"},
    "packages": [["blackd-client", "blackd-client"], ["stylua", "stylua"]],
}

# Python PIP Package Manager
python: PackageManager = {
    "cli_tool": "pip",
    "modes": {"install": "install", "update": "install"},
    "packages": [
        ["black", "black"],
        ["aiohttp", "aiohttp"],
        ["aiohttp_cors", "aiohttp_cors"],
    ],
}

# Arch community package manager (uses pacman internally)
yay: PackageManager = {
    "cli_tool": "yay",
    "modes": {
        "install": "--save --answerclean=All --answerdiff=None -S",
        "update": "--save --answerclean=All --answerdiff=None -Yu",
    },
    "packages": [
        ["jdtls", "jdtls"],
        ["groovy-language-server", "groovy-language-server"],
        ["dotnet-sdk", "dotnet"],
    ],
}

steps: int = len(yay["packages"]) + len(python["packages"]) + len(rust["packages"]) + len(go["packages"]) + len(node["packages"])
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
    counter: int = 0
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
            "{0}{1}{2} not in path skipping installing".format(Colors.FAIL, package_manager["cli_tool"])
        )
        return
    mode = get_package_mode()
    for package in package_manager["packages"]:
        install = "{0} {1} {2}".format(
            package_manager["cli_tool"], package_manager["modes"][mode], package[0]
        )
        try:
            inPath = in_path(package[1])
            isForce = mode == 'update' and True or False
            for _, option in enumerate(sys.argv):
                if option == "--force":
                    isForce = True

            if not inPath or isForce:
                log.Info("Installing CLI Package {0}{1}".format(Colors.OKGREEN, package[0]))
                cmd(install)
                log.Success("Success Installing package {0}{1}".format(Colors.OKGREEN, package[0]))
            else:
                log.Skip("CLI Package {0}{1}{2} in path".format(Colors.OKBLUE, package[0], Colors.ENDC))
        except subprocess.CalledProcessError as e:
            log.Error(
                "Failed to install {0}{1}{2} with code {3}".format(Colors.FAIL, package, Colors.ENDC, e.returncode)
            )


def java_debug() -> None:
    if not os.path.isdir(dap_path + "java-debug"):
        if not in_path("npm"):
            log.Warning("{0} not in path skipping installing".format("npm"))
            return
        log.Info("Install Java Debug")
        cmd(
            "git clone https://github.com/microsoft/java-debug "
            + dap_path
            + "java-debug"
        )
        cmd(
            "git clone https://github.com/microsoft/vscode-java-test "
            + dap_path
            + "vscode-java-test"
        )
        os.chdir(dap_path + "java-debug")
        cmd("./mvnw clean install")
        os.chdir(current_folder)
        os.chdir(dap_path + "vscode-java-test")
        cmd("npm install")
        cmd("npm run build-plugin")
        os.chdir(current_folder)
        log.Success("Java Debug Installed")


def sumneko_lua() -> None:
    if not os.path.isdir(lsp_path + "lua"):
        log.Info("Install lua langserver")
        cmd(
            "git clone https://github.com/sumneko/lua-language-server "
            + lsp_path
            + "lua"
        )
        os.chdir(lsp_path + "lua")
        cmd("git submodule update --init --recursive")
        os.chdir(current_folder)
        os.chdir(lsp_path + "lua/3rd/luamake")
        cmd("compile/install.sh")
        os.chdir(current_folder)
        os.chdir(lsp_path + "lua")
        cmd("3rd/luamake/luamake rebuild")
        os.chdir(current_folder)
        log.Success("Sumneko LSP Installed")


def jdtls() -> None:
    log.Warning(sys.platform + " JDTLS Needs Implementation")


def Darwin() -> None:
    log.Step("DAP Setup")
    java_debug()

    log.Step("LSP Setup")
    sumneko_lua()
    jdtls()
    install_cli_packages(node)
    install_cli_packages(go)
    install_cli_packages(rust)
    install_cli_packages(python)


def Cygwin() -> None:
    log.Error("Not Supported")


def Linux() -> None:
    log.Step("DAP Setup")
    java_debug()

    log.Step("LSP Setup")
    sumneko_lua()

    # install_cli_packages(yay)
    install_cli_packages(node)
    install_cli_packages(go)
    install_cli_packages(rust)
    install_cli_packages(python)


def Win32() -> None:
    install_cli_packages(node)
    install_cli_packages(rust)
    install_cli_packages(python)


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
            sys.exit(1)


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
