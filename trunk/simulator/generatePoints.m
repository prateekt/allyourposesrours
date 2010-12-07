function [ pointList ] = generatePoints( )
%generatePoints Generates a list of points
%   Detailed explanation goes here

% A cube:
% I'm adding the corner points first to ensure that the 5-point used to
% calculate E are not on a plane. All 5-points on a plane seemed to cause
% problems earlier.

pointList = [   -0.5, -0.5, -0.5;
                -0.5, -0.5,  0.5;
                -0.5,  0.5, -0.5;
                -0.5,  0.5,  0.5;
                 0.5, -0.5, -0.5;
                 0.5, -0.5,  0.5;
                 0.5,  0.5, -0.5;
                 0.5,  0.5,  0.5];

% Add interior points
[X, Y, Z] = ndgrid(-0.5:0.1:0.5, -0.5:0.1:0.5, -0.5:0.1:0.5);
pointList = [   pointList;
                X(:), Y(:), Z(:)];

% DEBUG: View points
figure, plot3(pointList(:,1), pointList(:,2), pointList(:,3), '.');
title('Original 3D points');
axis equal;

end

