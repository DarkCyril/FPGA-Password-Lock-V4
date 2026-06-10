# FPGA-Password-Lock-V4

An FPGA-based access control system implemented on the Intel MAX 10 (DE10-Lite) development board. The project uses a Moore Finite State Machine (FSM) to manage password entry, password updates, lockout protection, unlock timing, and PWM-controlled solenoid.

The system interfaces with a physical solenoid lock through a MOSFET driver circuit and includes a power-saving mode that reduces solenoid power consumption.

# Features
Password storage and verification
User-configurable password update mode
Failed-attempt lockout protection
Variable lockout timer with escalating delays
PWM-controlled solenoid driver
Power-saving hold mode
Hardware debouncing for push-button inputs
Seven-segment display integration
RTL simulation and hardware validation

# Hardware Used
# FPGA
Intel MAX 10 FPGA (DE10-Lite)
# Driver Circuit
N-Channel MOSFET
Flyback diode protection
External 12V power supply
# Actuator
12V Solenoid Lock
