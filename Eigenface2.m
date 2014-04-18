function face = Eigenface2(image, slideWindowSetting, k, teta, isShow, ...
    setNum)
% image - изображение в оттенках серого.
% slideWindowSetting - настройки для скользящего окна.
%   Пример: [10 50 100]
%   10 - шаг сдвига,
%   50 - шаг масштабирования,
%   100 - минимальная ширина.
% k - количество используемых главных компонент.
% teta - порог принятия лица [0-5].
% isShow - вывести полученое изображение.
%   0 - не выводить,
%   1 - выводить.
% setNum - номер файла с главными компонентами [1,2,3]. Чем больше значение,
% тем больше изображений в обучении.

if nargin < 6
    setNum = '';
end

if nargin < 5
    isShow = 0;
end

if nargin < 4
    teta = 2.5;
end

if nargin < 3
    k = 100;
end

if nargin < 2
    slideWindowSetting = [10 50 100];
end

width = 92;
height = 112;

[imageHeight, imageWidth] = size(image);

% Координаты скользщего окна.
window = slidingwindowfixed(imageWidth, imageHeight, width, height, ...
    slideWindowSetting(1), slideWindowSetting(2), slideWindowSetting(3));

% Recognition
setMat = strcat('EigenfacesSet', num2str(setNum), '.mat');
load(setMat);

I = zeros(width*height, size(window, 1), 'uint8');

for i=1:size(window, 1)
    L = image(window(i,2):window(i,4), window(i,1):window(i,3));
    L = imresize(L, [height width])';
    I(:,i) = L(:);
end

dist = zeros(1, size(window, 1));
for i=1:size(I,2)
    F = double(I(:,i)) - M;
    w = zeros(1, k);
    for j=1:k
      w(j) = u(:, j)'*F;
    end

    Im = zeros(size(I, 1), 1);
    for s=1:k
       Im = Im + u(:,s)*w(s);

       % Анимация.
    %    imshow(vec2img(Im + M, 92, 112));
    %    pause(0.01);
    end

    % Вычисление растояния между полученным изображением и исходным.
    dist(i) = sqrt(F'*F - sum(w.^2))/1000;

    % Вывод изображения на экран.
    if (isShow) && (dist(i) <= teta)
       %figure;
       pause(0.001);
       Im = Im + M;
       imshow([vec2img(I(:,i), width, height) vec2img(Im, width, height)]);
    end
end

face.isFace = dist <= teta;
face.dist = dist;
    
end