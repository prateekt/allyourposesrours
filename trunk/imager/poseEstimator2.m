function [M2, cameraCenter2] = poseEstimator2(N, K)

n=1;
K1 = K;
K2 = K;

%snap initial picture
useCamera('mage1');
I1 = imread('image1.jpeg');
I1 = rgb2gray(I1);

plot3(0,0,0,'s','MarkerFaceColor','g');
hold on;
cameraCenter2 = [0,0,0];
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
    p = zeros(5,3);
    q = zeros(5,3);
    for i=1:5
        p(i,:) = [pts_1(i,1),pts_1(i,2),1];
        q(i,:) = [pts_2(i,1),pts_2(i,2),1];
    end
    f_i = zeros(5,3);
    g_i = zeros(5,3);
    for i=5:10
        f_i(i-4,:) = [pts_1(i,1),pts_1(i,2),1];
        g_i(i-4,:) = [pts_2(i,1),pts_2(i,2),1];
    end
    
    %estimate pose -- five point
    E_dud = calibrated_fivepoint(p',q'); 
    numE = size(E_dud,2);
    EList = cell(numE);
    for i=1:numE
        EList{i} = reshape(E_dud(:,i)',3,3);
    end
    %use next 5 points to find correct E
    minSum=inf;
    correctE=-1;
    for i=1:size(EList,2)

        %extract current E
        E = EList{i};

        %Compute F from E
        %F = inv(K1)' * E * inv(K2);

        % We've already premultiplied the points by the intrinsic camera
        % matrices so we don't have do it again.
        F = E;

        %sum distances to Epipolar line
        sum=0;
        for j=1:5
            t = f_i(j,:)';
            p_prime = g_i(j,:)';
            % I think you should use transpose of F here
            sum = sum + distToEL(t, F', p_prime);
        end
        sum = sum  / 5;

        fprintf('E number: %u  Error: %f\n', i, sum);

        %save min sum
        if(sum < minSum)
            minSum =  sum;
            correctE = E;
        end
    end
    EFinal = correctE;    
    
    %get camera center
    M2 = robustCameraRecovery(EFinal, p,q);
    lastCenter = cameraCenter2;
    [cameraCenter2,w] = computeCameraCenter(M2,p(1,:));
        
    %plot
    plot3(cameraCenter2(1), cameraCenter2(2), cameraCenter2(3), 's',  lastCenter(1), lastCenter(2), lastCenter(3), 's');
    %{
    for i=0:100
        plot3(cameraCenter2(1)+w(1)*i, cameraCenter2(2) + w(2)*i, cameraCenter2(3) + w(3)*i);
    end
    %}
    getframe(gcf);
    %update
    I1 = I2;
    n = n + 1;
    
end