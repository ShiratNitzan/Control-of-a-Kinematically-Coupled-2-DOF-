%% input fur Impedance control section

%time for the simulation 

time_sim = 10 ; %[sec]
sample_time = 0.1;  %[sec]

% Loads the data from the MAT file and processes it
    
temp = load("ALLDATAfinal0.mat");  % Load the MAT file
temp = temp.ALLDATA;  % Extract the data from the loaded structure

hip = temp(:,7);  % Adjust data values
knee = temp(:,4);  % Adjust data values
ankle = temp(:,1);  % Adjust data values

t = 0:sample_time:time_sim-sample_time;  % Time vector from 0 to 10 seconds, with 0.1 second steps

input_knee = [t',deg2rad(knee)];  % Combine time and data into a single matrix
input_ankle = [t', deg2rad(-180+ankle)];  % Combine time and data into a single matrix