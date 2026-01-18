
    % Prompt the user to select the desired function
    disp('Choose the function to calculate angles:');
    disp('1 -  paper_equations_run');
    disp('2 -  paper_equations_walk');
    
    choice = input('Enter your choice (1 or 2): ');

    % Execute the selected function
    switch choice
        case 1
            paper_equations_run(step1_folder);
            disp('paper_equations_run executed.');
        case 2
            paper_equations_walk(step1_folder);
            disp('paper_equations_walk executed.');
        otherwise
            disp('Invalid choice. Exiting.');
            return;
    end
