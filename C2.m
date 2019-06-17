function [fitresult, gof] = C2(xx1, yy1, zz, pp, qq)
%  Create a fit.
%
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.

%% Fit: 'untitled fit 1'.
[xData, yData, zData, weights] = prepareSurfaceData(xx1, yy1, zz, zz );

% Set up fittype and options.
ft = fittype( 'a1*exp(-(x-x0)^2/(2*sigmax^2)-(y-y0)^2/(2*sigmay^2))', 'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 1 1 0 0]; % (intensity, sigmax, sigmay, positionx, positiony ?)

opts.StartPoint = [ 0 1 1 pp qq];
opts.Upper = [ 4 4 4 inf inf];
opts.Weights = weights;

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
%subplot(2,1,1) 
h = plot(fitresult, [xData, yData], zData);

%legend( h, 'untitled fit 1', 'z vs. x, y with z', 'Location', 'NorthEast' );
% Label axes
xlabel x
ylabel y
zlabel z
grid on