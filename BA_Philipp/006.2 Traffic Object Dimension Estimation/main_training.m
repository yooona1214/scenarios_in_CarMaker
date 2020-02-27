%{
This script is used to train the model.
Training is needed to determine the linear model parameters
c_height and c_width, bias_height and bias_width
Input: table trainTest.mat created with create_training_test_dataset
Output: Optimal c_width, c_height, bias_width, bias_height for this set of training data
Method used: Minimization of sum of squared deviations of calculated width 
// height from ground truth width // height. In other words: We solve the
least squares problem
%}


%% External parameters
% Main Directory
mainDir = 'C:\Users\philipp\Documents\GitHub\BA_1\src\006.1 Get Dimensions aktuell - Erweiterung Regression';


%% Set working directory
cd(mainDir);


%% Load training set
load("train.mat");


%% Delete description column and turn into double array
train = train(:, (1:5));
train = table2array(train);


%% Optimisation without bias

if 1
%% Model 1
%{
width_real = width_image * dist_x_from_camera * c_width
height_real = height_image * dist_x_from_camera * c_height
%}
P = optimproblem;
c_width = optimvar('c_width');
c_height = optimvar('c_height');
% obj = sum of squared deviations from ground truth (We solve the least squares probem)
obj = sum((train(:, 1) .* train(:, 3) * c_width - train(:, 4)).^2) + sum((train(:, 2) .* train(:, 3) * c_height - train(:, 5)).^2);
P.Objective = obj;
string = strcat('P: min sum((width image .* dist_x * c_width - width ground truth)^2) + sum((height image * dist_x * c_height - height ground truth)^2) \n Solve for c_width, c_height\n');
fprintf(string);
% showproblem(P)
var = solve(P);
% Get Min. value
P_min = sum((train(:, 1) .* train(:, 3) * var.c_width - train(:, 4)).^2) + sum((train(:, 2) .* train(:, 3) * var.c_height - train(:, 5)).^2);
% Print
string = strcat('\n Min. value =', 32, num2str(P_min), '\n Optimal c =', 32, '(', num2str(var.c_width), ',', 32, num2str(var.c_height), ') \n');
fprintf(string);


%% Plot model
% Width
max_width = max(train(:,1) .* train(:,3));
interval = (0:1:ceil(max_width));
width_hat = var.c_width .* interval;
figure('Name', 'X: width image * distance, Y: width real');
hold on;
scatter(width_hat, interval, '.');
scatter(train(:,4), train(:,1) .* train(:,3));

% Height
max_height = max(train(:,2) .* train(:,3));
interval = (0:1:ceil(max_height));
height_hat = var.c_height .* interval;
figure('Name', 'X: height image * distance, Y: height real');
hold on;
scatter(height_hat, interval, '.');
scatter(train(:,5), train(:,2) .* train(:,3));


%% Save c_width and c_height
% save('var_optimal_no_bias_model_1.mat', 'var');
end


if 0
%% Model 2
%{
width_image = width_real / dist_x_from_camera * c_width
height_image = height_real / dist_x_from_camera * c_height
%}
P = optimproblem;
c_width = optimvar('c_width');
c_height = optimvar('c_height');
% obj = sum of squared deviations from ground truth (We solve the least squares probem)
obj = sum((train(:, 4) ./ train(:, 3) * c_width - train(:, 1)).^2) + sum((train(:, 5) ./ train(:, 3) * c_height - train(:, 2)).^2);
P.Objective = obj;
string = strcat('P: min sum((width ground truth ./ dist_x * c_width - width image)^2) + sum((height ground truth ./ dist_x * c_height - height image)^2) \n Solve for c_width, c_height\n');
fprintf(string);
% showproblem(P)
var = solve(P);
% Get Min. value
P_min = sum((train(:, 4) ./ train(:, 3) * var.c_width - train(:, 1)).^2) + sum((train(:, 5) ./ train(:, 3) * var.c_height - train(:, 2)).^2);
% Print
string = strcat('\n Min. value =', 32, num2str(P_min), '\n Optimal c =', 32, '(', num2str(var.c_width), ',', 32, num2str(var.c_height), ') \n');
fprintf(string);


%% Plot model
% Width
max_domain = max(train(:,4) ./ train(:,3));
interval = (0:0.001:max_domain);
width_image_hat = var.c_width .* interval;
figure('Name', 'X: width_real / dist, Y: width_image');
hold on;
scatter(interval, width_image_hat, '.');
scatter(train(:,4) ./ train(:,3), train(:,1));

% Height
max_domain = max(train(:, 5) ./ train(:, 3));
interval = (0:0.001:max_domain);
height_image_hat = var.c_height .* interval;
figure('Name', 'X: height_real / dist, Y: height_image');
hold on;
scatter(interval, height_image_hat, '.');
scatter(train(:, 5) ./ train(:, 3), train(:, 2));


%% Save c_width and c_height
% save('var_optimal_no_bias_model_2.mat', 'var');
end





%%%%%%%%%%
%%%%%%%%%%

if 0
%% Optimistation with bias

%% Model 1
%{
width_real = width_image * dist_x_from_camera * c_width + bias_width
height_real = height_image * dist_x_from_camera * c_height + bias_height
%}
P = optimproblem;
c_width = optimvar('c_width');
c_height = optimvar('c_height');
bias_width = optimvar('bias_width');
bias_height = optimvar('bias_height');
% obj = sum of squared deviations from ground truth (We solve the least squares probem)
obj = sum((train(:, 1) .* train(:, 3) * c_width + bias_width - train(:, 4)).^2) + sum((train(:, 2) .* train(:, 3) * c_height + bias_height - train(:, 5)).^2);
P.Objective = obj;
string = strcat('P: min sum((width image .* dist_x * c_width + bias_width - width ground truth)^2) + sum((height image * dist_x * c_height + bias_width - height ground truth)^2) \n Solve for c_width, c_height, bias_width, bias_height \n');
fprintf(string);
% showproblem(P)
var = solve(P);
% Get Min. value
P_min = sum((train(:, 1) .* train(:, 3) * var.c_width + var.bias_width - train(:, 4)).^2) + sum((train(:, 2) .* train(:, 3) * var.c_height + var.bias_height - train(:, 5)).^2);
% Print
string = strcat('\n Min. value =', 32, num2str(P_min), '\n Optimal c =', 32, '(', num2str(var.c_width), ',', 32, num2str(var.c_height), ') \n Optimal bias =', 32, '(', num2str(var.bias_width), ',', 32, num2str(var.bias_height), ') \n');
fprintf(string);


%% Plot model
% Width
max_width = max(train(:,1) .* train(:,3));
interval = (0:1:ceil(max_width));
width_hat = var.bias_width + var.c_width .* interval;
figure('Name', 'Training data for width and estimated model');
hold on;
scatter(width_hat, interval, '.');
scatter(train(:,4), train(:,1) .* train(:,3));

% Height
max_height = max(train(:,2) .* train(:,3));
interval = (0:1:ceil(max_height));
height_hat = var.bias_height + var.c_height .* interval;
figure('Name', 'Training data for height and estimated model');
hold on;
scatter(height_hat, interval, '.');
scatter(train(:,5), train(:,2) .* train(:,3));


%% Save c_width and c_height
% save('var_optimal_with_bias_model_1.mat', 'var');
end


if 0
%% Model 2
%{
width_image = width_real / dist_x_from_camera * c_width + bias_width
height_image = height_real / dist_x_from_camera * c_height + bias_height
%}
P = optimproblem;
c_width = optimvar('c_width');
c_height = optimvar('c_height');
bias_width = optimvar('bias_width');
bias_height = optimvar('bias_height');
% obj = sum of squared deviations from ground truth (We solve the least squares probem)
obj = sum((train(:, 4) ./ train(:, 3) * c_width + bias_width - train(:, 1)).^2) + sum((train(:, 5) ./ train(:, 3) * c_height + bias_height - train(:, 2)).^2);
P.Objective = obj;
string = strcat('P: min sum((width ground truth ./ dist_x * c_width + bias_width - width image)^2) + sum((height ground truth ./ dist_x * c_height + bias_width - height image)^2) \n Solve for c_width, c_height, bias_width, bias_height \n');
fprintf(string);
% showproblem(P)
var = solve(P);
% Get Min. value
P_min = sum((train(:, 4) ./ train(:, 3) * var.c_width + var.bias_width - train(:, 1)).^2) + sum((train(:, 5) ./ train(:, 3) * var.c_height + var.bias_height - train(:, 2)).^2);
% Print
string = strcat('\n Min. value =', 32, num2str(P_min), '\n Optimal c =', 32, '(', num2str(var.c_width), ',', 32, num2str(var.c_height), ') \n Optimal bias =', 32, '(', num2str(var.bias_width), ',', 32, num2str(var.bias_height), ') \n');
fprintf(string);


%% Plot model
% Width
max_domain = max(train(:,4) ./ train(:,3));
interval = (0:0.001:max_domain);
width_image_hat = var.bias_width + var.c_width .* interval;
figure('Name', 'X: width_real / dist, Y: width_image');
hold on;
scatter(interval, width_image_hat, '.');
scatter(train(:,4) ./ train(:,3), train(:,1));

% Height
max_domain = max(train(:, 5) ./ train(:, 3));
interval = (0:0.001:max_domain);
height_image_hat = var.bias_height + var.c_height .* interval;
figure('Name', 'X: height_real / dist, Y: height_image');
hold on;
scatter(interval, height_image_hat, '.');
scatter(train(:, 5) ./ train(:, 3), train(:, 2));


%% Save c_width and c_height
% save('var_optimal_with_bias_model_2.mat', 'var');
end
