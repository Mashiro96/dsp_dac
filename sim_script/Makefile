VCS := vcs -full64 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed
VCSFLAG := -v2005 -sverilog  -v2k_generate -timescale=1ns/10ps -R
CL := csrc/ simv* simv.daidir/ ucli.key *.log *.vcd

all:
	$(VCS) $(VCSFLAG) -top top_tb -f list.f | tee -i run.log

clean:
	rm -rf $(CL)
