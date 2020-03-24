overlay_name := respeaker_wifi
design_name := respeaker_wifi

block_design:
	vivado -mode batch -source $(overlay_name).tcl -notrace

clean:
	rm -rf $(overlay_name) *.jou *.log NA
