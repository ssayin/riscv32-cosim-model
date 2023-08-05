/***************************************************************************************************
* Description:
* Considering different user cases, Slave VIP has two agents: slv_agent and slv_mem_agent.
* slv_agent doesn't have memory model and user can build their own memory model and fill in write
* transaction and/or read transaction responses in their own way.slv_mem_agent has memory model
* which user can use it directly.
* This file shows basic features of Slave VIP with memory model
* For Slave VIP with memory model to work correctly,the following four things must be done
*    1. import two packages.(this information also shows at the xgui of the VIP)
*         import axi_vip_pkg::*
*         import <component_name>_pkg::*;
*    2. delcare <component_name>_slv_mem_t agent
*    3. new agent (passing instance IF correctly)
*    4. start_slave
***************************************************************************************************/


import axi_vip_pkg::*;
import ex_sim_axi_vip_slv_0_pkg::*;


  /*************************************************************************************************
  * Declare <component_name>_slv_mem_t for slave mem agent
  * <component_name> can be easily found in vivado bd design: click on the instance,
  * then click CONFIG under Properties window and Component_Name will be shown
  * more details please refer PG267 for more details
  *************************************************************************************************/
  ex_sim_axi_vip_slv_0_slv_mem_t                          slv_agent;

  task slv_start_stimulus();
    /***********************************************************************************************
    * Before slv_agent is newed, user has to run simulation with an empty testbench(disable below two
    * lines) to find the hierarchy path of the AXI VIP's instance.Message like
    * "Xilinx AXI VIP Found at Path: my_ip_exdes_tb.DUT.ex_design.axi_vip_mst.inst" will be printed
    * out. Pass this path to the new function.
    ***********************************************************************************************/
    slv_agent = new("slave vip mem agent",DUT.ex_design.axi_vip_slv.inst.IF); // agent is newed
    slv_agent.start_slave();                                                  //  agent starts to run

  endtask

