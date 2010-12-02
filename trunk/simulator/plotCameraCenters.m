WC = [0, 0, 0]';

numPos = length(R);

cameraCenters = zeros(3,numPos);

for i = 1:numPos
    cameraCenters(:,i) = R{i} \ (WC - t{i});
end


figure, plot3(cameraCenters(1,:), cameraCenters(2,:), cameraCenters(3,:), 'x');

    