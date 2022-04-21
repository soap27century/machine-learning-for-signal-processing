% SCRIPT TO CREATE A DEMO FOR NEWTON'S METHOD
% FOLLOW THE COMMENTS SECTION CAREFULLY AND IMPLEMENT EACH SECTION AS
% INSTRUCTED IN THE COMMENTS

% create a function poly.m and write desired equation and return
% independent variable
f = @poly;     
% create a function poly_derivative.m and write desired equation and return
% independent variable
fder = @poly_derivative;
maxIters =  200;
tol = 1e-06;
% experiment with different values of xi
xi = -100.0;
% Initialization of relative errors, rel_errs
rel_errs = zeros(maxIters,1);
xr=xi;
% caluculate function values for each value of xlim_values using for loop
f_values=[];
xlim_values=[-abs(xr):0.1:abs(xr)];
% write from here
for xlim_values_tmp = (-abs(xr):0.1:abs(xr))
    f_values = [f_values,f(xlim_values_tmp)];
end
% plot the xlim_values vs function values and draw x-axis and y-axis
% centered at origin
% write your code here
plot(xlim_values,f_values);
line([-xi,xi],[0,0])
line([0,0],[-f(xr),f(xr)])

% write xr as 'x0' to denote initial point. Use text function to write text on figures
% write from here

text(xr,f(xr),'x0');

% plot tangent at xr
% write from here

tan=fder(xr);
tangent=[];
xx = -f(xr)/tan + xr;
line ([xr,xx],[f(xr),0],'color','r');

% draw line from xr to f(xr). Use functions text and line
[xr] = newtons_update(f,fder, xi);
% write from here

line([xr,xr],[0,f(xr)])

% find Newtons update and write on the same plot
% write from here
%[xr] = newtons_update(f,fder, xi);
text(xr,f(xr),'x1')
olditer = 'x1';

% M is the variable to hold frames of video. Use getframe function
%M=[];
count=1;
% write command here and store in M[count]
% gg=getframe;
% M{count}=gg;
M(count) = getframe();
count=count+1;
%pause

for iter = 1:maxIters
    % plot the xlim_values vs function values and draw x-axis and y-axis
    % centered at origin
    % write from here

    plot(xlim_values,f_values);
    line([-xi,xi],[0,0])
    line([0,0],[-f(xi),f(xi)])
    % plot tangent at xr
    % write from here
    tan=fder(xr);
    tangent=[];
    xx = -f(xr)/tan + xr;
    line ([xr,xx],[f(xr),0],'color','r');
    % draw line from xr to f(xr)
    % write from here
    %[xr] = newtons_update(f,fder, xrold);
    xrold=xr;
    % find Newtons update
    text(xr,f(xr),olditer);
    [xr] = newtons_update(f,fder, xrold);
    
    % Relative error from xr and xrold and stopping criteria and break if
    % rel_err<tol. 
    % write from here
    if (abs(xr-xrold) < tol)
        break;
    end
    %using string manipulation to obtain x1 x2 x3 ....
    str = int2str(count);
    str1=strcat('x',str);
    text(xr,f(xr),str1);
    olditer = str1;
    line([xr,xr],[0,f(xr)])
    
    % save the current frame for the video. Store in M(count)
    % write from here
    M(count) = getframe();
    count=count+1;
    %pause
 
end
  root = xr; 
movie(M,1,2);% play it onece at fps:2



