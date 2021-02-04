module ddr3_reg(
      aclk          ,
      areset_n      ,
      apb_sel       , 
      apb_enable    , 
      apb_addr      , 
      apb_write     , 
      apb_ready     , 
      apb_wdata     , 
      apb_rdata     ,
      reg_rdata     ,
      reg_raddr     ,
      reg_vld       
);
   input                               aclk          ;
   input                               areset_n      ;

   input                               apb_sel       ; 
   input                               apb_enable    ; 
   input  [7:0]                        apb_addr      ; 
   input                               apb_write     ; 
   input                               apb_ready     ; 
   input  [15:0]                       apb_wdata     ; 
   input  [15:0]                       apb_rdata     ; 
   output [15:0]                       reg_rdata     ; 
   output [ 7:0]                       reg_raddr     ; 
   output                              reg_vld       ; 

//////////////////////////////////////////////////////////////////////////////
   reg  [15:0]                       reg_rdata     ; 
   reg  [ 7:0]                       reg_raddr     ; 
   reg                               reg_vld       ; 
//////////////////////////////////////////////////////////////////////////////

   reg  [15:0]                         MODE_REG_0       ;//00
   reg  [15:0]                         MODE_REG_1       ;//01
   reg  [15:0]                         MODE_REG_2       ;//02
   reg  [15:0]                         MODE_REG_3       ;//03
   reg  [15:0]                         CTRL_MODE_DATA   ;//04
   reg  [15:0]                         STATUS_REG_DATA  ;//05
   reg  [15:0]                         arb_mode         ;//E0
   reg  [15:0]                         PRIORITY_SETTING ;//E4
   reg  [15:0]                         WEIGHT_SETTING0  ;//E8
   reg  [15:0]                         WEIGHT_SETTING1  ;//EC
   reg  [15:0]                         WEIGHT_SETTING2  ;//F0
   reg  [15:0]                         WEIGHT_SETTING3  ;//F4

//////////////////////////////////////////////////////////////////////////////
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		MODE_REG_0  <= `MODE_REG_0; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`MODE_REG_0_ADDR) && apb_ready ) begin
		MODE_REG_0[2]     <=  apb_wdata[2]; 	
		MODE_REG_0[3]     <=  apb_wdata[3]; 	
		MODE_REG_0[6:4]   <=  apb_wdata[6:4]; 	
		MODE_REG_0[11:9]  <=  apb_wdata[11:9]; 	
		MODE_REG_0[15:13] <=  apb_wdata[15:13]; 	
	end
end
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		MODE_REG_1  <= `MODE_REG_1; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`MODE_REG_1_ADDR) && apb_ready ) begin
		MODE_REG_1[1]     <=  apb_wdata[1]; 	
		MODE_REG_1[2]     <=  apb_wdata[2]; 	
		MODE_REG_1[5]     <=  apb_wdata[5]; 	
		MODE_REG_1[6]     <=  apb_wdata[6]; 	
		MODE_REG_1[8]     <=  apb_wdata[8]; 	
		MODE_REG_1[9]     <=  apb_wdata[9]; 	
		MODE_REG_1[10]    <=  apb_wdata[10]; 	
		MODE_REG_1[15:13] <=  apb_wdata[15:13]; 	
	end
end
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		MODE_REG_2  <= `MODE_REG_2; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`MODE_REG_2_ADDR) && apb_ready ) begin
		MODE_REG_2[5:3]     <=  apb_wdata[5:3]; 	
		MODE_REG_2[8]     <=  apb_wdata[8]; 	
		MODE_REG_2[10:9]    <=  apb_wdata[10:9]; 	
		MODE_REG_2[15:11]    <=  apb_wdata[15:11]; 	
	end
end
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		MODE_REG_3       <= `MODE_REG_3; 
	end
	//else if (apb_sel && apb_enable && apb_write && (apb_addr==`MODE_REG_3_ADDR) && apb_ready ) begin
	else   begin
	end
end
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		STATUS_REG_DATA  <= `STATUS_REG_DATA; 
	end
	else if (CTRL_MODE_DATA[0] ) begin
		if (CTRL_MODE_DATA[15:14]==2'b00)  STATUS_REG_DATA='d0;
		else if (CTRL_MODE_DATA[15:14]==2'b01)  STATUS_REG_DATA='d3;
		else if (CTRL_MODE_DATA[15:14]==2'b10)  STATUS_REG_DATA='d1;
		else if (CTRL_MODE_DATA[15:14]==2'b11)  STATUS_REG_DATA='d2;
	end
end

always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		CTRL_MODE_DATA  <= `CTRL_MODE_DATA; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`CTRL_MODE_DATA_ADDR) && apb_ready ) begin
		CTRL_MODE_DATA[0]     <=  apb_wdata[0]; 	
		CTRL_MODE_DATA[15:14]    <=  apb_wdata[15:14]; 	
	end
end
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		arb_mode  <= `ARB_MODE; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`ARB_MODE_ADDR) && apb_ready ) begin
		arb_mode[0]     <=  apb_wdata[0]; 	
		arb_mode[2:1]    <=  apb_wdata[2:1]; 	
	end
end
//PRIORITY_SETTING
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		PRIORITY_SETTING  <= `PRIORITY_SETTING; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`PRIORITY_SETTING_ADDR) && apb_ready ) begin
		PRIORITY_SETTING[1:0]    <=  apb_wdata[1:0]; 	
		PRIORITY_SETTING[3:2]    <=  apb_wdata[3:2]; 	
		PRIORITY_SETTING[5:4]    <=  apb_wdata[5:4]; 	
	end
end
//WEIGHT_SETTING0
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		WEIGHT_SETTING0  <= `WEIGHT_SETTING0; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`WEIGHT_SETTING0_ADDR) && apb_ready ) begin
		WEIGHT_SETTING0[3:0]    <=  apb_wdata[3:0]; 	
	end
end
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		WEIGHT_SETTING1  <= `WEIGHT_SETTING1; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`WEIGHT_SETTING1_ADDR) && apb_ready ) begin
		WEIGHT_SETTING1[3:0]    <=  apb_wdata[3:0]; 	
	end
end
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		WEIGHT_SETTING2  <= `WEIGHT_SETTING2; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`WEIGHT_SETTING2_ADDR) && apb_ready ) begin
		WEIGHT_SETTING2[3:0]    <=  apb_wdata[3:0]; 	
	end
end
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		WEIGHT_SETTING3  <= `WEIGHT_SETTING3; 
	end
	else if (apb_sel && apb_enable && apb_write && (apb_addr==`WEIGHT_SETTING3_ADDR) && apb_ready ) begin
		WEIGHT_SETTING3[3:0]    <=  apb_wdata[3:0]; 	
	end
end

//reg_rdata
//reg_vld
always @ (posedge aclk or negedge areset_n)
begin
	if (~areset_n) begin
		reg_rdata  <= 'd0; 
		reg_raddr  <= 'd0; 
		reg_vld    <= 'd0; 
	end
	else if (apb_sel && apb_enable && ~apb_write && apb_ready ) begin
		reg_vld    <= 'd1;
		reg_raddr    <= apb_addr;
		case(apb_addr)	
                  `MODE_REG_0_ADDR      :reg_rdata <=  MODE_REG_0      ; 
                  `MODE_REG_1_ADDR      :reg_rdata <=  MODE_REG_1      ; 
                  `MODE_REG_2_ADDR      :reg_rdata <=  MODE_REG_2      ; 
                  `MODE_REG_3_ADDR      :reg_rdata <=  MODE_REG_3      ; 
                  `CTRL_MODE_DATA_ADDR  :reg_rdata <=  CTRL_MODE_DATA  ; 
                  `STATUS_REG_DATA_ADDR :reg_rdata <=  STATUS_REG_DATA ; 
                  `ARB_MODE_ADDR        :reg_rdata <=  arb_mode        ; 
                  `PRIORITY_SETTING_ADDR:reg_rdata <=  PRIORITY_SETTING; 
                  `WEIGHT_SETTING0_ADDR :reg_rdata <=  WEIGHT_SETTING0 ; 
                  `WEIGHT_SETTING1_ADDR :reg_rdata <=  WEIGHT_SETTING1 ; 
                  `WEIGHT_SETTING2_ADDR :reg_rdata <=  WEIGHT_SETTING2 ; 
                  `WEIGHT_SETTING3_ADDR :reg_rdata <=  WEIGHT_SETTING3 ; 
		  default               :reg_rdata <=  'h5a5a_5a5a     ;//apb_rdata
		 endcase
	end
	else begin 
		reg_vld    <= 'd0; 
	end
end






endmodule

