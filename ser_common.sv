//==========================================
//				SER_COMMON_CLASS
//==========================================
`define NEW_OBJ function new(input string name="");\
	super.new(name);\
endfunction

`define NEW_COMP function new(input string name="",uvm_component parent=null);\
	super.new(name,parent);\
endfunction
