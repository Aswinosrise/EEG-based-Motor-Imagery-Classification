acc1=0;
acc2=0;
acc3=0;
acc4=0;
acc5=0;
acc6=0;
result1=0;result2=0;result3=0;result4=0;result5=0;result6=0;
set_size=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% testing on test data %%%%%%%%%%%%%%%%%%%%%%

for i=1:size(test_set,1)
    
    result1 = Msvm1.predict(test_set(i,1:6886));
    result2 = Msvm2.predict(test_set(i,1:6886));
    result3 = Msvm3.predict(test_set(i,1:6886));
    
    set_size=set_size+1;
    
    if(result1 == test_set(i,6887))
        acc1 = acc1+1;
    end
    
    
    if(result2 == test_set(i,6887))
        acc2 = acc2+1;
    end
    
    
    if(result3 == test_set(i,6887))
        acc3 = acc3+1;
    end
end

A1=(acc1/set_size)*100; %linear 99.5671 for train and 31.5789 for test
A2=(acc2/set_size)*100; %polynomial 25.9740 for train and 21.0526  for test
A3=(acc3/set_size)*100; %rbf 99.5671 for train and 22.0860 for test


%%%%%%%%%%%%%%%%% testing on training data %%%%%%%%%%%%%%%%%%%%%%%%

set_size=0;
for i=1:size(train_set,1)
    
    result4 = Msvm1.predict(train_set(i,1:6886));
    result5 = Msvm2.predict(train_set(i,1:6886));
    result6 = Msvm3.predict(train_set(i,1:6886));
    
    set_size=set_size+1;
    
    if(result4 == train_set(i,6887))
        acc4 = acc4+1;
    end
    
    
    if(result5 == train_set(i,6887))
        acc5 = acc5+1;
    end
    
    
    if(result6 == train_set(i,6887))
        acc6 = acc6+1;
    end
end

A4=(acc4/set_size)*100; %linear 99.5671 for train and 31.5789 for test
A5=(acc5/set_size)*100; %polynomial 25.9740 for train and 21.0526  for test
A6=(acc6/set_size)*100; %rbf 99.5671 for train and 22.0860 for test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

accuracy=[A1,A4;A2,A5;A3,A6];

figure
hold on
title('eeg_288 Train vs Test accuracy for SMO', 'FontSize', 10);
xlabel('Kernels', 'FontSize', 10);
ylabel('Accuracy', 'FontSize', 10);
bar(accuracy);
disp(accuracy);
legend('test','train');

