function [ pointList ] = generatePoints( )
%generatePoints Generates a list of points
%   Detailed explanation goes here

% A very simple point list to start
% [X, Y, Z] = ndgrid(-0.5:0.1:0.5, -0.5:0.5:0.5, 0);%, -0.5:0.5:0.5);
% pointList = [X(:), Y(:), Z(:)];

% A cube:
pointList = [   -0.5, -0.5, -0.5;
                -0.5, -0.5,  0.5;
                -0.5,  0.5, -0.5;
                -0.5,  0.5,  0.5;
                 0.5, -0.5, -0.5;
                 0.5, -0.5,  0.5;
                 0.5,  0.5, -0.5;
                 0.5,  0.5,  0.5];

% DEBUG: View points
figure, plot3(pointList(:,1), pointList(:,2), pointList(:,3), '.'); 
title('Original 3D points');
axis equal;

end

