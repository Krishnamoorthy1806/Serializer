//====================================================
//					SER_BASE_TEST
//====================================================
class ser_base_test extends uvm_test;
	`uvm_component_utils(ser_base_test)
	`NEW_COMP
	ser_env env;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env=ser_env::type_id::create("env",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
endclass

//===========================================================
//				BASIC_TEST
//===========================================================

class basic_test extends ser_base_test;
	`uvm_component_utils(basic_test)
	`NEW_COMP

	task run_phase(uvm_phase phase);
		basic_sequence b_seq;
		b_seq=basic_sequence::type_id::create("b_seq");
		phase.raise_objection(this);
		b_seq.start(env.agent.seq);
		phase.phase_done.set_drain_time(this,100);
		phase.drop_objection(this);
	endtask
endclass
