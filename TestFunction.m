clc;
path = 'D:\FaceDetection\FaceTest\';

%files = dir(strcat(path, '*.jpg'));
dirs = dir(path);
nameFolds = {dirs(:).name};
nameFolds(ismember(nameFolds,{'.','..'})) = [];

for k=nameFolds
    fold = strcat(path, k{:}, '\');
    ifiles = dir(strcat(fold, '*.jpg'));
    rfiles = dir(strcat(fold, '*.txt'));
    for i=1:length(ifiles)
        [L, map] = imread(strcat(fold, ifiles(i).name));
        [height, width] = size(L);

        %imshow(L);
        
        rect = [];
        
        if length(rfiles) ~= 0
            fin = fopen(strcat(fold, rfiles(i).name), 'r');
            rect = fread(fin, 'int');
            rect = reshape(rect, [], 4)
            fclose(fin);
        end
    end
end