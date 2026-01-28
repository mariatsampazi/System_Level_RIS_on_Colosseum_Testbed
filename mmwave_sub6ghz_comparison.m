clc; clear all; close all
%default fontisize for papers is 15

% NOT IMPLEMNTED IN THIS CODE:
% compare mmwave and sub6ghz bands for a 1000 elements selection, and same
% noise variance as reference, 10^(-16)


% contains same info as the metrics_sub6ghz.mat fie, but with 10^(-16) as
% noise variance
%load('metrics_sub6ghz_minus16_noise.mat');

%% ----------------------- for total comparison - sum ----------------------
% Load the sub 6 GHz mat file
load('metrics_sub6ghz.mat');
sub6ghz_powers=powers;
sub6ghz_power_no_ris=power_vector2;
sub6ghz_utilities=utilities;
% sub6ghz_powers_1000=powers(:,3);
% sub6ghz_utilities_1000=utilities(:,3);
maxUi2sub6ghz=maxUi2;

% Load the mmWave mat file
load('metrics_mmwave.mat');
mmwave_powers=powers;
mmwave_power_no_ris=power_vector2;
mmwave_utilities=utilities;
% mmwave_powers_1000=powers(:,3);
% mmwave_utilities_1000=utilities(:,3);
maxUi2mmwave=maxUi2;
% -------------------------------------------------------------------------

%% system's capacity
% power
sum_mmwave_power_no_ris=sum(mmwave_power_no_ris,1);
sum_sub6ghz_power_no_ris=sum(sub6ghz_power_no_ris,1);
sum_elems_sub6ghz=sum(sub6ghz_powers,1);
sum_elems_mmwave=sum(mmwave_powers,1);

% utility
sum_mmwave_utility_no_ris=sum(maxUi2mmwave,2);
sum_sub6ghz_utility_no_ris=sum(maxUi2sub6ghz,2);
utility_mmwave=sum(mmwave_utilities,1);
utility_sub6ghz=sum(sub6ghz_utilities,1);

% cat! 
final_sum_elems_sub6ghz=[sum_sub6ghz_power_no_ris,sum_elems_sub6ghz];
final_sum_elems_mmwave=[sum_mmwave_power_no_ris,sum_elems_mmwave];

final_utility_mmwave=[sum_mmwave_utility_no_ris,utility_mmwave];
final_utility_sub6ghz=[sum_sub6ghz_utility_no_ris,utility_sub6ghz];

%% plots
% figure(1);
% xlim('manual');
% ylim('manual');
% plot(final_sum_elems_sub6ghz,'-s','linewidth',0.5);
% hold on;
% plot(final_sum_elems_mmwave,'-*','linewidth',0.5);
% grid on;
% yticks([0.05 0.25 0.45]);
% xticks([1 2 3 4]);
% xticklabels({'10^0','10^1','10^2','10^3'});
% title('AWGN Noise Power -160dBm','FontSize', 20);
% xlabel('Number of RIS elements','FontSize', 15);
% ylabel('Sum user''s power [W]' ,'FontSize', 15);
% set(gca,'FontSize',15);
% legend('Sub-6 GHz band', 'mmWave band','Location', 'Best');
% 
% figure(2);
% xlim('manual');
% ylim('manual');
% semilogy(final_utility_sub6ghz,'-s','linewidth',0.5);
% hold on;
% semilogy(final_utility_mmwave,'-*','linewidth',0.5);
% grid on;
% %yticks([1*10^10 12*10^10]);
% xticks([1 2 3 4]);
% xticklabels({'10^0','10^1','10^2','10^3'});
% title('AWGN Noise Power -160dBm','FontSize', 20);
% xlabel('Number of RIS elements','FontSize', 15);
% ylabel('Sum user''s power [W]' ,'FontSize', 15);
% set(gca,'FontSize',15);
% legend('Sub-6 GHz band', 'mmWave band','Location', 'Best');

figure(1);
xlim('manual');
ylim('manual');
plot(final_sum_elems_sub6ghz,'-s','linewidth',0.5);
grid on;
yticks([0 0.05 0.15 0.25 0.35 0.45]);
xticks([1 2 3 4]);
xticklabels({'10^0','10^1','10^2','10^3'});
%title('Sub-6 GHz band','FontSize', 20);
xlabel('Number of RIS elements','FontSize', 15);
ylabel('Sum users'' power [W]' ,'FontSize', 15);
set(gca,'FontSize',15);

figure(2);
xlim('manual');
ylim('manual');
plot(final_sum_elems_mmwave,'-s','linewidth',0.5);
grid on;
%yticks([0.02 0.04 0.06 0.08 0.1 0.12]);
yticks([0.03 0.06 0.09 0.11]);
xticks([1 2 3 4]);
xticklabels({'10^0','10^1','10^2','10^3'});
%title('mmWave band','FontSize', 20);
xlabel('Number of RIS elements','FontSize', 15);
ylabel('Sum users'' power [W]' ,'FontSize', 15);
set(gca,'FontSize',15);


figure(3);
xlim('manual');
ylim('manual');
plot(final_utility_sub6ghz,'-s','linewidth',0.5);
grid on;
yticks([0 4*10^10 8*10^10 12*10^10]);
xticks([1 2 3 4]);
xticklabels({'10^0','10^1','10^2','10^3'});
%title('Sub-6 GHz band','FontSize', 20);
xlabel('Number of RIS elements','FontSize', 15);
ylabel('Sum user''s utility' ,'FontSize', 15);
set(gca,'FontSize',15);

figure(4);
xlim('manual');
ylim('manual');
plot(final_utility_mmwave,'-s','linewidth',0.5);
grid on;
yticks([0 3*10^10 6*10^10 9*10^10]);
%yticks([0 2*10^10 4*10^10 6*10^10 8*10^10 12*10^10]);

xticks([1 2 3 4]);
xticklabels({'10^0','10^1','10^2','10^3'});
%title('mmWave band','FontSize', 20);
xlabel('Number of RIS elements','FontSize', 15);
ylabel('Sum user''s utility' ,'FontSize', 15);
set(gca,'FontSize',15);


% figure(5);
% xlim('manual');
% ylim('manual');
% plot(final_sum_elems_sub6ghz,'-s','linewidth',0.5);
% hold on;
% plot(final_sum_elems_mmwave,'-*','linewidth',0.5);
% grid on;
% yticks([0.05 0.25 0.45]);
% xticks([1 2 3 4]);
% xticklabels({'10^0','10^1','10^2','10^3'});
% %title('AWGN Noise Power -160dBm','FontSize', 20);
% title('Sub-6 GHz VS. mmWave','FontSize', 20);
% xlabel('Number of RIS elements','FontSize', 15);
% ylabel('Sum user''s power [W]' ,'FontSize', 15);
% set(gca,'FontSize',15);
% legend('Sub-6 GHz band', 'mmWave band','Location', 'Best');


%[left, bottom, width, height])

figure(5);
set(gcf, 'Position', [100, 100, 300, 200]);  % Set the window size as 800x600 pixels, 400x350 was a good fit
xlim('manual');
y_lower_bound = 0.01; % Lower bound value
y_upper_bound = 100; % Upper bound value
ylim([y_lower_bound, y_upper_bound]);
semilogy(final_sum_elems_sub6ghz, '-s', 'linewidth', 1.75, 'MarkerSize', 10);
hold on;
semilogy(final_sum_elems_mmwave, '-*', 'linewidth', 1.75, 'MarkerSize', 10);
grid on;
xticks([1 2 3 4]);
xticklabels({'10^0', '10^1', '10^2', '10^3'});
xlabel('Number of RIS elements', 'FontSize', 13);
ylabel('Sum users'' power [W]', 'FontSize', 13);
set(gca, 'FontSize', 13);
% Add horizontal lines for the bounds
yline(y_lower_bound, '--');
set(gcf,'renderer','Painters'); % set the renderer
legend('Sub-6 GHz band', 'mmWave band', 'Location', 'Best');
exportgraphics(gcf,'comparison_sum_powers.eps','BackgroundColor','none','ContentType','vector') % export the figure to a vector graphics file

figure(6);
set(gcf, 'Position', [200, 200, 300, 200]);  % Set the window size as 800x600 pixels
xlim('manual');
y_lower_bound = 10^9; % Lower bound value
y_upper_bound = 10^11; % Upper bound value
ylim([y_lower_bound, y_upper_bound]);
semilogy(final_utility_sub6ghz, '-s', 'linewidth', 1.75, 'MarkerSize', 10);
hold on;
semilogy(final_utility_mmwave, '-*', 'linewidth', 1.75, 'MarkerSize', 10);
grid on;
xticks([1 2 3 4]);
xticklabels({'10^0', '10^1', '10^2', '10^3'});
xlabel('Number of RIS elements', 'FontSize', 13);
ylabel('Sum users'' utility', 'FontSize', 13);
set(gca, 'FontSize', 13);
legend('Sub-6 GHz band', 'mmWave band', 'Location', 'Best');
yline(y_lower_bound, '--');

% Remove the third entry from the legend
legend_handles = findobj(gcf, 'Type', 'Line');
legend_labels = {'Sub-6 GHz band', 'mmWave band'};
if numel(legend_handles) >= 3
    set(legend_handles(3), 'DisplayName', 'off');
    legend_handles = legend_handles(1:2);  % Remove the third handle
end
%legend(legend_handles, legend_labels, 'Location', 'northwest');
legend('Sub-6 GHz band', 'mmWave band', 'Location', 'northwest');
set(gcf,'renderer','Painters'); % set the renderer
exportgraphics(gcf,'comparison_sum_utilities.eps','BackgroundColor','none','ContentType','vector') % export the figure to a vector graphics file


%%
% power
mean_mmwave_power_no_ris=mean(mmwave_power_no_ris,1);
mean_sub6ghz_power_no_ris=mean(sub6ghz_power_no_ris,1);
mean_elems_sub6ghz=mean(sub6ghz_powers,1);
mean_elems_mmwave=mean(mmwave_powers,1);

% utility
mean_mmwave_utility_no_ris=mean(maxUi2mmwave,2);
mean_sub6ghz_utility_no_ris=mean(maxUi2sub6ghz,2);
mean_utility_mmwave=mean(mmwave_utilities,1);
mean_utility_sub6ghz=mean(sub6ghz_utilities,1);

% cat! 
mean_final_sum_elems_sub6ghz=[mean_sub6ghz_power_no_ris,mean_elems_sub6ghz];
mean_final_sum_elems_mmwave=[mean_mmwave_power_no_ris,mean_elems_mmwave];

mean_final_utility_mmwave=[mean_mmwave_utility_no_ris,mean_utility_mmwave];
mean_final_utility_sub6ghz=[mean_sub6ghz_utility_no_ris,mean_utility_sub6ghz];

figure(7); % Create a new figure
% power
% Sample data
categories = {'Sub-6GHz - Element 1', 'Sub-6GHz - Element 3', 'Sub-6GHz - Element 4', 'mmWave - Element 1', 'mmWave - Element 3', 'mmWave - Element 4'};
vector = [mean_final_sum_elems_sub6ghz(1), mean_final_sum_elems_sub6ghz(3),mean_final_sum_elems_sub6ghz(4), mean_final_sum_elems_mmwave(1), mean_final_sum_elems_mmwave(3), mean_final_sum_elems_mmwave(4)];

% Create a bar plot
bar(vector);

% Add labels and title
xlabel('Categories');
ylabel('Values');
title('Bar Plot Example for Vector');

% Set custom x-axis tick labels
set(gca, 'XTickLabel', categories, 'XTickLabelRotation', 45);



figure(8); % Create a new figure
% power
% Sample data
categories = {'Sub-6GHz - Element 1', 'Sub-6GHz - Element 3',  'Sub-6GHz - Element 3', 'mmWave - Element 1', 'mmWave - Element 3', 'mmWave - Element 4'};
vector = [mean_final_utility_sub6ghz(1), mean_final_utility_sub6ghz(3), mean_final_utility_sub6ghz(4), mean_final_utility_mmwave(1), mean_final_utility_mmwave(3), mean_final_utility_mmwave(4)];

% Create a bar plot
bar(vector);

% Add labels and title
xlabel('Categories');
ylabel('Values');
title('Bar Plot Example for Vector');

% Set custom x-axis tick labels
set(gca, 'XTickLabel', categories, 'XTickLabelRotation', 45);
% Display the plot
grid on;  % Add grid lines
