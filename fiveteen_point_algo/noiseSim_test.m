%noise sim test
[p,q,K1,K2] = fifteen_point_data();
[E_ground_truth, E_noise, E_ERROR] = noiseSim(p,q,K1,K2)
