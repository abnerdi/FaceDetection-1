function size = slidingwindowfixed(width, height, endWidth, ...
    endHeight, step, scaleStep, minSize)
% ������� ��������� ������ ���� � ��� �������. ����� ������ ���
% ���������������. ���������� ������� ��������� ����������� ����.

if nargin < 7
    minSize = 20;
end

if nargin < 6
    scaleStep = 10;
end

if nargin < 5
    step = 10;
end

size = zeros(1,4);

% �������� ����������� ������� ����, ������� ��������� � ���� �����������.
if endWidth >= endHeight
    windowWidth = width;
    windowHeight = newresizewidth(endWidth, endHeight, windowWidth);
else
    windowHeight = height;
    windowWidth = newresizewidth(endWidth, endHeight, windowHeight);
end

while windowWidth > minSize
    size = [size; filling(width, height, windowWidth, windowHeight, step)];
    windowWidth = windowWidth - scaleStep;
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