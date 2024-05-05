
function [labels,evec] = Solve_t_cuts(B,Nseg,maxKmIters,cntReps)
%%%
%% Input 
%%%
%%%         B               A bipartite graph with n*m
%%%
%%%         Nseg            Number of clusters
%%%
%%%         maxKmIters      Number of iteration
%%%
%%%         cntReps         Number of repeating `kmeans`
%%%
%% Output
%%%         labels          An indicator of clustering, n * 1
%%%
%%%         evec            The result of `f` in `tr(fLf')`
%%%                         where `L = D_B - B*B'`and `D_B` is the degree
%%%                         matrix of `B*B'`
%%% Version
%%% 
%%%         2024-04-06      - forked from SMCMB
if nargin < 4
    cntReps = 3;
end
if nargin < 3
    maxKmIters = 100;
end

[Nx,Ny] = size(B);
if Ny < Nseg
    error('Need more columns!');
end

dx = sum(B,2);
dx(dx==0) = 1e-10; % Just to make 1./dx feasible.
Dx = sparse(1:Nx,1:Nx,1./dx); clear dx
Wy = B'*Dx*B;

%%% compute Ncut eigenvectors
% normalized affinity matrix
d = sum(Wy,2);
D = sparse(1:Ny,1:Ny,1./sqrt(d)); clear d
nWy = D*Wy*D; clear Wy
nWy = (nWy+nWy')/2; % clusters * clusters

% computer eigenvectors
[evec,eval] = eig(full(nWy)); clear nWy   
[~,idx] = sort(diag(eval),'descend');
Ncut_evec = D*evec(:,idx(1:Nseg)); clear D

%%% compute the Ncut eigenvectors on the entire bipartite graph (transfer!)
evec = Dx * B * Ncut_evec; clear B Dx Ncut_evec

% normalize each row to unit norm
evec = bsxfun( @rdivide, evec, sqrt(sum(evec.*evec,2)) + 1e-10 );

% k-means
try 
    labels = kmeans(real(evec),Nseg,'MaxIter',maxKmIters,'Replicates',cntReps);
catch E
   fprintf('e\n');
end