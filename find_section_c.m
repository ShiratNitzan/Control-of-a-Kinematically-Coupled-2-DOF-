%% === FIND EXTREMA AND DEFINE INTERVALS ===
% In this section we find all extrema points of knee and ankle
% and define the intervals between extrema points


% Peak detection parameters
prominence_thresh = 3;        % Minimum prominence to count a peak
min_peak_dist_sec = 0.5;      % Minimal time between peaks [seconds]

% Find extrema (maxima and minima) for knee
[knee_max_peaks, knee_max_locs] = findpeaks(knee, t, ...
    'MinPeakProminence', prominence_thresh, ...
    'MinPeakDistance', min_peak_dist_sec);
[knee_min_peaks, knee_min_locs] = findpeaks(-knee, t, ...
    'MinPeakProminence', prominence_thresh, ...
    'MinPeakDistance', min_peak_dist_sec);
knee_min_peaks = -knee_min_peaks;

% Find extrema for ankle
[ankle_max_peaks, ankle_max_locs] = findpeaks(ankle, t, ...
    'MinPeakProminence', prominence_thresh, ...
    'MinPeakDistance', min_peak_dist_sec);
[ankle_min_peaks, ankle_min_locs] = findpeaks(-ankle, t, ...
    'MinPeakProminence', prominence_thresh, ...
    'MinPeakDistance', min_peak_dist_sec);
ankle_min_peaks = -ankle_min_peaks;

% Combine extrema times
knee_extrema_times = sort([knee_max_locs, knee_min_locs]);
ankle_extrema_times = sort([ankle_max_locs, ankle_min_locs]);

% Include start and end times
all_extrema_times = unique(sort([0, knee_extrema_times, ankle_extrema_times, t(end)]));

% Prepare storage for interval trends
n_intervals = length(all_extrema_times) - 1;
knee_trend = strings(n_intervals,1);
ankle_trend = strings(n_intervals,1);
direction_relation = strings(n_intervals,1);
interval_start = zeros(n_intervals,1);
interval_end = zeros(n_intervals,1);

% % === Combine and sort all extrema times from both signals ===
% all_extrema_times = unique(sort([knee_extrema_times, ankle_extrema_times]));

% === Combine and sort all extrema times from both signals including start and end times ===
all_extrema_times = unique(sort([0, knee_extrema_times, ankle_extrema_times, t(end)]));

% === Prepare storage for results ===
n_intervals = length(all_extrema_times) - 1;
knee_trend = strings(n_intervals,1);
ankle_trend = strings(n_intervals,1);
direction_relation = strings(n_intervals,1);
interval_start = zeros(n_intervals,1);
interval_end = zeros(n_intervals,1);

% === Function to check trend between two times ===
get_trend = @(angle, t_start, t_end, t_vec) ...
    sign(angle(find(t_vec>=t_end,1)) - angle(find(t_vec>=t_start,1)));

% === Loop over intervals to find trends and relation ===
for i = 1:n_intervals
    t_start = all_extrema_times(i);
    t_end = all_extrema_times(i+1);
  
    % Find indices closest to t_start and t_end in time vector t
    idx_start = find(t >= t_start, 1, 'first');
    idx_end = find(t >= t_end, 1, 'first');
    
    % Calculate trend for knee and ankle (positive = increasing, negative = decreasing)
    knee_diff = knee(idx_end) - knee(idx_start);
    ankle_diff = ankle(idx_end) - ankle(idx_start);
    
    if knee_diff > 0
        knee_trend(i) = "Increasing";
    elseif knee_diff < 0
        knee_trend(i) = "Decreasing";
    else
        knee_trend(i) = "Constant";
    end
    
    if ankle_diff > 0
        ankle_trend(i) = "Increasing";
    elseif ankle_diff < 0
        ankle_trend(i) = "Decreasing";
    else
        ankle_trend(i) = "Constant";
    end
    
    % Determine if directions are the same or opposite (ignore constant)
    if strcmp(knee_trend(i), "Constant") || strcmp(ankle_trend(i), "Constant")
        direction_relation(i) = "No Change";
    elseif strcmp(knee_trend(i), ankle_trend(i))
        direction_relation(i) = "Same Direction";
    else
        direction_relation(i) = "Opposite Direction";
    end
    
    interval_start(i) = t_start;
    interval_end(i) = t_end;
end