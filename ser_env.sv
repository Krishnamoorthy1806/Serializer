//====================================================
//					SER_ENVIRONMENT
//====================================================
class ser_env extends uvm_env;
	`uvm_component_utils(ser_env)
	`NEW_COMP
	ser_agent agent;
	ser_sbd sbd;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent=ser_agent::type_id::create("agent",this);
		sbd=ser_sbd::type_id::create("sbd",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
	endfunction
endclass
