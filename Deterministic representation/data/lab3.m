clear all;
clc;
%%
%1
mat1 = load('rbc_export1.mat');
mat1 = load('rbc_export2.mat');
%mat1 = load('rbc_export3.mat');
%mat1 = load('yeast_export.mat');
refSpec = mat1.refSpec;
%plot(refSpec(:,1),refSpec(:,2)),ylabel('Power(dBm)'), xlabel('Wavelength(nm)');

%%
%2%3
max1 = max(refSpec(:,2))-10;
indices = find(refSpec(:,2)>max1);
for i = 1:length(indices)
    
    newData(:,i)= mat1.specData(:,indices(i));
    freq(i) = 3*10^8/refSpec(indices(i),1)*10^9;
    
end
%plot(freq)

%%
%4
freq_a=min(freq):(max(freq)-min(freq))/1023:max(freq);
for i=1:400
    interp_specData(i,:)=interp1(freq,newData(i,:),fliplr(freq_a));
end

%plot(freq_a,interp_specData(1,:))

%%
%5
dataFFT = fft(interp_specData(2,:));
%plot(freq_a,dataFFT);

%%
%6

max2 = max(real(dataFFT));
index = find(dataFFT==max2);
max2 = max(real(dataFFT(index+1:1024)));
locs = find(dataFFT>=max2);
loc1 = locs(2);
loc2 = locs(3);

%%
%7
width = 10;
len = length(dataFFT);
filter = zeros(1,len);
for i=loc1-width:loc1+width
    filter(1,i) = 1;
end
for i=loc2-width:loc2+width
    filter(1,i) = 1;
end
%plot(filter)
dataFiltered= dataFFT.*filter;
dataIFFT = ifft(dataFiltered);

%%
%8
for i=1:400
    tmp(i,:) = fft(interp_specData(i,:));
end
result=bsxfun(@times,tmp,filter);
for i=1:400
    tmpIFFT(i,:) = ifft(result(i,:));
end


%%
%9%10
ifft_filtered_mag = abs(tmpIFFT);
ifft_filtered_phase = angle(tmpIFFT);
figure;
imagesc(ifft_filtered_mag)  
phase = (diff(unwrap((ifft_filtered_phase)),[],1)/(1/1024));
avg = repmat(mean(detrend(phase),2),1,1024);
phase = detrend(phase) - avg;
figure;
imagesc(phase); 
%imagesc(detrend(unwrap(angle(tmpIFFT))));