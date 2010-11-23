function [f1_x, f1_y, f2_x, f2_y] =  getCandidateCorrespondences(img1, img2) 
% 
% [f1_x, f1_y, f2_x, f2_y] = ...
%       getCandidateCorrespondences(img1, img2, NumFeatures, WindowSize) 
%
% Finds features in img1 and img2 and tries to find the most likely 
% correspondence pairs based on the Sum of Absolute Differences (SAD)
% of the windows around each feature.  (Note that spatial proximity is 
% currently not considered.)  The coordinates of these corresponding
% features are returned in the four output arguments. Note that bidirectional
% matching is used.
%
% If the argmuments NumFeatures and WindowSize are omitted, they will
% default to 200 and 17, respectively.
%
% This function calls getInterestPoints.m (an implementation of the Harris
% Corner Detector) to find features.
%
% -----
% Andrew Stein & Ranjith Unnikrishnan
% Robotics Institute, Carnegie Mellon University, 2003
%

DEBUG = 0;

if(nargin==2)
    NumFeatures = 250;
    WindowSize = 17;
end

% Get features in both images
disp('Finding corner features in each image...');
[f1_x, f1_y] = getInterestPoints(img1, WindowSize, NumFeatures);
[f2_x, f2_y] = getInterestPoints(img2, WindowSize, NumFeatures);

if(mod(WindowSize,2)==0)
    disp(['Given WindowSize is Even, adjusting to be ' num2str(WindowSize+1) ' instead.']);
end

window_coords = -(WindowSize-1)/2:(WindowSize-1)/2;

[M,N] = size(img1);

% get windows around the features
disp('Getting windows around each feature...');

% Optional: Weight pixels towards the center
weights=fspecial('gaussian',[WindowSize WindowSize], floor(WindowSize./3));
weights=reshape(weights(:),[1 1 numel(weights)]);

% Get the coordinates in a generic window centered at zero.
% This will have the form:
%
%    (-2,-2)  (-1,-2)  (0,-2)  (1,-2)  (2,-2)
%    (-2,-1)  (-1,-1)  (0,-1)  (1,-1)  (2,-1)
%    (-2, 0)  (-1, 0)  (0, 0)  (1, 0)  (2, 0)
%    (-2, 1)  (-1, 1)  (0, 1)  (1, 1)  (2, 1)
%    (-2, 2)  (-1, 2)  (0, 2)  (1, 2)  (2, 2)
%    
[win_x,win_y] = meshgrid(window_coords);

% "unwrap" each coordinate into a column vector
win_x = win_x(:);
win_y = win_y(:);

% This basically returns indices into each of the images for the contents
% of a window centered around each of the features.  Each column in index1
% (or index2) is the list of indices for a window around one feature.  See
% the sub2ind help for more information.
index1 = sub2ind(size(img1), repmat(f1_y(:)', [length(win_y) 1])+repmat(win_y, [1 length(f1_y)]), ...
    repmat(f1_x(:)', [length(win_x) 1])+repmat(win_x, [1 length(f1_x)]) );
index2 = sub2ind(size(img2), repmat(f2_y(:)', [length(win_y) 1])+repmat(win_y, [1 length(f2_y)]), ...
    repmat(f2_x(:)', [length(win_x) 1])+repmat(win_x, [1 length(f2_x)]) );

% Pull out the data from the images that is contained in each window using
% the indices computed above.  Then rearrange those so the window contents
% for each feature lie along the 3rd dimension.  In other words,
% img1(index1) is a [WindowSize^2 x NumFeatures x 1] matrix.  Permute turns it
% into a [1 x NumFeatures x WindowSize^2] matrix (and similarly makes
% img2(index2) into a [NumFeatures x 1 x WindowSize^2] matrix).
F1 = permute(img1(index1), [3 2 1]);
F2 = permute(img2(index2), [2 3 1]);

% Optional weighting: (applies the gaussian weights along the third
% dimension, since that's where the window data is)
F1 = double(F1).*repmat(weights, [1 size(F1,2)]);
F2 = double(F2).*repmat(weights, [size(F2,1) 1]);

% The lines above vectorized this code (and they run about 3 times faster):
% for(i=1:NumFeatures)
%     % The max and min calls here protect against out-of-bounds errors:
%     F1(1,i,:) = reshape(img1(max(1,min(M,f1_y(i) + window_coords)), ...
%         max(1,min(N,f1_x(i)+window_coords))), [1,1,WindowSize^2]);
%     F2(i,1,:) = reshape(img2(max(1,min(M,f2_y(i) + window_coords)), ...
%         max(1,min(N,f2_x(i)+window_coords))), [1,1,WindowSize^2]);
% 
%     % Optional weighting
%     F1(1,i,:) = F1(1,i,:) .* weights;
%     F2(i,1,:) = F2(i,1,:) .* weights;
% end

% build the monster working matrices so that we can compare all possible
% correspondences
disp('Building working matrices...')
F1 = repmat(F1, [NumFeatures 1]);
F2 = repmat(F2, [1 NumFeatures]);

% Compute SAD for windows for all correspondence possibilities: (note that
% all the rearranging and permuting and repmat-ing, etc, above is so we can
% do this calculation in one step.)
disp('Computing SAD of all window combinations...');
feature_SAD = sum( abs(F1-F2), 3);

% Find the best match for each feature in img1:
disp('Finding best matches...')
[minSAD, matches_SAD] = min(feature_SAD);

% Find elements in matches_SAD that are highest in both row and column
% Best match in image2 from image1
[minMatch, index2]=min(feature_SAD);
% Best match in image1 from image2
[minMatch, index1]=min(feature_SAD');

to_keep1=find(index1(index2)==[1:NumFeatures]);
to_keep2=index2(to_keep1);

% Retaining feature pairs that match best in both directions
f2_x = f2_x(to_keep2);
f2_y = f2_y(to_keep2);
f1_x = f1_x(to_keep1);
f1_y = f1_y(to_keep1);

% OPTIONAL: throw out correspondences where the SAD is too high:
% selected = sub2ind(to_keep2,to_keep1,size(feature_SAD));
% minSAD = feature_SAD(selected);
% SAD_threshold = mean(minSAD);
% to_keep = find(minSAD < SAD_threshold);
% f2_x = f2_x(to_keep);
% f2_y = f2_y(to_keep);
% f1_x = f1_x(to_keep);
% f1_y = f1_y(to_keep);
% 
disp(['Number of features kept: ' num2str(length(f1_x))])

if(DEBUG)
    % Display the images with the corresponding features connected by lines
    figure(1)
    subplot(121), plot([f1_x(:) f2_x(:)]',[f1_y(:) f2_y(:)]', '-o');
    subplot(122), plot([f1_x(:) f2_x(:)]',[f1_y(:) f2_y(:)]', '-o');
    disp('Done.')
    
    % Displays the images with one corresponding pair of features' windows
    % highlighted with red boxes in the image (useful for checking to make
    % sure reasonable candidates are being returned).  Advance through the
    % pairs by left-clicking.  Stop by right-clicking.
    figure(2)
    i=1;
    subplot 221, imagesc(img1), axis image
    h1 = rectangle('Position', [0 0 1 1], 'EdgeColor', 'r');
    subplot 222, imagesc(img2), axis image
    h2 = rectangle('Position', [0 0 1 1], 'EdgeColor', 'r');
    colormap(gray)
    
    button = 1;
    while(button~=3 & i<=length(to_keep1))
        set(h1, 'Position', [f1_x(i)-WindowSize/2 f1_y(i)-WindowSize/2 WindowSize WindowSize]);
        set(h2, 'Position', [f2_x(i)-WindowSize/2 f2_y(i)-WindowSize/2 WindowSize WindowSize]);
        
        subplot 223, imagesc(img1(max(1,min(M,f1_y(i) + window_coords)), ...
            max(1,min(N,f1_x(i)+window_coords)))), axis image
        subplot 224, imagesc(img2(max(1,min(M,f2_y(i) + window_coords)), ...
            max(1,min(N,f2_x(i)+window_coords)))), axis image
        colormap(gray)
        
        xlabel(['SAD = ' num2str(minSAD(i))]);
        
        [temp1,temp2,button] = ginput(1);
        i=i+1;
    end
    
end
