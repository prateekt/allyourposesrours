function [ E ] = calcBestE( Evec, p, q )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% q' * E * p = 0


%% Find the best E
numEs = size(Evec,2);
avg_dist = inf * ones(numEs,1);

for m=1:numEs
    E = reshape(Evec(:,m),3,3);
    avg_dist(m) = findAvgEpipolarDist(q', E, p');
end

[min_avg_dist, min_index] = min(avg_dist);

 if( length(Evec(:,min_index)) == 9)
     E = reshape(Evec(:,min_index), 3, 3);
 else
     E = eye(3);
 end


end

