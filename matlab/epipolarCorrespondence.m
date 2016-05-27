function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup

p1 = [x1; y1; 1];
epline = F*p1;
scale = norm(epline(1:2));
epline = epline/scale;
proj=round(cross(epline,[-epline(2) epline(1) epline(2)*x1-epline(1)*y1]'));  

window_size=8;
kernel_size = 2*window_size+1;
sigma = 5;
kernel = fspecial('gaussian', [kernel_size kernel_size], sigma);

im1_patch = double(im1((y1-window_size):(y1+window_size), (x1-window_size):(x1+window_size)));
best_error=1000;

for i=proj(1)-20:proj(1)+20
	for j=proj(2)-20:proj(2)+20 
        im2_patch = double(im2(j-window_size:j+window_size,i-window_size:i+window_size));
        current_error = norm(kernel .* (im1_patch - im2_patch));
        if current_error<best_error
            best_error=current_error;
            x2=i;
            y2=j;
        end   
	end
end

end

