#!/usr/bin/env python

# TODO
# Installation process
# for dependencies that need to be manually installed
# LSP's, Debug Adapters

import subprocess
import os
import sys
from os import system
from getpass import getuser
from datetime import datetime
from distutils.spawn import find_executable

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

    def Step(self, string: str):
        st = self.buildStepString("STEP", self.OKBLUE)
        print(st.format(self.now(), self.user, arrow, string, self.counter))
        self.counter = self.counter + 1


log = Log()

def Cmd(call: str):
    try:
        log.Info("Executing {0}".format(call))
        cmdArr = call.split()
        with open(os.devnull, "w") as f:
            subprocess.call(cmdArr, stdout=f)
            f.close()
    except subprocess.CalledProcessError as err:
        log.Error("Failed to execute {0}".format(call))
        log.Error("Trace {0}".format(err))

def java_debug():
    if not os.path.isdir(dap_path + "java-debug"):
        log.Info("Install Java Debug")
        Cmd("git clone https://github.com/microsoft/java-debug " + dap_path + "java-debug")
        Cmd("git clone https://github.com/microsoft/vscode-java-test " + dap_path + "vscode-java-test")
        os.chdir(dap_path + "java-debug")
        Cmd("./mvnw clean install")
        os.chdir(current_folder)
        os.chdir(dap_path + "vscode-java-test")
        Cmd("npm install")
        Cmd("npm run build-plugin")
        os.chdir(current_folder)
    else:
        log.Warning("JAVA Debug Exists Update?")

def sumneko_lua():
    if not os.path.isdir(lsp_path + "lua"):
        log.Info("Install lua langserver")
        Cmd("git clone https://github.com/sumneko/lua-language-server " + lsp_path + "lua")
        os.chdir(lsp_path + "lua")
        Cmd("git submodule update --init --recursive")
        os.chdir(current_folder)
        os.chdir(lsp_path + "lua/3rd/luamake")
        Cmd("compile/install.sh")
        os.chdir(current_folder)
        os.chdir(lsp_path + "lua")
        Cmd("3rd/luamake/luamake rebuild")
        os.chdir(current_folder)
    else:
        log.Warning("LUA LSP Exists Update?")

def jdtls():
    # TODO
    log.Warning("JDTLS Needs Implementation")

def Darwin():
    log.Step('DAP Setup')
    java_debug()

    log.Step('LSP Setup')
    sumneko_lua()
    jdtls()

def Cygwin():
    log.Error("Not Supported")
    exit(1)

def Linux():
    log.Step('DAP Setup')
    java_debug()

    log.Step('LSP Setup')
    sumneko_lua()
    jdtls()

if __name__ == "__main__":
    log.Info("Detected system is {0}".format(sys.platform))

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
