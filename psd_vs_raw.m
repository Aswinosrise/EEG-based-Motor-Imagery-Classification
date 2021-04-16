%%%%%%%%%%%%%%%% 2D graph to understand how data is modified %%%%%%%%%%%%%
k_before=[];
k_after=[];
for i=1:313:size(final,1)
    k_before=[k_before;final(i,1)];
end

for i=1:313:size(bp,1)
    k_after=[k_after;bp(i,1)];
end

X=final(:,1);
Y=bp(:,1);
figure
hold on
title('Raw vs psd for 1st channel till 200s','FontSize',10);
xlabel('Time','FontSize',10);
ylabel('Signal potential','FontSize',10);
plot(final(1:200,1),'r');
plot(bp(1:200,1),'b');

legend('Raw','PSD');
% plot(k_before(1:288,1),'r');
% plot(k_after(1:288,1),'b');

figure
hold on
title('Raw data vs PSD data for entire duration','FontSize',10);
xlabel('Time','FontSize',10);
ylabel('Signal potential','FontSize',10);

plot(X,'r');
plot(Y,'b');

legend('Raw','PSD');