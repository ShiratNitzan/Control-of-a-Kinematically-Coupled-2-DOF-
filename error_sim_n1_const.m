%% ==============================
% USER INPUTS BEFORE SIMULATION
% ==============================

% ---- Step 1: Ask for n value (between 0 and 1) ----


while true
    n = input(['Enter value of n (0-1, default ', num2str(1), '): ']);
    if isempty(n)
        n = 1;  % default value
    end
    if n >= 0 && n <= 1
        break
    else
        disp('Invalid input. Please enter a value between 0 and 1.');
    end
end
n1 = n;  % automatically update n1

% ---- Step 2: Ask which input types to simulate (1,2,3) ----
disp('===================================================================');
disp('Select which error types to simulate:');
disp('1 - Variable Value Only');
disp('2 - Fixed Value Only');
disp('3 - Both Variable and Fixed');
disp('===================================================================');

while true
    input_choice = input('Enter your choice (1/2/3, default 3): ');
    if isempty(input_choice)
        input_choice = 3;  % default to both
    end
    if ismember(input_choice, [1,2,3])
        break
    else
        disp('Invalid choice. Please enter 1, 2 or 3.');
    end
end

%% ---- Step 3: Set up inputs based on user choice ----
inputs = {};
labels = {};
colors = [];

if input_choice == 1 || input_choice == 3
    inputs{end+1} = deg2rad(-180 + estimated_ankle_var);
    labels{end+1} = 'Variable Slope - Ankle';
    labels{end+1} = 'Variable Slope - Knee';
    colors = [colors; 0.3010, 0.7450, 0.9330];  % light blue
    colors = [colors; 0.6350, 0.0780, 0.1840];  % dark red
end

if input_choice == 2 || input_choice == 3
    inputs{end+1} = deg2rad(-180 + estimated_ankle_fixed);
    labels{end+1} = 'Fixed Slope - Ankle';
    labels{end+1} = 'Fixed Slope - Knee';
    colors = [colors; 0.4660, 0.6740, 0.1880];  % green
    colors = [colors; 1.0000, 0.6470, 0.2000];  % light orange
end

%% ==============================
% RUN SIMULATIONS
% ==============================
disp('Running Simulations...');
t_all = cell(1, numel(inputs));
ankle_errors = cell(1, numel(inputs));
knee_errors = cell(1, numel(inputs));

for j = 1:numel(inputs)
    input_estimated = [t', inputs{j}'];
    assignin('base', 'input_estimated', input_estimated);

    simOut = sim('D1_final');

    % Extract time and signals
    t_out = simOut.get('e_b').time;
    error_vector_a = squeeze(simOut.get('e_a').signals.values(:, 1, :));
    error_vector_k = squeeze(simOut.get('e_k').signals.values(:, 1, :));

    % Convert from radians to degrees
    error_vector_a = rad2deg(error_vector_a);
    error_vector_k = rad2deg(error_vector_k);

    t_all{j} = t_out;
    ankle_errors{j} = error_vector_a;
    knee_errors{j}  = error_vector_k;
end

%% ==============================
% PLOT COMBINED ANKLE AND KNEE ERRORS
% ==============================
figure; hold on;
plot_idx = 1;

for j = 1:numel(inputs)
    plot(t_all{j}, ankle_errors{j}, 'LineWidth', 3, 'Color', colors(plot_idx,:), 'LineStyle', '-');  
    plot_idx = plot_idx + 1;
    plot(t_all{j}, knee_errors{j}, 'LineWidth', 3, 'Color', colors(plot_idx,:), 'LineStyle', '-');  
    plot_idx = plot_idx + 1;
end

xlabel('Time [s]', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Error [deg]', 'FontSize', 12, 'FontWeight', 'bold');
title('Ankle and Knee Errors (in Degrees) for Selected Input Cases', 'FontSize', 16, 'FontWeight', 'bold');
legend(labels, 'FontSize', 10, 'Location', 'northeast');
grid on; set(gca, 'FontSize', 11); box on;

%% ==============================
% SAVE COMBINED GRAPH
% ==============================
saveas(gcf, fullfile(step4_folder, 'Ankle_Knee_Errors.png'));
savefig(gcf, fullfile(step4_folder, 'Ankle_Knee_Errors_Combined.fig'));

%% ==============================
% SAVE SIMULATION INPUTS AND ERRORS
% ==============================
save(fullfile(step4_folder, 'D1_final_inputs.mat'), 'inputs', 't_all');
save(fullfile(step4_folder, 'D1_final_errors.mat'), 'ankle_errors', 'knee_errors');

%% ==============================
% SAVE SIMSCAPE SIMULATION OUTPUT
% ==============================
sim_file_name = fullfile(step4_folder, 'D1_final_simulation.mat');
simOutData = simOut; 
save(sim_file_name, 'simOutData');

%% ==============================
% SAVE SIMULINK MODEL SCREENSHOTS
% ==============================
model_name = 'D1_final';
print(['-s', model_name], '-dpng', '-r180', fullfile(step4_folder, 'D1_final.png'));
subsystem_name = [model_name, '/Leg'];
print(['-s', subsystem_name], '-dpng', '-r100', fullfile(step4_folder, 'Leg.png'));
