# VHDL Traffic Light Controller

This repository contains the VHDL code for a Traffic Light Controller, which was developed as a final project for my VLSI Design class. The project aims to simulate the operation of traffic lights at an intersection, using a Finite State Machine (FSM) approach to manage the light sequences based on sensor inputs, demonstrating both the practical application of VHDL in digital system design and an understanding of state machine concepts in traffic light control.

## Project Overview

The Traffic Light Controller is designed to manage the traffic flow at an intersection by controlling the lights for the highway and the road. It responds to sensor inputs, which simulate the presence of vehicles, to adjust the light sequences accordingly. This project showcases the use of VHDL for creating a digital design that can be implemented on FPGA or any other digital logic device supporting VHDL.

### Key Features

- **Sensor Input Handling**: Adjusts the traffic light sequences based on the presence of vehicles.
- **Finite State Machine**: Utilizes FSM for controlling the sequence of lights.
- **Modular Design**: Easy to understand and modify for different traffic scenarios.
- **Simulation Ready**: Prepared for simulation with test benches in environments supporting VHDL.

## Inspiration

The structure of this project and the approach taken were inspired by the example provided at [FPGA4Student](https://www.fpga4student.com/2017/08/vhdl-code-for-traffic-light-controller.html). This reference served as a valuable resource in understanding the fundamentals of designing a traffic light controller using VHDL and influenced the overall design and implementation of this project.

## Getting Started

To get started with this project, you will need a VHDL-compatible simulation or synthesis tool, such as Xilinx Vivado, Altera Quartus, or a similar environment that supports VHDL code compilation and FPGA programming.

### Running the Simulation

1. Clone this repository to your local machine.
2. Open the project in your VHDL-compatible tool.
3. Compile the VHDL source files.
4. Run the simulation with the provided test bench or program it onto an FPGA to see it in action.



---

**Note**: This project was created for educational purposes as part of a VLSI Design class final project. It is intended as a demonstration of applying VHDL for digital design and not for real-world traffic management solutions.
