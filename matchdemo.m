I0 = imread('images/cporta0.png') ;
I1 = imread('images/cporta1.png') ;


%%
Ia = single(rgb2gray(I0)) ;
Ib = single(rgb2gray(I1)) ;


%%
[fa,da] = vl_sift(Ia, 'PeakThresh', 0, 'EdgeThresh', 30) ;
[fb,db] = vl_sift(Ib, 'PeakThresh', 0, 'EdgeThresh', 30) ;

%% ѕосмотрите, как значение порога вли€ет на количество возвращаемых
%% совпадений
Threshold = 10;
[matchesi, scores] = vl_ubcmatch(da, db, Threshold) ;

%%
%–аспечатать сопоставлени€
[drop, perm] = sort(scores, 'descend') ;
matchesi = matchesi(:, perm) ;
length(matchesi)
matches = matchesi(:,1:end);
scores  = scores(perm) ;

figure(1) ; clf ;
imagesc(cat(2, I0, I1)) ;
fprintf( 2, 'Press any key to continue...\n\n' );
pause;
xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(I0,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 2, 'color', 'b') ;
fprintf( 2, 'Press any key to continue...\n\n' );
pause;
vl_plotframe(fa(:,matches(1,:))) ;
fprintf( 2, 'Press any key to continue...\n\n' );
pause;
fb(1,:) = fb(1,:) + size(I0,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
fprintf( 2, 'Press any key to continue...\n\n' );
pause;
axis equal ;
axis off  ;

% %%
% %сохранить в файл совпадени€
% 
% xa = fa(1,matchesi(1,:)) ;
% xb = fb(1,matchesi(2,:));
% ya = fa(2,matchesi(1,:)) ;
% yb = fb(2,matchesi(2,:)) ;
% 
% hold on ;
% x.ml = [xa;ya];
% x.mr = [xb;yb];
% 
% save('data/horse_pairs.mat', '-struct' , 'x');