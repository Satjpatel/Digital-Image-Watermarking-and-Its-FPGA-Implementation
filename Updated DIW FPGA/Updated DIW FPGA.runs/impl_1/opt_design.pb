
O
Command: %s
53*	vivadotcl2

opt_design2default:defaultZ4-113h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xcu2502default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xcu2502default:defaultZ17-349h px? 
n
,Running DRC as a precondition to command %s
22*	vivadotcl2

opt_design2default:defaultZ4-22h px? 
R

Starting %s Task
103*constraints2
DRC2default:defaultZ18-103h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
U
DRC finished with %s
272*project2
0 Errors2default:defaultZ1-461h px? 
d
BPlease refer to the DRC report (report_drc) for more information.
274*projectZ1-462h px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:08 ; elapsed = 00:00:06 . Memory (MB): peak = 2206.668 ; gain = 9.8092default:defaulth px? 
g

Starting %s Task
103*constraints2,
Cache Timing Information2default:defaultZ18-103h px? 
O
:Ending Cache Timing Information Task | Checksum: d7420b70
*commonh px? 
?

%s
*constraints2s
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.199 . Memory (MB): peak = 2206.668 ; gain = 0.0002default:defaulth px? 
a

Starting %s Task
103*constraints2&
Logic Optimization2default:defaultZ18-103h px? 
i

Phase %s%s
101*constraints2
1 2default:default2
Retarget2default:defaultZ18-101h px? 
x
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
782default:default2
8902default:defaultZ31-138h px? 
K
Retargeted %s cell(s).
49*opt2
02default:defaultZ31-49h px? 
;
&Phase 1 Retarget | Checksum: 8bd19ea0
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:18 ; elapsed = 00:00:18 . Memory (MB): peak = 2399.207 ; gain = 0.1482default:defaulth px? 
?
.Phase %s created %s cells and removed %s cells267*opt2
Retarget2default:default2
14262default:default2
14982default:defaultZ31-389h px? 
u

Phase %s%s
101*constraints2
2 2default:default2(
Constant propagation2default:defaultZ18-101h px? 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px? 
G
2Phase 2 Constant propagation | Checksum: 9cb596e8
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:20 ; elapsed = 00:00:20 . Memory (MB): peak = 2399.207 ; gain = 0.1482default:defaulth px? 
?
.Phase %s created %s cells and removed %s cells267*opt2(
Constant propagation2default:default2
3082default:default2
21062default:defaultZ31-389h px? 
f

Phase %s%s
101*constraints2
3 2default:default2
Sweep2default:defaultZ18-101h px? 
9
$Phase 3 Sweep | Checksum: 16dec0e67
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:22 ; elapsed = 00:00:23 . Memory (MB): peak = 2399.207 ; gain = 0.1482default:defaulth px? 
?
.Phase %s created %s cells and removed %s cells267*opt2
Sweep2default:default2
02default:default2
9322default:defaultZ31-389h px? 
r

Phase %s%s
101*constraints2
4 2default:default2%
BUFG optimization2default:defaultZ18-101h px? 
?
4Inserted BUFG %s to drive %s load(s) on clock net %s141*opt2&
clk_IBUF_BUFG_inst2default:default2
191462default:default2#
clk_IBUF_inst/O2default:defaultZ31-194h px? 
W
!Inserted %s BUFG(s) on clock nets140*opt2
12default:defaultZ31-193h px? 
?
PPhase BUFG optimization inserted %s global clock buffer(s) for CLOCK_LOW_FANOUT.553*opt2
02default:defaultZ31-1077h px? 
D
/Phase 4 BUFG optimization | Checksum: e15cad92
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:28 ; elapsed = 00:00:30 . Memory (MB): peak = 2399.207 ; gain = 0.1482default:defaulth px? 
?
EPhase %s created %s cells of which %s are BUFGs and removed %s cells.395*opt2%
BUFG optimization2default:default2
12default:default2
12default:default2
02default:defaultZ31-662h px? 
|

Phase %s%s
101*constraints2
5 2default:default2/
Shift Register Optimization2default:defaultZ18-101h px? 
?
dSRL Remap converted %s SRLs to %s registers and converted %s registers of register chains to %s SRLs546*opt2
02default:default2
02default:default2
02default:default2
02default:defaultZ31-1064h px? 
N
9Phase 5 Shift Register Optimization | Checksum: e15cad92
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:28 ; elapsed = 00:00:30 . Memory (MB): peak = 2399.207 ; gain = 0.1482default:defaulth px? 
?
.Phase %s created %s cells and removed %s cells267*opt2/
Shift Register Optimization2default:default2
02default:default2
02default:defaultZ31-389h px? 
x

Phase %s%s
101*constraints2
6 2default:default2+
Post Processing Netlist2default:defaultZ18-101h px? 
J
5Phase 6 Post Processing Netlist | Checksum: e15cad92
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:29 ; elapsed = 00:00:31 . Memory (MB): peak = 2399.207 ; gain = 0.1482default:defaulth px? 
?
.Phase %s created %s cells and removed %s cells267*opt2+
Post Processing Netlist2default:default2
02default:default2
02default:defaultZ31-389h px? 
/
Opt_design Change Summary
*commonh px? 
/
=========================
*commonh px? 


*commonh px? 


*commonh px? 
?
z-------------------------------------------------------------------------------------------------------------------------
*commonh px? 
?
?|  Phase                        |  #Cells created  |  #Cells Removed  |  #Constrained objects preventing optimizations  |
-------------------------------------------------------------------------------------------------------------------------
*commonh px? 
?
?|  Retarget                     |            1426  |            1498  |                                              0  |
|  Constant propagation         |             308  |            2106  |                                              0  |
|  Sweep                        |               0  |             932  |                                              0  |
|  BUFG optimization            |               1  |               0  |                                              0  |
|  Shift Register Optimization  |               0  |               0  |                                              0  |
|  Post Processing Netlist      |               0  |               0  |                                              0  |
-------------------------------------------------------------------------------------------------------------------------
*commonh px? 


*commonh px? 


*commonh px? 
a

Starting %s Task
103*constraints2&
Connectivity Check2default:defaultZ18-103h px? 
?

%s
*constraints2s
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.155 . Memory (MB): peak = 2399.207 ; gain = 0.0002default:defaulth px? 
I
4Ending Logic Optimization Task | Checksum: 574b45b0
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:35 ; elapsed = 00:00:38 . Memory (MB): peak = 2399.207 ; gain = 0.1482default:defaulth px? 
a

Starting %s Task
103*constraints2&
Power Optimization2default:defaultZ18-103h px? 
s
7Will skip clock gating for clocks with period < %s ns.
114*pwropt2
2.002default:defaultZ34-132h px? 
I
4Ending Power Optimization Task | Checksum: 574b45b0
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:01 . Memory (MB): peak = 2399.207 ; gain = 0.0002default:defaulth px? 
\

Starting %s Task
103*constraints2!
Final Cleanup2default:defaultZ18-103h px? 
D
/Ending Final Cleanup Task | Checksum: 574b45b0
*commonh px? 
?

%s
*constraints2o
[Time (s): cpu = 00:00:00 ; elapsed = 00:00:00 . Memory (MB): peak = 2399.207 ; gain = 0.0002default:defaulth px? 
b

Starting %s Task
103*constraints2'
Netlist Obfuscation2default:defaultZ18-103h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.1822default:default2
2399.2072default:default2
0.0002default:defaultZ17-268h px? 
J
5Ending Netlist Obfuscation Task | Checksum: 574b45b0
*commonh px? 
?

%s
*constraints2s
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.183 . Memory (MB): peak = 2399.207 ; gain = 0.0002default:defaulth px? 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
302default:default2
02default:default2
02default:default2
02default:defaultZ4-41h px? 
\
%s completed successfully
29*	vivadotcl2

opt_design2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2 
opt_design: 2default:default2
00:00:502default:default2
00:00:542default:default2
2399.2072default:default2
202.3482default:defaultZ17-268h px? 
H
&Writing timing data to binary archive.266*timingZ38-480h px? 
?
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2y
eC:/Users/HP/Desktop/Sem 7/Seminar/Updated DIW FPGA/Updated DIW FPGA.runs/impl_1/Eight_Bit_DCT_opt.dcp2default:defaultZ17-1381h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2&
write_checkpoint: 2default:default2
00:00:272default:default2
00:00:212default:default2
2399.2072default:default2
0.0002default:defaultZ17-268h px? 
?
%s4*runtcl2?
yExecuting : report_drc -file Eight_Bit_DCT_drc_opted.rpt -pb Eight_Bit_DCT_drc_opted.pb -rpx Eight_Bit_DCT_drc_opted.rpx
2default:defaulth px? 
?
Command: %s
53*	vivadotcl2?
lreport_drc -file Eight_Bit_DCT_drc_opted.rpt -pb Eight_Bit_DCT_drc_opted.pb -rpx Eight_Bit_DCT_drc_opted.rpx2default:defaultZ4-113h px? 
>
Refreshing IP repositories
234*coregenZ19-234h px? 
G
"No user IP repositories specified
1154*coregenZ19-1704h px? 
?
"Loaded Vivado IP repository '%s'.
1332*coregen2;
'D:/XilinxNayaDaur/Vivado/2020.2/data/ip2default:defaultZ19-2313h px? 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
?
#The results of DRC are in file %s.
168*coretcl2?
kC:/Users/HP/Desktop/Sem 7/Seminar/Updated DIW FPGA/Updated DIW FPGA.runs/impl_1/Eight_Bit_DCT_drc_opted.rptkC:/Users/HP/Desktop/Sem 7/Seminar/Updated DIW FPGA/Updated DIW FPGA.runs/impl_1/Eight_Bit_DCT_drc_opted.rpt2default:default8Z2-168h px? 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2 
report_drc: 2default:default2
00:02:352default:default2
00:02:222default:default2
4022.3322default:default2
1623.1252default:defaultZ17-268h px? 


End Record