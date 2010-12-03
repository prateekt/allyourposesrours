function [ points ] = triangulateWithE( pts_1, pts_2, E, K1, K2 )
%triangulate Finds the 3D points given the 2D correspondences and camera
%intrinsics.

M1 = K1 * eye(3,4);
M2 = camera2(E', K2);

points = backproject( pts_1, pts_2, M1, M2 );

end