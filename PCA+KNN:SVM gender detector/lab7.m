%% 
%Load all data
f = 'face/male/train/';
ls = dir([f '*.jpg']);
maleTrainData = [];
for i =1:length(ls)
    img=imread([f ls(i).name]);
    maleTrainData(:,i)=img(:);
end
f = 'face/female/train/';
ls = dir([f '*.jpg']);
femaleTrainData = [];
for i =1:length(ls)
    img=imread([f ls(i).name]);
    femaleTrainData(:,i)=img(:);
end
allTrainData=[maleTrainData,femaleTrainData];
f = 'face/male/test/';
ls = dir([f '*.jpg']);
maleTestData = [];
for i =1:length(ls)
    img=imread([f ls(i).name]);
    maleTestData(:,i)=img(:);
end
f = 'face/female/test/';
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
%%
% using knn
dimension = 500;
k = 100;
trainTmp=U(:,1:dimension)'*allTrainData;
testTmp=U(:,1:dimension)'*allTestData;
tmp = ones(1,3868);
tmp(1,1935:3868) = 2;
labels = KNN(trainTmp,tmp,testTmp,k);
acc=0;
for i=1:2000
    if i<=1000 && labels(i)==1
        acc=acc+1;
    elseif i>1000 && labels(i)==2
        acc=acc+1;
    end
end
acc=acc/2000;
%%
% using svm
dimension = 100;
trainTmp=U(:,1:dimension)'*allTrainData;
testTmp=U(:,1:dimension)'*allTestData;
tmp = ones(1,3868);
tmp(1,1935:3868) = -1;
Mdl1=fitclinear(trainTmp',tmp','BetaTolerance',1.00000e-4);
labels = [];
testTmp1 = testTmp';
for i = 1 : 2000
    labels(i) = predict(Mdl1,testTmp1(i,:));
end
acc=0;
for i=1:2000
    if i<=1000 && labels(i)==1
        acc=acc+1;
    elseif i>1000 && labels(i)==-1
        acc=acc+1;
    end
end
acc=acc/2000;

%%
%
dimension = 500;
trainTmp=U(:,1:dimension)'*allTrainData;
testTmp=U(:,1:dimension)'*allTestData;
Mdl2= fitcsvm(trainTmp',tmp','Standardize',true,...
'KernelFunction','polynomial','PolynomialOrder',2 ,'BoxConstraint',5);
labels = [];
testTmp1 = testTmp';
for i = 1 : 2000
    labels(i) = predict(Mdl2,testTmp1(i,:));
end
acc=0;
for i=1:2000
    if i<=1000 && labels(i)==1
        acc=acc+1;
    elseif i>1000 && labels(i)==-1
        acc=acc+1;
    end
end
acc=acc/2000;
%%
dimension = 100;
trainTmp=U(:,1:dimension)'*allTrainData;
testTmp=U(:,1:dimension)'*allTestData;
Mdl3= fitcsvm(trainTmp',tmp','Standardize',true,...
'KernelFunction','gaussian','BoxConstraint',1);
labels = [];
testTmp1 = testTmp';
for i = 1 : 2000
    labels(i) = predict(Mdl3,testTmp1(i,:));
end
acc=0;
for i=1:2000
    if i<=1000 && labels(i)==1
        acc=acc+1;
    elseif i>1000 && labels(i)==-1
        acc=acc+1;
    end
end
acc=acc/2000;