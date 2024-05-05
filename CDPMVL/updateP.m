function P = updateP(X,K,E,S,P,G,alpha, beta, lambda, delta)
    v = length(X);
    randV = randperm(v,v);
    for i = randV
        lastD = P;
        [weight_of_w, msg] = solve_weight(lastD, delta);
        res =  sum_of_P_without_index(lastD, weight_of_w, i);
        if abs(weight_of_w(i))<1e-14
            Lambda2 = 2 * (G - (S + res)/2);
            Lambda3 =  res;
            left =  beta * Lambda2 - lambda * Lambda3./2;
            right = (beta) + delta;
        else
            Lambda1 = 2 * K{i}'*( X{i} - E{i} - 0.5 * K{i}* S);
            Lambda2 = (2 /weight_of_w(i)) * (G - (S + res)/2);
            Lambda3 = 1/weight_of_w(i) * res;
            left = alpha * Lambda1 + beta * Lambda2 - lambda * Lambda3./2;
            right = (alpha + beta) + delta;
        end
        val = left ./ right;
        P{i} = updateT( val );
        if sum(sum(isnan(P{i})))>0
            idxx = isnan(P{i});
            tmp = P{i};
            tmp(idxx) = 0;
            P{i} = tmp;
        end
        fprintf('%s \n',msg);
    end
end

function [weight_of_c, msg] = solve_weight(P, epsilon)
    v = length(P);
    Pi = zeros(v,v);
    d = zeros(v,1);
    for i = 1 : v
        for j = 1 : v
            if i < j
                Di = P{i};
                Dj = P{j};
                Di = abs(Di); Dj = abs(Dj);
                sum_of_D = sum(sum(Di.*Dj))+eps;
                Pi(i,j) = sum_of_D;
                Pi(j,i) = sum_of_D;
            end
        end
        d(i) = 0;
    end
    % normr
    nPi = Pi ./norm(Pi,'fro');
    try 
        weight_of_c = solve_QP_iid(v,1,(nPi+ epsilon * eye(v)),d);
    catch E
        weight_of_c = 1/v * ones(v,1);
    end
    msg="";
    for j = 1:v
       msg = msg + sprintf('w[%d] = %.4f, ',j, weight_of_c(j));
    end
end

function sumP = sum_of_P_without_index(P,c,index)
    n = length(P);
    sumP = 0;
    for i=1:n
        if i ~= index
            sumP = sumP + c(i).* P{i};
        end
    end
end


