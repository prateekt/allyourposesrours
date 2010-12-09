function D =  distToEL(p, F, p_prime)

%compute FP'
FP_prime = F*p_prime;

%compute top
top = p'*FP_prime;

%compute bottom
bottom = sqrt( (FP_prime(1))^2 + (FP_prime(2))^2 );

D = abs(top / bottom);
