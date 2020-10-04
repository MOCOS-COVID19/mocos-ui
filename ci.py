#!/usr/bin/env python
import sys
import os
import argparse
import subprocess


if sys.version_info[0] < 3:
    raise Exception("unsuported version of Python!")


def run(command):
    cmd = list(command.split(" "))
    out = subprocess.run(cmd, stdout=sys.stdout, stderr=sys.stderr)
    if out.returncode != 0:
        raise Exception("non 0 returncode")


def deps():
    run("pip install -U pip setuptools wheel")
    run("pip install -r requirements.txt")
    run("pip install -r requirements-ci.txt")


def build():
    run("pyinstaller mocos-gui.py")
    run("cp -r views dist/mocos-gui/")
    os.chdir("./dist")
    if (os.environ['HOME'] == "windows"):
        run("7z a -tzip mocos-gui-win-amd64.zip mocos-gui/")
    if (os.environ['HOME'] == "osx"):
        run("zip -r mocos-gui-osx-amd64.zip mocos-gui/")
    else:
        run("zip -r mocos-gui-linux-amd64.zip mocos-gui/")


def main():
    parser = argparse.ArgumentParser(description='ci script is designed to run on travis')
    parser.add_argument('--deps', action='store_true', default=False,
                        help='install dependencies')
    parser.add_argument('--build', action='store_true', default=False,
                        help='build pacakge using py-installer')

    args = parser.parse_args()
    if args.deps:
        deps()
    elif args.build:
        build()
    else:
        print("pass at least one argument!")


if __name__ == "__main__":
    main()
