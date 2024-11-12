# UNIC-CASS Tutorial
## Verification design
### 1. Purpose of verification
Verification in VLSI ensures that a design meets functional and performance requirements before physical implementation. It helps detect and fix issues early, ensuring compliance with specifications and industry standards. Verifying at this stage reduces costs and risks, improving overall design quality and reliability for a successful chip fabrication.

The verification step includes two phases: RTL Verification and Gate Level Verification. In this tutorial, these processes will be explained step-by-step.
### 2. RTL Verification
- **Step 1**: Prepare your RTL design

Your design should be written in Verilog and be placed in the directory `verilog/rtl`.

```
.
└── verilog
    ├── dv
    ├── gl
    ├── includes
    └── rtl
        ├── defines.v
        ├── lovers_bec
        │   ├── lovers_acb.v
        │   ├── lovers_bec.v
        │   ├── lovers_classic_squarer.v
        │   ├── lovers_controller.v
        │   └── lovers_interleaved_mult.v
        ├── uprj_netlists.v
        ├── user_defines.v
        ├── user_proj_example.v
        ├── user_project_wrapper.v
        └── vmsu_8bit
            └── vmsu_8bit_top.v
```
In the case that your design has sub-modules, do not describe the hierachy in your verilog HDL description. All the `includes` will be illustrated in the file `verilog/includes/includes.rtl.caravel_user_project`. The detailed modification of this file will be dedicated in next step.

- **Step 2**: Modify the hierachy description

To describe the hierachy of your design, do not use the `'includes` statement in your verilog HDL description. Take a look in the file `verilog/includes/includes.rtl.caravel_user_project` and modify as follows. For example, the top design has 5 sub-modules named as `lovers_acb.v` , `lovers_bec.v`, `lovers_classic_squarer.v`, `lovers_controller.v`, and `lovers_interleaved_mult.v`. The modified includes file is:
```
# Caravel user project includes
# Top-integration Module
-v $(USER_PROJECT_VERILOG)/rtl/user_project_wrapper.v	 

# LOVERS BEC Projects
-v $(USER_PROJECT_VERILOG)/rtl/lovers_bec/lovers_controller.v
-v $(USER_PROJECT_VERILOG)/rtl/lovers_bec/lovers_bec.v
-v $(USER_PROJECT_VERILOG)/rtl/lovers_bec/lovers_acb.v
-v $(USER_PROJECT_VERILOG)/rtl/lovers_bec/lovers_interleaved_mult.v
-v $(USER_PROJECT_VERILOG)/rtl/lovers_bec/lovers_classic_squarer.v
```

- **Step 3**: Prepare your testbench and firmware for verification

To verify your design, a HDL description of testbed, which dedicate the interconnection between your design and Caravel core, has to be prepared and placed in the directory `verilog/dv/{your_testbench}`. In addition, a C-file of firmware which programmes the Caravel core is also located in the same directory. In more detailed how to program the Caravel core to communicate with your core is presented in Github homepage of Caravel Efabless.
```
.
└── verilog
    ├── dv
    │   ├── la_bec
    │   │   │   ├── Makefile
    │   │   │   ├── io_la.c
    │   │   │   ├── la_bec.c
    │   │   │   ├── la_bec_tb.v
    │   │   │   ├── sm_bec_v3_randomKey_spec.h
    │   │   │   ├── sm_bec_v3_randomKey_txt.h
    ├── gl
    ├── includes
    └── rtl
```

- **Step 4**: Execute RTL Verification
To process RTL Verification, execute this command:
```
make verify-{your_testbench}-rtl
```
If you meet the Error as follows, please check the consistency of the name between the directory `verilog/dv/{your_testbench}` and the executed command.
```
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
Makefile:27: /Users/rmit/bec-unic/openlane/../mgmt_core_wrapper/verilog/dv/make/env.makefile: No such file or directory
Makefile:28: /Users/rmit/bec-unic/openlane/../mgmt_core_wrapper/verilog/dv/make/var.makefile: No such file or directory
Makefile:29: /Users/rmit/bec-unic/openlane/../mgmt_core_wrapper/verilog/dv/make/cpu.makefile: No such file or directory
Makefile:30: /Users/rmit/bec-unic/openlane/../mgmt_core_wrapper/verilog/dv/make/sim.makefile: No such file or directory
make: *** No rule to make target `/Users/rmit/bec-unic/openlane/../mgmt_core_wrapper/verilog/dv/make/sim.makefile'.  Stop.
make: *** [verify-la_bec-rtl] Error 2
```
A successful RTL verification is shown as below:
```
docker pull efabless/dv:latest
latest: Pulling from efabless/dv
Digest: sha256:06497b070c8578fbbe87170c9f4dfa61c2c9a9d9f665a637c4d822ea98a7f1b7
Status: Image is up to date for efabless/dv:latest
docker.io/efabless/dv:latest
docker run -u $(id -u $USER):$(id -g $USER) -v /Users/rmit/IC5-CASS-2024:/Users/rmit/IC5-CASS-2024 -v /Users/rmit/IC5-CASS-2024/dependencies/pdks:/Users/rmit/IC5-CASS-2024/dependencies/pdks -v /Users/rmit/IC5-CASS-2024/caravel:/Users/rmit/IC5-CASS-2024/caravel -v /Users/rmit/IC5-CASS-2024/mgmt_core_wrapper:/Users/rmit/IC5-CASS-2024/mgmt_core_wrapper -e TARGET_PATH=/Users/rmit/IC5-CASS-2024 -e PDK_ROOT=/Users/rmit/IC5-CASS-2024/dependencies/pdks -e CARAVEL_ROOT=/Users/rmit/IC5-CASS-2024/caravel -e TOOLS=/foss/tools/riscv-gnu-toolchain-rv32i/217e7f3debe424d61374d31e33a091a630535937 -e DESIGNS=/Users/rmit/IC5-CASS-2024 -e USER_PROJECT_VERILOG=/Users/rmit/IC5-CASS-2024/verilog -e PDK=sky130A -e CORE_VERILOG_PATH=/Users/rmit/IC5-CASS-2024/mgmt_core_wrapper/verilog -e CARAVEL_VERILOG_PATH=/Users/rmit/IC5-CASS-2024/caravel/verilog -e MCW_ROOT=/Users/rmit/IC5-CASS-2024/mgmt_core_wrapper efabless/dv:latest sh -c "source ~/.bashrc && cd /Users/rmit/IC5-CASS-2024/verilog/dv/la_bec && export SIM=RTL && make"
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
        -f/Users/rmit/IC5-CASS-2024/mgmt_core_wrapper/verilog/includes/includes.rtl.caravel \
        -f/Users/rmit/IC5-CASS-2024/verilog/includes/includes.rtl.caravel_user_project -o la_bec.vvp la_bec_tb.v
/Users/rmit/IC5-CASS-2024/caravel/verilog/rtl/caravel.v:236: warning: input port clock is coerced to inout.
vvp  la_bec.vvp
Reading la_bec.hex
la_bec.hex loaded into memory
Memory 5 bytes = 0x6f 0x00 0x00 0x0b 0x13
FST info: dumpfile la_bec.vcd opened for output.
Executing BEC in Multiple Encryption Mode!
LA BEC: Processor writes data to BEC
LA BEC: #00 write data done
LA BEC: Processor writes data to BEC
LA BEC: BEC is processing
LA BEC: #01 write data done
LA BEC done
la_bec_tb.v:188: $finish called at 38765012500 (1ps)
mv la_bec.vcd RTL-la_bec.vcd
rm la_bec.vvp
```

- **Step 5**: Debuging RTL design

To debug your design, simulated waveform will be located in the path `verilog/dv/{your_testbench}/RTL-{your_testbench}.vcd`. For waveform debugging, Gtkwave could be use for reading and display the result wave by the executing command:
```
gtkwave verilog/dv/RTL-{your_testbench}.vcd
```

### 3. Gate Level Verification
- **Step 1**: Prepare your Gate Level design

Your synthesized gate level design will be automatically placed in the directory `verilog/gl`. Please verify the existence of these synthesized gate level design before start the Gate Level Verification process.

```
.
└── verilog
    ├── dv
    ├── gl
    │   ├── bec.nl.v
    │   ├── bec.v
    │   ├── lovers_controller.nl.v
    │   ├── lovers_controller.v
    │   ├── user_project_wrapper.nl.v
    │   ├── user_project_wrapper.v
    ├── includes
    └── rtl
```
In the case that your design has sub-modules, do not describe the hierachy in your verilog HDL description. All the `includes` will be illustrated in the file `verilog/includes/includes.gl.caravel_user_project`. The detailed modification of this file will be dedicated in next step.

- **Step 2**: Modify the hierachy description

To describe the hierachy of your design, do not use the `'includes` statement in your verilog HDL description. Take a look in the file `verilog/includes/includes.gl.caravel_user_project` and modify as follows. For example, the top design has 2 synthesized sub-modules named as `lovers_bec.v` and `lovers_controller.v`. The modified includes file is:
```
// Caravel user project includes		
$(USER_PROJECT_VERILOG)/gl/user_project_wrapper.v    
$(USER_PROJECT_VERILOG)/gl/bec.v
$(USER_PROJECT_VERILOG)/gl/lovers_controller.v
$(CARAVEL_VERILOG_PATH)/gl/caravel_core.v
```

- **Step 4**: Execute RTL Verification
To process RTL Verification, execute this command:
```
make verify-{your_testbench}-gl
```

A successful RTL verification is shown as below:
```
ddocker pull efabless/dv:latest
latest: Pulling from efabless/dv
Digest: sha256:06497b070c8578fbbe87170c9f4dfa61c2c9a9d9f665a637c4d822ea98a7f1b7
Status: Image is up to date for efabless/dv:latest
docker.io/efabless/dv:latest
docker run -u $(id -u $USER):$(id -g $USER) -v /Users/rmit/IC5-CASS-2024:/Users/rmit/IC5-CASS-2024 -v /Users/rmit/IC5-CASS-2024/dependencies/pdks:/Users/rmit/IC5-CASS-2024/dependencies/pdks -v /Users/rmit/IC5-CASS-2024/caravel:/Users/rmit/IC5-CASS-2024/caravel -v /Users/rmit/IC5-CASS-2024/mgmt_core_wrapper:/Users/rmit/IC5-CASS-2024/mgmt_core_wrapper -e TARGET_PATH=/Users/rmit/IC5-CASS-2024 -e PDK_ROOT=/Users/rmit/IC5-CASS-2024/dependencies/pdks -e CARAVEL_ROOT=/Users/rmit/IC5-CASS-2024/caravel -e TOOLS=/foss/tools/riscv-gnu-toolchain-rv32i/217e7f3debe424d61374d31e33a091a630535937 -e DESIGNS=/Users/rmit/IC5-CASS-2024 -e USER_PROJECT_VERILOG=/Users/rmit/IC5-CASS-2024/verilog -e PDK=sky130A -e CORE_VERILOG_PATH=/Users/rmit/IC5-CASS-2024/mgmt_core_wrapper/verilog -e CARAVEL_VERILOG_PATH=/Users/rmit/IC5-CASS-2024/caravel/verilog -e MCW_ROOT=/Users/rmit/IC5-CASS-2024/mgmt_core_wrapper efabless/dv:latest sh -c "source ~/.bashrc && cd /Users/rmit/IC5-CASS-2024/verilog/dv/la_bec && export SIM=GL && make"
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
iverilog -Ttyp -DFUNCTIONAL -DGL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
        -f/Users/rmit/IC5-CASS-2024/mgmt_core_wrapper/verilog/includes/includes.gl.caravel \
        -f/Users/rmit/IC5-CASS-2024/verilog/includes/includes.gl.caravel_user_project -o la_bec.vvp la_bec_tb.v
/Users/rmit/IC5-CASS-2024/caravel/verilog/gl/caravel.v:755: warning: input port clock is coerced to inout.
vvp  la_bec.vvp
Reading la_bec.hex
la_bec.hex loaded into memory
Memory 5 bytes = 0x6f 0x00 0x00 0x0b 0x13
FST info: dumpfile la_bec.vcd opened for output.
Executing BEC in Multiple Encryption Mode!
LA BEC: Processor writes data to BEC
LA BEC: #00 write data done
LA BEC: Processor writes data to BEC
LA BEC: BEC is processing
LA BEC: #01 write data done
LA BEC done
la_bec_tb.v:188: $finish called at 38765012500 (1ps)
mv la_bec.vcd GL-la_bec.vcd
rm la_bec.vvp
```
