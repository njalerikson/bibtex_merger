function optimize_glmfit()
	% Flags
	dataDir			= '../../data/';
	prelearningDir	= '../../data/1_prelearning/';

	addpath('subroutines');


	% Test for results directory
	if exist(strcat(pwd,'/',dataDir),'dir') ~= 7
		mkdir(dataDir);
	end
	if exist(strcat(pwd,'/',prelearningDir),'dir') ~= 7
		mkdir(prelearningDir);
	end
	
	% Initialize output to file
	% fileID = fopen(strcat(dataDir,'details.txt'),'a');

	% Importing Data
	data = csvread(strcat(prelearningDir, 'deepComparisonLearner.csv'));
	folds = 10;

	X = data(:, 2:end);
	y = data(:, 1);
    
    % column of ones
    % X = [ones(size(X, 1), 1) X];
    
    % normalize data
    % smallest = min(min(X));
    % if smallest < 0
    %     X = X - min(min(X)) + 1;
    % end
    % X = log(X)/log(max(max(X)));
    
	indices = crossvalind('Kfold',X(:,1),folds);
	test = (indices == 1);
	train = xor(1,test);

	Xtrain = X(train, :);
	ytrain = y(train, :);

	Xtest = X(test, :);
	ytest = y(test, :);

	lambdas = [0.03];

	% Find best lambda, plot lambda vs. accuracy
	% if length(lambdas) > 1
	% 	[lambda, ~] = find_best_lambda(Xtrain, ytrain, lambdas, folds);
	% else
	% 	lambda = lambdas(1);
	% end

	% Get best model
	% [theta, ytrainp, accuracyTrain, ytestp] = ...
	% 	train_predict(Xtrain, ytrain, Xtest, lambda);

	theta = glmfit(Xtrain, ytrain, 'binomial');%'binomial', 'gamma', 'inverse gaussian', 'normal' (the default), 'poisson'

	ytrainp = glmval(theta, Xtrain, 'logit');
	ytestp  = glmval(theta, Xtest, 'logit');

	id0 = (ytrainp <= 0.5);
	id1 = (ytrainp > 0.5);
	ytrainp(id0) = 0;
	ytrainp(id1) = 1;

	id0 = (ytestp <= 0.5);
	id1 = (ytestp > 0.5);
	ytestp(id0) = 0;
	ytestp(id1) = 1;

	% Xtest(1,:)
	% theta

	% temp = Xtest * theta;
	% temp(1)
	% pause;

	% ytrainp = ones(length(ytrainp), 1)
	% ytestp = ones(length(ytestp), 1)
    
    fprintf('training accuracy:   %3.2f%%\n', mean(double(ytrainp == ytrain)) * 100);
    fprintf('prediction accuracy: %3.2f%%\n', mean(double(ytestp == ytest)) * 100);
    % fprintf('lambda: %3.2f\ntheta: ', lambda);
    fprintf('%3.3f\n', theta);

	% fprintf(fileID, [...
	% 	'%3.2f%% \t\t'], accuracyTrain);
	% fprintf(fileID, [...
	% 	'%3.2f%% train accuracy, ' ...
	% 	'lambda = %3.3f, '], accuracyTrain, lambda);
	% if length(lambdas) > 1
	% 	fprintf(fileID, [...
	% 		'"%s", '], filename);
	% end

	% Close output file
	% fclose(fileID);
end