function [ angle_deg ] = findAngleBetweenVectors( v1, v2 )
%findAngleBetweenVectors Finds the angle in degrees between two vectors
%   Detailed explanation goes here

% angle_deg = acosd( dot(v1, v2) / (norm(v1) * norm(v2)));
angle_deg = atan2(norm(cross(v1,v2)),dot(v1,v2)) * 180 / pi;

end

