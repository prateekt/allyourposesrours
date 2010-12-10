function [p,q,K1,K2] = fifteen_point_data2(R1,t1, K1, R2, t2, K2)

%% Generate a 3D point cloud
[pointList] = generatePoints();

%compute camera projection matrices, P1 and P2
P1 = K1*[R1 t1'];
P2 = K2*[R2 t2'];

%% Project the 3D points onto each camera's normalized image plane
[pts1, pts2] = projectPoints(pointList, P1, P2);

% Homogeneous version of the pointss
h_pts1 = [pts1 ones(size(pts1,1),1)];
h_pts2 = [pts2 ones(size(pts2,1),1)];

%% Premultiply the input points by inv(K1) and inv(K2)
h_pts1 = K1 \ h_pts1';
h_pts2 = K2 \ h_pts2';
h_pts1 = h_pts1';
h_pts2 = h_pts2';

%choose first 15 points to be p and q
p = zeros(15,3);
q = zeros(15,3);
for i=1:15
    p(i,:) = h_pts1(i,:);
    q(i,:) = h_pts2(i,:);
end