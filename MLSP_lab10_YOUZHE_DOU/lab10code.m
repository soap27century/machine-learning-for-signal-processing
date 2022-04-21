%%
clear all;
clc;
%%
%load data
train_image = loadMNISTImages('data/train-images-idx3-ubyte');
labels = loadMNISTLabels('data/train-labels-idx1-ubyte');
[D,N]=size(train_image);
train_image_centered=train_image-(sum(train_image,2)/N)*ones(1,N);
%%
K = 100;
w = randn(D,K);
sigma = abs(randn(1,1));
% get log-likelihood
M = w'* w + sigma.*eye(K);
S = 0;
for i = 1:N
   S = S + norm(train_image_centered(:,i))^2 ;
end
U = chol(M);
T = inv(U')*(w'*train_image_centered);
t_sum=0;
for i = 1:K
    for j = 1:N
        t_sum=t_sum+abs(T(i,j))^2;
    end
end
second_part = (S - t_sum)/(sigma*N);
first_part = 2*sum(log(diag(U)))+(D - K)*log(sigma); 
tmp = (-N/2)*(D*log(2*pi) + first_part + second_part);
log_likihood = [];
log_likihood = [log_likihood, tmp];
%%
for iter = 1:10
    % E-step
    M = w'*w + sigma*eye(K);
    U = chol(M);
    V= inv(U);
    Ezn = {};
    Eznzn_t = {};
    for i=1:N
        Ezn{i} = (V*V')* w'*train_image_centered(:,i);
        Eznzn_t{i} = sigma.*(V*V') + Ezn{i}*Ezn{i}';
    end
    % M-step
    first_part=0;
    second_part=0;
    sigma_new=0;
    for i = 1:N
        first_part = first_part + train_image_centered(:,i)*Ezn{i}';
        second_part = second_part + Ezn{i}*Ezn{i}';
    end
    w_new = first_part * inv(second_part + sigma.*(V*V'));
    for i =1:N
        sigma_new = sigma_new + (norm(train_image_centered(:,i))^2 - 2*Ezn{i}'* w_new'*train_image_centered(:,i)+trace(Eznzn_t{i}*w_new'*w_new));
    end
    sigma_new=sigma_new/(N*D);
    w = w_new;
    sigma = sigma_new;
    % compute log-likelihood
    M = w'* w + sigma.*eye(K);
    S = 0;
    for i = 1:N
       S = S + norm(train_image_centered(:,i))^2 ;
    end
    U = chol(M);
    T = inv(U')*(w'*train_image_centered);
    t_sum=0;
    for i = 1:K
        for j = 1:N
            t_sum=t_sum+abs(T(i,j))^2;
        end
    end
    second_part = (S - t_sum)/(sigma*N);
    first_part = 2*sum(log(diag(U)))+(D - K)*log(sigma); 
    tmp = (-N/2)*(D*log(2*pi) + first_part + second_part);
    log_likihood = [log_likihood,tmp];
end
%%
%plot to see the trend (increasing?)
plot(log_likihood);

%%
% project data
train_proj = w'*train_image_centered;
test_images = loadMNISTImages('data/t10k-images-idx3-ubyte')'; 
test_labels = loadMNISTLabels('data/t10k-labels-idx1-ubyte');
test_image_centered=test_images'-(sum(train_image,2)/N)*ones(1,10000);
test_images_proj=w'*test_image_centered;
tmp_train=cell(1,10);
meann=cell(1,10);
covv=cell(1,10);
for j = 1:10
   tmp_train{j}=train_proj(:,find(labels == j-1));
end
for i =1:10
   meann{i}=mean(tmp_train{i},2);
   covv{i}=cov(tmp_train{i}');
end
score=zeros(10000,10);
for i =1:10
score(:,i)= mvnpdf(test_images_proj',meann{i}',covv{i});
end
%%
%compute accuracy
[~,res] = max(score,[],2); 
res=res-1;
count=0;
diff=res-test_labels;
for i =1:10000
if diff(i)==0
    count=count+1;
end
end
accuracy=count/10000;

