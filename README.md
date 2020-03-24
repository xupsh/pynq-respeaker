# ReSpeaker 4-Mic Array for PYNQ

This repo contains the pip install package for ReSpeaker 4-Mic Array on PYNQ. It's only support PYNQ Z2 board. There are 2 noetbooks in the design. DOA.ipynb demostrates how to calculate DOA (Direction Of Arrival) of the sound. STT.ipynb demostrates  how to do STT (Speech To Text) with APIs provided by Baidu.
![](./boards/Pynq-Z2/notebooks/data/respeaker_pynq.jpg)

## Quick Start

To install this overlay on your PYNQ board, Open a terminal on your PYNQ board and run:

### *Online Install*
```shell
# (on PYNQ v2.3 or v2.4 only)
sudo pip3 install git+https://github.com/xupsh/pynq-respeaker.git
```
### *Standalone Install*
```shell
# (on PYNQ v2.3 or v2.4 only)
sudo python setup.py install
```

Note: This command must be run as root.  

### Run the examples

After the installation, a folder pynq-respeaker shuold be seen in `/home/xilinx/jupyter_notebooks`.There are 2 notebooks in it and you can run them.

## About the ReSpeaker and the project overlay  
### ReSpeaker
ReSpeaker is a 4-mic array with an AC108 4-channel ADC as a converter. More information about ReSpeaker, please click [here](http://wiki.seeedstudio.com/ReSpeaker_4_Mic_Array_for_Raspberry_Pi/).         

### Rebuild the overlay  
windows: Open vivado 2018.3 and type these command lines in the tcl console:  
```
cd <PATH_TO_PROJECT>/boards/Pynq-Z2/notebooks/bitstream  
source respeaker_wifi.tcl
```
linux: Use these command lines:  
```
source <PATH_TO_VIVADO>/2018.3/settings64.sh  
cd <PATH_TO_PROJECT>/boards/Pynq-Z2/notebooks/bitstream  
make
```
### Customized overlay  
AC108 support I2S interface, here is the Vivado Block Design diagram.  
![](./overlay.png)  
The customized respeaker IP converts I2S signal and stored results in it. PS accesses those data via AXI_lite bus (MMIO in PYNQ ).

## License

**PYNQ** License : [BSD 3-Clause License](https://github.com/Xilinx/PYNQ/blob/master/LICENSE)
