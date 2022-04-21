function [result] = aveEuclidDistance(testTmp, maleTmp, femaleTmp)
c= size(testTmp,2);
cm = size(maleTmp,2);
cf = size(femaleTmp,2);
result = [];
for i = 1:c
    c = testTmp(:,i);
    matm = repmat(c, 1, cm);matf = repmat(c, 1, cf);
    disM = sum(sqrt(diag((maleTmp - matm)'*(maleTmp - matm))));
    disF = sum(sqrt(diag((femaleTmp - matf)'*(femaleTmp - matf))));
    if disM < disF
        result(i) = 1;
    else
        result(i) = 2;
    end
end