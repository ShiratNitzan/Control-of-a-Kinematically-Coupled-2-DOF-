# Control of a Kinematically Coupled 2-DOF Underactuated Prosthetic Leg

## Project Overview
This repository contains the design, modeling, and simulation of a motorized prosthetic leg that utilizes an **underactuated mechanism**. The core innovation lies in using a **single central motor** to actuate both the knee and ankle joints through optimized kinematic coupling.

Developed at the **eNaBle Lab (Technion)**, this project focuses on replicating natural gait patterns while reducing mechanical complexity and weight.

## Documentation & Research
For a detailed theoretical background and research data, please refer to the included PDF file:
**`Control of a Kinematically Coupled 2 DOF.pdf`**

Key sections in the document:
* **Research & Methodology:** Full breakdown of the biomechanical study and control architecture.
* **File Descriptions (Appendix):** Detailed list of all code files and scripts can be found on **page 27**.
* **Expected Results (Appendix):** Explanation of the generated outputs, logs, and figures can be found on **page 29**.

## Requirements
* **MATLAB Version:** R2022b
* **Toolboxes Required:**
  * Simulink
  * Simscape & Simscape Multibody
  * Control System Toolbox


## Getting Started
1. **Download:** Download the repository as a ZIP file and extract it.
2. **Setup:** Open MATLAB R2022b and navigate to the project root directory.
3. **Run:** Execute the main function:
   ```matlab
   main.m
