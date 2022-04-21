clear all; close all;
ori = imread('elephant.jpg');
maxIter = 100;
img = im2double(ori);
X = reshape(img,size(img,1)*size(img,2),3);
K = 2;
[C,I2] = Kmeans_code(X, K, maxIter);
K = 5;
[C,I5] = Kmeans_code(X, K, maxIter);
K = 10;
[C,I10] = Kmeans_code(X, K, maxIter);
imgNew1 = reshape(I2,size(img));
imgNew2 = reshape(I5,size(img));
imgNew3 = reshape(I10,size(img));
%%
figure(1)
subplot(2,2,1);imshow(ori);title('original');
subplot(2,2,2);imshow(im2uint8(imgNew1));title('k=2');
subplot(2,2,3);imshow(im2uint8(imgNew2));title('k=5');
subplot(2,2,4);imshow(im2uint8(imgNew3));title('k=10');
%%
%using built-in fucntion
[idx,C] = kmeans(X,2);
pic = zeros(size(X,1),1,3);
for i = 1:size(pic,1)
    pic(i,1,:) = C(idx(i),:);
end
pic1 = reshape(pic,size(ori));

[idx,C] = kmeans(X,5);
for i = 1:size(pic,1)
    pic(i,1,:) = C(idx(i),:);
end
pic2 = reshape(pic,size(ori));

[idx,C] = kmeans(X,10);
for i = 1:size(pic,1)
    pic(i,1,:) = C(idx(i),:);
end
pic3 = reshape(pic,size(ori));
figure(2)
subplot(2,2,1);imshow(im2uint8(ori));title('original');
subplot(2,2,2);imshow(im2uint8(pic1));title('k=2 using built-in kmeans');
subplot(2,2,3);imshow(im2uint8(pic2));title('k=5 using built-in kmeans');
subplot(2,2,4);imshow(im2uint8(pic3));title('k=10 using built-in kmeans');