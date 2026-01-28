clc; clear all; close all;

% final processing for the path gains of the UAV-RIS-USERS topology
% 
% load('/Users/maria/Documents iCloud/QuaDriGa_2021.07.12_v2.6.1-0/tutorials/implementation/RIS_on_Colosseum/Path Gains/sub-6-GHz/100 elements and random positions 1/data I like - sub6ghz/user_to_UAV.mat');
% load('/Users/maria/Documents iCloud/QuaDriGa_2021.07.12_v2.6.1-0/tutorials/implementation/RIS_on_Colosseum/Path Gains/sub-6-GHz/100 elements and random positions 1/data I like - sub6ghz/user_to_RIS.mat');
% load('/Users/maria/Documents iCloud/QuaDriGa_2021.07.12_v2.6.1-0/tutorials/implementation/RIS_on_Colosseum/Path Gains/sub-6-GHz/100 elements and random positions 1/data I like - sub6ghz/RIS_to_UAV.mat');
%disp('mmave testing');

%%

load('user_to_UAV.mat');
load('user_to_RIS_new_format.mat');
load('RIS_to_UAV_new_format.mat');

%channel gain USER-RIS-UAV
%channel gain optimal for users
%total_users is total_users-1 because we do not care about the UAV

%% 10 elems
M=10;
h_iRu_star_10 = zeros(total_users-1, M);
sum_h_iRu_star_10 = zeros(total_users-1,1);
for n=1:total_users-1
    for m=1:M
        h_iRu_star_10(n,m)=abs(user_ris_final_pg_complex_10(n,m)).*exp((1j).*((angle(user_uav_final_pg_complex(n,1)))));
        sum_h_iRu_star_10(n) = sum(h_iRu_star_10(n,:));
    end
end

% the phase shifts just change the phase, the magnitude is unchangeable
n=1:total_users-1;
h_iRu_10 = abs(h_Ru_total_10(1)).*sum_h_iRu_star_10(n);

%channel gain for users with RIS
n=1:total_users-1;
g_i_10 =power(abs(user_uav_final_pg_complex(n) + h_iRu_10(n)),2);
%g_i =power(abs( h_iRu(n)),2);
%g_i =power(abs(user_uav_final_pg_complex(n)) ,2);

n=1:total_users-1;
g_i_no_ris_10=power(abs(user_uav_final_pg_complex(n)),2);

%--------------------------------------------------------
% channel gain with RIS
[G_i_10,sortIdx10] = sort(g_i_10,'descend'); 
%G_i=g_i;

% channel gain without RIS
[G_i_no_ris_10,sortIdx_no_ris10] = sort(g_i_no_ris_10,'descend');
%[G_i_no_ris_10,sortIdx_no_ris10] = sort(g_i_10,'descend');
%G_i_no_ris=g_i_no_ris;
%--------------------------------------------------------

db_g_i_ris_10=10.*log10(G_i_10); %ris
%{
figure(1);
plot(db_g_i_ris,'LineWidth',2);
hold on; 
grid on;
title('Path Gains for the UE to UAV link with and without the presence of RIS averaged over 100 different channel realizations.','FontSize', 24);
xlabel('USER ID','FontSize', 24);
xticks([1 2 3 4 5]);
yticks([-140 -120 -100 -80 -60 -40 -20 ]);
ylabel('Path Gain [dB]','FontSize', 24);
db_g_i_no_ris=10.*log10(G_i_no_ris);
plot(db_g_i_no_ris, 'LineWidth',2);
legend('RIS','NO RIS','FontSize', 18, 'Location', 'Best');
%}
%--------------
new_db_g_i_ris_10=mag2db(G_i_10)./2;
new_db_g_i_no_ris_10=mag2db(G_i_no_ris_10)./2;

%new_db_g_i_ris=round(new_db_g_i_ris);
%new_db_g_i_no_ris=round(new_db_g_i_no_ris);

%%{


%%y=[new_db_g_i_no_ris;new_db_g_i_ris];
%% y10 is correct, only
%y10 = [new_db_g_i_no_ris_10(1) new_db_g_i_ris_10(1); new_db_g_i_no_ris_10(2) new_db_g_i_ris_10(2); new_db_g_i_no_ris_10(3) new_db_g_i_ris_10(3); new_db_g_i_no_ris_10(4) new_db_g_i_ris_10(4); new_db_g_i_no_ris_10(5) new_db_g_i_ris_10(5)];
%%b1 = bar(new_db_g_i_no_ris); hold on;


%% 100 elems
M=100;
h_iRu_star_100 = zeros(total_users-1, M);
sum_h_iRu_star_100 = zeros(total_users-1,1);
for n=1:total_users-1
    for m=1:M
        h_iRu_star_100(n,m)=abs(user_ris_final_pg_complex_100(n,m)).*exp((1j).*((angle(user_uav_final_pg_complex(n,1)))));
        sum_h_iRu_star_100(n) = sum(h_iRu_star_100(n,:));
    end
end

% the phase shifts just change the phase, the magnitude is unchangeable
n=1:total_users-1;
h_iRu_100 = abs(h_Ru_total_100(1)).*sum_h_iRu_star_100(n);

%channel gain for users with RIS
n=1:total_users-1;
g_i_100 =power(abs(user_uav_final_pg_complex(n) + h_iRu_100(n)),2);
%g_i =power(abs( h_iRu(n)),2);
%g_i =power(abs(user_uav_final_pg_complex(n)) ,2);

n=1:total_users-1;
g_i_no_ris_100=power(abs(user_uav_final_pg_complex(n)),2);

%--------------------------------------------------------
%% channel gain with RIS - 100 elems
[G_i_100,sortIdx100] = sort(g_i_100,'descend'); 
%G_i=g_i;

% channel gain without RIS
[G_i_no_ris_100,sortIdx_no_ris100] = sort(g_i_no_ris_100,'descend');
%[G_i_no_ris_100,sortIdx_no_ris100] = sort(g_i_100,'descend');
%G_i_no_ris=g_i_no_ris;
%--------------------------------------------------------

db_g_i_ris_100=10.*log10(G_i_100); %ris

%--------------
new_db_g_i_ris_100=mag2db(G_i_100)./2;
new_db_g_i_no_ris_100=mag2db(G_i_no_ris_100)./2;


%y=[new_db_g_i_no_ris;new_db_g_i_ris];
%% y100 is correct, only
%%y100=[new_db_g_i_no_ris_100(1) new_db_g_i_ris_100(1); new_db_g_i_no_ris_100(2) new_db_g_i_ris_100(2); new_db_g_i_no_ris_100(3) new_db_g_i_ris_100(3); new_db_g_i_no_ris_100(4) new_db_g_i_ris_100(4); new_db_g_i_no_ris_100(5) new_db_g_i_ris_100(5)];
%b1 = bar(new_db_g_i_no_ris); hold on;


%% 1000 elems
M=1000;
h_iRu_star_1000 = zeros(total_users-1, M);
sum_h_iRu_star_1000 = zeros(total_users-1,1);
for n=1:total_users-1
    for m=1:M
        h_iRu_star_1000(n,m)=abs(user_ris_final_pg_complex_1000(n,m)).*exp((1j).*((angle(user_uav_final_pg_complex(n,1)))));
        sum_h_iRu_star_1000(n) = sum(h_iRu_star_1000(n,:));
    end
end

% the phase shifts just change the phase, the magnitude is unchangeable
n=1:total_users-1;
h_iRu_1000 = abs(h_Ru_total_1000(1)).*sum_h_iRu_star_1000(n);

%channel gain for users with RIS
n=1:total_users-1;
g_i_1000 =power(abs(user_uav_final_pg_complex(n) + h_iRu_1000(n)),2);
%g_i =power(abs( h_iRu(n)),2);
%g_i =power(abs(user_uav_final_pg_complex(n)) ,2);

n=1:total_users-1;
g_i_no_ris_1000=power(abs(user_uav_final_pg_complex(n)),2);

%--------------------------------------------------------
% channel gain with RIS
[G_i_1000,sortIdx1000] = sort(g_i_1000,'descend'); 
%G_i=g_i;

% channel gain without RIS
[G_i_no_ris_1000,sortIdx_no_ris1000] = sort(g_i_no_ris_1000,'descend');
%[G_i_no_ris_1000,sortIdx_no_ris1000] = sort(g_i_1000,'descend');
%G_i_no_ris=g_i_no_ris;
%--------------------------------------------------------

db_g_i_ris_1000=10.*log10(G_i_1000); %ris

%--------------
new_db_g_i_ris_1000=mag2db(G_i_1000)./2;
new_db_g_i_no_ris_1000=mag2db(G_i_no_ris_1000)./2;

%% always change that name ! for different bands !
% y900mhz=[new_db_g_i_no_ris_1000(1) new_db_g_i_ris_10(1) new_db_g_i_ris_100(1) new_db_g_i_ris_1000(1); ...
%     new_db_g_i_no_ris_1000(2) new_db_g_i_ris_10(2) new_db_g_i_ris_100(2) new_db_g_i_ris_1000(2); ...
%     new_db_g_i_no_ris_1000(3) new_db_g_i_ris_10(3) new_db_g_i_ris_100(3) new_db_g_i_ris_1000(3);...
%     new_db_g_i_no_ris_1000(4) new_db_g_i_ris_10(4) new_db_g_i_ris_100(4) new_db_g_i_ris_1000(4);...
%     new_db_g_i_no_ris_1000(5) new_db_g_i_ris_10(5) new_db_g_i_ris_100(5)  new_db_g_i_ris_1000(5)];

%% comment
% y900mhz=[new_db_g_i_no_ris_1000(1) new_db_g_i_ris_10(1) new_db_g_i_ris_100(1) new_db_g_i_ris_1000(1); ...
%     new_db_g_i_no_ris_1000(2) new_db_g_i_ris_10(2) new_db_g_i_ris_100(2) new_db_g_i_ris_1000(2); ...
%     new_db_g_i_no_ris_1000(3) new_db_g_i_ris_10(3) new_db_g_i_ris_100(3) new_db_g_i_ris_1000(5);...
%     new_db_g_i_no_ris_1000(4) new_db_g_i_ris_10(4) new_db_g_i_ris_100(4) new_db_g_i_ris_1000(4);...
%     new_db_g_i_no_ris_1000(5) new_db_g_i_ris_10(5) new_db_g_i_ris_100(5)  new_db_g_i_ris_1000(3)];

y900mhz = [new_db_g_i_no_ris_1000(1) new_db_g_i_ris_10(1) new_db_g_i_ris_100(1) new_db_g_i_ris_1000(1); ...
           new_db_g_i_no_ris_1000(2) new_db_g_i_ris_10(2) new_db_g_i_ris_100(2) new_db_g_i_ris_1000(2); ...
           new_db_g_i_no_ris_1000(3) new_db_g_i_ris_10(3) new_db_g_i_ris_100(3) new_db_g_i_ris_1000(3); ...
           new_db_g_i_no_ris_1000(4) new_db_g_i_ris_10(4) new_db_g_i_ris_100(4) new_db_g_i_ris_1000(4); ...
           new_db_g_i_no_ris_1000(5) new_db_g_i_ris_10(5) new_db_g_i_ris_100(5) new_db_g_i_ris_1000(5)];

figure(1); clf;

% original tvt
%width = 1500;  % Width in pixels
%height = 480; % Height in pixels %460mmWave
% ---------------
width = 1500;  % Width in pixels
height = 480; % Height in pixels %460mmWave
set(gcf, 'Position', [100, 100, width, height]);

b = bar(y900mhz);
hold on;
grid on;
grid minor;
b(1).BarWidth = 0.35;
%b(1).BaseValue = -110; %sub6GHz
b(1).BaseValue = -130; %mmWave
set(gca, 'FontSize', 25);
legend('NO RIS', '10 elements on RIS', '100 elements on RIS', '1000 elements on RIS', 'FontSize', 25, 'Location', 'northeast');
xlabel('User''s index', 'FontSize', 25);
ylabel('Path Gain [dB]', 'FontSize', 25);

hLegend = findobj(gcf, 'Type', 'Legend');
set(hLegend, 'Orientation', 'horizontal', 'Location', 'northeast','FontSize', 25);

numGroups = size(y900mhz, 1);
numBars = size(y900mhz, 2);
groupWidth = 0.2;

for i = 1:numBars
    x = (1:numGroups) - groupWidth/2 + (i-1) * groupWidth - 0.2;
    yval = y900mhz(:, i);
    
    for j = 1:numGroups
        value = round(yval(j), 2);
        xpos = x(j);
        ypos = yval(j);
        text(xpos, ypos, sprintf('%.2f', value), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', ...
            'FontSize', 22, 'Color', 'black', 'FontWeight', 'bold', 'Rotation', -45);
        % Add a dot at the top center of each bar
        % Add a dot at the top center of each bar
        %dotX = x(j);
        %dotY = yval(j) ; % Adjust the vertical position of the dot as desired
        %plot(dotX, dotY, 'k.', 'MarkerSize', 10);
    end
end

xticks(1:numGroups);
xticklabels({'1', '2', '3', '4', '5'});

hold off;

set(gcf,'renderer','Painters'); % set the renderer
exportgraphics(gcf,'path_gain_mmwave_v2.eps','BackgroundColor','none','ContentType','vector') % export the figure to a vector graphics file

%%save('900mhz_comparison_path_gains.mat',"y900mhz");

%b2 = bar(new_db_g_i_ris);
%b2.BaseValue = -140; hold off;


%{
figure(3);
for i=1:1: max(sortIdx)
    y_new=[new_db_g_i_no_ris(i) new_db_g_i_ris(i)];
    b=bar(y_new);
hold on;
grid on;
grid minor;
b(1).BarWidth = 0.25;
b(1).BaseValue = -120;
end
%}
%semilogy(,y)
%}

%%{
% ----- * RESOURCE ALLOCATION * -----
syms x; %transmission power of user i

total_users=5;

%--------------------------CONSTANT PARAMETERS-----------------------------
%W =10*10^6;%bandwidth (in [Hz] in accordance with the Shannon Capacity formula) %1.08*10^6
%noise variance (-130dBm) (-13) // {-120, -15, -18}
W =5*10^6; %test for rr1
% W =30*10^6;

% a_value=0.2;
% M_value= 3; 
% sigma_square=10^(-22);

%--parameters that control the curve a,M--
%% --- low band - 900 MHz ---
%  a_value=0.3; 
%  M_value= 3; %10; 
%  sigma_square=10^(-12);

%% --- mid band - sub 6GHz ---
%  a_value=0.3;
%  M_value= 3; 
%  sigma_square=10^(-14); %-14

%% --- high band - 28 GHz ---
% a_value=0.3; 
% M_value= 3; 
% a_value=5.15; 
% M_value= 80; 
% sigma_square=10^(-12); %-16 mmwave

a_value=20; 
M_value= 80; 
sigma_square=2*10^(-14); %-16 mmwave

%%
ite=0; %iteration index (1)
max_power=0.2;

x_vals = linspace(10^(-5),max_power,2000); %interval of feasible transmission powers

%each user selects and transmits with a randomly selected feasible uplink transmission power
val = floor(log10(max_power - 10^(-5)));  
power_vector = unifrnd(10^(-5)-(10^val)*eps, max_power+(10^val)*eps, total_users, 1);
power_vector1=power_vector;
%G_i=G_i_100;

G_i_temp = [ G_i_10, G_i_100, G_i_1000];

% debug fr3 paper
% G_i_temp = 1.0e-06 * [
%      0.1659    0.1659    0.1656  ;   
%     0.3337    0.3337    0.3330   ;  
%     0.2613    0.2613    0.2604   ;  
%     0.3948    0.3948    0.3934  ;  
%     0.1249    0.1249    0.1245 
% ];

for i=1:1:3
    G_i=G_i_temp(:,i);
    convergence=0;
    while convergence==0
        for n=1:total_users
            [U_i,SNIR]=USER_UTILITY(n, x, G_i, power_vector, W, sigma_square, a_value, M_value); %utility function of each user i
           [R_i]=USER_RATE(n, x, G_i, power_vector, W, sigma_square, a_value, M_value); 
            %the UAV "imposes" a minimum transmission power on the user i,
           % necessary for SIC decoding
            P_min=NOMA_optimization(n, G_i, power_vector, sigma_square);
            %disp(P_min); 
            x_vals2 = linspace(P_min,max_power,2000);
           % disp(x_vals2);
            U_i_vals = double( subs(U_i, x, x_vals2) ); %convert sym2double
            R_i_vals = double( subs(R_i, x, x_vals2) ); 
            maxF = max(U_i_vals);  %find the maximum value of the utility function of each user
            indexOfFirstMax = find(U_i_vals == maxF, 1, 'first');  %find the power that maximizes the utility function of each user i
            % Get the x and y values at that index i.e. x=Pi and y=maxUi 
             maxUi(n) = U_i_vals(indexOfFirstMax); 
             maxRi(n) = R_i_vals(indexOfFirstMax); %maximum transmission rate
             Pi(n) = x_vals2(indexOfFirstMax); 
            SNIR_vals(n)=double(subs(SNIR, x, Pi(n)));
        end
    
        count=0;
        for n=1:1:total_users
            if (abs(power_vector(n)-Pi(n))<1.0e-04)
                count=count+1;%disp(SNIR_vals);
               % disp('here');
            end
        end
    
        if count==total_users
            convergence=1; 
        end
    
        power_vector=transpose(vpa(Pi));
     
        %disp(ite);
        ite=ite+1;
    end
   powers(:,i)=power_vector;
   utilities(:,i)=maxUi;
end

%---------------------------------------------------
G_i2=G_i_no_ris_10;
ite2=0; %iteration index
power_vector2=power_vector1; %the same initilization for the case without RIS
convergence2=0;
while convergence2==0
    for n=1:total_users
        [U_i2,SNIR2]=USER_UTILITY(n, x, G_i2, power_vector2, W, sigma_square, a_value, M_value); %utility function of each user i
        [R_i2]=USER_RATE(n, x, G_i2, power_vector2, W, sigma_square, a_value, M_value);
        %the UAV "imposes" a minimum transmission power on the user i,
        %necessary for SIC decoding
        P_min2=NOMA_optimization(n, G_i2, power_vector2, sigma_square); %disp(P_min);
        x_vals2b = linspace(P_min2,max_power,2000);
        U_i_vals2 = double( subs(U_i2, x, x_vals2b) ); %convert sym2double
        R_i_vals2 = double( subs(R_i2, x, x_vals2b) ); 
        maxF2 = max(U_i_vals2);  %find the maximum value of the utility function of each user
        indexOfFirstMax2 = find(U_i_vals2 == maxF2, 1, 'first');  %find the power that maximizes the utility function of each user i
        % Get the x and y values at that index i.e. x=Pi and y=maxUi 
        maxUi2(n) = U_i_vals2(indexOfFirstMax2); 
        maxRi2(n) = R_i_vals2(indexOfFirstMax2); %maximum transmission rate
        Pi2(n) = x_vals2b(indexOfFirstMax2); 
        SNIR_vals2(n)=double(subs(SNIR2, x, Pi2(n)));
    end

    count2=0;
    for n=1:1:total_users
        if (abs(power_vector2(n)-Pi2(n))<1.0e-04)
            count2=count2+1;
        end
    end

    if count2==total_users
        convergence2=1; 
    end

    power_vector2=transpose(vpa(Pi2));

    ite2=ite2+1; 
end

% figure(2);
% semilogy(power_vector); hold on; semilogy(power_vector2);
% disp(power_vector2-power_vector); legend('RIS','NO RIS');
% 
% figure(3);
% semilogy(maxUi); hold on; semilogy(maxUi2);
% legend('RIS','NO RIS');


%% comment the following lines, we plot them in separate files
%{
figure(2);
semilogy(power_vector2);
hold on;
semilogy(powers(:,1)); 
hold on; 
semilogy(powers(:,2)); 
hold on;
semilogy(powers(:,3));
xticks([1 2 3 4 5]);
legend('NO RIS', '10 elements on RIS', '100', '1000 elems');

figure(3);
semilogy(maxUi2);
hold on;
semilogy(utilities(:,1)); 
hold on; 
semilogy(utilities(:,2)); 
hold on;
semilogy(utilities(:,3));
yticks([10^6 10^8 10^10 10^11]);
xticks([1 2 3 4 5]);
legend('NO RIS', '10 elements on RIS', '100', '1000 elems');
%}
%save('metrics_sub6ghz.mat','utilities','powers','power_vector2','maxUi2');
%save('metrics_sub6ghz_minus16_noise.mat','utilities','powers','power_vector2','maxUi2');

save('metrics_sub6ghz_test.mat','utilities','powers','power_vector2','maxUi2');

%% to install the scenario on Colosseum => relevant info
save('colosseum_scenario_info_highdir.mat',"user_uav_final_pg_complex","h_iRu_10","h_iRu_100","h_iRu_1000");
%}
%save('RA_power_results_1000elems_exp2.mat');

% figure(1);
% semilogy(power_vector);
 disp(power_vector2);  disp(powers);