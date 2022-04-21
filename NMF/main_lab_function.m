clear all
d1=112; d2=92; d=d1*d2; 
imagesNb=9; peopleNb=40; images=cell(peopleNb,imagesNb);
matX=zeros(d,peopleNb*imagesNb);

jj=1;
for ni=1:peopleNb
    for kimg=1:imagesNb
    filename=sprintf('Train/s%i/%i.pgm',ni,kimg);
    im=double(imread(filename));

    matX(:,jj)=reshape(im,d,1);
    jj=jj+1;
    end
end

X=matX/max(matX(:));

%opt = statset('MaxIter',500,'Display','final');
%[W,H] = nnmf(X,40,'options',opt,'algorithm','mult');
%[W,H,obj,num_iter] = nmf(X,40,500,0.001);
[W,H,obj,k] = ssnmf(X,40,500,0.001,1,1);


figure;
for k = 1:40
  subplot(5,8,k);
  imagesc(reshape(W(:,k),d1,d2));
  colormap gray; axis image off;
end
