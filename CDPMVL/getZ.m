function [Z] = getZ(A,D)
    v = length(D);
    Z = 0 ;
    for i = 1:v
        Z = Z + 1/v * D{i};
    end
    Z = (Z+A)/2;
end

