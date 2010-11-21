function ARow = computeARow(constraint)
syms x;
syms y;
syms z;

%compute the ordering of coefficients that we want coeffs function to give
%ideally give us (though it will the coefficients in the order that its designed to give us).
NORM = x^3 + 2*y^3 + 3*x^2*y + 4*x*y^2 + 5*x^2*z + 6*x^2 + 7*y^2*z + 8*y^2 + 9*x*y*z + 10*x*y + 11*x*z^2 + 12*x*z + 13*x + 14*y*z^2 + 15*y*z + 16*y + 17*z^3 + 18*z^2 + 19*z + 20;
NORM_coeffs = double(coeffs(NORM));

%use coeffs to give us its ordering
ARowCoeff = coeffs(constraint);

%reorder the coefficients in the ordering we want
ARow = zeros(20,1);
for i=1:20
    ARow(NORM_coeffs(i)) = ARowCoeff(i);
end
