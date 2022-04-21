function [ output_args ] = newtons_update( f, fder, xi )
%NEWTONS_UPDATE Summary of this function goes here
%   Detailed explanation goes here
tan=fder(xi);    
x=-f(xi)/tan+xi;
output_args = x;
end

