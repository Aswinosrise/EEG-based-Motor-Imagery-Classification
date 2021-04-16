function [set] = preprocess(s, h, path)

% Function to perform artifact removal
% To obtain events
% To perform Feature Extraction
% And to assign class labels

%%%%%%%%%%% artifact processing %%%%%%%%%%%

%gettting regress coefficients
EL = find(h.CHANTYP=='E');
OL = identify_eog_channels(path);
[R,S] = regress_eog(s,EL,OL);

S=S*R.r0; % without offset correction
S = [ones(size(S,1),1),S] * R.r1;    % with offset correction

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

%%%%%%%%%%%%%%%%%%%%% Feature Extraction %%%%%%%%%%%%%%%%%%%%%%%%%%%
bp1=[];
bp2=[];
bp_final=[];
for i=1:313:90144
    for j=1:22
        bp1=bandpower(final(i:i+312,j),250/2,[8,9],1);
        bp2=[bp2,bp1'];
    end
    bp_final=[bp_final;bp2];
    bp2=[];
end

bp_final(isnan(bp_final))=0;
bp_final(isinf(bp_final))=0;

%%%%%%%%% pca %%%%%%%%%%%%%%
% [coeff,score] = pca(bp_final');
% bp_final = score*coeff;
% bp_final = bp_final';
% bp_final = bp_final(:,1:50);
% 
% Md1 = rica(bp_final,30);
% bp = transform(Md1, bp_final);
%addding class labels at the end
set = [bp_final,c];
