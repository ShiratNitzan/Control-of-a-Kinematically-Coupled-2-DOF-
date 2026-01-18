
%% ==============================
% MAIN SIMULATION FUNCTION
% ==============================
clear all; close all; clc;

disp('===================================================================');
disp('                Simulation performed by Shirat Nitzan 2025              ');
disp('===================================================================');

%% GENERAL PROJECT DESCRIPTION
disp('===================================================================');
disp('                  Welcome to the Motorized Prosthetic Simulation    ');
disp('===================================================================');
disp('This final project aims to design a motorized prosthetic model for above-knee.');
disp('The prosthesis uses a primary motor to actuate both the knee and ankle joints.');
disp('A smaller auxiliary motor helps with kinematic coupling.');
disp('Joint kinematic profiles were obtained from Shkedy Rabani et al. (2022), walking at 1.25 m/s.');
disp('A single walking cycle is modeled over 10 seconds.');
disp('-------------------------------------------------------------------');
disp('Motivation: Restore natural gait, reduce energy expenditure for amputees.');
disp('Goal: Support natural gait, minimize muscle compensation, reduce device weight.');
disp('Objectives: Identify functional kinematic coupling, implement control loop, validate model.');
disp('===================================================================');
disp('Press Enter to start the simulation workflow...');
disp(' ');
input('','s');

%% CREATE MAIN SIMULATION FOLDER
SimulationMainFolderName = input('Enter a name for the main simulation folder (English only): ','s');
SimulationMainFolder = fullfile(pwd, SimulationMainFolderName);
if ~exist(SimulationMainFolder,'dir')
    mkdir(SimulationMainFolder);
end
disp(['Main simulation folder created: ' SimulationMainFolder]);
disp(' ');

% % Create diary file
% diaryFile = fullfile(SimulationMainFolder,'Simulation_Log.txt');
% Safely close any previously open diary
if strcmpi(get(0,'Diary'), 'on')
    diary off
end

% Define diary file and start logging
diaryFile = fullfile(SimulationMainFolder, 'Simulation_Log.txt');
try
    diary(diaryFile);
    diary on;
catch ME
    warning('Could not start diary: %s', ME.message);
end
%% STEP 1: Choose Research Dataset
step1_folder = fullfile(SimulationMainFolder, 'STEP 1 - Choose Research Dataset');
if ~exist(step1_folder,'dir')
    mkdir(step1_folder);
end

disp('-------------------------------------------------------------------');
disp('STEP 1: Select Research Dataset');
disp('-------------------------------------------------------------------');
disp('1 - Our choice - Walking at 1.25 m/s (level ground) [Shkedy Rabani et al. 2022]');
disp('2 - Other dataset [Shkedy Rabani et al. 2022]');
disp('0 - Exit simulation');
disp(' ');

dataChoice = getUserChoice('Choose dataset (1, 2, or 0): ', [0 1 2]);
disp(' ');

if dataChoice == 0
    disp('Simulation stopped by user.');
    diary off;
    return
elseif dataChoice == 1
    disp('Loading Walking dataset at 1.25 m/s...');
    Our_choise;  
elseif dataChoice == 2
    disp('Loading alternative dataset...');
    Other_dataset;
    report_data;
end
disp(' ');

%% STEP 2: Data Analysis (SECTION + LINEAR RELATION)
step2_folder = fullfile(SimulationMainFolder, 'STEP 2 - Data Analysis');
if ~exist(step2_folder,'dir')
    mkdir(step2_folder);
end

disp('-------------------------------------------------------------------');
disp('STEP 2: Data Analysis and Linear Relationship');
disp('-------------------------------------------------------------------');
disp('This step identifies sections of knee and ankle motion and fits linear relation:');
disp('theta_ankle = m * theta_knee + b');
disp('Slope sign m can be positive or negative depending on relative rotation direction.');
disp(' ');

choice = getUserChoice('Press 1 to continue or 0 to exit simulation: ', [0 1]);
disp(' ');
if choice == 0
    disp('Simulation stopped by user.');
    diary off;
    return
end

% Compute Sections
find_section_c;  
plotChoice = getUserChoice('Plot the section analysis? 1 = Yes, 2 = No: ', [1 2]);
disp(' ');
if plotChoice == 1
    find_section_p;   % Plot results
end

% Fit Linear Equations
find_eq_c;
plotChoice = getUserChoice('Plot the linear fit results? 1 = Yes, 2 = No: ', [1 2]);
disp(' ');
if plotChoice == 1
    find_eq_p;   % Plot linear fit
end

%% STEP 3: Parameter Initialization
step3_folder = fullfile(SimulationMainFolder, 'STEP 3 - Parameter Initialization');
if ~exist(step3_folder,'dir')
    mkdir(step3_folder);
end

disp('-------------------------------------------------------------------');
disp('STEP 3: Initialize Simulation Parameters');
disp('-------------------------------------------------------------------');
disp('This step sets motor properties, leg dimensions, ground parameters, and impedance gains.');
disp(' ');

choice = getUserChoice('Press 1 to continue or 0 to exit simulation: ', [0 1]);
disp(' ');
if choice == 0
    disp('Simulation stopped by user.');
    diary off;
    return
end

parameters_to_D1; 

%% STEP 4: Run Simscape Simulation
step4_folder = fullfile(SimulationMainFolder, 'STEP 4 - Simscape Simulation');
if ~exist(step4_folder,'dir')
    mkdir(step4_folder);
end

disp('-------------------------------------------------------------------');
disp(' SIMSCAPE SIMULATION OPTIONS ');
disp('-------------------------------------------------------------------');
disp('===================================================================');
disp('Control Parameter n selection:');
disp('This determines how much the controller considers the heel error in addition to the knee.');
disp('n = 0 -> Only Knee Error is considered');
disp('n = 1 -> Full consideration of Heel error');
disp('===================================================================');
disp('1 - Run Simscape simulation with a fixed n');
disp('2 - Run Simscape simulation for multiple n values');
disp('0 - Skip simulation');
disp(' ');

simChoice = getUserChoice('Choose simulation mode (0, 1, or 2): ', [0 1 2]);
disp(' ');

switch simChoice
    case 0
        disp('Skipping Simscape simulation.');
        diary off;
    case 1
        disp('Running simulation for fixed n...');
        error_sim_n1_const;  % Function using fixed N
    case 2
        disp('Running simulation for multiple n values...');
        disp('There is no automatic saving of files in this running..');
        error_sim;   % Function loops over N values
end

disp('===================================================================');
disp('=== Simulation complete ===');
disp('===================================================================');
disp(' ');

diary off;  % Stop recording all output


% UNIVERSAL INPUT FUNCTION
% ==============================
function userChoice = getUserChoice(promptText, validValues)
% Safely asks user for numeric input until a valid value is entered
% INPUTS:
%   promptText - text displayed to user
%   validValues - vector of allowed numeric choices
% OUTPUT:
%   userChoice - validated numeric user input

while true
    input_choice = input(promptText, 's'); % Read input as string
    
    % --- Check for non-numeric or empty input ---
    if isempty(input_choice) || isnan(str2double(input_choice))
        % Pause diary so error doesn't get logged
        diary_state = get(0, 'Diary'); 
        if strcmpi(diary_state, 'on')
            diary off
            fprintf('Invalid choice. Please enter one of these values: %s\n', mat2str(validValues));
            diary on
        else
            fprintf('Invalid choice. Please enter one of these values: %s\n', mat2str(validValues));
        end
        continue
    end

    % --- Convert to numeric and check validity ---
    num_choice = str2double(input_choice);
    if isscalar(num_choice) && any(num_choice == validValues)
        userChoice = num_choice;
        break;  % Valid input -> exit loop
    else
        % Pause diary again for invalid numeric values
        diary_state = get(0, 'Diary');
        if strcmpi(diary_state, 'on')
            diary off
            fprintf('Invalid choice. Please enter one of these values: %s\n', mat2str(validValues));
            diary on
        else
            fprintf('Invalid choice. Please enter one of these values: %s\n', mat2str(validValues));
        end
    end
end

end

