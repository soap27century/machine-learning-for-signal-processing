function img=loadimage(individual,numbers)
switch(numbers)
    case{1,2,3,4,5,6,7,8,9}
        imgroot='Train';
        img=double(imread(fullfile(imgroot,['s' num2str(individual) ],[num2str(numbers) '.pgm'])));
    case 10
        imgroot='Test';
        img=double(imread(fullfile(imgroot,['s' num2str(individual) ],[num2str(numbers) '.pgm'])));
end

