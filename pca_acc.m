acc1=0;
acc2=0;
acc3=0;
result1=0;result2=0;result3=0;
set_size=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% testing on test data %%%%%%%%%%%%%%%%%%%%%%

for i=1:size(test_set,1)
    
    result1 = Msvm1.predict(test_set(i,1:30));
    result2 = Msvm2.predict(test_set(i,1:30));
    result3 = Msvm3.predict(test_set(i,1:30));
    
    set_size=set_size+1;
    
    if(result1 == test_set(i,31))
        acc1 = acc1+1;
    end
    
    
    if(result2 == test_set(i,31))
        acc2 = acc2+1;
    end
    
    
    if(result3 == test_set(i,31))
        acc3 = acc3+1;
    end
end

A1=(acc1/set_size)*100; %linear 99.5671 for train and 31.5789 for test
A2=(acc2/set_size)*100; %polynomial 30.9740 for train and 21.0531  for test
A3=(acc3/set_size)*100; %rbf 99.5671 for train and 30.0860 for test


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

accuracy=[A1 A2 A3];
loc= categorical({'Linear','Polynomial','Rbf'});



str1 = 'eeg288 PCA35';
str2 = solver_name;
str3=" ";
figure
hold on
title(strcat(str1,str3,str2), 'FontSize', 10);
xlabel('Kernels', 'FontSize', 10);
ylabel('Accuracy', 'FontSize', 10);
bar(loc,accuracy,0.6);
disp(accuracy);
disp(set_size);
