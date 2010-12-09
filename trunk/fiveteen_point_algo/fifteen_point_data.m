function [p,q,K1,K2] = fifteen_point_data()

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

%% Premultiply the input points by inv(K1) and inv(K2)
h_pts1 = K{1} \ h_pts1';
h_pts2 = K{2} \ h_pts2';
h_pts1 = h_pts1';
h_pts2 = h_pts2';

%choose first 15 points to be p and q
p = zeros(15,3);
q = zeros(15,3);
for i=1:15
    p(i,:) = h_pts1(i,:);
    q(i,:) = h_pts2(i,:);
end

%get instrinsics matrices
K1 = K{1};
K2 = K{2};
