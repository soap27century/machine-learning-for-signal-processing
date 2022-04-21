function [C, I] = Kmeans_code(X, K, maxIter)
tmp = rand(K,1)*size(X,1)
tmp = round(tmp);
centroids = X(tmp,:);
distance = zeros(size(X,1),K);
cluster = zeros(size(X,1),1);
for i = 1:maxIter
    for pixel = 1:size(X,1)
        for individualC = 1:K
            tmp1 = centroids(individualC,:) - X(pixel,:);
            distance(pixel, individualC) = norm(tmp1);
        end
        [m,cluster(pixel)] = min(distance(pixel,:));
    end
    newC = zeros(size(centroids)); 
    for individualC = 1:K
        newC(individualC,:) = mean(X(find(cluster == individualC),:),1);
    end
    centroids = newC;
end

C = centroids;
for individualC = 1:K
    index = find(cluster == individualC);
    n = length(index);
    for j = 1:n
        X(index(j),:) = centroids(individualC,:);
    end
end
I = X;

