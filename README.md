# ReSpeaker 4-Mic Array for PYNQ

This repo contains the pip install package for ReSpeaker 4-Mic Array on PYNQ. It's only support PYNQ Z2 board.

## Quick Start

In order to install it on your PYNQ board, connect to the board, open a terminal and type:

### Online Install
```shell
# (on PYNQ v2.3 only)
sudo pip3 install git+https://github.com/sumilao/pynq-respeaker.git
```
### Standalone Install
```shell
# (on PYNQ v2.3 only)
cd pynq-sense-hat
sudo python setup.py install
```

NOTE: This command must be run as root.