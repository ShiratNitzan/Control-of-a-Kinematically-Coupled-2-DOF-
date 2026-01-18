%% ==============================
% PHYSICAL VARIABLES INPUT
% ==============================
disp('===================================================================');
disp('PHYSICAL PARAMETERS - Default values are shown. Press Enter to keep.');
disp('===================================================================');

% Default values
thickness_def = 5;       % [mm]
holeRadius_def = 5;      % [mm]
R_def = 25;              % Motor radius [mm]
W_def = 10;              % Motor width [mm]
M_def = 1;               % Motor mass [Kg]
L_knee_def = 420;        % Tibia + Fibula length [mm]
L_foot_def = 240;        % Foot length [mm]

% User input with default
thickness = input(['Thickness [mm] (default ', num2str(thickness_def), '): ']);
if isempty(thickness), thickness = thickness_def; end

holeRadius = input(['Hole radius [mm] (default ', num2str(holeRadius_def), '): ']);
if isempty(holeRadius), holeRadius = holeRadius_def; end

R = input(['Motor radius [mm] (default ', num2str(R_def), '): ']);
if isempty(R), R = R_def; end

W = input(['Motor width [mm] (default ', num2str(W_def), '): ']);
if isempty(W), W = W_def; end

M = input(['Motor mass [Kg] (default ', num2str(M_def), '): ']);
if isempty(M), M = M_def; end

L_knee = input(['Tibia + Fibula length [mm] (default ', num2str(L_knee_def), '): ']);
if isempty(L_knee), L_knee = L_knee_def; end

L_foot = input(['Foot length [mm] (default ', num2str(L_foot_def), '): ']);
if isempty(L_foot), L_foot = L_foot_def; end

% Dependent parameters
J = 0.5*M^2*R*1e-3; % Inertia torque [kg*m^2]
[x_knee, y_knee] = createBar2hole(L_knee,holeRadius*4,holeRadius,0);
Corner_knee = L_knee/2 - holeRadius*2;

[x_foot, y_foot] = createBar2hole(L_foot,holeRadius*4,holeRadius,0);
Corner_foot = L_foot/2 - holeRadius*2;

%% ==============================
% CONTROL PARAMETERS INPUT WITH VALIDATION
% ==============================
disp('===================================================================');
disp('CONTROL PARAMETERS - Default values are shown. Press Enter to keep.');
disp('Rules: Kd <= K, P <= D^2 * K / J');
disp('===================================================================');

% Default values
K_def = 2.5;
Kd_def = 1;
Dd_def = 1;
P_def = 80;
D_def = 1.5;

valid = false;
while ~valid
    K = input(['Environment torque K (default ', num2str(K_def), '): ']);
    if isempty(K), K = K_def; end

    while true
        Kd = input(['Impedance PD Kd (<= K, default ', num2str(Kd_def), '): ']);
        if isempty(Kd), Kd = Kd_def; end
        if Kd <= K, break; else, disp('Invalid: Kd must be <= K'); end
    end

    D = input(['Motor torque PD D (default ', num2str(D_def), '): ']);
    if isempty(D), D = D_def; end

    while true
        P = input(['Motor torque PD P (<= D^2*K/J, default ', num2str(P_def), '): ']);
        if isempty(P), P = P_def; end
        if P <= D^2*K/J, break; else, disp(['Invalid: P <= ', num2str(D^2*K/J)]); end
    end

    Dd = input(['Impedance PD Dd (default ', num2str(Dd_def), '): ']);
    if isempty(Dd), Dd = Dd_def; end

    valid = true;
end

%% ==============================
% FIXED PARAMETERS
%%The intention was to add a surface with these variables, but in the end it didn't happen.
% ==============================
g = -9.8; %[N] -9.8 OR 0 in x!
Stiffiness = 1e6; %[N/m]
Damping = 1e2; %[N/(m/s)]
Trasition_Region_W = 1e-3 ;%[m]
Static_Friction = 0.8;
Dynamic_Friction = 0.6;
Critical_Velocity = 1e-3 ; %[m/s]
time_sim = 10 ; %[sec]
sample_time = 0.1;  %[sec]

%% ==============================
% JOINT TARGETS & BOUNDS
% ==============================
state_Targat_1to2 = knee(1);  % Target position in degrees
lower_bound_1to2 = min(knee);  
upper_bound_1to2 = max(knee);  

state_Targat_2to3 = -180+ankle(1);
lower_bound_2to3 = -180+min(ankle);
upper_bound_2to3 = -180+max(ankle);

%% ==============================
final_vars = {'thickness','holeRadius','R','W','M','L_knee','L_foot', ...
              'J','x_knee','y_knee','Corner_knee','x_foot','y_foot','Corner_foot', ...
              'K','Kd','D','P','Dd', ...
              'g','Stiffiness','Damping','Trasition_Region_W', ...
              'Static_Friction','Dynamic_Friction','Critical_Velocity', ...
              'time_sim','sample_time', ...
              'state_Targat_1to2','lower_bound_1to2','upper_bound_1to2', ...
              'state_Targat_2to3','lower_bound_2to3','upper_bound_2to3'};


save(fullfile(step3_folder, 'FinalVars.mat'), final_vars{:});

%%
% NOTES
% All other original variables like x_knee, y_knee, x_foot, y_foot, Corner_knee, Corner_foot
% remain in the system and are computed automatically.


