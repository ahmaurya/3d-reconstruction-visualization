% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       4. Save the correct M2, p1, p2, R and P to q2_5.mat

clear;
clc;

im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
load('../data/some_corresp.mat');
load('../data/intrinsics.mat');

M = max(size(im1));

% compute fundamental matrix from corresponding points
F = eightpoint(pts1, pts2, M);

% compute essential matrix from fundamental matrix and camera intrinsics
E = essentialMatrix(F, K1, K2);

% possible M2s
M2_ = camera2(E);

M1 = [eye(3), zeros(3,1)];

for i = 1:4
    P_ = triangulate(K1*M1, pts1, K2*M2_(:,:,i), pts2);
    if all(P_(:,3) > 0)
        P = P_;
        M2 = M2_(:,:,i);
    end
end

p1 = pts1;
p2 = pts2;

save('q2_5.mat', 'M2', 'p1', 'p2', 'P');
