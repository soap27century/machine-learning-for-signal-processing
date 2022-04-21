function [B,W,obj,k] = nmf(V,rank,max_iter,lambda) 
 % NMF - Non-negative matrix factorization 
 % [B,W,OBJ,NUM_ITER] = NMF(V,RANK,MAX_ITER,LAMBDA)
 % V - Input data.
 % RANK - Rank size.
 % MAX_ITER - Maximum number of iterations (default 50).
 % LAMBDA - Convergence step size (default 0.0001).
 % B - Set of basis images.
 % W - Set of basis coefficients.
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
obj=compute_objective(V,B,W);
% Start iteration 
for i=1:max_iter
    % update B and W and obj
    B = B.*bsxfun(@rdivide, (V./(B*W))*W', sum(W',1));
    W = W.*bsxfun(@rdivide, B'*(V./(B*W)), sum(B',2));
    obj_new=compute_objective(V,B,W);
    error=abs(obj_new-obj);
    obj=obj_new;
    k=i;
    % stop iteration if error is small
    if error<lambda
        break;
    end
end
