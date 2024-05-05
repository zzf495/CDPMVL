%% Add path
addpath('./utils/');
addpath('./CDPMVL/');
rng(104);
%% Load COIL20
path='./Yale.mat';
load(path,'fea','gt');
%% parameter setting
options.T = 20;         % The iterations
options.innerT = 50;    % The inner iterations
options.q = 3;          % The number of anchor (q * C)
options.alpha = 10;     % The weight of CPSCL
options.lambda = 1e3;   % The weight of DPKE
options.beta = 1e3;     % The weight of fusion
options.delta = 1;      % The weight of regularization
options.zeta = 1e-3;    % The weight of L1 norm w.r.t E
%% run program
rep = [];
for i = 1:10
    [results,~,~] = CDPMVL(fea, gt, options);
    rep = [rep;results];
end
mean(rep,1)
std(rep,[],1)