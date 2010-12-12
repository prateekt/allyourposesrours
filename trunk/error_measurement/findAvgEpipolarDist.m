function [ avg_dist ] = findAvgEpipolarDist(q, E, p )
%findAvgEpipolarDist Summary of this function goes here
%   Detailed explanation goes here

% Note:
% p and q must have camera intrinsics removed and be 3-by-n matrices, where
% n is the number of points to test
% E should be of the form q' * E * p = 0

numPoints = size(p, 2);

sum = 0;

for i = 1:numPoints
    sum = sum + distToEL(q(:,i), E, p(:,i));
end

avg_dist = sum / numPoints;


end

