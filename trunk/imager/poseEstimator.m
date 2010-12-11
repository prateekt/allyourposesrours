function [M2, cameraCenter2] = poseEstimator(N, K)

n=1;
K1 = K;
K2 = K;

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
    pts_1 = [f1_x, f1_y, ones(size(f1_x,1))];
    pts_2 = [f2_x, f2_y, ones(size(f1_x,1))];
    size(pts_1)
    size(pts_2)
    
    %make first 15 p and q
    p = zeros(15,3);
    q = zeros(15,3);
    for i=1:15
        p(i,:) = [pts_1(i,1),pts_1(i,2),1];
        q(i,:) = [pts_2(i,1),pts_2(i,2),1];
    end
        
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
%    EList = five_point(pts_1, pts_2);
    [EFinal, ERROR_RATIO] = fifteen_point(p,q,K1,K2); 
    M2 = robustCameraRecovery(EFinal, p,q);
    [cameraCenter2,w] = computeCameraCenter(M2,p(1,:));
        
    %plot
    plot3(cameraCenter2(1), cameraCenter2(2), cameraCenter2(3), 's','MarkerFaceColor','g');
    for i=0:5
        plot3(cameraCenter2(1)+w(1)*i, cameraCenter2(2) + w(2)*i, cameraCenter2(3) + w(3)*i);
    end
    getframe(gcf);
    %{
    figure(2);
    subplot(1,2,1);
    hold on;
    imagesc(I1);
    for j=1:15
        plot(p(j,1),p(j,2),'s');
    end
    hold off;
    subplot(1,2,2);
    hold on;
    for j=1:15
        plot(q(j,1),q(j,2),'s');
    end
    hold off;
    getframe(gcf);
    %}
    %update
    I1 = I2;
    n = n + 1;
    
end
hold off;