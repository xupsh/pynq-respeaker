from setuptools import setup
import os
import shutil
import sys
import subprocess

if os.geteuid() != 0:
    print("This program must be run as root. Aborting.")
    sys.exit(1)

if os.environ['BOARD'] != 'Pynq-Z2':
    print("Only supported on a Pynq-Z2 Board")
    exit(1)

setup(
	name = "respeaker",
	version = 1.0,
	url = 'https://github.com/xupsh/pynq-respeaker',
	license = 'BSD 3-Clause License',
	author = "Jin Yongwei",
	author_email = "xup_china@xilinx.com",

	include_package_data = True,
	packages = ['respeaker'],
	package_data = {
	'' : ['*.bit','*.tcl','*.py','*.bin','*.txt', '*.cpp', '*.h', '*.sh'],
	},
	description = "ReSpeaker 4-Mic Array for PYNQ",
    install_requires=[
        'pynq','numpy','soundfile','baidu-aip','smbus'
    ],
)

if 'install' in sys.argv:
	os.system("echo y | apt-get install libsndfile1")
	if os.path.isdir(os.environ["PYNQ_JUPYTER_NOTEBOOKS"]+"/pynq-respeaker/"):
		shutil.rmtree(os.environ["PYNQ_JUPYTER_NOTEBOOKS"]+"/pynq-respeaker/")
	shutil.copytree("boards/Pynq-Z2/notebooks/",os.environ["PYNQ_JUPYTER_NOTEBOOKS"]+"/pynq-respeaker/")