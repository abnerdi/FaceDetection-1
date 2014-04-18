function face = Eigenface1(Image, k, teta, isShow, setNum)
% Image - ����������� � �������� ������.
% k - ���������� ������������ ������� ���������.
% teta - ����� �������� ���� [0-5].
% isShow - ������� ��������� �����������.
%   0 - �� ��������,
%   1 - ��������.
% setNum - ����� ����� � �������� ������������ [1,2,3]. ��� ������ ��������,
% ��� ������ ����������� � ��������.

if nargin < 5
    setNum = '';
end

if nargin < 4
    isShow = 0;
end

if nargin < 3
    teta = 2.5;
end

if nargin < 2
    k = 400;
end

% Recognition
setMat = strcat('EigenfacesSet', num2str(setNum), '.mat');
load(setMat);

I = Image(:);

F = double(I) - M;
w = zeros(1, k);
for j=1:k
  w(j) = u(:, j)'*F;
end
imshow(vec2img(M, 92, 112)*255);
Im = zeros(size(I));
Err = zeros(1, 1366);
for s=1:k
   Im = Im + u(:,s)*w(s);
   Err(s) = sqrt(sum((F-Im).^2));
   % ��������.
%    imshow(vec2img(Im + M, 92, 112));
%    pause(0.001);
end
% plot(1:1366, Err);
% ���������� ��������� ����� ���������� ������������ � ��������.
dist = sqrt(F'*F - sum(w.^2))/1000;

face.isFace = dist <= teta;
face.dist = dist;

% ����� ����������� �� �����.
if isShow
   figure;
   Im = Im + M;
   imshow([vec2img(I, 92, 112) vec2img(Im, 92, 112)]);
end

end