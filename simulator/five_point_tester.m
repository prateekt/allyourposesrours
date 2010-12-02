% Test

close all

addpath ../paper1_impl

% Load the camera calibrations
load('templeSparseRing_data.mat');
[ P, K, R, t ] = extractKRt(data);

% Generate a 3D point cloud
[ pointList ] = generatePoints( );

% Project the 3D points onto each camera's normalized image plane
[ pts1, pts2 ] = projectPoints( pointList, P{1}, P{2} );

[ idealReprojPoints ] = backproject( pts1, pts2, P{1}, P{2} );

figure();
plot3(idealReprojPoints(:,1), idealReprojPoints(:,2), idealReprojPoints(:,3), '.');
title('Error-free reprojected points?');
% 
% % Calculate the essential matrix between the camera views
% EList = five_point(pts1, pts2);
% 
% % Backproject the points into 3D and view them
% for i = 1:length(EList)
%    
%     reprojPoints = triangulateWithE(pts1, pts2, EList{i}', K{1}, K{2});
%     figure()
%     plot3(reprojPoints(:,1), reprojPoints(:,2), reprojPoints(:,3), '.')
% end

