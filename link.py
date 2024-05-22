#!/usr/bin/env python3
import os
import json
import subprocess
import sys
import shutil

def green(text):
    return f'\033[32m{text}\033[m'

def yellow(text):
    return f'\033[33m{text}\033[m'

def red(text):
    return f'\033[31m{text}\033[m'

def white(text):
    return f'\033[37;1m{text}\033[m'

def is_wsl():
    try:
        with open("/proc/version") as fp:
            content = fp.read()
            if "microsoft" in content.lower():
                return True
    except FileNotFoundError:
        pass
    return False


dotfiles_path = os.path.dirname(os.path.realpath(__file__))

with open(os.path.join(dotfiles_path, "config.json")) as fp:
    cfg = json.load(fp)

links = cfg["links"]

for src, dst in links.items():
    src_path = os.path.join(dotfiles_path, src)
    dst_path = os.path.expanduser(dst)
    pre = f"Link {white(src)} to {white(dst_path)}"
    if os.path.exists(src_path):
        if os.path.islink(dst_path):
            trg = os.readlink(dst_path)
            if os.path.realpath(dst_path) != os.path.realpath(trg):
                print(f"{pre}: " + red(f"linked to invalid path: {trg}"))
            else:
                print(f"{pre}: " + green("already linked"))
        elif os.path.exists(dst_path):
            print(f"{pre}: " + red(f"target path already exists"))
        else:
            os.makedirs(os.path.dirname(dst_path), exist_ok=True)
            os.symlink(src_path, dst_path)
            print(f"{pre}: " + green("linked"))
    else:
        print(f"{pre}: " + red("source not found"))

if is_wsl():
    print(green("\nWindows Subsystem for Linux (WSL) detected"))
    res = subprocess.run('cmd.exe /c echo %HOMEDRIVE%%HOMEPATH%'.split(), capture_output=True)
    homedir = res.stdout.decode().strip()
    print("User home directory:", white(homedir))
    if homedir[1] != ':':
        print(red("Expected drive at beginning of home directory path"))
        sys.exit(1)
    homedir = "/mnt/" + homedir[0].lower() + homedir[2:].replace('\\', '/')
    print("Translated to WSL space:", white(homedir))
    
    for src, dst in cfg["windows"].items():
        src_path = os.path.join(dotfiles_path, src)
        if dst[0] == "~":
            dst_path = homedir + dst[1:]
        else:
            dst_path = dst
        pre = f"Copy {white(src)} to {white(dst_path)}"
        if os.path.exists(src_path):
            if os.path.exists(dst_path):
                shutil.copy(src_path, dst_path)
                print(f"{pre}: {yellow('replaced existing')}")
            else:
                os.makedirs(os.path.dirname(dst_path), exist_ok=True)
                shutil.copy(src_path, dst_path)
                print(f"{pre}: {green('installed')}")
        else:
            print(f"{pre}: " + red("source not found"))

