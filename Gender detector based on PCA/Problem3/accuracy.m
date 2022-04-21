function [ count ] = accuracy( result )
count = 0;
for i=1:2000
   if i<=1000 && result(i)<=1934
       count=count+1;
   elseif i>1000 && result(i)>=1934
       count=count+1;
   end
end
count=count/2000;
end

