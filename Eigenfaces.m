clc;
clear;

%% Recognition
path = 'D:\imgmatlab\DB\orl_faces\s';
load('EigenfacesSet.mat');

k=100;

faceNums = [1];%[1 10 20 3 9 16 24 31 39 34];
varNums = [1];

I = zeros(10304,size(faceNums,2)*size(varNums, 2), 'uint8');
i = 1;

for dir=faceNums
    for img=varNums
        L = imread(strcat(path, num2str(dir), '\', num2str(img), '.pgm')).';
        L = rgb2gray(imread('det.jpg'));
        L = L';
        I(:,i) = L(:);
        i = i + 1;
    end
end

for i=1:size(I,2)
   F = double(I(:,i)) - M;
   w = zeros(1, k);
   for j=1:k
      w(j) = u(:, j)'*F;
   end
   
   Im = zeros(10304,1);
   for s=1:k
       Im = Im + u(:,s)*w(s);
   end
   
   % Distance
   
   e = F'*F - sum(w.^2)
   
   % Show image
   figure;
   Im = Im + M;
   imshow([vec2img(I(:,i), 92, 112) vec2img(Im, 92, 112)]);
end