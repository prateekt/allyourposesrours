function [readings_5, readings_7] = exp_NisterImplementationWithNoise()


numTests = 1000;
% noise_std_dev = 0.01;

maxNoise = 1;

%generate fixed R,T and other variables
[fixedR, fixedT, varR, varT] = getRT();

%% Generate a 3D point cloud
[pointList] = generatePoints();
% Trying random points instead
% pointList = rand(15,3);


% Let's move these points in front of the camera by increasing Z. We are
% assuming that the world coordinate system is equal to camera1's
% coordinate system.
numPoints = size(pointList, 1);
% Moves the points in front of the cameras
pointList = pointList + 15*[zeros(numPoints, 2) ones(numPoints,1)];

% figure(1);
% subplot(1,2,1);
% plot3(pointList(:,1), pointList(:,2), pointList(:,3), '.');
% axis equal;

% Set up camera 1
R1 = eye(3,3);
t1 = [0 0 0];
K1 = eye(3,3);

P1 = computeProjectionMatrix(K1, R1, t1);

close all;

figure(1);
title('Average error');
hold on;

figure(2);
title('Min Error');
hold on;

% Foward motion
i = 1;
% Sideways motion
% i = 2;
% for i=1:size(fixedR,2)
index = 1;
for noise_std_dev = 0:0.1:1;
    % Setup camera 2
    R2 = fixedR{i};
%     t2 = fixedT{i};
    t2 = [-2, 1.4, 0.3];
    t2 = t2/norm(t2);
    K2 = eye(3,3);
    
    P2 = computeProjectionMatrix(K2, R2, t2)
    
    
    % Project the 3D points onto each camera's normalized image plane
    [pts1, pts2] = projectPoints(pointList(1:15,:), P1, P2);
    
    % Homogeneous version of the points
    h_pts1 = [pts1 ones(size(pts1,1),1)];
    h_pts2 = [pts2 ones(size(pts2,1),1)];
    
    % Premultiply the input points by inv(K1) and inv(K2)
    h_pts1 = K1 \ h_pts1';
    h_pts2 = K2 \ h_pts2';
    p = h_pts1';
    q = h_pts2';
    
    
    sum_5=0;
    sum_7 = 0;
    
    min_5 = inf;
    min_7 = inf;
    for j=1:numTests
        
        % Add noise to camera2's projection
        r = randn(15,2);
        % Limit r to a max noise level
        r(r > maxNoise) = maxNoise;
        
        q_disturbed = q + [noise_std_dev*r zeros(15,1)];
        
        Evec5   = calibrated_fivepoint(q_disturbed(1:5,:)', p(1:5,:)');
        E5 = calcBestE(Evec5, p(8:10,:), q_disturbed(8:10,:));
        
        Evec7 = sevenp(q_disturbed(1:7,:)', p(1:7,:)');
        E7 = calcBestE(Evec7, p(8:10,:), q_disturbed(8:10,:));
        
        
%         recovered_P2 = robustCameraRecovery(E5, p(:,:), q_disturbed(:,:));
%         recovered_t2 = recovered_P2(:,4);
%         error_t_angle = findAngleBetweenVectors(t2, recovered_t2);
        
        E_ERROR_5 = findAvgEpipolarDist(q(11:15,:)', E5, p(11:15, :)');
        E_ERROR_7 = findAvgEpipolarDist(q(11:15,:)', E7, p(11:15, :)');
        
        sum_5 = sum_5 + E_ERROR_5;
        sum_7 = sum_7 + E_ERROR_7;
        cReadings_5{j} = E_ERROR_5;
        cReadings_7{j} = E_ERROR_7;
        
        min_5 = min(min_5, E_ERROR_5);
        min_7 = min(min_7, E_ERROR_7);
                
    end
    readings_5{index} = cReadings_5;
    readings_7{index} = cReadings_7;
    index = index + 1;
    sum_5 = sum_5 / numTests;
    sum_7 = sum_7 / numTests;
    figure(1);
    plot(noise_std_dev,sum_5,'s');
    plot(noise_std_dev,sum_7,'x');
    
    figure(2);
    plot(noise_std_dev,min_5,'s');
    plot(noise_std_dev,min_7,'x');

%     getframe(gcf);
end

hold off;


% figure(1), subplot(1,2,2), plot(pts1(:,1), pts1(:,2), '.');
% axis equal;


end



