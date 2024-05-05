function [results,results_iter,D] = CDPMVL(fea, Y, options)
%%% Codes of CDPMVL: Consensus and Diversity-fusion Partial-view-shared Multi-view Learning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% intput
%%%
%%% fea                     -    Multi-view data, with each cell being 
%%%                              m_v * N
%%%
%%% Y                       -    The clustering indicator used for
%%%                              metrics
%% options
%%% T                       -    The iterations
%%%
%%% innerT                  -    The inner iterations
%%%
%%% alpha                   -    The weight of CPSCL
%%%
%%% beta                    -    The weight of fusion
%%%
%%% lambda                  -    The weight of DPKE
%%%
%%% gamma                   -    The weight of L1 norm w.r.t E
%%%
%%% delta                   -    The weight of regularization
%%%
%% === Version ===
%%%     Upload                   2024-05-05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    results_iter = [];
    results = [];
    v = length(fea);
    X = {};
    n_v = zeros(v,1);
    m_v = zeros(v,1);
    for i=1:v
       [n_v(i),m_v(i)] = size(fea{i});
       X{i} = fea{i}';
    end
    num_of_clusters = length(unique(Y));
    % Parameters
    T = options.T;
    innerT = options.innerT;
    q = options.q * num_of_clusters;
    q = max(q,num_of_clusters);
    alpha = options.alpha;
    beta = options.beta;
    delta = options.delta;
    lambda = options.lambda;
    zeta = options.zeta;
    % initialize the anchors
    [indx, X] = initializeAnchor(X,q);
    D = {};
    E = {};
    S = indx;
    [mm,nn]=size(S);
    % Init D and E
    for i = 1:v
       tmp = (S + rand(mm,nn));
       tmp = tmp./repmat(sum(tmp,1)+eps,mm,1);
       D{i} = tmp;
       E{i} = zeros(m_v(i),n_v(i));
    end
    G = S;
    obj = [];
    for iter = 1:T
            % Update K^v
           [Z] = getZ(S,D);
           [K] = updateK(X,Z,E); 
           % Update S
           S = updateS(X,K,E,D,G,alpha, beta, delta, num_of_clusters, innerT);
           % Update P^v
           D = updateP(X,K,E,S,D,G,alpha, beta, lambda, delta);
           % Update E^v
           [Z] = getZ(S,D);
           [E] = updateE(X,K,Z,alpha, zeta);
           % update G
           G = updateT( Z );
           results_avg = [];
           for kk = 1:10
               y1 = Solve_t_cuts(G',num_of_clusters);
               [~,results_avg] = getClusteringResults(kk,Y,y1,results_avg,0);
           end
           mean_avg = mean(results_avg,1);
           results = mean_avg;
           for i = 1:4
                results_iter(iter,i) = mean_avg(i);
           end
           % loss 
           term1 = 0;
           term2 = norm(G - Z,'fro');
           for iv = 1:v
               term1 = term1 + norm(X{iv}-0.5 * K{iv}*(S+D{iv})-E{iv},'fro');
           end
           obj(iter) = alpha * term1+ beta * term2;
           fprintf('[%d]-th acc:%.4f, MIhat: %.4f, Purity:%.4f, ARI:%.4f \n',iter,...
                results(1),results(2),results(3),results(4));
           fprintf('=====================[%d]: %.4f========================== \n',iter,obj(iter)) 
           if (iter >= innerT)
               if (iter>1) && (abs((obj(iter-1)-obj(iter))/(obj(iter-1)))<1e-4 || iter>T || obj(iter) < 1e-10)
                   fprintf('break ...\n');
                   for index=iter+1:T
                       for i = 1:4
                            results_iter(index,i)=results(i);
                       end
                   end
                   break;
               end
           end
    end
end
