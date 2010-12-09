function [ pts1, pts2 ] = projectPoints( pointList, M1, M2 )
%projectPoints Project the points onto each image plane

% pointList: n-by-3 list of points in the form (x, y, z) and with n number
% of points.

% M1 and M2: 3-by-4 project matrices

% pts1 and pts2: n-by-2 list of normalized points in the form (x, y)

numPoints = size(pointList, 1);

% Convert points to homogenous coordinates
pointList = [ pointList, ones(numPoints, 1) ]';

pts1 = M1 * pointList;
pts2 = M2 * pointList;


% Transpose pts1 and pts2 so they list points as (x,y,w)
pts1 = pts1';
pts2 = pts2';

% Normalize points by w and trim off w

pts1 = pts1(:,1:2) ./ repmat(pts1(:,3), 1, 2);
pts2 = pts2(:,1:2) ./ repmat(pts2(:,3), 1, 2);

% DEBUG: View points
%{
figure();
subplot(2,2,1);
plot(pts1(:,1), pts1(:,2), '.');
title('Camera 1 view:');
subplot(2,2,2);
plot(pts2(:,1), pts2(:,2), '.');
title('Camera 2 view');
%}

% Show correspondences
% subplot(2,1,2);
% plot(

end

