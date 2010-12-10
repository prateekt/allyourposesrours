function [E_ground_truth, E_noise, E_ERROR] = noiseSim(p,q,K1,K2)

%{
%infer ground truth E from p and q
E_ground_truth = fifteen_point(p,q,K1,K2);
%}
E_ground_truth = 1;

%perturb points a bit with gaussian noise
p_disturbed = zeros(15,3);
q_disturbed = zeros(15,3);
for i=1:15
    p_disturbed(i,:) = [(p(i,1) + randn(1,1)), (p(i,2) + randn(1,1)), 1];
    q_disturbed(i,:) = [(q(i,1) + randn(1,1)), (q(i,2) + randn(1,1)), 1];
end

%infer E with noise
[E_noise, E_ERROR] = fifteen_point(p_disturbed, q_disturbed, K1, K2);
E_ERROR

%squared error between ground truth E and E with noise
% E_ERROR=0;
% for i=1:3
%     for j=1:3
%         E_ERROR = E_ERROR + abs(E_ground_truth(i,j)-E_noise(i,j));
%     end
% end