%% === DISPLAY: Print equations and RMSE ===

fprintf('--- Variable Slope per Segment ---\n');
for i = 1:n_segments
    fprintf('Segment %d: θ̂_ankle = %.4f * θ_knee + %.4f, RMSE = %.4f\n', ...
        i, slopes_var(i), intercepts_var(i), rmse_var(i));
end

fprintf('\n--- Fixed Slope per Segment ---\n');
for i = 1:n_segments
    fprintf('Segment %d: θ̂_ankle = %.4f * θ_knee + %.4f, RMSE = %.4f\n', ...
        i, slopes_fixed(i), intercepts_fixed(i), rmse_fixed(i));
end

fprintf('\n--- Statistics ---\n');
fprintf('Variable slope: mean intercept = %.4f, std = %.4f, mean RMSE = %.4f, std RMSE = %.4f\n', ...
    mean_intercept_var, std_intercept_var, mean_rmse_var, std_rmse_var);
fprintf('Fixed slope: mean intercept = %.4f, std = %.4f, mean RMSE = %.4f, std RMSE = %.4f\n', ...
    mean_intercept_fixed, std_intercept_fixed, mean_rmse_fixed, std_rmse_fixed);
fprintf('Best global slope (fixed for all segments): %.4f\n', best_slope);

%% === PLOTTING ===

colors = lines(n_segments);

% --- Graph 1: Variable slope fits ---
fig1 = figure; hold on;
plot(t, ankle, 'k', 'LineWidth', 3.5, 'DisplayName', 'Actual Ankle Angle');
for i = 1:n_segments
    idx_range = find(t >= interval_start(i) & t < interval_end(i));
    plot(t(idx_range), estimated_ankle_var(idx_range), 'Color', colors(i,:), ...
        'LineWidth', 3, 'DisplayName', sprintf('Seg %d fit', i));
end
xlabel('Time [s]'); ylabel('Angle [deg]');
title('Ankle Angle: Variable Slope Fit');
legend('Location','best'); grid on; hold off;

% Save Graph 1
savefig(fullfile(step2_folder, 'Ankle_Variable_Slope.fig'));
saveas(fig1, fullfile(step2_folder, 'Ankle_Variable_Slope.png'));

% --- Graph 2: Fixed slope fits ---
fig2 = figure; hold on;
plot(t, ankle, 'k', 'LineWidth', 3.5, 'DisplayName', 'Actual Ankle Angle');
for i = 1:n_segments
    idx_range = find(t >= interval_start(i) & t < interval_end(i));
    plot(t(idx_range), estimated_ankle_fixed(idx_range), 'Color', colors(i,:), ...
        'LineWidth', 3, 'DisplayName', sprintf('Seg %d fit', i));
end
xlabel('Time [s]'); ylabel('Angle [deg]');
title(sprintf('Ankle Angle: Fixed Slope Fit (m = %.3f)', best_slope));
legend('Location','best'); grid on; hold off;

% Save Graph 2
savefig(fullfile(step2_folder, 'Ankle_Fixed_Slope.fig'));
saveas(fig2, fullfile(step2_folder, 'Ankle_Fixed_Slope.png'));

% --- Graph 3: Comparison Variable vs Fixed Slope ---
fig3 = figure; hold on;
plot(t, ankle, 'k', 'LineWidth', 3.5, 'DisplayName', 'Actual Ankle Angle');
plot(t, estimated_ankle_var, 'g-', 'LineWidth', 2, 'DisplayName', 'Variable Slope');
plot(t, estimated_ankle_fixed, 'c-', 'LineWidth', 2, 'DisplayName', 'Fixed Slope');
xlabel('Time [s]'); ylabel('Angle [deg]');
title('Actual vs Estimated Ankle Angle: Variable vs Fixed Slope');
legend('Location','best'); grid on; hold off;

% Save Graph 3
savefig(fullfile(step2_folder, 'Ankle_Comparison_Variable_Fixed.fig'));
saveas(fig3, fullfile(step2_folder, 'Ankle_Comparison_Variable_Fixed.png'));
