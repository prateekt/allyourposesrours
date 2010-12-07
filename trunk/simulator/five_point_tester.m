% Test
clear
close all

addpath ../paper1_impl

% Path to Nister's 5-point implementation
addpath ../../nister

%% Load the camera calibrations
load('templeSparseRing_data.mat');
[ P, K, R, t ] = extractKRt(data);

%% Generate a 3D point cloud
[ pointList ] = generatePoints( );

%% Project the 3D points onto each camera's normalized image plane
[ pts1, pts2 ] = projectPoints( pointList, P{1}, P{2} );

% Homogeneous version of the pointss
h_pts1 = [pts1 ones(size(pts1,1),1)];
h_pts2 = [pts2 ones(size(pts2,1),1)];


%% Perfect backprojection original projection matrices
[ idealReprojPoints ] = backproject( pts1, pts2, P{1}, P{2} );
figure();
plot3(idealReprojPoints(:,1), idealReprojPoints(:,2), idealReprojPoints(:,3), '.');
title('Gnd truth projection matrices');
axis equal;

%% Backprojection with error-free E and calculated projection matrices
E = findGndTruthE(R{1}, t{1}, R{2}, t{2});
reprojPoints = triangulateWithE(pts1, pts2, E', K{1}, K{2});
figure()
plot3(reprojPoints(:,1), reprojPoints(:,2), reprojPoints(:,3), '.');
title('Gnd truth E, approx projection matrices');
axis equal;


%% Premultiply the input points by inv(K1) and inv(K2)
h_pts1 = K{1} \ h_pts1';
h_pts2 = K{2} \ h_pts2';
h_pts1 = h_pts1';
h_pts2 = h_pts2';


%% Nister's 5-point implementation
% Evec = calibrated_fivepoint(h_pts2', h_pts1');
% 
% numEs = size(Evec, 2);
% 
% for i = 1: numEs
%     EList{i} = reshape(Evec(:,i), 3, 3);
% end


%% Calculate the essential matrix with 5-point algorithm

 EList = five_point(h_pts1, h_pts2);

%% Backproject the points into 3D and view them
for i = 1:length(EList)
    
    reprojPoints = triangulateWithE(pts1, pts2, EList{i}', K{1}, K{2});
    figure()
    plot3(reprojPoints(:,1), reprojPoints(:,2), reprojPoints(:,3), '.');
    axis equal
    
    
end

%% Check error
for i=1:length(EList)
  i
  E = EList{i};
  % Check determinant constraint! 
  error_determinate = det( E)
  % Check trace constraint
  error_trace = 2 *E*transpose(E)*E -trace( E*transpose(E))*E
  % Check reprojection errors
  error_reprojection = diag( h_pts2 * E * h_pts1')
  sum_error_proj = sum(abs(error_reprojection))
end


