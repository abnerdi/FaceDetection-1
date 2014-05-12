clc;
x = 0:0.1:100;
y = x;

sig1 = 19.28;
sig2 = 8.55;
sig12 = -5.45;
m1 = 42.91;
m2 = 32.28;

% sig1 = 0.5;
% sig2 = 0.5;
% sig12 = 0;
% m1 = 0;
% m2 = 0;

f = @(x,y)(exp(-(((x - m1)^2)/(2*sig1) + ((y-m2)^2)/(2*sig2))));
%f = @(xs,ys)(exp(-(sig1*(xs-m1)^2 + 2*sig12*(xs-m1)*(ys-m2) + sig2*(ys-m2)^2)));
%f = @(x,y)((sig1*(x-m1)^2 + 2*sig12*(x-m1)*(y-m2) + sig2*(y-m2)^2 + 1));



z = zeros(length(x));

for i=1:length(x)
    for j = 1:length(y)
        z(i,j) = f(x(i), y(j));
    end
end
pcolor(x,y,z);
shading interp;
colormap(gray);

% 
% [L, map] = imread('D:\Windows Documents\Documents\Диплом\6.jpg');
% LG = rgb2gray(L);
% LB = edge(LG, 'sobel');
% 
% [n, m, s] = size(L);
% 
% imshow(LB);
% 
% rect = slidingwindowfixed(m, n, 92, 112, 50);
% size(rect, 1)
% 
% r = [rect(:,1) rect(:,2) rect(:,3)-rect(:,1) rect(:,4)-rect(:,2)];
% 
% II = integralImage(LB);



% clc;
% 
% 
% [L, map] = imread('5.jpg');
% LG = rgb2gray(L);
% LB = edge(LG, 'sobel');
% 
% [n, m, s] = size(L);
% 
% imshow(LB);
% 
% rect = slidingwindowfixed(m, n, 92, 112, 50);
% size(rect, 1)
% 
% r = [rect(:,1) rect(:,2) rect(:,3)-rect(:,1) rect(:,4)-rect(:,2)];
% 
% II = integralImage(LB);
% 
% hold on;
% k = 0;
% for i=1:size(rect, 1)
%     if ValueGrade(r(i,3)*r(i,4), integralImage(II, rect(i,:)), 10304) > 300
%         k = k + 1;
%         %imshow(LB);
%         rH = rectangle('Position',r(i,:));
%         set(rH,'edgecolor','b')
%         %pause(0.001);
%     end
% end
% 
% k
% 
% % 
% % L = rgb2gray(imread('2.jpg'));
% % L = L(1:500, 1:300);
% % tic
% % LB = edge(L, 'sobel', (graythresh(L)*.1));
% % toc
% % LI = integralImage(LB);
% % LI = LI(end, end);
% % 
% % sizeL = size(L,1)*size(L,2);
% % 
% % x = 0.05;
% % s = 0.95;
% % 
% % res = LI;
% % resx = sizeL;
% % 
% % while s>x
% %    L1 = imresize(LB, s);
% %    L1I = integralImage(L1);
% %    L1I = L1I(end, end);
% %    res(end+1) = L1I;
% %    resx(end+1) = (size(L1,1)*size(L1,2));
% %    s = s-x;
% % end
% % 
% % plot(resx, res);
% % hold on;
% % 
% % ff = zeros(size(resx));
% % for i=1:length(resx)
% %     ff(i) = ValueGrade(resx(1), res(1), resx(i));
% % end
% % 
% % plot(resx, ff);
