%%data modified for csp 

 %CSP
    X1=[];
    X2=[];
    for i=1:size(bp_to_csp,1)
       if bp_to_csp(i,23)== 1
          X1= [X1;bp_to_csp(i,1:23)];
       end
       
       if bp_to_csp(i,23)== 3 || bp_to_csp(i,23) == 4 || bp_to_csp(i,23) == 2
           X2= [X2;bp_to_csp(i,1:23)];
       end 
    end
    
    disp('end of loop');
    %%%applying csp %%%%%%%%%
    [W] =csp(X1(1:end,1:22),X2(1:end,1:22));
    X1_csp = X1(1:end,1:22)*W;
    X2_csp = X2(1:end,1:22)*W;
    
    X1_csp = [X1_csp,X1(:,23)];
    X2_csp = [X2_csp,X2(:,23)];
    
    data_csp = [X1_csp;X2_csp];
        
    