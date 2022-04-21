%% 
%load and prepare data
train_x = loadMNISTImages('data/train-images-idx3-ubyte')';
train_y = loadMNISTLabels('data/train-labels-idx1-ubyte');
test_x = loadMNISTImages('data/t10k-images-idx3-ubyte')';
test_y = loadMNISTLabels('data/t10k-labels-idx1-ubyte');
[r,c] = size(test_x);
%pca and projection
U_784 = pca(train_x);
U_50=U_784(:,1:50);
U_100=U_784(:,1:100);
U_200=U_784(:,1:200);
U_300=U_784(:,1:300);
U_400=U_784(:,1:400);
U_500=U_784(:,1:500);
U = {U_50,U_100,U_200,U_300,U_400,U_500};
train_x=train_x';
[D,N]=size(train_x);
mu=sum(train_x,2)/N;
train_x=train_x-mu*ones(1,N);
proj_train_x_50=U_50'*train_x;
proj_train_x_100=U_100'*train_x;
proj_train_x_200=U_200'*train_x;
proj_train_x_300=U_300'*train_x;
proj_train_x_400=U_400'*train_x;
proj_train_x_500=U_500'*train_x;
proj_train_x = {proj_train_x_50,proj_train_x_100,proj_train_x_200...
    proj_train_x_300,proj_train_x_400,proj_train_x_500};

test=test_x'-mu*ones(1,r);
proj_test_x_50=U_50'*test;
proj_test_x_100=U_100'*test;
proj_test_x_200=U_200'*test;
proj_test_x_300=U_300'*test;
proj_test_x_400=U_400'*test;
proj_test_x_500=U_500'*test;
proj_test_x = {proj_test_x_50,proj_test_x_100,proj_test_x_200...
    proj_test_x_300,proj_test_x_400,proj_test_x_500};


%% 
%shared cov
acc_shared_cov=zeros(1,6);
for index = 1:6
    train_data=cell(1,10);
    tmp_train = proj_train_x{index};
    tmp_test = proj_test_x{index};
    for i = 1:10
        train_data{i}=tmp_train(:,find(train_y == i-1));
    end
    class_mean=cell(1,10);
    covv=cell(1,10);
    for i =1:10
        class_mean{i}=mean(train_data{i},2);
        covv{i}=cov(train_data{i}');
    end
    sz = size(tmp_train,1);
    shared_cov=zeros(sz,sz);
    for i =1:10
        shared_cov=shared_cov + (size(train_data{i},2)/N)*covv{i};
    end
    sample_score=zeros(r,10);
    for i =1:10
        sample_score(:,i)= mvnpdf(tmp_test',class_mean{i}',shared_cov);
    end
    [M,I] = max(sample_score,[],2); 
    I=I-1;
    count=0;
    diff=I-test_y;
    for i =1:r
        if diff(i)==0
            count=count+1;
        end
    end
    acc_shared_cov(1,index)=count/r;

end
%%
%different cov for each class
acc_diff_cov=zeros(1,6);
for index = 1:6
    tmp_train = proj_train_x{index};
    tmp_test = proj_test_x{index};
    for i = 1:10
        train_data{i}=tmp_train(:,find(train_y == i-1));
    end
    for i =1:10
        class_mean{i}=mean(train_data{i},2);
        covv{i}=cov(train_data{i}');
    end
    for i =1:10
        sample_score(:,i)= mvnpdf(tmp_test',class_mean{i}',covv{i});
    end
    [M,I] = max(sample_score,[],2); 
    I=I-1;
    count=0;
    diff=I-test_y;
    for i =1:r
        if diff(i)==0
            count=count+1;
        end
    end
    acc_diff_cov(1,index)= count/r;
end