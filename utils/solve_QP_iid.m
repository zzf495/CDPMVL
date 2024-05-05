function [Z] = solve_QP_iid(q,n,left,right)
    options = optimset( 'Algorithm','interior-point-convex','Display','off');
    Z = zeros(q,n);
    for i=1:n
        ff = right(:,i);
        Z(:,i)=quadprog(left,ff',[],[],ones(1,q),1,zeros(q,1),ones(q,1),[],options);
    end
end
