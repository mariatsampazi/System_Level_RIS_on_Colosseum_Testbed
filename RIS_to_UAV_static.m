clc; clear all; close all;

% * Scenario Description *
% In this scenario, we describe the links between the RIS and the UAV.

sim_runs=100;  % number of Monte Carlo simulations (i.e. 100)

x_i=[];

for k=1:1:sim_runs
    disp(k); 
    [pos] = xlsread('static_5_positions_RIS_to_UAV.xlsx');
    % layout setup
    l = qd_layout;  
    l.update_rate=0.1;                                 % resolution, observe the channel every 0.1 seconds 
    % l.tx_array=qd_arrayant('3gpp-');%, 100, 0.5 , 10);
    % l.rx_array=qd_arrayant('3gpp');%,100, 0.5 , 10);
  % l.simpar.center_frequency = 5915e6;    
  l.simpar.center_frequency = 28e9; 
%   l.simpar.center_frequency = 900e6;
    l.simpar.use_absolute_delays = 1;                  % Enables true LOS delay
    l.name='Urban Macro-Cell​ Environment';             % densely populated urban area
    l.no_tx=size(pos,1);
    l.no_rx=l.no_tx;

    % set-up of the scenarios
    % * 3GPP_38.901_UMi - 3GPP NR Urban Micro-Cell​ LOS SCENARIO *
    LOS='3GPP_38.901_UMa_LOS';
    %LOS='WINNER_UMa_C2_LOS';
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
        %b(1,i).scenpar.KF_mu = 3; 
        %b(1,i).plpar=[];
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
        
        % I care about the link between the RIS and the UAV
        if isequal(c(1,i).name ,'3GPP-38.901-UMa-LOS_1_2')   % 1 -> 2
           index=i;
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

%Db_mc_path_gain= 10.*log10(power(abs(mc_path_gain),2));

% Introducing the RIS to enhance the Path Gains of the links regarding RIS'
% elements "communication" with the UAV

% coordinates of the users and the RIS
x_i=transpose(x_i); y_i=transpose(y_i); z_i=transpose(z_i);
x_R=x_i(1); y_R=y_i(1); z_R=z_i(1); %RIS
x_u=x_i(2); y_u=y_i(2); z_u=z_i(2); %UAV

%distance between the RIS' 1st element and the UAV
d_Ru = power((z_R-z_u)^2+(x_R-x_u)^2+(y_R-y_u)^2, 1/2);

%approximately signal's cosine of AoA from the RIS's 1st element to the UAV
phi_Ru = (x_R - x_u)/ d_Ru;



% Official Introducing the RIS into the channel 
% we calculate the path gains and we multiply them with the steering vector
% of the RIS

%----------channel gain between the RIS's 1st element and the UAV----------

% Number of reflecting elements

% Number of reflecting elements

%% 10 reflecting elems
M=10;
users=5;
h_Ru_array_response_10 = zeros(users,M);
for n=1:users
    for m=1:M
        h_Ru_array_response_10(n,m)=exp(-1j*pi*(m-1)*phi_Ru);
    end
end
h_Ru_total_10 = abs(mc_path_gain(1,2)).*h_Ru_array_response_10;

%% 100 reflecting elems
M=100;
users=5;
h_Ru_array_response_100 = zeros(users,M);
for n=1:users
    for m=1:M
        h_Ru_array_response_100(n,m)=exp(-1j*pi*(m-1)*phi_Ru);
    end
end
h_Ru_total_100 = abs(mc_path_gain(1,2)).*h_Ru_array_response_100;

%% 1000 reflecting elems
M=1000;
users=5;
h_Ru_array_response_1000 = zeros(users,M);
for n=1:users
    for m=1:M
        h_Ru_array_response_1000(n,m)=exp(-1j*pi*(m-1)*phi_Ru);
    end
end
h_Ru_total_1000 = abs(mc_path_gain(1,2)).*h_Ru_array_response_1000;

%h_Ru_total=mc_path_gain(1,2);

%% save the mat file
save('RIS_to_UAV_new_format.mat', "d_Ru","h_Ru_total_10","h_Ru_total_100","h_Ru_total_1000");

%% for colosseum
save('ris_to_uav_col.mat',"mc_toa_col");

%{
% Plot the Topology
set(0,'DefaultFigurePaperSize',[14.5 7.7]);
l.visualize([],[],0);
view(-33,60);
%}
%db=10.*log10(power(abs(mc_path_gain(1,2)),2))