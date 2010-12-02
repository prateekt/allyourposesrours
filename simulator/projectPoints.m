function [ pts1, pts2 ] = projectPoints( pointList, P1, P2 )
%projectPoints Project the points onto each image plane

% pointList: n-by-3 list of points in the form (x, y, z) and with n number
% of points.

% P1 and P2: 3-by-4 project matrices

% pts1 and pts2: n-by-3 list of points in the form (x, y, w) with w being
% the homogenous coordinate

numPoints = size(pointList, 1);

% Convert points to homogenous coordinates
pointList = [ pointList, ones(numPoints, 1) ]';

pts1 = P1 * pointList;
pts2 = P2 * pointList;


% Transpose pts1 and pts2 so they list points as (x,y,w)
pts1 = pts1';
pts2 = pts2';

% Normalize points by w

pts1 = pts1 ./ repmat(pts1(:,3), 1, 3);
pts2 = pts2 ./ repmat(pts2(:,3), 1, 3);

% DEBUG: View points
figure();
subplot(2,2,1);
plot(pts1(:,1), pts1(:,2), '.');
subplot(2,2,2);
plot(pts2(:,1), pts2(:,2), '.');

% Show correspondences
% subplot(2,1,2);
% plot(

end

