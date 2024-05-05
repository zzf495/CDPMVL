function [K] = updateK(X,Z,E)
    v = length(X);
    K = {};
    for  i = 1 : v
        G =  (X{i} - E{i}) * Z';
        [U,~,V] = mySVD(G);
        K{i} = real(U*V');
   end
end