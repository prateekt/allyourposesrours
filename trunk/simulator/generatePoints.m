function [ pointList ] = generatePoints( )
%generatePoints Generates a list of points
%   Detailed explanation goes here

% A very simple point list to start
[X, Y, Z] = ndgrid(-0.5:0.1:0.5, -0.5:0.5:0.5, 0);%, -0.5:0.5:0.5);
pointList = [X(:), Y(:), Z(:)];

% DEBUG: View points
figure, plot3(pointList(:,1), pointList(:,2), pointList(:,3), '.'); 

end

