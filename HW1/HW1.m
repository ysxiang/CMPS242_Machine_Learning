load train.txt
load test.txt

trainX = train(:,1);
trainT = train(:,2);
deg = 9;
% Preprocess the data
trainX_p = prep(trainX, deg);
trainT_p = trainT;

numData = length(trainX);
numFolds = 10;
% Divide the data randomly into 10 folds
idx = crossvalind('Kfold', numData, numFolds);

% Choose 100 ln(lambda)s randomly from -10 to 0
lnlambda = -10 * rand(1, 100);
% Or increment ln(lambda) by 0.1 every time: lnlambda = -10 : 0.1 : 0
cv_error = zeros(1, 100);   % 1*100
test_error = zeros(1, 100);
W = zeros(1, 100);

for i = 1 : 100 % For each lnlambda, train the model
    for k = 1 : numFolds % Divide into 10 folds, choose one as validation set and the rest as training set
        % training set
        trainX_tr = trainX_p(:,idx ~= k);
        trainT_tr = trainT_p(:,idx ~= k);
        % validation set
        trainX_val = trainX_p(:,idx == k);
        trainT_val = traint_p(:,idx == k);
        % Train W
        w = inv(trainX_tr * trainX_tr' + lnlambda(i) * eye(deg + 1)) * trainX_tr * trainT_tr;
        % Count the cv_error for each and add them up for MSE
        cv_error(i) = cv_error(i) + (trainX_tr' * W - trainT_tr) * (trainX_tr' * W - trainT_tr) / length(trainT_tr);
    end
    % Get the cross-validation error for each lnlambda
    cv_error(i) = cv_error(i) / numFolds;
    % train W based on the whole training set (including validation set)
    W(i) = inv(trainX_p * trainX_p' + lnlambda(i) * eye(deg + 1)) * trainX_p * trainT_p;
    test_error(i) = (trainX_val' * W(i) - trainT_val) * (trainX_val' * W(i) - trainT_val) / length(trainT_val);
end

% Find the minimum test)
cv_y = min(cv_error);
cv_x = find(cv_error == cv_y);
test_y = min(test_error);
test_x = find(test_error == test_y);



% function of preprocessing data
% vector[N*1] -> matrix[10*
function func = prep(ori, deg) % deg = 9
    X = [];
    len = size(ori,1);
    for i = 1 : len
        vector = zeros(0, deg + 1);
        val = ori(i);
        for j = 0 : deg
            vector(j + 1) = val^j;
        end
        X = [X ; vector];
    end
    X = X';
    func = X;
end

    