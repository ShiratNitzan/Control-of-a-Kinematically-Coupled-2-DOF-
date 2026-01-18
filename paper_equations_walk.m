function paper_equations_walk(step_folder)

%% =========================================================
% Display header
%% =========================================================
disp('****************************************************************************')
disp(' This code take as input the Surface Gradient [%] and gives prediction')
disp(' of lower limb joint kinematics and kinetics of one gait cycle during walking at 1.25m/s')
disp('****************************************************************************')

%% =========================================================
% Variables setup
%% =========================================================
ALLDATA = [];
w = 2*pi()/100;
joint = {'ANK','KNEE','HIP'};
kin = {'ANG','MOM','POW'};
joint1 = {'Ankle','Knee','Hip'};
unit = {'Joint Angle (Degree)','Joint Moment (N/Kg)','Joint Power (W/Kg)','Joint Power (W/Kg)'};
kin1 = {'Angle','Moment','Power'};

%%%%%%%%%
Surface_Gradient = getUserChoice('Enter Surface Gradient [%] input range is -15% to 15%: ', -15:15);
yesF = getUserChoice('Type 1 to plot data, 2 for no plot: ', [1 2]);

anat_plane = 'Sagittal';
CSV_path = ['Coefs\' anat_plane '\WALK\'];

load model_coefs
s_size_all = eval(['model_coefs.' anat_plane '.s_size_walk']);
count = 1;

warning('off',model_coefs.id)

for j = 1:3
    for k = 1:3
        fileNameB = sprintf('coeff_poly_%s_%s.csv', kin{k}, joint{j});
        v_b = csvread([CSV_path fileNameB]);
        s_size = s_size_all(k,j);
        X = 1:100;
        Y = Surface_Gradient;
        S = zeros(1,100);
        C = zeros(1,100);

        Z = (v_b(1,1).*Y.^3 + v_b(1,2).*Y.^2 + v_b(1,3).*Y + v_b(1,4));
        m = 1;
        for i = 2:2:s_size*2
            S = (v_b(i,1).*Y.^3 + v_b(i,2).*Y.^2 + v_b(i,3).*Y + v_b(i,4)).*(sin(m*w.*X));
            Z = Z + S;
            C = (v_b(i+1,1).*Y.^3 + v_b(i+1,2).*Y.^2 + v_b(i+1,3).*Y + v_b(i+1,4)).*(cos(m*w.*X));
            Z = Z + C;
            m = m + 1;
        end

        ALLDATA(:,count) = Z';
        count = count + 1;
    end
end

%% =========================================================
% Save CSV and MAT in STEP 1 folder
%% =========================================================
sg_str = SG_str(Surface_Gradient);
csvwrite(fullfile(step_folder, ['FinalFit_ALL_DATA' sg_str '.csv']), ALLDATA);
save(fullfile(step_folder, ['ALLDATAfinal' sg_str]), 'ALLDATA');

%%%%% shirat %%%%%
%csvwrite(['FinalFit_ALL_DATA_simulation' '.csv'], ALLDATA);
save(['ALLDATAfinal_simulation'], 'ALLDATA');
%%%%%%%%%%%%%%%%%%%%%

disp(' ')
disp('*************************************************************************')
disp('All the data was written to FinalFit_ALL_DATA.csv')
disp('and to a matlab ALLDATAfinal.dat, matrix name ALLDATA ')
disp(' ')
disp('The build of the csv file/ matlab matrix (ALLDATA)')
disp(' 1 2 3 4 5 6 7 8 9')
disp(' Ankle(column # 1-3) Knee(column # 4-6) Hip(column # 7-9)')
disp(' Angle Moment Power Angle Moment Power Angle Moment Power')
disp('***************************************************************************')

%%%%shirat%%%%%
theta1 = ALLDATA(:,1);
theta2 = ALLDATA(:,4);
moment1 = ALLDATA(:,2);
moment2 = ALLDATA(:,5);

results = struct(...
    'theta1_min', min(theta1), 'theta1_max', max(theta1), ...
    'theta2_min', min(theta2), 'theta2_max', max(theta2), ...
    'moment1_min', min(moment1), 'moment1_max', max(moment1), ...
    'moment2_min', min(moment2), 'moment2_max', max(moment2) ...
);

disp('--------------------------------------');
disp('Results: Min and Max Values');
disp('--------------------------------------');
fprintf('Ankle_angle: Min = %.2f, Max = %.2f\n', results.theta1_min, results.theta1_max);
fprintf('Knee_angle: Min = %.2f, Max = %.2f\n', results.theta2_min, results.theta2_max);
fprintf('Ankle_Moment: Min = %.2f, Max = %.2f\n', results.moment1_min, results.moment1_max);
fprintf('Knee_Moment: Min = %.2f, Max = %.2f\n', results.moment2_min, results.moment2_max);
disp('--------------------------------------');

%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
%% =========================================================
% Plot with grid, save in STEP 1 folder
%% =========================================================
if yesF == 1
    % --- Ankle ---
    fig1 = figure(1);
    subplot(3,1,1),plot(1:100,ALLDATA(:,1)), grid on
    title(sprintf('%s ,Walking at 1.25m/s, %s %1.f %s', joint1{1}, 'Surface Gradient =',Surface_Gradient,'%'))
    ylabel('Angle [Degree]');
    subplot(3,1,2),plot(1:100,ALLDATA(:,2)), grid on
    ylabel('Normalized moment [Nm/kg/m]');
    subplot(3,1,3),plot(1:100,ALLDATA(:,3)), grid on
    ylabel('Normalized power [W/kg/m]');
    xlabel('Stride Cycle(%)');
    
    % Save PNG and FIG
    saveas(fig1, fullfile(step_folder, ['Ankle_' sg_str '.png']));
    savefig(fig1, fullfile(step_folder, ['Ankle_' sg_str '.fig']));
    
    % --- Knee ---
    fig2 = figure(2);
    subplot(3,1,1),plot(1:100,ALLDATA(:,4)), grid on
    title(sprintf('%s ,Walking at 1.25m/s, %s %1.f %s', joint1{2}, 'Surface Gradient =',Surface_Gradient,'%'))
    ylabel('Angle [Degree]');
    subplot(3,1,2),plot(1:100,ALLDATA(:,5)), grid on
    ylabel('Normalized moment [Nm/kg/m]');
    subplot(3,1,3),plot(1:100,ALLDATA(:,6)), grid on
    ylabel('Normalized power [W/kg/m]');
    xlabel('Stride Cycle(%)');
    
    % Save PNG and FIG
    saveas(fig2, fullfile(step_folder, ['Knee_' sg_str '.png']));
    savefig(fig2, fullfile(step_folder, ['Knee_' sg_str '.fig']));
    
    % --- Hip ---
    fig3 = figure(3);
    subplot(3,1,1),plot(1:100,ALLDATA(:,7)), grid on
    title(sprintf('%s ,Walking at 1.25m/s, %s %1.f %s', joint1{3}, 'Surface Gradient =',Surface_Gradient,'%'))
    ylabel('Angle [Degree]');
    subplot(3,1,2),plot(1:100,ALLDATA(:,8)), grid on
    ylabel('Normalized moment [Nm/kg/m]');
    subplot(3,1,3),plot(1:100,ALLDATA(:,9)), grid on
    ylabel('Normalized power [W/kg/m]');
    xlabel('Stride Cycle(%)');
    
    % Save PNG and FIG
    saveas(fig3, fullfile(step_folder, ['Hip_' sg_str '.png']));
    savefig(fig3, fullfile(step_folder, ['Hip_' sg_str '.fig']));
end

end

%% =========================================================
% Helper function to convert Surface Gradient to string
%% =========================================================
function [sg_str] = SG_str(sg)
num1 = floor(abs(sg));
num2 = mod(sg,1)*10;
if sg < 0
    if num2
        sg_str = [num2str(num1) '_' num2str(num2) 'Neg'];
    else
        sg_str = [num2str(num1) 'Neg'];
    end
else
    if num2
        sg_str = [num2str(num1) '_' num2str(num2)];
    else
        sg_str = [num2str(num1)];
    end
end
end

%% =========================================================
% UNIVERSAL INPUT FUNCTION
%% =========================================================
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
        break;
    else
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
