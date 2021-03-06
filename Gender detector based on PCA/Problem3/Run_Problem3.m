%% 
%Load all data
f = '/Users/youzhedou/Desktop/Code_samples/Machine-Learning-for-Signal-Processing/HW1/data/face/male/train/';
ls = dir([f '*.jpg']);
maleTrainData = [];
for i =1:length(ls)
    img=imread([f ls(i).name]);
    maleTrainData(:,i)=img(:);
end

f = '/Users/youzhedou/Desktop/Code_samples/Machine-Learning-for-Signal-Processing/HW1/data/face/female/train/';
ls = dir([f '*.jpg']);
femaleTrainData = [];
for i =1:length(ls)
    img=imread([f ls(i).name]);
    femaleTrainData(:,i)=img(:);
end
allTrainData=[maleTrainData,femaleTrainData];

f = '/Users/youzhedou/Desktop/Code_samples/Machine-Learning-for-Signal-Processing/HW1/data/face/male/test/';
ls = dir([f '*.jpg']);
maleTestData = [];
for i =1:length(ls)
    img=imread([f ls(i).name]);
    maleTestData(:,i)=img(:);
end
f = '/Users/youzhedou/Desktop/Code_samples/Machine-Learning-for-Signal-Processing/HW1/data/face/female/test/';
ls = dir([f '*.jpg']);
femaleTestData = [];
for i =1:length(ls)
    img=imread([f ls(i).name]);
    femaleTestData(:,i)=img(:);
end
allTestData=[maleTestData,femaleTestData];
%%
%pca
n = 500;
[D,N]=size(allTrainData);
meanCol=sum(allTrainData,2)/N;
allTrainDataCentered=allTrainData-meanCol*ones(1,N);
[U,S,V]=svd(allTrainDataCentered,0);
U=U(:,1:n);


%% Plot eigenvalue 
x=1:500;
figure(1)
plot(x,diag(S(1:500,1:500)).^2);

%% Plot average face
[row,col] = size(img);
[D1,N1]=size(maleTrainData);
mu1=sum(maleTrainData,2)/N1;
[D2,N2]=size(femaleTrainData);
mu2=sum(femaleTrainData,2)/N2;
iu1=reshape(mu1,[row,col]);
iu2=reshape(mu2,[row,col]);
figure(2)
% subplot(1,2,1); imagesc(iu1); title('male avg face');
% subplot(1,2,2); imagesc(iu2); title('female avg face');
subplot(1,2,1); imshow(iu1,[]); title('male avg face');
subplot(1,2,2); imshow(iu2,[]); title('female avg face');

%% reconstrcut test face
[D,N]=size(allTestData);
mu3=sum(allTestData,2)/N;

noOfEigenFaces = 100;
eigenVector=U(:,1:noOfEigenFaces);
allTestDataCentered=allTestData-mu3*ones(1,N);
recon1 = eigenVector'*allTestDataCentered;
reconPic1 = eigenVector*recon1(:,1) + mu3;

noOfEigenFaces = 300;
eigenVector=U(:,1:noOfEigenFaces);
allTestDataCentered=allTestData-mu3*ones(1,N);
recon2 = eigenVector'*allTestDataCentered;
reconPic2 = eigenVector*recon2(:,1) + mu3;

noOfEigenFaces = 500;
eigenVector=U(:,1:noOfEigenFaces);
allTestDataCentered=allTestData-mu3*ones(1,N);
recon3 = eigenVector'*allTestDataCentered;
reconPic3 = eigenVector*recon3(:,1) + mu3;

figure(3)
subplot(2,2,1);imshow(reshape(reconPic1,size(img)),[]);
title('reconstructed face using 100 eigen faces')
subplot(2,2,2);imshow(reshape(reconPic2,size(img)),[]);
title('reconstructed face using 300 eigen faces')
subplot(2,2,3);imshow(reshape(reconPic3,size(img)),[]);
title('reconstructed face using 500 eigen faces')
subplot(2,2,4);imshow(reshape(allTestData(:,1),size(img)),[]);
title('original face')


%% simple gender detection system
% dimension = 50; 
% ED = zeros(2,2000);
% res = zeros(2000,1);
% for i = 1:2000
%     ED(1,i) = norm(allTestDataCentered(:,i)-mu1);
%     ED(2,i) = norm(allTestDataCentered(:,i)-mu2);
%     if(ED(1,i)>ED(2,i))
%         res(i,1)=2;
%     else
%         res(i,1)=1;
%     end
% end
% acc=0;
% for i=1:2000
%     if i<=1000 && res(i)==1
%         acc=acc+1;
%     elseif i>1000 && res(i)==2
%         acc=acc+1;
%     end
% end
% acc=acc/2000;

dimension = 100;
maleTmp=U(:,1:dimension)'*mu1;
femaleTmp=U(:,1:dimension)'*mu2;
testTmp=U(:,1:dimension)'*allTestData;
trainTmp=[maleTmp,femaleTmp];
IDX1=knnsearch(trainTmp',testTmp');


%% Another gender detection system
% testTmp=U'*allTestDataCentered;
% Y=U'*allTrainDataCentered;
% IDX=knnsearch(Y',testTmp');
dimension = 500;
trainTmp=U(:,1:dimension)'*allTrainData;
testTmp=U(:,1:dimension)'*allTestData;
maleTmp = trainTmp(:,1:1934);
femaleTmp=trainTmp(:,1935:3868);
result = aveEuclidDistance(testTmp,maleTmp,femaleTmp);
acc=0;
for i=1:2000
    if i<=1000 && result(i)==1
        acc=acc+1;
    elseif i>1000 && result(i)==2
        acc=acc+1;
    end
end
acc=acc/2000;