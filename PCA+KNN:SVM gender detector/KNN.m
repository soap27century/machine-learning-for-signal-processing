function [labels] = KNN(trainData,dataLabels,testData, K)
[~,N] = size(trainData);
[~,nTest] = size(testData);
distance = zeros(N,nTest);
for i = 1: nTest
     for j = 1: N 
        distance(j,i) = norm(testData(:,i)-trainData(:,j));
     end
end
[~,Index]= sort(distance,'ascend');
testLabel = zeros(K,nTest);
for i = 1:nTest
    for j=1:K
        testLabel(j,i) = dataLabels(Index(j,i));
    end
end
labels = mode(testLabel);
labels = labels';
end