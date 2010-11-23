function [x,y,weights] = getInterestPoints(img, windowsize, numPoints, display_flag)
%
% [x,y,weights] = getInterestPoints(img, windowsize, numPoints, <display_flag>)
%
% Finds interest points in image 'img' using a Harris Corner Detector.
% 
% 'numPoints' is the desired maximum number of features.  Note that there is no
%   guarantee that 'numPoints' number of features will actually be returned,
%   so the calling function should check the actual number. (Default is 50)
%
% 'windowsize' is exactly that: the size of the windows used for the Harris
%    Detector (Default is 11)
%
% 'display_flag' is an optional argument (Default is 0).  If set to anything  
%   but zero, the image will be displayed with detected features overlaid.  
%   This will also be true if getInterestPoints is called with no output 
%   arguments, regardless of the setting of display_flag.
%
% Note that this function uses the 'imregionalmax' function in the image
% processing toolbox.
%
% -----
% Andrew Stein, Robotics Institute, Carnegie Mellon University, 2003
%

if(nargin==1)
    windowsize = 11;
    numPoints = 50;
end

if(nargin < 4)
    display_flag = 0;
end

% compute x and y derivatives
[Ix, Iy] = gradient(double(img));

W = gausswin(windowsize);

sumIx = imfilter(Ix.^2, W, 'symmetric');
sumIy = imfilter(Iy.^2, W, 'symmetric');
sumIxIy = imfilter(Ix.*Iy, W, 'symmetric');

% assemble all the covariance matrices:
C(1,1,:) = sumIx(:);
C(2,2,:) = sumIy(:);
C(1,2,:) = sumIxIy(:);
C(2,1,:) = sumIxIy(:);

K = 1/25;
T = C(1,1,:) + C(2,2,:);  % the traces of all the C matrices
D = C(1,1,:).*C(2,2,:) - C(2,1,:).*C(1,2,:); % determinants of all the C matrices

% use the Harris detector to compute interest point "strength" everywhere in the image:
p = D - K*T.^2;

% reshape back into an image
p = reshape(p, size(sumIx,1), size(sumIy, 2));

% Find the local maxima of the Harris detector output:
max_p = double(imregionalmax(p));

% blank out regions close to edge of image to avoid detecting features that
%  will likely disappear between consecutive images
mask=zeros(size(max_p));
mask(windowsize:(size(max_p,1)-windowsize),windowsize:(size(max_p,2)-windowsize))=1;
max_p = max_p .* mask;

% Get the coordinates and weights of those maxima
[y,x] = find(max_p);
weights = p(max_p==1);

% sort by weight
[features] = sortrows([x(:) y(:) weights(:)], 3);

% only keep the best numPoints of them:
x       = features(max(1,end-numPoints+1):end, 1);
y       = features(max(1,end-numPoints+1):end, 2);
weights = features(max(1,end-numPoints+1):end, 3);

% Display if no output arguments given, or if display_flag set
if(nargout==0 | display_flag)
    imagesc(img), hold on, plot(x,y, 'gx', 'LineWidth', 2, 'MarkerSize', 8); hold off
    axis image, colormap(gray)
end

return;

