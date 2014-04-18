function face = Eigenface1(Image, k, teta, isShow, setNum)
% Image - изображение в оттенках серого.
% k - количество используемых главных компонент.
% teta - порог прин€ти€ лица [0-5].
% isShow - вывести полученое изображение.
%   0 - не выводить,
%   1 - выводить.
% setNum - номер файла с главными компонентами [1,2,3]. „ем больше значение,
% тем больше изображений в обучении.

if nargin < 5
    setNum = '';
end

if nargin < 4
    isShow = 0;
end

if nargin < 3
    teta = 2.5;
end

if nargin < 2
    k = 400;
end

% Recognition
setMat = strcat('EigenfacesSet', num2str(setNum), '.mat');
load(setMat);

I = Image(:);

F = double(I) - M;
w = zeros(1, k);
for j=1:k
  w(j) = u(:, j)'*F;
end
imshow(vec2img(M, 92, 112)*255);
Im = zeros(size(I));
Err = zeros(1, 1366);
for s=1:k
   Im = Im + u(:,s)*w(s);
   Err(s) = sqrt(sum((F-Im).^2));
   % јнимаци€.
%    imshow(vec2img(Im + M, 92, 112));
%    pause(0.001);
end
% plot(1:1366, Err);
% ¬ычисление расто€ни€ между полученным изображением и исходным.
dist = sqrt(F'*F - sum(w.^2))/1000;

face.isFace = dist <= teta;
face.dist = dist;

% ¬ывод изображени€ на экран.
if isShow
   figure;
   Im = Im + M;
   imshow([vec2img(I, 92, 112) vec2img(Im, 92, 112)]);
end

end