%%%%%%%%%%% loading data %%%%%%%%%%%%%%%%%
warning('off','all');
file_path1 = 'datset/A01T.gdf';

[x1, y1] = sload(file_path1, 0, 'OVERFLOWDETECTION:OFF');

%%%%%%%%%%% artifact processing and feature extraction %%%%%%%%%%%
data_set1 = preprocess(x1, y1, file_path1);

%%%% combining both data sets %%%%%%%%%
data_set = [data_set1];% data_set2; data_set3; data_set4];% data_set5];% data_set6; data_set7; data_set8; data_set9];


%%%%%%% shuffling them %%%%%%%%%%%
%data_set = data_set(randperm(end),:);

feature_size = size(data_set,2)-1;

%%%%%%%%%% splitting them for test and train as 90 and 10 %%%%%%%%%%
eval = mat2cell(data_set, [ceil(0.9*size(data_set,1)) ceil(0.1*size(data_set,1))-1],feature_size+1);
train_set=eval{1,1};
test_set=eval{2,1};

%train_set = train_set(randperm(size(train_set,1)),:);
%%svm
disp('Msvm has started');
disp('Ongoing');

%declaring svm template for use with fitcecoc
solver_name='SMO';
 svm_linear=templateSVM('KernelFunction','linear','Solver',solver_name);
% svm_poly=templateSVM('KernelFunction','polynomial','Solver',solver_name);
% svm_rbf=templateSVM('KernelFunction','rbf','Solver',solver_name);
% % 

% %Generating models for finding the model with maximum accuracy
% 
Msvm1 = fitcecoc(train_set(:,1:feature_size),train_set(:,feature_size+1),'Coding','allpairs','Learners',svm_linear);
% Msvm2 = fitcecoc(train_set(:,1:feature_size),train_set(:,feature_size+1),'Coding','allpairs','Learners',svm_poly);
% Msvm3 = fitcecoc(train_set(:,1:feature_size),train_set(:,feature_size+1),'Coding','allpairs','Learners',svm_rbf);
M1 = fitcnb(train_set(:,1:feature_size),train_set(:,feature_size+1),'DistributionNames','normal');%,'Standardize',1);
M2 = fitcknn(train_set(:,1:feature_size),train_set(:,feature_size+1),'Distance','euclidean','NumNeighbors',5,'Standardize',1);
M3 = fitctree(train_set(:,1:feature_size),train_set(:,feature_size+1));%,'Standardize',1);

disp('Models Generated');
%main_acc(Msvm1, Msvm2, Msvm3,T, test_set, feature_size, solver_name);

main_acc(Msvm1, M1, M2,M3, test_set, feature_size, solver_name);
%Msvm2 = fitcecoc(train_table,'Class','Coding','binarycomplete');
%Msvm3 = fitcecoc(train_table,'Class','Coding','onevsall');
%Msvm4 = fitcecoc(train_table,'Class','Coding','ordinal');
%Msvm = fitcsvm(train_table,'Class','ClassNames',[1,2],'KernelFunction', 'Polynomial');
