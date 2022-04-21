function [B,W,obj,k] = ssnmf(V,rank,max_iter,lambda,alpha,beta)
% NMF - Non-negative matrix factorization
% [W,H,OBJ,NUM_ITER] = SSNMF(V,RANK,MAX_ITER,LAMBDA)
% V - Input data.
% RANK - Rank size.
% MAX_ITER - Maximum number of iterations (default 50).
% LAMBDA - Convergence step size (default 0.0001).
% ALPHA - Sparse coefficient for W.
% BETA - Sparse coefficient for B.
% W - Set of basis images.
% H - Set of basis coefficients.
% OBJ - Objective function output.
% NUM_ITER - Number of iterations run.
 [D,N]=size(V);
 %random B and W
 B=rand(D,rank);
 W=rand(rank,N);
  % make the rows of B sum to 1
 colSum=sum(B,1);
 for i=1:rank
     B(:,i)=B(:,i)./colSum(i);
 end
 
% Calculate initial objective
obj=compute_objective2(V,B,W,alpha,beta);
% Start iteration 
for i=1:max_iter
    % update B and W and obj
    B = B.*bsxfun(@rdivide, (V./(B*W))*W', sum(W',1)+alpha);
    W = W.*bsxfun(@rdivide, B'*(V./(B*W)), sum(B',2)+beta);
    obj_new=compute_objective2(V,B,W,alpha,beta);
    error=abs(obj_new-obj);
    obj=obj_new;
    k=i;
    if error<lambda
        break;
    end
    
end
 

