function [ P, K, R, t ] = extractKRt(data)

numPos = size(data,1);

K = cell(numPos, 1);
R = cell(numPos, 1);
t = cell(numPos, 1);
P = cell(numPos, 1);

for i = 1:numPos
    
    % K and R are transposed because the reshape function places elements
    % into the new matrix column-wise but the original data is stored
    % row-wise.
    K{i} = reshape(data(i,1:9),3,3)';
    R{i} = reshape(data(i,10:18),3,3)';
    t{i} = reshape(data(i,19:21),3,1);
    
    P{i}  = K{i} * [ R{i} t{i}];
    
    
end


end