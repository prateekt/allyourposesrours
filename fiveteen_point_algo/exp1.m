function readings = exp1()

%generate fixed R,T and other variables
[fixedR, fixedT, varR, varT] = getRT();
K1 = eye(3,3);
K2 = eye(3,3);

%generate perfect points
R1 = eye(3,3);
t1 = [0 0 0];
hold on;
for i=1:size(fixedR,2)
    R2 = varR{i};
    t2 = varT{i};
    sum=0;
    for j=1:30
        [p,q,K1,K2] = fifteen_point_data2(R1,t1, K1, R2, t2, K2);
        [E_ground_truth, E_noise, E_ERROR] = noiseSim(p,q,K1,K2);   
        sum = sum + E_ERROR;
        cReadings{j} = E_ERROR;
    end
    readings{i} = cReadings;
    sum = sum / 30;
    plot(i,sum,'s');
    getframe(gcf);
end

hold off;


