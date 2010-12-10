function errors = exp2()

%Perfect 	 points with wide variety of R,t

%generate variety of R,T and other variables
[fixedR, fixedT, varR, varT] = getRT();
K1 = eye(3,3);
K2 = eye(3,3);

%generate perfect points
R1 = eye(3,3);
t1 = [0 0 0];
hold on;
for i=1:size(varR,2)
    i

    if(i==4 || i==5 || i==7 || i==8 || i==15 || i==34 || i==37 || i==38)
        errors{i} = inf;
        continue;
    end
    R2 = varR{i};
    t2 = varT{i};
    R2
    t2
    [p,q,K1,K2] = fifteen_point_data2(R1,t1, K1, R2, t2, K2);
    [EFinal, ERROR_RATIO] = fifteen_point(p,q,K1,K2);
    errors{i} = ERROR_RATIO;
    plot(i,ERROR_RATIO,'s');
    getframe(gcf);
end

hold off;
    
