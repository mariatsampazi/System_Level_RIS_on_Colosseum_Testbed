clc; clear all; close all;

% * Scenario Description *
% In this scenario, we describe the links betwenn the (static) users and
% the RIS. We assume that all the links are LOS, therefore the users can
% see the RIS. In this -LOS- link, despite the direct LOS link between the
% users and the RIS, we assume that other NLOS paths exist (MPCs), but at
% least 1 strong LOS MPC exists, as mentioned previously. The RIS has a 
% steering vector which can steer the beam to the desired direction. 
% For the calculation of the path gains between the users and the RIS, we
% multiply the generated path gains through QuaDRiGa, with the steering vector. 
% Therefore, the RIS makes the wireless environment more controllable.

sim_runs=100;%00;  % number of Monte Carlo simulations (i.e. 100)

x_i=[];

for k=1:1:sim_runs
    disp(k);
    [pos] = xlsread('static_5_positions_RIS.xlsx');
%   pos(2:end,2)=0.5;
    % layout setup

%     pos(6,2)=1000;
%     pos(6,1)=2340;

%     pos(6,2)=500;
%     pos(6,1)=458;

%      pos(6,2)=832;
%      pos(6,1)=1000;

%      pos(6,2)=1000;
%      pos(6,1)=1641;

%  pos(2:end,2)=500;
%  pos(2:end,1)=458;

%  pos(2:end,2)=108;
% pos(2:end,1)=110;
% 
%     pos(6,2)=150;
%       pos(6,1)=150;

%% mmwave

% pos(6,2)=700;
% pos(6,1)=700;

    l = qd_layout;  
    l.update_rate=0.1;                                 % resolution, observe the channel every 0.1 seconds 
    % l.tx_array=qd_arrayant('3gpp-3d');%, 100, 0.5 , 10);
    % l.rx_array=qd_arrayant('3gpp-3d');%, 100, 0.5 , 10);
  % l.simpar.center_frequency = 5915e6;
   l.simpar.center_frequency = 28e9;
  %  l.simpar.center_frequency = 5915e6; 
   % l.simpar.center_frequency = 900e6; 
    l.simpar.use_absolute_delays = 1;                  % Enables true LOS delay
    l.name='Urban Macro-Cell​ Environment';             % densely populated urban area
    l.no_tx=size(pos,1);
    l.no_rx=l.no_tx;

    % set-up of the scenarios
    % * 3GPP_38.901_UMi - 3GPP NR Urban Micro-Cell​ LOS SCENARIO *
    LOS='3GPP_38.901_UMa_LOS';
    % ******************************

    for i=1:1:l.no_tx
        l.tx_track(1,i) = qd_track( 'linear' , 0, [] ); 
        l.tx_track(1,i).initial_position = [pos(i,1); pos(i,2); pos(i,3)];  
        x_i(i)=pos(i,1); y_i(i)=pos(i,2); z_i(i)=pos(i,3);
        l.tx_track(1,i).name=num2str(i);
        l.tx_track(1,i).no_segments = l.tx_track(1,i).no_snapshots;
    end

    for i=1:1:l.no_rx
        l.rx_track(1,i) = qd_track( 'linear' , 0, [] );  
        l.rx_track(1,i).initial_position = [pos(i,1)+power(10,-8); pos(i,2)+ power(10,-8); pos(i,3)]; 
        l.rx_track(1,i).name=num2str(i);
        l.rx_track(1,i).scenario=LOS;
        l.rx_track(1,i).no_segments = l.rx_track(1,i).no_snapshots;
    end

    b = l.init_builder;  
    
    for i=1:1:size(b,2)
        b(1,i).scenpar.PerClusterDS = 0;   % Disable per-cluster delay spread for the 3gpp scenario
       % b(1,i).scenpar.KF_mu = 0.005; 
       % b(1,i).plpar=[];
    end
    
    b.gen_parameters;                      % Generate small-scale-fading parameters
    c = get_channels( b );                 % Generate channel coefficients

    snaps = l.rx_track(1,l.no_tx-1).no_snapshots;
    runs=l.no_rx*(l.no_rx+ 2*(snaps-1));
    
    link_names{runs} = [];
    path_power{runs} = [];
    toa{runs} = [];
  
    for i=1:1:runs  
        c(1,i).individual_delays=0;                         % Remove per-antenna delays
        dl = c(1,i).delay.';                                % Extract path delays from the channel
        %pow = squeeze( abs(c(1,i).coeff).^2 )';            % Calculate path powers from the channel
        pow = squeeze( c(1,i).coeff)';  
        disp(strvcat(c(1,i).name));                         % display link name
        path_power{i}=pow;                                  % save path powers
        mc_path_power(k,:)=path_power;
        toa{i}=dl;                                          % save time of arrival
        mc_toa(k,:)=toa;
        
        % I care about the uplink transmission of the users to the UAV
        if isequal(c(1,i).name ,'3GPP-38.901-UMa-LOS_2_1')   % 2 -> 1
           index=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMa-LOS_3_1')   % 3 -> 1  
           index2=i;
        end
       
        if isequal(c(1,i).name ,'3GPP-38.901-UMa-LOS_4_1')   % 4 -> 1 
           index3=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMa-LOS_5_1')   % 5 -> 1  
           index4=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMa-LOS_6_1')   % 6 -> 1    
           index5=i;
        end

        link_names{i}=c(1,i).name;                         % save link name
    
    end

end

for k=1:1:sim_runs
    for i=1:1:runs
        path_gain(k,i)=sum(mc_path_power{k,i},2);
        toa_col(k,i)=max(mc_toa{k,i});
    end
end

% mc_path_gain contains the final complex value for the generated paths
% which is a coherent summation of all the MPC components
mc_path_gain=sum(path_gain,1)./sim_runs;
mc_toa_col=sum(toa_col,1)./sim_runs;

Db_mc_path_gain= 10.*log10(power(abs(mc_path_gain),2));

% Introducing the RIS to enhance the Path Gains of the links regarding ue's
% communication with the RIS

% coordinates of the users and the RIS
x_i=transpose(x_i); y_i=transpose(y_i); z_i=transpose(z_i);
x_R=x_i(1); y_R=y_i(1); z_R=z_i(1);

%distance between ground user and RIS' 1st element
n=2:1:l.no_tx;
d_iR = power((z_i(n)-z_R).^2 + (x_i(n)-x_R(1)).^2 + (y_i(n)-y_R(1)).^2 ,1./2);

%approximately signal's cosine of AoD ("phi" angle) from the user to the RIS in rads
n=2:1:l.no_tx;
phi_iR = (x_i(n) - x_R(1))./ d_iR;

% Official Introducing the RIS into the channel 
% we calculate the path gains and we multiply them with the steering vector
% of the RIS

% Number of reflecting elements

%% 10 reflecting elems
M=10;
h_iR_LOS_10 = zeros(l.no_tx-1,M);
for n=1:1:l.no_tx-1
    for m=1:M
        h_iR_LOS_10(n,m)=exp(-1j.*pi.*phi_iR(n).*(m-1));
    end
end

ris_mc_path_gain_users_ris=[mc_path_gain(1,7);mc_path_gain(1,13);mc_path_gain(1,19);mc_path_gain(1,25);mc_path_gain(1,31)];
user_ris_final_pg_complex_10= abs(ris_mc_path_gain_users_ris).*h_iR_LOS_10;

%% 100 reflecting elems
M=100;
h_iR_LOS_100 = zeros(l.no_tx-1,M);
for n=1:1:l.no_tx-1
    for m=1:M
        h_iR_LOS_100(n,m)=exp(-1j.*pi.*phi_iR(n).*(m-1));
    end
end

ris_mc_path_gain_users_ris=[mc_path_gain(1,7);mc_path_gain(1,13);mc_path_gain(1,19);mc_path_gain(1,25);mc_path_gain(1,31)];
user_ris_final_pg_complex_100= abs(ris_mc_path_gain_users_ris).*h_iR_LOS_100;

%% 1000 reflecting elems
M=1000;
h_iR_LOS_1000 = zeros(l.no_tx-1,M);
for n=1:1:l.no_tx-1
    for m=1:M
        h_iR_LOS_1000(n,m)=exp(-1j.*pi.*phi_iR(n).*(m-1));
    end
end

ris_mc_path_gain_users_ris=[mc_path_gain(1,7);mc_path_gain(1,13);mc_path_gain(1,19);mc_path_gain(1,25);mc_path_gain(1,31)];
user_ris_final_pg_complex_1000= abs(ris_mc_path_gain_users_ris).*h_iR_LOS_1000;

%user_ris_final_pg_complex=user_ris_final_pg_complex;
%user_ris_final_pg_complex=transpose(user_ris_final_pg_complex);

% results in dB
%db=10.*log10(power(abs(user_ris_final_pg_complex),2));

%% save the mat file
save('user_to_RIS_new_format.mat', "M","user_ris_final_pg_complex_10", "user_ris_final_pg_complex_100","user_ris_final_pg_complex_1000");

%% for colosseum
save('user_to_ris_col.mat',"mc_toa_col");
%{
% Plot the Topology
set(0,'DefaultFigurePaperSize',[14.5 7.7]);
l.visualize([],[],0);
view(-33,60);
%}

%visualize_clusters;
%b(1,6).visualize_clusters;