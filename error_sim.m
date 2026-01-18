% ---- Title: Error Norm vs n1 for Two Different Inputs ----

n_values = linspace(0, 1, 8);


% Preallocate arrays for both input cases
error_norms_1 = zeros(size(n_values));
error_norms_a_1 = zeros(size(n_values));
error_norms_k_1 = zeros(size(n_values));

error_norms_2 = zeros(size(n_values));
error_norms_a_2 = zeros(size(n_values));
error_norms_k_2 = zeros(size(n_values));

% Define inputs
inputs = {deg2rad(-180 + estimated_ankle_var), deg2rad(-180 + estimated_ankle_fixed)};

% Loop over both input scenarios
for j = 1:2
    input_estimated = [t', inputs{j}'];
    assignin('base', 'input_estimated', input_estimated);
    
    for i = 1:length(n_values)
        n = n_values(i);
        assignin('base', 'n1', n);

        simOut = sim('D1_final');  % Run simulation

        % Extract signals
        error_struct = simOut.get('e_b');
        error_struct_a = simOut.get('e_a');
        error_struct_k = simOut.get('e_k');

        % Flatten error signals
        error_vector = squeeze(error_struct.signals.values(:, 1, :));
        error_vector_a = squeeze(error_struct_a.signals.values(:, 1, :));
        error_vector_k = squeeze(error_struct_k.signals.values(:, 1, :));

        % Calculate L2 norms
        err = norm(error_vector(:), 2);
        err_a = norm(error_vector_a(:), 2);
        err_k = norm(error_vector_k(:), 2);

        if j == 1
            error_norms_1(i) = err;
            error_norms_a_1(i) = err_a;
            error_norms_k_1(i) = err_k;
        else
            error_norms_2(i) = err;
            error_norms_a_2(i) = err_a;
            error_norms_k_2(i) = err_k;
        end
    end
end

%% ---- Plotting All 6 Graphs Together ----
figure; hold on;

% ---- Colors for all 6 curves ----
colors = {'#0072BD', '#77AC30', '#A2142F', '#D95319', '#4DBEEE', '#EDB120'};  % 6 unique colors

% ---- Marker shapes for each input ----
marker_input1 = 'o';  % circles for Input 1
marker_input2 = 'd';  % squares for Input 2

% ---- Plot Input 1 curves (solid lines, circle markers) ----
plot(n_values, error_norms_1,   'Color', colors{1}, 'LineStyle', '-', 'Marker', marker_input1, 'LineWidth', 2);
plot(n_values, error_norms_a_1, 'Color', colors{2}, 'LineStyle', '-', 'Marker', marker_input1, 'LineWidth', 2);
plot(n_values, error_norms_k_1, 'Color', colors{3}, 'LineStyle', '-', 'Marker', marker_input1, 'LineWidth', 2);

% ---- Plot Input 2 curves (dashed lines, square markers) ----
plot(n_values, error_norms_2,   'Color', colors{4}, 'LineStyle', '--', 'Marker', marker_input2, 'LineWidth', 2);
plot(n_values, error_norms_a_2, 'Color', colors{5}, 'LineStyle', '--', 'Marker', marker_input2, 'LineWidth', 2);
plot(n_values, error_norms_k_2, 'Color', colors{6}, 'LineStyle', '--', 'Marker', marker_input2, 'LineWidth', 2);

% ---- Titles and labels ----
xlabel('n1 Value', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('L2 Error Norm', 'FontSize', 12, 'FontWeight', 'bold');
title('Error Norm vs. n for Two Different Inputs', 'FontSize', 16, 'FontWeight', 'bold');

% ---- Legend ----
legend({ ...
    'Variable Slope: Combined = n·error_{knee} + (1−n)·error_{ankle}', ...
    'Variable Slope: Ankle', ...
    'Variable Slope: Knee', ...
    'Fixed Slope: Combined = n·error_{knee} + (1−n)·error_{ankle}', ...
    'Fixed Slope: Ankle', ...
    'Fixed Slope: Knee' ...
}, 'Location', 'northwest', 'FontSize', 9, 'Interpreter', 'tex');



grid on;
set(gca, 'FontSize', 10);
box on;
hold off;


