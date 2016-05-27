function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas
%

[n1,~] = size(p1);
[n2,~] = size(p2);

p1 = [p1'; ones(1,n1)];
p2 = [p2'; ones(1,n2)];

P = zeros(4,n1);

for i=1:n1
	x = [0 p1(3,i) -p1(2,i); -p1(3,i) 0 p1(1,i); p1(2,i) -p1(1,i) 0];
	y = [0 p2(3,i) -p2(2,i); -p2(3,i) 0 p2(1,i); p2(2,i) -p2(1,i) 0];

	Q = [x*M1; y*M2];
	[~,~,V] = svd(Q);
	z = V(:,end);
	P(:,i) = z/z(4);
end

p1_hat = M1*P;
p2_hat = M2*P;

P = P(1:3,:)';

error = (p1-p1_hat).^2 + (p2-p2_hat).^2;

end

