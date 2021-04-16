function main_acc(Model1, Model2, Model3, Model4, test_set, feature_size, solver_name)

% Function to calculate accuracy for training and testing set for all
% models
% Also contains the graph module that creates accuracy vs kernel chart

acc1=0;
acc2=0;
acc3=0;
result1=0;
result2=0;
result3=0;
result4=0;
acc4=0;
A1=0;A2=0;A3=0;A4=0;
set_size=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% testing on test data %%%%%%%%%%%%%%%%%%%%%%

for i=1:size(test_set,1)
    
    result1 = Model1.predict(test_set(i,1:feature_size));
    result2 = Model2.predict(test_set(i,1:feature_size));
    result3 = Model3.predict(test_set(i,1:feature_size));
    result4 = Model4.predict(test_set(i,1:feature_size));
    
    set_size=set_size+1;
    
    if(result1 == test_set(i,feature_size+1))
        acc1 = acc1+1;
    end
    
    
    if(result2 == test_set(i,feature_size+1))
        acc2 = acc2+1;
    end
    
    
    if(result3 == test_set(i,feature_size+1))
        acc3 = acc3+1;
    end
    
    if(result4 == test_set(i,feature_size+1))
        acc4 = acc4+1;
    end
end

A1=(acc1/set_size)*100; %linear 99.5671 for train and 31.5789 for test
A2=(acc2/set_size)*100; %polynomial 25.9740 for train and 21.0526  for test
A3=(acc3/set_size)*100;%rbf 99.5671 for train and 22.0860 for test
A4=(acc4/set_size)*100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%accuracy=[A1,A4;A2,A5;A3,A6];
accuracy=[A1 A2 A3 A4];%,A4];
loc= categorical({'NaiveBayes','KNN','DecisionTrees','SVM linear'});

str1 = 'eeg288 Statistical Classifiers';
str2 = solver_name;
str3=" ";
figure
hold on
title(strcat(str1,str3,str2), 'FontSize', 10);
xlabel('Classifiers', 'FontSize', 10);
ylabel('Accuracy', 'FontSize', 10);
bar(loc,accuracy,0.6);
disp(accuracy);
disp(set_size);
%legend('test','train');
%legend('linear','poly','rbf','NB');