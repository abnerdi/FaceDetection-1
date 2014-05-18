function size = slidingwindowfixed(width, height, endWidth, ...
    endHeight, minSize)
% Функция принимает размер окна и шаг прохода. Можно задать шаг
% масштвбирования. Возвращает матрицу координат скользящего окна.

if nargin < 5
    minSize = 20;
end

rate = 8;

size = zeros(1,4);

% Выбираем максимально большое окно, которое вместится в наше изображение.
if endWidth >= endHeight
    windowWidth = width;
    windowHeight = newresizewidth(endWidth, endHeight, windowWidth);
else
    windowHeight = height;
    windowWidth = newresizewidth(endWidth, endHeight, windowHeight);
end

while windowWidth > minSize
    adaStep = round((1/rate)*windowWidth);
    %adaStep
    adaScale = round((2/rate)*windowWidth);
    size = [size; filling(width, height, windowWidth, windowHeight, adaStep)];
    windowWidth = windowWidth - adaScale;
    windowHeight = newresizeheight(endWidth, endHeight, windowWidth);
end
size = size(2:end, :);
end

function newwidth = newresizewidth(width, height, newheight)
    newwidth = round((newheight * width) / height);
end

function newheight = newresizeheight(width, height, newwidth)
    newheight = round((newwidth * height) / width);
end

function res = filling(width, height, windowWidth, windowHeight, step)
    additional = 5;
    m = (width - windowWidth + additional)/step + 1;
    n = (height - windowHeight + additional)/step + 1;
    res = zeros(int32((m-1)*(n-1)), 4);
    k = 1;
    for i=1:m
        for j=1:n
            x0 = step*(i-1) + 1;
            y0 = step*(j-1) + 1;
            x1 = min(x0+windowWidth, width);
            y1 = min(y0+windowHeight, height);
            
            res(k,:) = [x0 y0 x1 y1];
            
            k = k + 1;
        end
    end
    
end