function [ angle_deg ] = findAngleBetweenMatrices( R1, R2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

v1 = ones(size(R1,2),1)
v2 = ones(size(R2,2),1)

v1 = R1 * v1
v2 = R2 * v2

angle_deg = findAngleBetweenVectors(v1, v2);


end

