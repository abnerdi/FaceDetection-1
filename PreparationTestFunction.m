clc;
path = 'D:\FaceDetection\FaceTest\';

%files = dir(strcat(path, '*.jpg'));
dirs = dir(path);
nameFolds = {dirs(:).name};
nameFolds(ismember(nameFolds,{'.','..'})) = [];

for k=nameFolds
    fold = strcat(path, k{:}, '\');
    files = dir(strcat(fold, '*.jpg'));
    for i=1:length(files)
        [L, map] = imread(strcat(fold, files(i).name));
        [height, width] = size(L);

        imshow(L);

        rect = [];
        while 1
            rect(end+1,:) = getrect;
            rH = rectangle('Position',rect(end,:));
            set(rH,'edgecolor','b');

            [x, y, key] = ginput(1);
            
            if isempty(key)
                key = 0;
            end

            switch key
                case 32
                    out = strcat(fold, strrep(files(i).name, '.jpg', ''), '.txt');
                    fout = fopen(out, 'w+');
                    fwrite(fout, rect, 'int');
                    fclose(fout);
                    rect
                    break; % переход на след. картинку.
                case 8
                    delete(rH);
                    rect(end,:) = [];
                    continue; % удаление предыдущего квадрата.
                otherwise
                    continue; % переход на следующую итерацию.
            end
        end
    end
end

% fin = fopen('D:\FaceDetection\test\1.txt', 'r');
% ff = fread(fin);
% reshape(ff, [], 4);