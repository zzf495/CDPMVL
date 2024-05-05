function [E] = updateE(X,K,Z,alpha, zeta)
    v = length(X);
    E = {};
   for  i = 1 : v
        res = X{i} - K{i} * Z;
        E{i} = shrink(res,0.5 * zeta / alpha);
   end
end