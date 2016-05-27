clear;
clc;

im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
load('../data/some_corresp.mat');
load('../data/intrinsics.mat');
load('../data/templeCoords.mat');

M = max(size(im1));
F = eightpoint(pts1, pts2, M);
E = essentialMatrix(F, K1, K2);

[n,~] = size(x1);
x2 = zeros(n, 1);
y2 = zeros(n, 1);

for i = 1:n
    [x, y] = epipolarCorrespondence(im1, im2, F, x1(i), y1(i));
    x2(i) = x;
    y2(i) = y;
end

M2_ = camera2(E);

M1 = [eye(3), zeros(3,1)];

point1 = [x1,y1];
point2 = [x2,y2];

for i = 1:4
    P_ = triangulate(K1*M1, point1, K2*M2_(:,:,i), point2);
    if all(P_(:,3) > 0)
        P = P_;
        M2 = M2_(:,:,i);
    end
end

M1 = K1*M1;
M2 = K2*M2;
save('q2_7.mat', 'M1', 'M2', 'F');

scatter3(P(:,1),P(:,2),P(:,3));

%pcshow(P(:,1),P(:,2),P(:,3));