overlay_name := respeaker_wifi
design_name := respeaker_wifi

all: block_design bitstream check_timing
	@echo
	@tput setaf 2 ; echo "Built $(overlay_name) successfully!"; tput sgr0;
	@echo

block_design:
	vivado -mode batch -source $(overlay_name).tcl -notrace

clean:
	rm -rf $(overlay_name) *.jou *.log NA