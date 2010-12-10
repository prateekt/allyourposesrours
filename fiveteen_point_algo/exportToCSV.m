function S = exportToCSV(exp_log)

S = zeros(30,3);
pt1 = exp_log{1};
pt2 = exp_log{2};
pt3 = exp_log{3};
for i=1:30
    S(i,1) = pt1{i};
    S(i,2) = pt2{i};
    S(i,3) = pt3{i};
end