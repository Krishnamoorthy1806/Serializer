//====================================================
//					SER_AGENT
//====================================================
class ser_agent extends uvm_agent;
	`uvm_component_utils(ser_agent)
	`NEW_COMP
	ser_seq seq;
	ser_drv drv;
	ser_mon mon;
	ser_sub sub;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq=ser_seq::type_id::create("seq",this);
		drv=ser_drv::type_id::create("drv",this);
		mon=ser_mon::type_id::create("mon",this);
		sub=ser_sub::type_id::create("sub",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(seq.seq_item_export);
	endfunction
endclass
