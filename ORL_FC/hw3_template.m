%%
%% Template for PCA-based face recognition
%%

fprintf('Loading data...\n');
load('ORL_32x32.mat'); % matrix with face images (fea) and labels (gnd)
load('train_test_orl.mat'); % training and test indices (trainIdx, testIdx)
fea = double(fea / 255);

display_faces(fea,10,10);
title('Face data');
pause;


% partition the data into training and test subset
n_train = size(trainIdx,1);
n_test = size(testIdx,1);
train_data = fea(trainIdx,:);
train_label = gnd(trainIdx,:);
test_data = fea(testIdx,:);
test_label = gnd(testIdx,:);

fprintf('Running PCA...\n');
components = % find principal components (use princomp function)

display_faces(components,10,10); 
title ('Top principal components');

train_data_pca = % low-dim coefficients for training data (projection onto components)
train_data_reconstructed = % high-dimensional faces reconstructed from the low-dim coefficients

fprintf('Projecting test data...\n');
test_data_pca = % low-dim coefficients for test data

test_data_reconstructed = % high-dimensional reconstructed test faces
fprintf('Running nearest-neighbor classifier...\n');

[nn_ind, estimated_label] = % output of nearest-neighbor classifier:
% nearest neighbor training indices for each training point and 
% estimated labels (corresponding to labels of the nearest neighbors)
    
fprintf('Classification rate: %f\n', sum(estimated_label == test_label)/n_test);

%%
%% display complete test results (for debugging)
%%
for batch = 1:10
    clf;
    for i = 1:12
        test_ind = (batch-1)*12+i;
        subplot(4,12,i);
        imshow(reshape(test_data(test_ind,:),[32 32]),[]);
        if i == 6
            title('Orig. test img.');
        end
        subplot(4,12,i+12);
        imshow(reshape(test_data_reconstructed(test_ind,:),[32 32]),[]);
        if i == 6
            title('Low-dim test img.');
        end
        subplot(4,12,i+24);
        imshow(reshape(train_data_reconstructed(nn_ind(test_ind),:),[32 32]),[]);
        if i == 6
            title('Low-dim nearest neighbor');
        end
        subplot(4,12,i+36);
        imshow(reshape(train_data(nn_ind(test_ind),:),[32 32]),[]);
        if i == 6
            title('Orig. nearest neighbor');
        end
        if estimated_label(test_ind)~=test_label(test_ind)
            xlabel('incorrect');
        end
    end
    pause;
end

