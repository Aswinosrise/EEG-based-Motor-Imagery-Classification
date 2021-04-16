%%%%%%%%%%%% loading data %%%%%%%%%%%%%%%%%
warning('off','all');
[s, h] = sload('datset/A01T.gdf', 0, 'OVERFLOWDETECTION:OFF');

%%%%%%%%%%% artifact processing %%%%%%%%%%%

%gettting regress coefficients
EL = find(h.CHANTYP=='E');
OL = identify_eog_channels('datset/A01T.gdf');
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
        %bp1=bandpower(final(i:i+312,j),250,[8,9],1);
        bp1=final(i:i+312,j);
        bp2=[bp2,bp1'];
    end
    bp_final=[bp_final;bp2];
    bp2=[];
end

bp_final_new = bp_final';
bp_final = bandpower(bp_final_new(:,1:288),250,[8,9],1);

bp_final = bp_final';
bp_final(isnan(bp_final))=0;
bp_final(isinf(bp_final))=0;

disp(size(bp_final));
accuracy=[];
no_of_pc=[];
a=0;

%%starting of the training for each value of pc

for features=5:5:100
   
    [coeff,score] = pca(bp_final');
    bp_final1= score*coeff;
    bp_final1 = bp_final1';
    bp_final1 = bp_final1(:,1:features);
    
    set=[bp_final1,c];
    eval = mat2cell(set, [ceil(0.9*size(set,1)) ceil(0.1*size(set,1))-1],features+1);
    train_set=eval{1,1};
    test_set=eval{2,1};
    
    %train_set =  train_set(randperm(end),:);
    
    %%svm
    fprintf('Iteration %d\n', a);
    
    %Generating models for finding the model with maximum accuracy
    acc=0;
    solver_name='L1QP';
    svm_kernel=templateSVM('KernelFunction','polynomial','Solver',solver_name);
    Msvm1 = fitcecoc(train_set(:,1:features),train_set(:,features+1),'Coding','allpairs','Learners',svm_kernel);
    
    for j=1:size(test_set,1)
        result1 = Msvm1.predict(test_set(j,1:features));
        if(result1 == test_set(j,features+1))
            acc=acc+1;
        end
    end
    accuracy=[accuracy,(acc/size(test_set,1))*100];
    no_of_pc=[no_of_pc,features];
    a=a+1;
    
end


%%% printing the maximum acc and corresponding pc

acc = max(accuracy);
index = accuracy==acc;
pc = no_of_pc(index);
fprintf('\n');
fprintf('%d %d',acc,pc);

%%%  Plotting the results %%%%%%%%

figure
hold on
title('Accuracy vs Pcs graph', 'FontSize', 10);
xlabel('Principal Comps', 'FontSize', 10);
ylabel('Accuracy', 'FontSize', 10);
bar(no_of_pc,accuracy,0.6);
legend('polynomial SMO');
