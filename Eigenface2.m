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

PERCENT_SOBEL = 3.4;
PERCENT_SKIN = 50;

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
    k = 5;
end

if nargin < 2
    slideWindowSetting = [10 50 100];
end

width = 32;
height = 32;

if ndims(image) == 3
    image_gray = rgb2gray(image);
else
    image_gray = image;
end
image_gray = LBP(image_gray);

[imageHeight, imageWidth] = size(image_gray);

% Координаты скользщего окна.
window = slidingwindowfixed(imageWidth, imageHeight, width, height, ...
    slideWindowSetting(3));
length(window)


% Recognition
setMat = strcat('EigenfacesSetLBP', num2str(setNum), '.mat');
load(setMat);

II_sobel = integralImage(sobelGrade(image_gray));
if ndims(image) == 3
    II_skin = integralImage(skinDetection(image));
end
delnum = [];
rect = cat(2, window(:,1), window(:,2), window(:,3)-window(:,1), ...
    window(:,4)-window(:,2));

for i=1:size(window, 1)
    val_Sobel = (integralImage(II_sobel, rect(i,:))/...
        (rect(i,3)*rect(i,4)))*100;
    if ndims(image) == 3
        val_Skin = (integralImage(II_skin, rect(i,:))/...
            (rect(i,3)*rect(i,4)))*100;
    else
        val_Skin = PERCENT_SKIN;
    end
    if val_Sobel < PERCENT_SOBEL || val_Skin < PERCENT_SKIN
        delnum(end+1) = i;
    end
end
window(delnum, :) = [];
rect(delnum, :) = [];
length(window)

I = zeros(width*height, size(window, 1), 'uint8');

for i=1:size(window, 1)
    L = image_gray(window(i,2):window(i,4), window(i,1):window(i,3));
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
       figure;
       %pause(0.001);
       Im = Im + M;
       imshow([vec2img(I(:,i), width, height) vec2img(Im, width, height)]);
    end
end

face.isFace = dist <= teta;
face.dist = dist;
    
end