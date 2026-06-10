# FPGA Password Lock System V4

An FPGA-based access control system implemented on the Intel MAX 10 (DE10-Lite) development board. The project uses a Moore Finite State Machine (FSM) to manage password entry, password updates, lockout protection, unlock timing, and PWM-controlled solenoid actuation.

The system interfaces with a physical solenoid lock through a MOSFET driver circuit and includes a power-saving mode that reduces solenoid power consumption after actuation.

---

## Features

* Password storage and verification
* User-configurable password update mode
* Failed-attempt lockout protection
* Variable lockout timer with escalating delays
* PWM-controlled solenoid driver
* Power-saving hold mode
* Hardware debouncing for push-button inputs
* RTL simulation and hardware validation

---

## Hardware Used

### FPGA

* Intel MAX 10 FPGA (DE10-Lite)

### Driver Circuit

* N-Channel MOSFET
* Flyback diode protection
* External 12V power supply

### Actuator

* 12V Solenoid Lock

---

## System Architecture

```text
Switches / Buttons
        │
        ▼
 Password FSM
        │
        ├── Lockout Timer
        │
        ├── Password Storage
        │
        └── PWM Driver
                 │
                 ▼
            MOSFET Driver
                 │
                 ▼
              Solenoid
```

---

## State Machine

The lock controller is implemented as a Moore FSM with six states:

| State   | Description                         |
| ------- | ----------------------------------- |
| S_IDLE  | Waiting for user input              |
| S_SET   | Update stored password              |
| S_INPUT | Enter password                      |
| S_CHK   | Verify password                     |
| S_BLK   | Lockout state after failed attempts |
| S_UNBLK | Unlock state                        |

---

## Power-Saving PWM Mode

Initial testing showed that the solenoid required significantly more current to actuate than to remain engaged.

A PWM hold mode was implemented to reduce power consumption:

1. Solenoid receives full power during pull-in.
2. A startup timer keeps the solenoid energized for approximately 20 ms.
3. After pull-in completes, PWM hold mode is enabled.
4. Duty cycle is reduced while maintaining reliable operation.

### Results

| Mode      | Duty Cycle |
| --------- | ---------- |
| Pull-In   | 100%       |
| Hold      | ~40%       |
| Reduction | ~60%       |

Hardware testing demonstrated reliable actuation while significantly reducing steady-state power consumption and coil heating.

---

## Engineering Challenges

### Solenoid Actuation

Initial PWM experiments could not reliably actuate the lock at reduced duty cycles.

Investigation revealed that the issue was not insufficient holding force but insufficient pull-in time.

The solution was to:

* Add a startup delay using existing PWM timing infrastructure
* Allow the solenoid to fully actuate
* Transition to reduced-duty hold mode

This enabled reliable operation at substantially lower hold duty cycles.

### Timing Design

The PWM generator operates using a 50 MHz system clock.

```text
50 MHz Clock
    ↓
50,000 Clock Cycles
    ↓
1 ms PWM Period
```

Additional timing behavior was created by counting completed PWM periods rather than introducing additional timers.

---

## Project Structure

```text
FPGA-Password-Lock-V4/
│
├── constraints/
│   └── DE10-Lite pin assignments
│
├── src/
│   ├── password_lock_top.v
│   ├── password_fsm.v
│   ├── count_down.v
│   └── powersaving_mode.v
│
├── tb/
│   └── testbench files
│
└── README.md
```

---

## Future Improvements

* PCB design for lock driver circuitry
* Non-volatile password storage
* Keypad interface
* OLED/LCD user interface
* Battery-powered operation
* Expanded verification and testbench coverage

---

## Skills Demonstrated

* Verilog HDL
* Finite State Machine Design
* PWM Generation
* Digital Timing and Counters
* FPGA Hardware Integration
* MOSFET Driver Design
* Hardware Debugging
* Oscilloscope and Logic Analyzer Validation
* Power Optimization Techniques

---

## Demo

