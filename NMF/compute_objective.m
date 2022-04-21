function [obj] = compute_objective(V,W,H)
 obj = sum(sum(V.*log(W*H) - (W*H)));
end

