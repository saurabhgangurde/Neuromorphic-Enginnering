function [ image ] = create_image( sigma )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    length = 32;    % length of gaussFilter vector
    x = linspace(-length / 2, length / 2, length);
    gaussFilter = 255*exp(-x .^ 2 / (2 * sigma ^ 2));
    image=zeros(32,32);
    image(8:23,:)=ones(16,1)*gaussFilter;

end

