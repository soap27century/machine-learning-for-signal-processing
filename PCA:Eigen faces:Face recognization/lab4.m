%clear all; clc;

%load all data and save in vectors
for m = 1:40
    for n = 1:10
        img = loadimage(m,n);
        [row,col] = size(img);
        allData(:,m,n) = reshape(img,[row*col,1]);
    end
end
trainData = allData(:,:,1:9);% 3d vectors 10304*40*9
testData = allData(:,:,10);% 2d vectors 10304*40

%%
%pick one image and centered the data
ave=[];
for i=1:10304
    trainDataSingle(i,:)=allData(i,:,1);
    ave(i)=mean(trainDataSingle(i,:));
    trainCentered(i,:)=trainDataSingle(i,:)-ave(i);
end

%%
[V, r] = eig(transpose(trainCentered)*trainCentered);
E = zeros(size(r));
for i = 1:40
    E(i,i) = sqrt(r(i,i));
end
temp = trainCentered * V;
for i = 1:40
    temp(:,i) = temp(:,i) ./ E(i,i);
end
U = -real(temp);

[U,S,VT] = svd(trainCentered);

% for i = 1:40
%     eigen(i) = S(i,i)^2;
% end
% figure(1)
% plot(eigen);title('eigen values');
%%
%eigen faces
im1 = reshape(U(:,1),[row,col]);
im2 = reshape(U(:,2),[row,col]);
im3 = reshape(U(:,3),[row,col]);
im40 = reshape(U(:,40),[row,col]);
% figure(2);
% subplot(2,2,1); imagesc(im1); title('eigen faces 1');
% subplot(2,2,2); imagesc(im2); title('eigen faces 2');
% subplot(2,2,3); imagesc(im3); title('eigen faces 3');
% subplot(2,2,4); imagesc(im40); title('eigen faces 40');

% subplot(2,2,1); imshow(im1,[]); title('eigen faces 1');
% subplot(2,2,2); imshow(im2,[]); title('eigen faces 1');
% subplot(2,2,3); imshow(im3,[]); title('eigen faces 1');
% subplot(2,2,4); imshow(im40,[]); title('eigen faces 1');
%%
%reconstruction
eigenVector=U(:,1:40);
recon = eigenVector'*trainCentered;
recon10=eigenVector(:,1:10)*recon(1:10,1)+ave';
recon20=eigenVector(:,1:20)*recon(1:20,1)+ave';
recon30=eigenVector(:,1:30)*recon(1:30,1)+ave';
recon40=eigenVector(:,1:40)*recon(1:40,1)+ave';
figure(3)
subplot(2,2,1);imagesc(reshape(recon10,[row,col]));title('reconstruction 10 eigenvalues')
subplot(2,2,2);imagesc(reshape(trainData(:,1,1),[row,col]));title('original')
subplot(2,2,3);imagesc(reshape(recon10,[row,col])-reshape(trainData(:,1,1),[row,col]));title('differences')
figure(4)
subplot(2,2,1);imagesc(reshape(recon20,[row,col]));title('reconstruction 20 eigenvalues')
subplot(2,2,2);imagesc(reshape(trainData(:,1,1),[row,col]));title('original')
subplot(2,2,3);imagesc(reshape(recon20,[row,col])-reshape(trainData(:,1,1),[row,col]));title('differences')
figure(5)
subplot(2,2,1);imagesc(reshape(recon30,[row,col]));title('reconstruction 30 eigenvalues')
subplot(2,2,2);imagesc(reshape(trainData(:,1,1),[row,col]));title('original')
subplot(2,2,3);imagesc(reshape(recon30,[row,col])-reshape(trainData(:,1,1),[row,col]));title('differences')
figure(6)
subplot(2,2,1);imagesc(reshape(recon40,[row,col]));title('reconstruction 40 eigenvalues')
subplot(2,2,2);imagesc(reshape(trainData(:,1,1),[row,col]));title('original')
subplot(2,2,3);imagesc(reshape(recon40,[row,col])-reshape(trainData(:,1,1),[row,col]));title('differences')
%%
[r,c]=size(testData);
mu2=sum(testData,2)/c;
testData=testData-mu2*ones(1,c);
% projection onto different number of vectors
Projection1=U(:,1:10)'*testData;
Projection2=U(:,1:20)'*testData;
Projection3=U(:,1:30)'*testData;
Projection4=U(:,1:40)'*testData;
IDX1=knnsearch(transpose(transpose(U(:,1:10))*trainCentered),Projection1');
IDX2=knnsearch(transpose(transpose(U(:,1:20))*trainCentered),Projection2');
IDX3=knnsearch(transpose(transpose(U(:,1:30))*trainCentered),Projection3');
IDX4=knnsearch(transpose(transpose(U(:,1:40))*trainCentered),Projection4');
figure(7)
%check image in s(i)
i = 1;
subplot(2,2,1); imshow(uint8(loadimage(IDX1(i),1))); title('closest image for test s1 when H=10');
subplot(2,2,2); imshow(uint8(loadimage(IDX2(i),1))); title('closest image for test s1 when H=20');
subplot(2,2,3); imshow(uint8(loadimage(IDX3(i),1))); title('closest image for test s1 when H=30');
subplot(2,2,4); imshow(uint8(loadimage(IDX4(i),1))); title('closest image for test s1 when H=40');