%% === CALCULATE TRENDS AND CREATE TABLE ===
% In this section we calculate the trend (Increasing/Decreasing/Constant)
% for each interval, and compare the directions of knee and ankle

% === Plotting ===
knee_extrema_times = sort([knee_max_locs, knee_min_locs]);
ankle_extrema_times = sort([ankle_max_locs, ankle_min_locs]);

figure; hold on;

plot(t, ankle, 'k', 'DisplayName', 'Ankle Angle', 'LineWidth', 3.5);
plot(t, knee, 'm', 'DisplayName', 'Knee Angle', 'LineWidth', 3.5);

for i = 1:length(knee_extrema_times)
    xline(knee_extrema_times(i), '--m', 'HandleVisibility','off', 'LineWidth', 2);
end

for i = 1:length(ankle_extrema_times)
    xline(ankle_extrema_times(i), '--k', 'HandleVisibility','off', 'LineWidth', 2);
end

plot(knee_max_locs, knee_max_peaks, 'om', 'HandleVisibility','off', 'LineWidth', 2);
plot(knee_min_locs, knee_min_peaks, 'sm', 'HandleVisibility','off', 'LineWidth', 2);
plot(ankle_max_locs, ankle_max_peaks, 'ok', 'HandleVisibility','off', 'LineWidth', 2);
plot(ankle_min_locs, ankle_min_peaks, 'sk', 'HandleVisibility','off', 'LineWidth', 2);

xlabel('Time [s]');
ylabel('Angle [deg]');
title('Knee and Ankle Angles with Detected Extrema');
legend;
grid on;

%% --- Create Result Table ---
result_table = table(interval_start, interval_end, knee_trend, ankle_trend, direction_relation, ...
    'VariableNames', {'StartTime', 'EndTime', 'KneeTrend', 'AnkleTrend', 'DirectionRelation'});

disp(result_table);

%% --- Save Outputs in step1_folder ---
% Save figure
figFile = fullfile(step2_folder, 'Knee_Ankle_Extrema.fig');
savefig(figFile);

% Save figure as image (PNG)
pngFile = fullfile(step2_folder, 'Knee_Ankle_Extrema.png');
saveas(gcf, pngFile);

% Save MATLAB table
tableFile = fullfile(step2_folder, 'Knee_Ankle_Trends.mat');
save(tableFile, 'result_table');


% Optional: Save as Excel for easy inspection
excelFile = fullfile(step2_folder, 'Knee_Ankle_Trends.xlsx');
writetable(result_table, excelFile);

