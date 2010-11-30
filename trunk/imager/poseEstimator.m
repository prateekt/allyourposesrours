function [M2, cameraCenter] = poseEstimator(N)

load intrinsics;

n=1;

%snap initial picture
useCamera('mage1');
I1 = imread('image1.jpeg');
I1 = rgb2gray(I1);

plot3(0,0,0,'s');
hold on;
while(n <= N)

    %snap new picture
    useCamera('mage2');
    I2 = imread('image2.jpeg');
    I2 = rgb2gray(I2);

    %get point correspondences
    [f1_x, f1_y, f2_x, f2_y] =  getCandidateCorrespondences(I1, I2);
    pts_1 = [f1_x, f1_y];
    pts_2 = [f2_x, f2_y];
    size(pts_1)
    size(pts_2)
    
    %{
    %estimate pose -- seven point 
    
    %Note: I was comparing the ploted points of the five point algorithm
    %with my sevenpoint implementation. Let's take it out for now.
    
    m = max(size(I1,1), size(I1,2));
    F = sevenpoint_norm(pts_1, pts_2, m);
    E = essentialMatrix(F{1}, K1,K2);
    M2 = robustCameraRecovery(E, pts_1,pts_2);
    cameraCenter = computeCameraCenter(M2);
%}
    %estimate pose -- five point
    EList = five_point(pts_1, pts_2);
    M2 = robustCameraRecovery(EList{1}, pts_1,pts_2);
    cameraCenter2 = computeCameraCenter(M2);
    
    %plot
    plot3(cameraCenter2(1), cameraCenter2(2), cameraCenter2(3), 's');
    getframe(gcf);
    
    %update
    I1 = I2;
    n = n + 1;
    
end
hold off;