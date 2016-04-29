% Problem 10
close all;
load face_emotion_data;

y = y>0;

% learning binomial with all features
w_hat_all_features = glmfit(X,y,'binomial','constant','off');

% PCA and dimensionality reduction
[coeff, score, latent] = pca(X);
reduced_features_indices = 1:3;
X_reduced_features = X(:,reduced_features_indices);

% learning binomial with reduced features
w_hat_reduced_features = glmfit(X_reduced_features,y,'binomial','constant','off');

% sanity check - all features
theta_estimated = X*w_hat_all_features;
mu_estimated = 1./(1+exp(-theta_estimated));
y_estimated = mu_estimated > 0.5;
mistakes_all_features = sum(y_estimated ~= y);

% sanity check - reduced features
theta_estimated = X_reduced_features*w_hat_reduced_features;
mu_estimated = 1./(1+exp(-theta_estimated));
y_estimated = mu_estimated > 0.5;
mistakes_reduced_features = sum(y_estimated ~= y);

mistakes_all_features = zeros(1,8);
mistakes_reduced_features = zeros(1,8);

for i=1:8
    % data organization
    hold_out_indices = 1+16*(i-1):16*i;
    X_hold_out_set = X(hold_out_indices,:);
    X_hold_out_set_reduced_features = X_hold_out_set(:,reduced_features_indices);
    y_hold_out_set = y(hold_out_indices);
    
    training_set_indices = [1:hold_out_indices(1)-1 hold_out_indices(end)+1:128];
    X_training_set = X(training_set_indices,:);
    X_training_set_reduced_features = X_training_set(:,reduced_features_indices);
    y_training_set = y(training_set_indices);
    
    % training - all features
    w_hat_all_features = glmfit(X_training_set,y_training_set,'binomial','constant','off');
    
    % testing - all features
    theta_estimated = X_hold_out_set*w_hat_all_features;
    mu_estimated = 1./(1 + exp(-theta_estimated));
    y_estimated = mu_estimated > 0.5;
    mistakes_all_features(i) = sum(y_estimated ~= y_hold_out_set);
    
    % training - reduced features
    w_hat_reduced_features = glmfit(X_training_set_reduced_features,y_training_set,'binomial','constant','off');
    
    % testing - reduced features
    theta_estimated = X_hold_out_set_reduced_features*w_hat_reduced_features;
    mu_estimated = 1./(1+exp(-theta_estimated));
    y_estimated = mu_estimated > 0.5;
    mistakes_reduced_features(i) = sum(y_estimated ~= y_hold_out_set);
end

mistakes_all_features
mean(mistakes_all_features/16)
mistakes_reduced_features
mean(mistakes_reduced_features/16)

% to decide best feature
true_metric = zeros(1,9);
false_metric = zeros(1,9);

for i=1:1:9
    true_values = X(y==1,i);
    false_values = X(y==0,i);
    true_metric(i) = mean(true_values);
    false_metric(i) = mean(false_values);
end
true_metric
false_metric
abs(true_metric-false_metric)