clc; clear all; close all; clf;

%% Code for the revision

%% sub-6GHz
load('metrics_sub2_rev.mat');
figure(1); 
set(gcf, 'Position', [100, 100, 400, 300]);  
xlim('manual');
ylim('manual');
semilogy(transpose(power_vector2),'-s','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(powers(:,1),'-*','linewidth',2,'MarkerSize', 10); 
hold on; 
semilogy(powers(:,2),'-o','linewidth',2,'MarkerSize', 10); 
hold on;
semilogy(powers(:,3),'-d','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(powers(:,4),'-^','linewidth',2,'MarkerSize', 10); 
xticks([1 2 3 4 5]); 
grid on;
xlabel('User''s index','FontSize', 35);
ylabel('User''s Power [W]' ,'FontSize', 35); 
set(gca,'FontSize',15.1);
legend('no RIS', '100 RIS el.', '300 RIS el.', '500 RIS el.', '1000 RIS el.','Location', 'northeast');
set(gcf,'renderer','Painters'); 
exportgraphics(gcf,'power-sub6ghz_more_elems.eps','BackgroundColor','none','ContentType','vector');

figure(2); 
set(gcf, 'Position', [0, 0,400, 300]);  
xlim('manual');
ylim('manual');
x=1:1:5;
semilogy(x,transpose(maxUi2),'-s','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(x,utilities(:,1),'-*','linewidth',2,'MarkerSize', 10); 
hold on; 
semilogy(x,utilities(:,2),'-o','linewidth',2,'MarkerSize', 10); 
hold on;
semilogy(x,utilities(:,3),'-d','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(x,utilities(:,4),'-^','linewidth',2,'MarkerSize', 10); % New line for utilities(:,4)
yticks([10^6  10^11]); % sub 6
xticks([1 2 3 4 5]);
grid on;
xlabel('User''s index','FontSize', 35);
ylabel('User''s Utility' ,'FontSize', 35);
set(gca,'FontSize',15.1);
legend('no RIS', '100 RIS el.', '300 RIS el.', '500 RIS el.', '1000 RIS el.','Location', 'southeast'); 
set(gcf,'renderer','Painters'); 
exportgraphics(gcf,'utility-sub6ghz_more_elems.eps','BackgroundColor','none','ContentType','vector');

%{
%% high band - mmwave (28 GHz)
load('metrics_mmwave_rev.mat');
figure(3); 
set(gcf, 'Position', [100, 100, 400, 300]); 
xlim('manual');
ylim('manual');
semilogy(transpose(power_vector2),'-s','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(powers(:,1),'-*','linewidth',2,'MarkerSize', 10); 
hold on; 
semilogy(powers(:,2),'-o','linewidth',2,'MarkerSize', 10); 
hold on;
semilogy(powers(:,3),'-d','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(powers(:,4),'-^','linewidth',2,'MarkerSize', 10); % New line for powers(:,4)
xticks([1 2 3 4 5]); 
grid on;
xlabel('User''s index','FontSize', 35);
ylabel('User''s Power [W]' ,'FontSize', 35); 
set(gca,'FontSize',16.1);
legend('no RIS', '100 RIS el.', '500 RIS el.', '700 RIS el.', '1000 RIS el.','Location', 'Best');
set(gcf,'renderer','Painters'); 
exportgraphics(gcf,'power-mmwave_more_elems.eps','BackgroundColor','none','ContentType','vector');

figure(4); 
set(gcf, 'Position', [0, 0,400, 300]); 
xlim('manual');
ylim('manual');
x=1:1:5;
semilogy(x,transpose(maxUi2),'-s','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(x,utilities(:,1),'-*','linewidth',2,'MarkerSize', 10); 
hold on; 
semilogy(x,utilities(:,2),'-o','linewidth',2,'MarkerSize', 10); 
hold on;
semilogy(x,utilities(:,3),'-d','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(x,utilities(:,4),'-^','linewidth',2,'MarkerSize', 10); 
yticks([10^8  10^11]); % mmwave
xticks([1 2 3 4 5]);
grid on;
xlabel('User''s index','FontSize', 35);
ylabel('User''s Utility' ,'FontSize', 35);
set(gca,'FontSize',16.1);
legend('no RIS', '100 RIS el.', '500 RIS el.', '700 RIS el.', '1000 RIS el.','Location', 'northwest'); 
set(gcf,'renderer','Painters'); 
exportgraphics(gcf,'utility-mmwave_more_elems.eps','BackgroundColor','none','ContentType','vector');

%}
