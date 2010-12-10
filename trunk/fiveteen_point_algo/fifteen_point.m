function [EFinal, ERROR_RATIO] = fifteen_point(p,q,K1,K2)

%create different sets of points
a_i = zeros(5,3);
b_i = zeros(5,3);
for i=1:5
    a_i(i,:) = p(i,:);
    b_i(i,:) = q(i,:);
end
f_i = zeros(5,3);
g_i = zeros(5,3);
for i=5:10
    f_i(i-4,:) = p(i,:);
    g_i(i-4,:) = q(i,:);
end
h_i = zeros(5,3);
j_i = zeros(5,3);
for i=10:15
    h_i(i-9,:) = p(i,:);
    j_i(i-9,:) = q(i,:);
end

%using first five correspondences, do 5 point algorithm and generate EList
% Resulting E{i} from EList satisfies b_i' * E{i} * a_i
EList = five_point(a_i, b_i);

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
        p = f_i(j,:)';
        p_prime = g_i(j,:)';
        % I think you should use transpose of F here
        sum = sum + distToEL(p, F', p_prime);
    end
    
    fprintf('E number: %u  Error: %f\n', i, sum);
    
    %save min sum
    if(sum < minSum)
        minSum =  sum;
        correctE = E;
    end
end
EFinal = correctE;

%Use final correspondences to independently test quality of E.
% F = inv(K1)' * EFinal * inv(K2);
% Same here regarding the intrinsic matrices
F = EFinal;
ERROR_SUM = 0;
for j=1:5
    p = h_i(j,:)';
    p_prime = j_i(j,:)';
    % I think you should use transpose of F here
    ERROR_SUM = ERROR_SUM + distToEL(p, F', p_prime);
end

% The ERROR_RATIO gives misleading (possibility bad) results when ERROR_SUM
% is roughly equal to zero, which is the case in simulation.
% ERROR_RATIO  = abs(ERROR_SUM-minSum)/ ERROR_SUM;
ERROR_RATIO  = ERROR_SUM / 5;
fprintf('EFinal error: %f \n', ERROR_SUM);

end