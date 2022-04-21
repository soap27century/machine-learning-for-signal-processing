%% Problem 2
file = 'speaker/train/';
matrix = dir([file,'*']);
data_all = {};
for i =3:length(matrix)
    data_all{i-2}=dlmread([file matrix(i).name]);
end
label={'101188-m','102147-m','103183-m','106888-m'...
    '110667-m','2042-f','3424-m','4177-m','4287-f','7722-f'};
cur_data={};
for i = 1:2:20
    cur_data{ceil(i/2)} = [];
    cur_data{ceil(i/2)} = data_all{i};
    cur_data{ceil(i/2)} = [cur_data{ceil(i/2)} ; data_all{i+1}];
end
for i = 1: 10
    eval([['GMM_Model',num2str(i)],'=','fitgmdist(cur_data{i} , 64,''Options'',statset(''MaxIter'',300),''CovarianceType'',''diagonal'')',';'])
end
%% Load test data
file = 'speaker/test/';
data_test = {};
for i =1:10
    data_test{i}=dlmread([file ['test',num2str(i)]]);
end
logp=zeros(10,10);
for i = 1:10
    for j = 1:10
        [~,logp(i,j)] = posterior(eval(['GMM_Model',num2str(j)]),data_test{i});
    end
end
I = zeros(10,1);
for i = 1:10
    [M,I(i)] = min(logp(i,:));
end
%%results
fid=fopen('result.text','w');
for i=1:10
    fprintf(fid,'%s',['test',num2str(i),' ']);
    fprintf(fid,'%s\n',label{I(i)});
end
fclose(fid);
        