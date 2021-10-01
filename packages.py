#!/usr/bin/env python

# TODO
# Installation process
# for dependencies that need to be manually installed
# LSP's, Debug Adapters

import subprocess
import os
import sys
from getpass import getuser
from datetime import datetime
from distutils.spawn import find_executable

# index[0] is the package name index[1] is the bin name in path
node_packages = [
    ["typescript-language-server", "typescript-language-server"],
    ["vscode-html-languageserver-bin", "html-languageserver"],
    ["css-language-server", "css-language-server"],
    ["svelte-language-server", "svelteserver"],
    ["bash-language-server", "bash-language-server"],
    ["yaml-language-server", "yaml-language-server"],
    ["dockerfile-language-server-nodejs", "docker-langserver"],
    ["dprint", "dprint"],
    ["pyright", "pyright"],
]

go_packages = [
    ["mvdan.cc/sh/v3/cmd/shfmt@latest", "shfmt"],
    ["github.com/mattn/efm-langserver@latest", "efm-langserver"],
]

rust_packages = [["blackd-client", "blackd-client"], ["stylua", "stylua"]]

pip_packages = [
    ["black", "black"],
    ["aiohttp", "aiohttp"],
    ["aiohttp_cors", "aiohttp_cors"],
]

yay_packages = [
    ["jdtls", "jdtls"]
]

now = datetime.now()
current_time = now.strftime("%H:%M:%S")
current_folder = os.path.abspath(os.getcwd())
user = getuser()
home = "{0}{1}".format(os.environ.get("HOME"), "/")
dap_path = home + ".local/share/nvim/dapinstall/"
lsp_path = home + ".local/share/nvim/lsp/"

arrow = "====>"


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
    user = getuser()
    counter = 0

    def now(self):
        time = datetime.now()
        return time.strftime("%H:%M:%S")

    def buildLogString(self, kind: str, color: str):
        start = "{2} {0} " + color + "{1}:" + kind + " " + self.ENDC
        attach = self.HEADER + ": {3}" + self.ENDC
        return start + attach

    def buildStepString(self, kind: str, color: str):
        start = "{2} {0} " + color + "{1}:" + kind + " {4}/16" + self.ENDC
        attach = self.BOLD + ": {3}" + self.ENDC
        return start + attach

    def Success(self, string: str):
        st = self.buildLogString("SUCCESS", self.OKGREEN)
        print(st.format(self.now(), self.user, arrow, string))

    def Warning(self, string: str):
        st = self.buildLogString("WARNING", self.WARNING)
        print(st.format(self.now(), self.user, arrow, string))

    def Error(self, string: str):
        st = self.buildLogString("ERROR", self.FAIL)
        print(st.format(self.now(), self.user, arrow, string))

    def Critical(self, string: str):
        st = self.buildLogString("CRITICAL", self.FAIL)
        print(st.format(self.now(), self.user, arrow, string))

    def Info(self, string: str):
        st = self.buildLogString("INFO", self.OKBLUE)
        print(st.format(self.now(), self.user, arrow, string))

    def Skip(self, string: str):
        st = self.buildLogString("SKIP", self.OKBLUE)
        print(st.format(self.now(), self.user, arrow, string))

    def Step(self, string: str):
        st = self.buildStepString("STEP", self.OKBLUE)
        print(st.format(self.now(), self.user, arrow, string, self.counter))
        self.counter = self.counter + 1


log = Log()


def cmd(call: str):
    try:
        log.Info("Executing {0}".format(call))
        cmdArr = call.split()
        with open(os.devnull, "w") as f:
            subprocess.call(cmdArr, stdout=f)
            f.close()
    except subprocess.CalledProcessError as err:
        log.Error("Failed to execute {0}".format(call))
        log.Error("Trace {0}".format(err))


def in_path(cmd: str):
    try:
        inPath = find_executable(cmd) is not None
        return inPath
    except subprocess.CalledProcessError as e:
        log.Error(
            "Call Check {0} Failed with return code {1}".format(cmd, e.returncode)
        )


def install_cli_packages(
    cli_tool: str, cli_options: str, arr: list[list[str]], options: str = ""
):
    if not in_path(cli_tool):
        log.Warning("{0} not in path skipping installing".format(cli_tool))
        return
    for package in arr:
        install = "{0} {1} {2} {3}".format(cli_tool, cli_options, package[0], options)
        try:
            inPath = in_path(package[1])
            isForce = False
            for key, option in enumerate(sys.argv):
                if option == "--force":
                    isForce = True

            if not inPath or isForce:
                log.Info("Installing CLI Package {0}".format(package[0]))
                cmd(install)
                log.Success("Success Installing package {0}".format(package[0]))
            else:
                log.Skip("SKIP: CLI Package {0} in path".format(package[0]))
        except subprocess.CalledProcessError as e:
            log.Error(
                "Failed to install {0} with code {1}".format(package, e.returncode)
            )


def java_debug():
    if not os.path.isdir(dap_path + "java-debug"):
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
    else:
        log.Warning("JAVA Debug Exists Update?")


def sumneko_lua():
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
    else:
        log.Warning("LUA LSP Exists Update?")


def jdtls():
    # TODO
    if sys.platform == 'linux':
        log.Info("Install jdtls langserver")
        install_cli_packages("yay", "-S", yay_packages)
    else:
        log.Warning(sys.platform + " JDTLS Needs Implementation")


def Darwin():
    log.Step("DAP Setup")
    java_debug()

    log.Step("LSP Setup")
    sumneko_lua()
    install_cli_packages("npm", "install -g", node_packages)
    install_cli_packages("go", "install", go_packages)
    install_cli_packages("cargo", "install", rust_packages)
    install_cli_packages("pip", "install", pip_packages)
    jdtls()


def Cygwin():
    log.Error("Not Supported")
    exit(1)


def Linux():
    log.Step("DAP Setup")
    java_debug()

    log.Step("LSP Setup")
    sumneko_lua()
    install_cli_packages("npm", "install -g", node_packages)
    install_cli_packages("go", "install", go_packages)
    install_cli_packages("cargo", "install", rust_packages)
    install_cli_packages("pip", "install", pip_packages)


def help():
    for option in sys.argv:
        if option == "--help" or option == "-h":
            print("Usage:")
            print("  ./packages.py [OPTIONS]")
            print("")
            print("OPTIONS:")
            print(
                "  --force            | will force install without check if already installed"
            )
            sys.exit(0)


if __name__ == "__main__":
    log.Info("Detected system is {0}".format(sys.platform))
    help()

    try:
        if sys.platform == "cygwin":
            Cygwin()

        if sys.platform == "darwin":
            Darwin()

        if sys.platform == "linux":
            Linux()

    except:
        # TODO: figure out why error
        # if it throws one
        log.Error("Error While Installing")
