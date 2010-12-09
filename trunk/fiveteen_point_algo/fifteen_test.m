%fifteen_point test case

addpath ../simulator ../paper1_impl

[p,q,K1,K2] = fifteen_point_data();
[EFinal, ERROR_RATIO] = fifteen_point(p,q,K1,K2)
