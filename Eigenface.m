function dist = Eigenface1(Image, k, isShow)
% Image - изображение в оттенках серого.
% k - количество используемых главных компонент.
% isShow - вывести полученое изображение.
%   0 - не выводить,
%   1 - выводить.

if nargin < 3
    isShow = 0;
end

if nargin < 2
    k = 100;
end

% Recognition
load('EigenfacesSet.mat');

I = Image(:);

F = double(I) - M;
w = zeros(1, k);
for j=1:k
  w(j) = u(:, j)'*F;
end

Im = zeros(size(I));
for s=1:k
   Im = Im + u(:,s)*w(s);
   
   % јнимаци€.
%    imshow(vec2img(Im + M, 92, 112));
%    pause(0.01);
end

% ¬ычисление расто€ни€ между полученным изображением и исходным.
dist = sqrt(F'*F - sum(w.^2));

% ¬ывод изображени€ на экран.
if isShow
   figure;
   Im = Im + M;
   imshow([vec2img(I, 92, 112) vec2img(Im, 92, 112)]);
end

end