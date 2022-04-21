function [obj] = compute_objective2(V,W,H,alpha,beta)
 obj = sum(sum(V.*log(W*H) - (W*H))) + alpha*sum(sum(H))+ beta*sum(sum(W));
end