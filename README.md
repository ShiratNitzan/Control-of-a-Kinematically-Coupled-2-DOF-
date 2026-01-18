# Control of a Kinematically Coupled 2-DOF Underactuated Prosthetic Leg

## Project Overview
This repository contains the design, modeling, and simulation of a motorized prosthetic leg that utilizes an **underactuated mechanism**. The core innovation lies in using a **single central motor** to actuate both the knee and ankle joints through optimized kinematic coupling.

Developed at the **eNaBle Lab (Technion)**, this project focuses on replicating natural gait patterns while reducing mechanical complexity and weight.

## Documentation & Research
### 1. Main Project Report
For a detailed theoretical background and research data, please refer to:
**`Control of a Kinematically Coupled 2 DOF.pdf`**
* **File Descriptions (Appendix):** See **page 27** for a detailed list of all code files.
* **Expected Results (Appendix):** See **page 29** for explanation of outputs and logs.

### 2. Supplementary Material & External Data
The file **`Supplementary Material.pdf`** contains the dataset used in this research. This data is based on the study:
*"Parametric Equations to Study and Predict Lower-Limb Joint Kinematics and Kinetics During Human Walking and Slow Running on Slopes"*
**Written by:** Anat Shkedy Rabani, Sarai Mizrachi, Gregory S. Sawicki, Raziel Riemer (Ben-Gurion University of the Negev).

## Requirements
* **MATLAB Version:** R2022b (Student Version)
* **Toolboxes Required:**
  * Simulink
  * Simscape & Simscape Multibody
  * Control System Toolbox
  * Optimization Toolbox

## Getting Started
1. **Download:** Download the repository as a ZIP file and extract it.
2. **Setup:** Open MATLAB R2022b and navigate to the project root directory.
3. **Run:** Execute the main function:
   ```matlab
   main.m
