function  [Xnd , fxnd , pd_current]     = generate_nd_features(options)
%
%
%  Generate new positive features considered as non-detection for the
%  current trained model
%
%  Usage
%  ------
%
%  [Xnd , fxnd , pd_current]     = generate_nd_features(options)
%
%  Inputs
%  -------
%  options          Options struture
%
%                   positives_path   Path from positives images are loaded for generating positives examples
%                   posext           Positives extension files
%                   Nposboost        Number of desired positives examples for training set (Npostrain+Npostest <= Npostotal)
%                   seed             Seed value for random generator in order to generate the same positive/negative sets
%                   resetseed        Reset generator with given seed (default resetseed = 1)  
%                   standardize      Standardize images (default standardize = 1)
%                   preview          Preview current example (default preview = 0)
%                   posresize        Resize positive images to dimsItraining size
%                   probaflipIpos    Probability to flip Positive examples (default probaflipIpos = 0.5)
%                   probarotIpos     Probability to rotate Positives examples with an angle~N(m_angle,sigma_angle) (default probarotIpos = 0.01)
%                   m_angle          Mean rotation angle value in degree (default mangle = 0)
%                   sigma_angle      variance of the rotation angle value (default sigma_angle = 5^2)
%                   posscalemin      Minimum scaling factor to apply on positives patch subwindows (default scalemin = 0.25)
%                   posscalemax      Maximum scaling factor to apply on positives patch subwindows (default scalemax = 2)
%                   negscalemin      Minimum scaling factor to apply on negatives patch subwindows (default scalemin = 1)
%                   negscalemax      Maximum scaling factor to apply on negatives patch subwindows (default scalemax = 5)
%                   dimsItraining    Positive size for training (default dimsItraining = [24,24])
%                   featype          Type of features (featype: 0 <=> Haar, 1 <=> MBLBP, 3 <=> Histogram of MBLBP)
%  Outputs
%  -------
%
%  Xnd              features associated with False alarms for current model (d x Nnegboost)
%  fxnd             Output predicted values of the false alarms (1 x Nnegboost)
%  pd_current       Probability of non-detections
%
%
%  Author : Sébastien PARIS : sebastien.paris@lsis.org
%  -------  Date : 02/25/2011
%
%
% close all
% options.positives_path     = fullfile(pwd , 'images' , 'train' , 'positives');
% options.posext             = {'png'};
% options.preview            = 0;
% options.Nposboost          = 50;
% options.seed               = 5489;
% options.probaflipIpos      = 0.5;
% options.probarotIpos       = 0.05;
% options.m_angle            = 0;
% options.sigma_angle        = 5^2;
% options.posscalemin        = 0.25;
% options.posscalemax        = 1.75;
% options.negscalemin        = 0.7;
% options.negscalemax        = 3;
% options.typefeat           = 3;
% options.spyr               = [1 , 1 , 1 , 1 ; 1/4 , 1/4 , 1/4 , 1/4];
% options.scale              = [1];
% options.maptable           = 0;
% options.useFF              = 0;
% options.cs_opt             = 1;
% options.improvedLBP        = 0;
% options.rmextremebins      = 1;
% options.color              = 0;
% options.norm               = 4;
% options.clamp              = 0.2;
% options.s                  = 2;
% options.B                  = 1;
% options.c                  = 5;
%
% [Xtrain , ytrain , Xtest , ytest]     = generate_face_features(options);
% indp                                  = find(ytest == 1);
% indn                                  = find(ytest ==-1);
% wpos                                  = options.Nnegtrain/options.Npostrain;
% options.model                         = train_dense(ytrain' , Xtrain , sprintf('-s %d -B %d -c %d' , options.s , options.B , options.c) , 'col');
%% options.model                         = train_dense(ytrain' , Xtrain , sprintf('-s %d -B %d -c %d -w1 %f' , options.s , options.B , options.c , wpos) , 'col');
% fxtest                                = options.model.w(1:end-1)*Xtest + options.model.w(end);
% if(options.model.Label(1)==-1)
%     fxtest                            = -fxtest;
% end
% ytest_est                             = sign(fxtest);
% accuracy                              = sum(ytest_est == ytest)/length(ytest);
% tp                                    = sum(ytest_est(indp) == ytest(indp))/length(indp);
% fp                                    = 1 - sum(ytest_est(indn) == ytest(indn))/length(indn);
% perf                                  = sum(ytest_est == ytest)/length(ytest);
%
% if(options.model.Label(1) == 1)
%     [tpp , fpp]                       = basicroc(ytest , fxtest);
% else
%     [tpp , fpp]                       = basicroc(ytest , fxtest);
% end
%
% auc_est                               = auroc(tpp', fpp');
%
% figure(1)
% plot(fpp , tpp  , 'b', 'linewidth' , 2)
% grid on
% title(sprintf('Accuracy = %4.3f, AUC = %4.3f' , accuracy , auc_est))
% axis([-0.02 , 1.02 , -0.02 , 1.02])
%
% figure(2)
% plot(options.model.w)
%
% w = options.model.w;
% save modelw8 w
%


if(nargin < 1)
    options.positives_path     = fullfile(pwd , 'images' , 'train' , 'positives');
    options.posext             = {'png'};
    options.Nposboost          = 50;
    options.seed               = 5489;
    options.resetseed          = 1;
    options.preview            = 0;
    options.standardize        = 1;
    options.posresize          = 0;
    options.probaflipIpos      = 0.5;
    options.probarotIpos       = 0.05;
    options.m_angle            = 0;
    options.sigma_angle        = 7^2;
    options.posscalemin        = 0.25;
    options.posscalemax        = 1.75;
    options.negscalemin        = 0.7;
    options.negscalemax        = 3;
    options.typefeat           = 3;
    
    options.addbias            = 1;
    options.num_threads        = -1;
    options.spyr               = [1 , 1 , 1 , 1 ; 1/4 , 1/4 , 1/4 , 1/4];
    options.scale              = [1];
    options.maptable           = 0;
    options.useFF              = 0;
    options.cs_opt             = 1;
    options.improvedLBP        = 0;
    options.rmextremebins      = 0;
    options.color              = 0;
    options.norm               = 2;
    options.clamp              = 0.2;
    options.n                  = 0;
    options.L                  = 1.2;
    options.kerneltype         = 0;
    options.numsubdiv          = 8;
    options.minexponent        = -20;
    options.maxexponent        = 8;
    
    options.dimsItraining      = [24 , 24];
    options.rect_param         = [1 1 2 2;1 1 2 2;2 2 1 1;2 2 2 2;1 2 1 2;0 0 0 1;0 1 0 0;1 1 1 1;1 1 1 1;1 -1 -1 1];
    options.usesingle          = 1;
    options.transpose          = 0;
   
    
end


if(~any(strcmp(fieldnames(options) , 'positives_path')))
    options.positives_path     = fullfile(pwd , 'images' , 'train' , 'positives');
end
if(~any(strcmp(fieldnames(options) , 'posext')))
    options.posext             = {'png'};
end
if(~any(strcmp(fieldnames(options) , 'Nposboost')))
    options.Nposboost          = 50;
end
if(~any(strcmp(fieldnames(options) , 'typefeat')))
    options.typefeat           = 3;
end
if(~any(strcmp(fieldnames(options) , 'addbias')))
    options.addbias            = 1;
end
if(~any(strcmp(fieldnames(options) , 'seed')))
    options.seed                = 5489;
end
if(~any(strcmp(fieldnames(options) , 'resetseed')))
    options.resetseed            = 1;
end
if(~any(strcmp(fieldnames(options) , 'preview')))
    options.preview             = 0;
end
if(~any(strcmp(fieldnames(options) , 'standardize')))
    options.standardize         = 1;
end
if(~any(strcmp(fieldnames(options) , 'posresize')))
    options.posresize           = 0;
end
if(~any(strcmp(fieldnames(options) , 'probaflipIpos')))
    options.probaflipIpos      = 0.5;
end
if(~any(strcmp(fieldnames(options) , 'probarotIpos')))
    options.probarotIpos       = 0.05;
end
if(~any(strcmp(fieldnames(options) , 'm_angle')))
    options.m_angle            = 0.0;
end
if(~any(strcmp(fieldnames(options) , 'sigma_angle')))
    options.sigma_angle        = 5^2;
end

if(~any(strcmp(fieldnames(options) , 'typefeat')))
    options.typefeat            = 3;
end
if(~any(strcmp(fieldnames(options) , 'n')))
    options.n                  = 0;
end
if(~any(strcmp(fieldnames(options) , 'L')))
    options.L                  = 0.7;
end
if(~any(strcmp(fieldnames(options) , 'kerneltype')))
    options.kerneltype         = 0;
end
if(~any(strcmp(fieldnames(options) , 'numsubdiv')))
    options.numsubdiv          = 8;
end
if(~any(strcmp(fieldnames(options) , 'minexponent')))
    options.numsubdiv          = -20;
end
if(~any(strcmp(fieldnames(options) , 'maxexponent')))
    options.maxexponent        = 8;
end
if(~any(strcmp(fieldnames(options) , 'num_threads')))
    options.num_threads        = -1;
end
if(~any(strcmp(fieldnames(options) , 'spyr')))
    options.spyr                = [1 , 1 , 1 , 1 ; 1/4 , 1/4 , 1/4 , 1/4];
end
if(~any(strcmp(fieldnames(options) , 'scale')))
    options.scale                = 1;
end
if(~any(strcmp(fieldnames(options) , 'maptable')))
    options.maptable             = 0;
end
if(~any(strcmp(fieldnames(options) , 'useFF')))
    options.useFF                = 0;
end
if(~any(strcmp(fieldnames(options) , 'cs_opt')))
    options.cs_opt               = 1;
end
if(~any(strcmp(fieldnames(options) , 'improvedLBP')))
    options.improvedLBP          = 0;
end
if(~any(strcmp(fieldnames(options) , 'rmextremebins')))
    options.rmextremebins        = 0;
end
if(~any(strcmp(fieldnames(options) , 'color')))
    options.color                = 0;
end
if(~any(strcmp(fieldnames(options) , 'norm')))
    options.norm                 = 2;
end
if(~any(strcmp(fieldnames(options) , 'clamp')))
    options.clamp                = 0.2;
end
if(~any(strcmp(fieldnames(options) , 'posscalemin')))
    options.posscalemin          = 0.25;
end
if(~any(strcmp(fieldnames(options) , 'posscalemax')))
    options.posscalemax          = 1.75;
end


if(~any(strcmp(fieldnames(options) , 'dimsItraining')))
    options.dimsItraining       = [24 , 24];
end
if(~any(strcmp(fieldnames(options) , 'transpose')))
    options.transpose           = 0;
end
if(~any(strcmp(fieldnames(options) , 'usesingle')))
    options.single              = 1;
end

if( (options.typefeat == 0) && ~any(strcmp(fieldnames(options) , 'rect_param')))
    options.rect_param          = [1 1 2 2;1 1 2 2;2 2 1 1;2 2 2 2;1 2 1 2;0 0 0 1;0 1 0 0;1 1 1 1;1 1 1 1;1 -1 -1 1];
end
if( (options.typefeat == 1) && ~any(strcmp(fieldnames(options) , 'map')))
    options.map                 = uint8(0:255);
end



if(options.typefeat == 0)
    options.d                       = size(options.F , 2);
elseif(options.typefeat == 1)
    options.d                       = size(options.F , 2);
elseif(options.typefeat == 2)
    if(options.cs_opt == 1)
        if(options.maptable == 0)
            options.Nbins           = 16;
        elseif(options.maptable == 1)
            options.Nbins           = 15;
        elseif(options.maptable == 2)
            options.Nbins           = 6;
        elseif(options.maptable == 3)
            options.Nbins           = 6;
        end
%        options.improvedLBP         = 0;
    else
        if(options.maptable == 0)
            options.Nbins           = 256;
        elseif(options.maptable == 1)
            options.Nbins           = 59;
        elseif(options.maptable == 2)
            options.Nbins           = 36;
        elseif(options.maptable == 3)
            options.Nbins           = 10;
        end
    end
    options.nH                  = sum(floor(((1 - options.spyr(:,1))./(options.spyr(:,3)) + 1)).*floor((1 - options.spyr(:,2))./(options.spyr(:,4)) + 1));
    options.nscale              = length(options.scale);
    options.d                   = options.Nbins*(1+options.improvedLBP)*options.nH*options.nscale;
elseif((options.typefeat == 3))
    if(options.cs_opt == 1)
        if(options.maptable == 0)
            options.Nbins           = 16;
        elseif(options.maptable == 1)
            options.Nbins           = 15;
        elseif(options.maptable == 2)
            options.Nbins           = 6;
        elseif(options.maptable == 3)
            options.Nbins           = 6;
        end
        options.improvedLGP         = 0;
    else
        if(options.maptable == 0)
            options.Nbins           = 256;
        elseif(options.maptable == 1)
            options.Nbins           = 59;
        elseif(options.maptable == 2)
            options.Nbins           = 36;
        elseif(options.maptable == 3)
            options.Nbins           = 10;
        end
    end
    options.nH                      = sum(floor(((1 - options.spyr(:,1))./(options.spyr(:,3)) + 1)).*floor((1 - options.spyr(:,2))./(options.spyr(:,4)) + 1));
    options.nscale                  = length(options.scale);
    options.d                       = options.Nbins*(1+options.improvedLGP)*options.nH*options.nscale;    
end

options.std_angle                  = sqrt(options.sigma_angle);


%% reset seed eventually %%

if(options.resetseed)
    RandStream.setDefaultStream(RandStream.create('mt19937ar','seed',options.seed));
end

Ntotal                 = options.Nposboost;

if(options.typefeat == 0)
    if(options.transpose)
        if(options.usesingle)
            Xnd            = zeros(Ntotal , options.d , 'single');
        else
            Xnd            = zeros(Ntotal , options.d);
        end
    else
        if(options.usesingle)
            Xnd            = zeros(options.d , Ntotal , 'single');
        else
            Xnd            = zeros(options.d , Ntotal);
        end 
    end
elseif(options.typefeat == 1)
    if(options.transpose)
        if(options.usesingle)
            Xnd            = zeros(Ntotal , options.d , 'single');
        else
            Xnd            = zeros(Ntotal , options.d);
        end
    else
        if(options.usesingle)
            Xnd            = zeros(options.d , Ntotal , 'single');
        else
            Xnd            = zeros(options.d , Ntotal);
        end 
    end
elseif(options.typefeat == 3)
    Xnd                 = zeros(options.d , Ntotal);
end

%Xnd                    = zeros(options.d , Ntotal);
fxnd                   = zeros(1 , Ntotal);


%% Generate Npos Positives examples from Xpos without replacement %%

directory              = [];
for i = 1:length(options.posext)
    directory          = [directory ; dir(fullfile(options.positives_path , ['*.' options.posext{i}]))] ;
end
nbpos_photos           = length(directory);
index_posphotos        = randperm(nbpos_photos);

h                      = waitbar(0,sprintf('Generating positives' ));
set(h , 'name' , sprintf('Boosting positives  stage %d/%d' , options.m , options.boost_ite'));
drawnow

co                     = 1;
copos                  = 1;
cophotos               = 1;
if(options.preview)
    fig = figure(1);
    set(fig,'doublebuffer','on');
    colormap(gray)
end

while(co <= Ntotal)
    
    Ipos                       = imread(fullfile(options.positives_path , directory(index_posphotos(cophotos)).name));
    [Ny , Nx , Nz]             = size(Ipos);
    if(Nz == 3)
        Ipos                   = rgb2gray(Ipos);
    end
    
    if(rand < options.probaflipIpos)
        Ipos                   = Ipos(: , end:-1:1) ;
    end
    if(rand < options.probarotIpos)
        Ipos                   = fast_rotate(Ipos , options.m_angle + options.std_angle*randn(1,1));
    end
    
    scale                      = options.posscalemin + (options.posscalemax-options.posscalemin)*rand;
    Nys                        = round(Ny*scale);
    Nxs                        = round(Nx*scale);
    
    %% Resize Ipos %%
    
    Ipos                       = imresize(Ipos , [Nys , Nxs]);
    
    if((options.typefeat == 0) || (options.typefeat == 1) || (options.posresize == 1))
        Ipos                   = imresize(Ipos , options.dimsItraining);
    end
      
    %% Standardize image %%
    if(options.standardize)
        dIpos                      = double(Ipos);
        stdIpos                    = std(dIpos(:));
        if(stdIpos~=0)
            dIpos                  = dIpos/stdIpos;
        end
        minIpos                    = min(dIpos(:));
        maxIpos                    = max(dIpos(:));
        Ipos                       = uint8(floor(255*(dIpos-minIpos)/(maxIpos-minIpos)));
    end
    
    if(options.typefeat == 0)
        Xtemp                     = haar(Ipos , options);
        [fxtemp , ytemp]          = eval_haar(Ipos , options);
    elseif(options.typefeat == 1)
        Xtemp                     = mblbp(Ipos , options);
        [fxtemp , ytemp]          = eval_mblbp(Ipos , options);
    elseif(options.typefeat == 2)
        [fxtemp , ytemp , Xtemp]  = eval_hmblbp_spyr_subwindow(Ipos , options);
    elseif(options.typefeat == 3)
        [fxtemp , ytemp , Xtemp]  = eval_hmblgp_spyr_subwindow(Ipos , options);
    end
        
    if(fxtemp < 0)
        if(options.transpose)
            Xnd(co , :)           = Xtemp;
        else
            Xnd(: , co)           = Xtemp;
        end
        fxnd(co)                  = fxtemp;
        co                        = co + 1;
        if(options.preview)
            imagesc(Ipos);
        end
    end
    
    copos                          = copos + 1;  
    waitbar((co - 1)/Ntotal , h , sprintf('#pos = %d, Pd = %10.9f' , co - 1 , 1 - ((co - 1)/(copos - 1))));
    drawnow
    if(cophotos < nbpos_photos)
        cophotos               = cophotos + 1;
    else
        cophotos               = 1;
        index_posphotos        = randperm(nbpos_photos);
    end
end
close(h)

pd_current                      = 1 - ((co - 1)/(copos - 1));

if(Ntotal > 0)
    if((options.transpose) && (options.typefeat < 2))
        Xnd                     = Xnd(: , 1:Ntotal);
    else
        Xnd                     = Xnd(: , 1:Ntotal);
    end
else
    Xnd                         = zeros(options.d , 0);
end
fxnd                            = fxnd(1:Ntotal);
