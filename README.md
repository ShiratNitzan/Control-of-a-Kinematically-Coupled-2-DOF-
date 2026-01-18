# Control of a Kinematically Coupled 2-DOF Underactuated Prosthetic Leg

## Project Identity & Context
* **Institution:** Technion – Israel Institute of Technology, Faculty of Mechanical Engineering.
* **Laboratory:** Neuro-Robotics and Bionic Limb (eNaBle) Lab.
* **Primary Goal:** Developing a motorized, underactuated prosthetic solution to improve mobility and quality of life for amputees, inspired by the needs of wounded soldiers and civilians.
* **Core Technology:** Single-motor actuation for multi-joint movement (Knee & Ankle).



## Project Overview
This repository contains the design, modeling, and simulation of a motorized prosthetic leg that utilizes an **underactuated mechanism**. The core innovation lies in using a **single central motor** to actuate both the knee and ankle joints through optimized kinematic coupling. This approach focuses on replicating natural gait patterns while significantly reducing mechanical complexity, weight, and energy consumption.

## Documentation & Research
### 1. Main Project Report
For a detailed theoretical background and research data, please refer to:
**`Control of a Kinematically Coupled 2 DOF.pdf`**
* **File Descriptions (Appendix):** See **page 27** for a detailed list of all code files and their specific roles in the project.
* **Expected Results (Appendix):** See **page 29** for an explanation of the generated outputs, simulation logs, and graphical results.

### 2. Supplementary Material & External Data
The file **`Supplementary Material.pdf`** contains the foundational dataset used for this research. This data is based on the study:
*"Parametric Equations to Study and Predict Lower-Limb Joint Kinematics and Kinetics During Human Walking and Slow Running on Slopes"*
**Written by:** Anat Shkedy Rabani, Sarai Mizrachi, Gregory S. Sawicki, Raziel Riemer (Ben-Gurion University of the Negev).

## Requirements
* **MATLAB Version:** R2022b (Student Version)
* **Toolboxes Required:**
    * Simulink
    * Simscape & Simscape Multibody
    * Control System Toolbox

## Getting Started
1.  **Download:** Download the repository as a ZIP file and extract it.
2.  **Setup:** Open MATLAB R2022b and navigate to the project root directory.
3.  **Run:** Execute the main function:
    ```matlab
    main.m
    ```
    *Note: Ensure all subfolders are added to the MATLAB path.*

## 💡 Pro Tip for Users
The interface is interactive and prints detailed information to the MATLAB console. 
**For the best experience, double-click the "Command Window" tab to make it full-screen.** This allows you to clearly see the printed execution steps, system status, and data logs (also saved in `simulation_Log.TXT`) as they appear, making it much easier to "see who is against whom" (follow the process flow).

## Key Features
* **Bio-inspired Design:** Based on human gait data analysis (BGU study).
* **Underactuated Control:** Implementation of a kinematic coupling mechanism.
* **Advanced Control Layers:** SEA (Series Elastic Actuator) control, Impedance Control for safety, and Weighted Error Optimization.
* **Physical Simulation:** Developed using high-fidelity MATLAB Simscape Multibody models.

## Authors
* **Shirat Nitzan** & **Nili E. Krausz**
* *Neuro-Robotics and Bionic Limb (eNaBle) Lab, Faculty of Mechanical Engineering, Technion.*
