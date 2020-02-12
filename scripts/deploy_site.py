#!/usr/bin/env python
import os
import os.path as osp
base_d = osp.dirname(__file__)+'/../'
import subprocess

cmd_make_site = "cd {base_d}/docgen/; make site"
cmd_copy = "cp -ar {base_d}/docgen/site/* {dst_d}"

def run_cmd(cmd):
    print (cmd)
    subprocess.call(cmd, shell=True)

def main(dst_d):
    os.makedirs(dst_d, exist_ok=True)
    run_cmd(cmd_make_site.format(base_d=base_d))
    run_cmd(cmd_copy.format(base_d=base_d, dst_d=dst_d))

if __name__ == "__main__":
   import fire
   fire.Fire(main)
