function [ points ] = backproject( pts_1, pts_2, M1, M2 )
%triangulate Finds the 3D points given the 2D correspondences and camera
% projection matrices.

% points: n-by-3 matrix of 3D points in the form (x, y, z) with each row
% representing one point

% Preallocate
points = zeros(length(pts_1), 4);

for i = 1:size(pts_1, 1)
    
    % Method taken from section 12.2 Linear triangulation methods in
    % Hartley R., Zisserman A., Multiple View Geometry in Computer Vision  
    x1 = pts_1(i,1);
    y1 = pts_1(i,2);
    x2 = pts_2(i,1);
    y2 = pts_2(i,2);
    
    % A is a 4-by-4 matrix    
    A = [  x1 * M1(3,:) - M1(1,:);
            y1 * M1(3,:) - M1(2,:);
            x2 * M2(3,:) - M2(1,:);
            y2 * M2(3,:) - M2(2,:)];
   
    % Ah = 0, where h is the 3D homogeneous coordinate of the real world
    % point
    [U, D, V] = svd(A);
    
    % Take the last column of V
    h = V(:,end);
        
    % Scale by the homogeneous component
    h = h / h(end);
    
    % Place into the point list
    points(i,:) = h';
    
    
end
% Trim off the homogenous component
points = points(:,1:3);

end