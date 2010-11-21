function [ P ] = triangulateWithE( pts_1, pts_2, E, K1, K2 )
%triangulate Finds the 3D points given the 2D correspondences and camera
%intrinsics.

M1 = K1 * eye(3,4);
M2 = camera2(E, K2);

% Preallocate
P = zeros(length(pts_1), 4);

for i = 1:size(pts_1, 1)
    
    % Method taken from section 12.2 Linear triangulation methods in
    % Hartley R., Zisserman A., Multiple View Geometry in Computer Vision  
    x1 = pts_1(i,1);
    y1 = pts_1(i,2);
    x2 = pts_2(i,1);
    y2 = pts_2(i,2);
    
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
    %h = h / h(end);
    
    % Place into the point list
    P(i,:) = h';
    
    
end
% Trim off the homogenous component
P = P(:,1:3);

end