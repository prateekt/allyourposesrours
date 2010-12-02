% Setup script


load('templeSparseRing_data.mat');

[ P, K, R, t ] = extractKRt(data);

[ pointList ] = generatePoints( );

[ pts1, pts2 ] = projectPoints( pointList, P{1}, P{2} );