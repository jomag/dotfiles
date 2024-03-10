#!/usr/bin/env python3
import os
import json

dotfiles_path = os.path.dirname(os.path.realpath(__file__))

with open(os.path.join(dotfiles_path, "config.json")) as fp:
    cfg = json.load(fp)

links = cfg["links"]

for src, dst in links.items():
    src_path = os.path.join(dotfiles_path, src)
    dst_path = os.path.expanduser(dst)
    pre = f"Link {src} to {dst_path}"
    if os.path.exists(src_path):
        if os.path.islink(dst_path):
            trg = os.readlink(dst_path)
            if os.path.realpath(dst_path) != os.path.realpath(trg):
                print(f"{pre}: linked to invalid path: {trg}")
            else:
                print(f"{pre}: already linked")
        elif os.path.exists(dst_path):
            print(f"{pre}: target path already exists")
        else:
            os.symlink(src_path, dst_path)
            print(f"{pre}: linked")
    else:
        print(f"{pre}: not found")


