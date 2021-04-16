acc1=0;
acc2=0;
acc3=0;
acc4=0;
acc5=0;
result1=0;result2=0;result3=0;result4=0;result5=0;
set_size=0;
for i=1:size(test_table,1)
    %if test_table.Class(i)==1 || test_table.Class(i)==2
    %result1 = M1.predict(test_table{i,1:22});
    %result2 = M2.predict(test_table{i,1:22});
    %result1 = Msvm1.predict(test_table{i,1:22});
    %result2 = Msvm2.predict(test_table{i,1:22});
    %result3 = M3.predict(test_table{i,1:22});
    %result4 = Msvm4.predict(test_table{i,1:22});
    result5 = Msvm1.predict(test_table{i,1:22});
    set_size=set_size+1; %overall is 8138
    
    
%     if(result1 == test_table.Class(i))
%         acc1 = acc1+1;
%     end
%     
%     if(result2 == test_table.Class(i))
%         acc2 = acc2+1;
%     end
    
%     if(result3 == test_table.Class(i))
%         acc3 = acc3+1;
%     end
%     
%     if(result4 == test_table.Class(i))
%         acc4 = acc4+1;
%     end
    
     if(result5 == test_table.Class(i))
        acc5 = acc5+1;
   end
end
%end
 disp(set_size);
 %disp((acc1/set_size)*100); %52.45
 %disp((acc2/set_size)*100); %52.37
 %disp((acc3/set_size)*100);
% disp((acc4/set_size)*100);
disp((acc5/set_size)*100);
