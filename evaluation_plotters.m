clc; clear all; close all; clf;

%load('metrics_sub6ghz_minus16_noise.mat'); %comparison
%% low band - 900 MHz
%load('metrics_lowband.mat');

%%

%% sub-6GHz
load('metrics_sub6ghz.mat');
figure(1); 
set(gcf, 'Position', [100, 100, 400, 300]);  % Set the window size as 800x600 pixels, 800 is fine
xlim('manual');
ylim('manual');
semilogy(transpose(power_vector2),'-s','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(powers(:,1),'-*','linewidth',2,'MarkerSize', 10); 
hold on; 
semilogy(powers(:,2),'-o','linewidth',2,'MarkerSize', 10); 
hold on;
semilogy(powers(:,3),'-d','linewidth',2,'MarkerSize', 10);
%yticks([10^(-4)  10^(-2) 10^0]);
xticks([1 2 3 4 5]); 
grid on;
%title('mmWave band','FontSize', 20);
%title('Sub-6 GHz band','FontSize', 20);
xlabel('User''s index','FontSize', 35);
ylabel('User''s Power [W]' ,'FontSize', 35); 
set(gca,'FontSize',15.1);
legend('no RIS', '10 elements on RIS', '100 elements on RIS', '1000 elements on RIS','Location', 'Best');
% not for RIS sub6ghz
set(gcf,'renderer','Painters'); % set the renderer
exportgraphics(gcf,'power-sub6ghz2.eps','BackgroundColor','none','ContentType','vector') % export the figure to a vector graphics file


figure(2); 
set(gcf, 'Position', [0, 0,400, 300]);  % Set the window size as 800x600 pixels
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
%yticks([10^8  10^11]); % mmwave
yticks([10^6  10^11]); % sub 6
xticks([1 2 3 4 5]);
grid on;
%title('mmWave band','FontSize', 20);
%title('Sub-6 GHz band','FontSize', 20);

xlabel('User''s index','FontSize', 35);
ylabel('User''s Utility' ,'FontSize', 35);
set(gca,'FontSize',15.1);
legend('no RIS', '10 elements on RIS', '100 elements on RIS', '1000 elements on RIS','Location', 'northwest'); 
% legend not for RIS sub6ghz
set(gcf,'renderer','Painters'); % set the renderer
exportgraphics(gcf,'utility-sub6ghz2.eps','BackgroundColor','none','ContentType','vector') % export the figure to a vector graphics file

%% high band - mmwave (28 GHz)
load('metrics_sub6ghz_test.mat');
figure(3); 
set(gcf, 'Position', [100, 100, 400, 300]);  % Set the window size as 800x600 pixels, 800 is fine
xlim('manual');
ylim('manual');
semilogy(transpose(power_vector2),'-s','linewidth',2,'MarkerSize', 10);
hold on;
semilogy(powers(:,1),'-*','linewidth',2,'MarkerSize', 10); 
hold on; 
semilogy(powers(:,2),'-o','linewidth',2,'MarkerSize', 10); 
hold on;
semilogy(powers(:,3),'-d','linewidth',2,'MarkerSize', 10);
%yticks([10^(-4)  10^(-2) 10^0]);
xticks([1 2 3 4 5]); 
grid on;
%title('mmWave band','FontSize', 20);
%title('Sub-6 GHz band','FontSize', 20);
xlabel('User''s index','FontSize', 35);
ylabel('User''s Power [W]' ,'FontSize', 35); 
set(gca,'FontSize',16.1);
legend('no RIS', '10 elements on RIS', '100 elements on RIS', '1000 elements on RIS','Location', 'Best');
% not for RIS sub6ghz
set(gcf,'renderer','Painters'); % set the renderer
exportgraphics(gcf,'power-mmwave2.eps','BackgroundColor','none','ContentType','vector') % export the figure to a vector graphics file



figure(4); 
set(gcf, 'Position', [0, 0,400, 300]);  % Set the window size as 800x600 pixels
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
yticks([10^8  10^11]); % mmwave
%yticks([10^6  10^11]); % sub 6
xticks([1 2 3 4 5]);
grid on;
%title('mmWave band','FontSize', 20);
%title('Sub-6 GHz band','FontSize', 20);

xlabel('User''s index','FontSize', 35);
ylabel('User''s Utility' ,'FontSize', 35);
set(gca,'FontSize',16.1);
legend('no RIS', '10 elements on RIS', '100 elements on RIS', '1000 elements on RIS','Location', 'northwest'); 
% legend not for RIS sub6ghz
set(gcf,'renderer','Painters'); % set the renderer
exportgraphics(gcf,'utility-mmwave2.eps','BackgroundColor','none','ContentType','vector') % export the figure to a vector graphics file




%%
%{
load('RA_power_results_10elems.mat','power_vector','power_vector2');
pv_10_ris=power_vector; pv_10_no_ris=power_vector2;

load('RA_power_results_100elems.mat','power_vector','power_vector2');
pv_100_ris=power_vector; pv_100_no_ris=power_vector2;

load('RA_power_results_100elems.mat','power_vector','power_vector2');
pv_1000_ris=power_vector; pv_1000_no_ris=power_vector2;


figure(5);
set(gca,'yscale','log');
hold on; 
grid on; 
xticks([]);
%xticks([1 2 3 4 5]);
xlabel('user ID'); 
ylabel('transmission power in [Watts]');
p1=semilogy(sum(pv_10_no_ris)); 
hold on; 
p2=semilogy(sum(pv_10_ris));
hold on; 
p3=semilogy(sum(pv_100_ris));
hold on; 
p4=semilogy(sum(pv_1000_ris));
hold off;
h = [p1;p2;p3;p4];
legend(h,'no RIS','10 elements on RIS','100 elements on RIS','1000 elements on RIS');
%}

% x = 1900:10:2000;
% 
% y1 = [75.99,91.92,105.71,...
%        123.23,131.69,...
%        150.67,179.33,203.12,...
%        226.55,249.63,281.42];
% 
% y2 = [55.2,61.972,65.71,...
%        76.23,87.669,...
%        91.7,103.23,124.21,...
%        130.55,135.63,145.22];
% 
% fig = figure('Color','w');
% bar(x, [y1' y2'],'grouped');
% ax = get(gca);
% cat = ax.Children;
% 
% set(cat(2),'FaceColor',[145 25 206]/255,'BarWidth',2);
% 
% set(cat(1),'FaceColor',[45 125 206]/255,'BarWidth',2);
% 
% set(gca,'box','off');