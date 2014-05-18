clc;

%% Read Data
path = 'D:\FaceDetection\DB\orl_faces\s';
path2 = 'D:\FaceDetection\al\';
files = dir(strcat(path2, '*.jpg'));
path3 = 'D:\FaceDetection\al2\';
files3 = dir(strcat(path3, '*.jpg'));
faceNums = [1:40];
varNums = [1:10];

%load('ORL_32x32.mat')

width = 32;
height = 32;

%G = zeros(width*height,size(faceNums,2)*size(varNums, 2), 'uint8');
G = zeros(width*height, size(fea,1), 'uint8');
i = 1;

for i=1:size(fea, 1)
    L = LBP(reshape(fea(i, :),[width height])).';
    G(:, i) = L(:);
end

% for directory=faceNums
%     for img=varNums
%         L = imread(strcat(path, num2str(directory), '\', num2str(img), '.pgm')).';
%         G(:,i) = L(:);
%         i = i + 1;
%     end
% end


% for i=1:length(files)
%     L = imread(strcat(path2, files(i).name))';
%     G(:, 400 + i) = L(:);
% end

% for i=1:length(files3)
%     L = imread(strcat(path3, files3(i).name))';
%     G(:, 400 + length(files) + i) = L(:);
% end


%% Average image
M = mean(G, 2);

%% Normalize
A = zeros(size(G));

for i=1:size(G,2)
    A(:, i) = double(G(:, i)) - M;
end

%% Eigenfaces
C = A'*A;
[v, eigval] = eig(C);
u = zeros(size(A,1), size(v,1));

v = fliplr(v);

for i=1:size(v,1)
   u(:, i) = A*v(:,i);
   u(:, i) = u(:, i)/norm(u(:, i));
end

%% Save
save('EigenfacesSetLBP.mat', 'M', 'u');