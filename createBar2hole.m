function [xShape, yShape] = createBar2hole(length1, width, holeRadius, showPlot)
    % CREATEBAR2HOLE Draws a rounded bar with two holes or just returns coordinates
    % Inputs:
    %   length1    - length of the bar
    %   width      - width of the bar
    %   holeRadius - radius of the holes
    %   showPlot   - 0: no plot, 1: show plot
    % Outputs:
    %   xShape, yShape - coordinates of the shape outline

    if nargin < 4
        showPlot = 1;  % default: show plot
    end

    % Parameters
    cornerRadius = width / 2;

    % Create angles
    theta = linspace(0, pi, 500); 
    thetaHole = linspace(0, 2*pi, 500);

    % Right rounded corner
    xRightCorner1 = length1/2 - cornerRadius + cornerRadius * cos(3/2*pi + theta);
    yRightCorner1 = cornerRadius * sin(3/2*pi + theta);

    % Right hole
    xRightinside = length1/2 - cornerRadius + holeRadius * cos(pi/2 - thetaHole);
    yRightinside = holeRadius * sin(pi/2 - thetaHole);

    % Left hole
    xLeftinside = -length1/2 + cornerRadius + holeRadius * cos(pi/2 - thetaHole);
    yLeftinside = holeRadius * sin(pi/2 - thetaHole);

    % Left rounded corner
    xLeftCorner1 = -length1/2 + cornerRadius + cornerRadius * cos(pi/2 + theta);
    yLeftCorner1 = cornerRadius * sin(pi/2 + theta);

    % Straight top edge
    x1upEdge = linspace(length1/2 - cornerRadius, -length1/2 + cornerRadius, 2);
    y1upEdge = (width / 2) * ones(size(x1upEdge));

    % Combine shape
    xShape = [xRightCorner1, xRightinside, x1upEdge, xLeftinside, xLeftCorner1]';
    yShape = [yRightCorner1, yRightinside, y1upEdge, yLeftinside, yLeftCorner1]';

    % Plot only if requested
    if showPlot
        figure;
        hold on;
        h1 = plot(xShape, yShape, 'k', 'LineWidth', 1); % Outline of the shape
        axis equal;

        % ==== Add dimension arrows ====
        hWidth  = plot([length1/2 + 0.1, length1/2 + 0.1], [-width/2, width/2], 'r', 'LineWidth', 1.5);
        hLength = plot([-length1/2, length1/2], [-(width/2 + 0.1), -(width/2 + 0.1)], 'b', 'LineWidth', 1.5);
        hDia    = plot([length1/2 - cornerRadius, length1/2 - cornerRadius], [-holeRadius, holeRadius], 'g', 'LineWidth', 1.5);

        % ==== Labels & Legend ====
        title('Rounded Bar with Two Holes and Dimensions');
        xlabel('X Axis'); ylabel('Y Axis');
        legend([h1, hWidth, hLength, hDia], ...
               {'Bar Shape', ...
                ['Width = ', num2str(width)], ...
                ['Length = ', num2str(length1)], ...
                ['Hole Diameter = ', num2str(2 * holeRadius)]}, ...
               'Location', 'best');

        hold off; grid on;
    end
end
