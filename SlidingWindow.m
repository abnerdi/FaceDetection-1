function size = slidingwindow(width, height, step, scaleStep)
% Функция принимает размер окна и шаг прохода. Можно задать шаг
% масштвбирования. Возвращает матрицу координат скользящего окна.

if nargin < 4
    scaleStep = 10;
end

if nargin < 3
    step = 10;
end

size = zeros(1,4);

windowWidth = width;
windowHeight = height;

while windowWidth > 20
    size = [size; filling(width, height, windowWidth, windowHeight, step)];
    if windowWidth == windowHeight
       windowWidth = windowWidth - scaleStep;
       windowHeight = windowHeight - scaleStep;
    else
        if windowWidth - windowHeight >= scaleStep
            windowWidth = windowWidth - scaleStep;
        end
        if windowHeight - windowWidth >= scaleStep
            windowHeight = windowHeight - scaleStep;
        end
        if abs(windowHeight - windowWidth) < scaleStep
            windowWidth = min(windowWidth, windowHeight);
            windowHeight = min(windowWidth, windowHeight);
        end
    end
end
size = size(2:end, :);
end

function res = filling(width, height, windowWidth, windowHeight, step)
    additional = step - 1;
    m = (width - windowWidth + additional)/step + 1;
    n = (height - windowHeight + additional)/step + 1;
    res = zeros(int32((m-1)*(n-1)), 4);
    k = 1;
    for i=1:m
        for j=1:n
            x0 = step*(i-1);
            y0 = step*(j-1);
            x1 = windowWidth+x0;
            y1 = windowHeight+y0;
            res(k,:) = [x0 y0 x1 y1];
            k = k + 1;
        end
    end
    
end