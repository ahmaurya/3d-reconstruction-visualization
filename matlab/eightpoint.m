function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup

pts1_ = pts1 ./ M;
pts2_ = pts2 ./ M;
[m,~] = size(pts1);

X1 = pts1_(:, 1);
Y1 = pts1_(:, 2);
X2 = pts2_(:, 1);
Y2 = pts2_(:, 2);

% constructing U as described in class slides
U = [X1.*X2, X1.*Y2, X1, Y1.*X2, Y1.*Y2, Y1, X2, Y2, ones(m,1)];

% SVD to get fundamental matrix
[~,~,V] = svd(U);

% right singular vector corresponding to smaleest singular value
v = V(:,9);

% fundamental matrix from v
F = reshape(v,3,3);

% svd F to constrain sigma3 = 0
[U,S,V] = svd(F);
S(3,3) = 0;
F = U*S*V';

%refine F
%F = refineF(F, pts1, pts2);

%rescale to unnormalize F
Tu = [1/M 0 0; 0 1/M 0; 0 0 1];
F = Tu'*F*Tu;

end

