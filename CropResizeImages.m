clc;
path = 'D:\imgmatlab\DB\stirling\';
pathsave = 'D:\imgmatlab\al21\';
files = dir(strcat(path, '*.gif'));

new_width = 92;
new_height = 112;

for i=1:length(files)
    [L, map] = imread(strcat(path, files(i).name));
    L = ind2gray(L, map);
    [height, width] = size(L);
    
%     windowWidth = width;
%     windowHeight = round((windowWidth * new_height) / new_width);
%     windowHeight = height;
%     windowWidth = round((windowHeight * new_width) / new_height);

    W = slidingwindowfixed(width, height, new_width, new_height, 11, 40, 200);
    size(W);
    i
    dist = Eigenface2(L, W, 150);

    [minDist, ind] = min(dist);
    
    I = L(W(ind,2):W(ind,4), W(ind,1):W(ind,3));

    I = imresize(I', [new_width new_height])';
    
    imwrite(I, strcat(pathsave, num2str(i), '.jpg'));
    
end