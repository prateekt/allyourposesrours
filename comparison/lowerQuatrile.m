[c5, c7] = exp_NisterImplementationWithNoise;

for i = 1:length(c5)
    y = sort(cell2mat(c5{1,i}));
    c5noise(i,1) = median(y(find(y<median(y))));
end

for i = 1:length(c7)
    y = sort(cell2mat(c7{1,i}));
    c7noise(i,1) = median(y(find(y<median(y))));
end

figure();
hold on;
plot(c5noise,'s');
plot(c7noise,'x');
title('Noise: lower quatrile');