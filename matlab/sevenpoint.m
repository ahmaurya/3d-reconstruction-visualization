function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup

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

% right singular vectors corresponding to two smallest singular values
v1 = V(:,9);
v2 = V(:,8);

% fundamental matrix from v
F1 = reshape(v1,3,3);
F2 = reshape(v2,3,3);

% solving for lambda such that F1 + lambda*F2 = 0
syms lambda;
lambdas = solve(det(F1 + lambda*F2) == 0);
lambdas = real(double(lambdas));

% rescaling factor
Tu = [1/M 0 0; 0 1/M 0; 0 0 1];

% calculate F for each real root, refine, and unnormalize it
for i = 1:numel(lambdas)
	F{i} = F1 + lambdas(i)*F2;
	%F{i} = refineF(F{i}, pts1, pts2);
	F{i} = Tu'*F{i}*Tu;
end

end

