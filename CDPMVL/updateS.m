function S = updateS(X,K,E,D,TT,alpha, beta, delta, num_of_clusters, iter_num)
    v = length(X);
    Lambda1 = 0;
    sum_of_D =  0;
    for i = 1:v
        Lambda1 = Lambda1 + 2/v * K{i}'*( X{i} - E{i} - 0.5 * K{i} * D{i});
        sum_of_D = sum_of_D + 1/v * D{i};
    end
    Lambda2 = 2 * (TT - sum_of_D/2);
    left = alpha * Lambda1 + beta * Lambda2;
    right = (alpha + beta) + delta;
    val = left ./ right;
    S = coclustering_bipartite_fast_re(val', sum_of_D' , num_of_clusters, iter_num)';
end

