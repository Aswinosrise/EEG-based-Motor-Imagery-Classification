%%%%%%%%%%%% loading data %%%%%%%%%%%%%%%%%
warning('off','all');
[s, h] = sload('A01T.gdf', 0, 'OVERFLOWDETECTION:OFF');

%%%%%%%%%%% artifact processing %%%%%%%%%%%

%gettting regress coefficients
EL = find(h.CHANTYP=='E');
OL = identify_eog_channels('A01T.gdf');
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





bp1=[];
bp2=[];
bp_final=[];
for i=1:313:90144
    for j=1:22
        bp1=bandpower(final(i:i+312,j),250,[8,30],1);
        bp2=[bp2,bp1'];
    end
    bp_final=[bp_final;bp2];
    bp2=[];
end

% addding class labels at the end
set=[bp_final,c];

% %removing NaN and Inf values
% bp_final(isnan(bp_final))=0;
% bp_final(isinf(bp_final))=0;

% shuffling the matrix to prevent more amount of training examples from a
% single class
set = set(randperm(end),:);

eval = mat2cell(set, [ceil(0.8*size(set,1)) ceil(0.2*size(set,1))-1],6887);
train_set=eval{1,1};
test_set=eval{2,1};


%%svm
disp('Msvm has started');
disp('Ongoing');

%declaring svm template for use with fitcecoc
svm_linear=templateSVM('KernelFunction','linear','Solver','SMO');
svm_poly=templateSVM('KernelFunction','polynomial','Solver','SMO');
svm_rbf=templateSVM('KernelFunction','rbf','Solver','SMO');

%Generating models for finding the model with maximum accuracy

Msvm1 = fitcecoc(train_set(:,1:6886),train_set(:,6887),'Coding','allpairs','Learners',svm_linear);
Msvm2 = fitcecoc(train_set(:,1:6886),train_set(:,6887),'Coding','allpairs','Learners',svm_poly);
Msvm3 = fitcecoc(train_set(:,1:6886),train_set(:,6887),'Coding','allpairs','Learners',svm_rbf); %acc =22.8070 for rbf, acc=31.5789 for linear, acc=21.0526 for polynomial

%Msvm2 = fitcecoc(train_table,'Class','Coding','binarycomplete');
%Msvm3 = fitcecoc(train_table,'Class','Coding','onevsall');
%Msvm4 = fitcecoc(train_table,'Class','Coding','ordinal');
%Msvm = fitcsvm(train_table,'Class','ClassNames',[1,2],'KernelFunction', 'Polynomial');