I = imread('images/horse0.png') ;

image(I);
colormap gray ;
axis equal ; axis off ; axis tight ;

%%
I = single(rgb2gray(I)) ;

clf ;
imagesc(I);
axis equal ; axis off ; axis tight ;


%%
%% Посмотрите, как различные параметры влияют на количество и
%% расположение интересных точек
PeakThreshold = 15;
EdgeThreshold = 10;
NormThreshold = 0.1;
GaussSize = 2;
[f, d] = vl_sift(I, 'PeakThresh', PeakThreshold, 'EdgeThresh', EdgeThreshold, 'NormThresh', NormThreshold, 'WindowSize', GaussSize);


hold on ;
perm = randperm(size(f,2));
sz = size(perm); 
xx = min(100, sz(2));
sel  = perm(1:xx) ;

h1  = vl_plotframe(f(:,sel));
set(h1,'color','y','linewidth',2);

%%
% delete(h1);
% 
% h2 = vl_plotsiftdescriptor(d(:,sel),f(:,sel));
% set(h2,'color','g','linewidth',1);
% 
% h1   = vl_plotframe(f(:,sel));
% set(h1,'color','y','linewidth',2);
% 
% 


%%
