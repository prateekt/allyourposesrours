function [ P ] = computeProjectionMatrix( K, R, t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

P = K*[R' -R'*t'];

end

