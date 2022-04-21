%load images
Cameraman_image=imread('cameraman.tif');
Moon_image=imread('5.1.09.tiff');
figure(3)
imshow(Moon_image)

%fade images
Fade_image1=0.8.*Cameraman_image;
Fade_image2=0.2.*Moon_image;
Mixte_image=Fade_image1+Fade_image2;
figure(4)
imshow(Mixte_image)

[m,n]=size(Moon_image);
First_part_image_1=Cameraman_image(1:100,1:100);
last_part_image_2=Moon_image(m-99:m,n-99:n);
last_part_Mixte_image=0.8.*last_part_image_2+0.2.*First_part_image_1;
figure(5)
imshow(last_part_Mixte_image)
%unravel images using reshape
Moon_image_unravel = reshape(Moon_image,[256*256,1]);
Cameraman_image_unravel = reshape(Cameraman_image,[256*256,1]);
Both_images = zeros(256*256,2);
Both_images(:,1) = Moon_image_unravel;
Both_images(:,2) = Cameraman_image_unravel;
New_image1 = Both_images*[0.5;0.5];
mixte_image = reshape(New_image1,[256,256]);
figure(6)
imshow(uint8(mixte_image));


