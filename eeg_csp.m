    %%%%%%%%%%% loading data %%%%%%%%%%%%%%%%%
    [s, h] = sload('A02T.gdf', 0, 'OVERFLOWDETECTION:OFF');

    %%%%%%%%%%% artifact processing %%%%%%%%%%%

    %gettting regress coefficients
    EL = find(h.CHANTYP=='E');
    OL = identify_eog_channels('A02T.gdf');
    [R,S] = regress_eog(s,EL,OL);


    %%%%%%%%%%% event extraction %%%%%%%%%%%%%%

    %Create a new matrix A such that type,pos,duration and class are all in 1
    %matrix
    %Run in S from that position till the duration

    h.EVENT.POS=h.EVENT.POS((h.EVENT.TYP==769) | (h.EVENT.TYP==770) | (h.EVENT.TYP==771) | (h.EVENT.TYP==772));
    h.EVENT.DUR=h.EVENT.DUR((h.EVENT.TYP==769) | (h.EVENT.TYP==770) | (h.EVENT.TYP==771) | (h.EVENT.TYP==772));
    h.EVENT.TYP=h.EVENT.TYP((h.EVENT.TYP==769) | (h.EVENT.TYP==770) | (h.EVENT.TYP==771) | (h.EVENT.TYP==772));

    %creating classes for each type
    for i=1:288
        if(h.EVENT.TYP(i)==769)
            class(i)=1;
            continue;
        elseif(h.EVENT.TYP(i)==770)
            class(i)=2;
            continue;
        elseif(h.EVENT.TYP(i)==771)
            class(i)=3;
            continue;
        elseif(h.EVENT.TYP(i)==772)
            class(i)=4;
            continue;
        end

    end

    c=transpose(class);

    A=[h.EVENT.POS,h.EVENT.DUR,h.EVENT.TYP,c]; %single matrix for all specs

    %split S matrix according to A matrix
    final=[];
    v=[];
    for i=1:288
        v=[v;repmat(A(i,4),313,1)];
        pre_final=[S(A(i):A(i)+312,:)];
        final=[final;pre_final];
    end

    %%%%%%%%%%%%%%% Feature extraction %%%%%%%%%%%%%%%%%
    bp = bandpower(final(:,1:22),250,[8,30],1);


    % %applying pca
    % [coeff,score] = pca(bp(1:end,1:end),'Rows','pairwise');
    %
    % bp= bp(1:end,1:end)*coeff(:,1:10);


    %assigning class labels at the end
    bp = [bp,v];
    bp_to_csp = shuffle(bp,1);

    %splitting the matrix into training and testing 80% and 20%
    eval = mat2cell(data_csp, [ceil(0.8*size(data_csp,1)) ceil(0.2*size(data_csp,1))-1],5);
    train_set=eval{1,1};
    test_set=eval{2,1};
    
    %creating tables from train_set and test_set for easy readability //NP
    train_table = array2table(train_set);
    test_table = array2table(test_set);
    %describing column headings for training and testing data
    train_table.Properties.VariableNames(1:5) = {'Ch_1','Ch_2','Ch_3','Ch_4','Class'};%'Ch_5','Ch_6','Ch_7','Ch_8','Ch_9','Ch_10','Ch_11','Ch_12','Ch_13','Ch_14','Ch_15','Ch_16','Ch_17','Ch_18','Ch_19','Ch_20','Ch_21','Ch_22','Class'};
    test_table.Properties.VariableNames(1:5)  = {'Ch_1','Ch_2','Ch_3','Ch_4','Class'};%'Ch_5','Ch_6','Ch_7','Ch_8','Ch_9','Ch_10','Ch_11','Ch_12','Ch_13','Ch_14','Ch_15','Ch_16','Ch_17','Ch_18','Ch_19','Ch_20','Ch_21','Ch_22','Class'};

    %%%%%%%%%%% classification %%%%%%%%%%%%%%%

    %%knn
    %disp('m1,m2 has started');
    %M1 = fitcknn(train_table,'Class','ClassNames',[1,2],'Distance','euclidean','NumNeighbors',5,'Standardize',1);

    %%svm
    disp('Msvm has started');
    disp('Ongoing');
    %declaring svm template for use with fitcecoc
    t=templateSVM('KernelFunction','rbf');

    %Generating models for finding the model with maximum accuracy

    %Msvm = fitcsvm(train_table,'Class','ClassNames',[1,2],'KernelFunction', 'Polynomial');
    Msvm1 = fitcecoc(train_table,'Class','Coding','allpairs','Learners',t); %acc =40.7477
    %Msvm2 = fitcecoc(train_table,'Class','Coding','binarycomplete'); %acc = 39.9268
    %Msvm3 = fitcecoc(train_table,'Class','Coding','onevsall'); %acc = 33.8973
    %Msvm4 = fitcecoc(train_table,'Class','Coding','ordinal'); %acc = 30.5913
    %Msvm5 = fitcecoc(train_table,'Class','Coding','ternarycomplete');

