%% === COMPUTATION: Fit Lines & Estimate Ankle Angle ===

n_segments = length(interval_start);

% --- Preallocate ---
slopes_var = zeros(n_segments,1);
intercepts_var = zeros(n_segments,1);
rmse_var = zeros(n_segments,1);

slopes_fixed = zeros(n_segments,1);
intercepts_fixed = zeros(n_segments,1);
rmse_fixed = zeros(n_segments,1);

estimated_ankle_var = zeros(size(t));
estimated_ankle_fixed = zeros(size(t));

% --- Variable slope: Fit per segment ---
for i = 1:n_segments
    idx_range = find(t >= interval_start(i) & t < interval_end(i));
    x = knee(idx_range);
    y = ankle(idx_range);
    
    p = polyfit(x, y, 1);
    slopes_var(i) = p(1);
    intercepts_var(i) = p(2);
    
    y_fit = slopes_var(i)*x + intercepts_var(i);
    rmse_var(i) = sqrt(mean((y - y_fit).^2));
    
    estimated_ankle_var(idx_range) = y_fit;
end
estimated_ankle_var(end) = estimated_ankle_var(end-1);

% --- Fixed slope: compute global slope ---
p_global = polyfit(knee(:), ankle(:), 1);
best_slope = p_global(1);

for i = 1:n_segments
    idx_range = find(t >= interval_start(i) & t < interval_end(i));
    x = knee(idx_range);
    y = ankle(idx_range);
    
    b = mean(y - best_slope*x);  % intercept per segment
    intercepts_fixed(i) = b;
    slopes_fixed(i) = best_slope;
    
    y_fit = best_slope*x + b;
    rmse_fixed(i) = sqrt(mean((y - y_fit).^2));
    
    estimated_ankle_fixed(idx_range) = y_fit;
end
estimated_ankle_fixed(end) = estimated_ankle_fixed(end-1);


% --- Statistics ---
mean_intercept_fixed = mean(intercepts_fixed);
std_intercept_fixed = std(intercepts_fixed);
mean_rmse_fixed = mean(rmse_fixed);
std_rmse_fixed = std(rmse_fixed);

mean_intercept_var = mean(intercepts_var);
std_intercept_var = std(intercepts_var);
mean_rmse_var = mean(rmse_var);
std_rmse_var = std(rmse_var);


%% --- Save Estimated Ankle Variable Slope ---
save(fullfile(step2_folder, 'Estimated_Ankle_Var.mat'), 'estimated_ankle_var');

%% --- Save Estimated Ankle Fixed Slope ---
save(fullfile(step2_folder, 'Estimated_Ankle_Fixed.mat'), 'estimated_ankle_fixed');

