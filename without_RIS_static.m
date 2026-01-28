clc; clear all; close all;

%************************** Scenario Description **************************
% In this scenario, we consider 5 static users and a UAV hovering at a
% certain height. For the generation of the channels we use the QuaDRiGa 
% channel generator. 
%**************************************************************************

% The channel is stochastic, so in order to deduce a clear trend about the
% links, we use Monte Carlo Simulations, therefore we average the achieved
% path gains of the links considered, over a 100 different channel realizations. 
%**************************************************************************

% The input of (the 5) static users coordinates is read from a Microsoft Excel
% file. All entries are Cartesian Coordinates. The 1st entry corresponds to 
% the location of the UAV. The 5 next entries correspond to the locations
% of the static users (which correspond to static vehicles, probably parked
% vehicles in a parking lot or parked at the side of a highway, or cars at different
% vicinities, i.e. New York environment, urban and densely populated). The
% entries are in the form: x_coord, y_coord, z_coord, with z representing
% the height of our nodes.

sim_runs=100;  % number of Monte Carlo simulations (i.e. 100)

for k=1:1:sim_runs
    disp(k);
    [pos] = xlsread('static_5_positions_UAV.xlsx');

%% sub-6 ghz
    %max d_cov
%     pos(6,2)=1000;
%     pos(6,1)=2340;
% 
%     pos(6,2)=500;
%     pos(6,1)=458;

%     pos(6,2)=832;
%     pos(6,1)=1000;

%     pos(6,2)=1000;
%     pos(6,1)=1641;

%  pos(2:end,2)=500;
%  pos(2:end,1)=458;

%       pos(6,2)=150;
%       pos(6,1)=150;

% pos(2:end,2)=108;
% pos(2:end,1)=110;

%% mmwave

% pos(6,2)=700;
% pos(6,1)=700;

    %pos(1,3)=120;
    s=qd_simulation_parameters;
    %s.center_frequency=5915e6;
    % layout setup
    l = qd_layout(s);  
    % l.tx_array=qd_arrayant('3gpp-mmw');%, 100, 0.5 , 10);
    % l.rx_array=qd_arrayant('3gpp-mmw');% 100, 0.5 , 10);
    l.update_rate=0.1;                                 % resolution, observe the channel every 0.1 seconds 
  %l.simpar.center_frequency = 5915e6;                % test different frequency bands
   %l.simpar.center_frequency = 28e9;
   l.simpar.center_frequency = 2e9;
  %  l.simpar.center_frequency = 900e6;   
    l.simpar.use_absolute_delays = 1;                  % Enables true LOS delay
    l.name='Urban Macro-Cell​ Environment';             % densely populated urban area
    l.no_tx=size(pos,1);
    l.no_rx=l.no_tx;

    % set-up of the scenarios
    % * 3GPP_38.901_UMi - 3GPP NR Urban Macro-Cell​ NLOS SCENARIO *
    NLOS='3GPP_38.901_UMa_NLOS';
    %NLOS='BERLIN_UMa_NLOS';
    %NLOS='WINNER_UMa_C2_NLOS';
    % ******************************

    for i=1:1:l.no_tx
        l.tx_track(1,i) = qd_track( 'linear' , 0, [] ); 
        l.tx_track(1,i).initial_position = [pos(i,1); pos(i,2); pos(i,3)];   
        l.tx_track(1,i).name=num2str(i);
        l.tx_track(1,i).no_segments = l.tx_track(1,i).no_snapshots;
    end

    for i=1:1:l.no_rx
        l.rx_track(1,i) = qd_track( 'linear' , 0, [] );  
        l.rx_track(1,i).initial_position = [pos(i,1)+power(10,-8); pos(i,2)+ power(10,-8); pos(i,3)]; 
        l.rx_track(1,i).name=num2str(i);
        l.rx_track(1,i).scenario=NLOS;
        l.rx_track(1,i).no_segments = l.rx_track(1,i).no_snapshots;
    end

    b = l.init_builder;  
    
    for i=1:1:size(b,2)
        b(1,i).scenpar.PerClusterDS = 0;   % Disable per-cluster delay spread for the 3gpp scenario
        %b(1,i).scenpar.KF_mu = -1000;      % decrease los power (-40)
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
        if isequal(c(1,i).name ,'3GPP-38.901-UMa-NLOS_2_1')   % 2 -> 1
           index=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMa-NLOS_3_1')   % 3 -> 1  
           index2=i;
        end
       
        if isequal(c(1,i).name ,'3GPP-38.901-UMa-NLOS_4_1')   % 4 -> 1 
           index3=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMa-NLOS_5_1')   % 5 -> 1  
           index4=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMa-NLOS_6_1')   % 6 -> 1    
           index5=i;
        end

        link_names{i}=c(1,i).name;                         % save link name
    
    end

end

for k=1:1:sim_runs
    for i=1:1:runs
        % path gain is the link path gain for every link, for every
        % realization
        path_gain(k,i)=sum(mc_path_power{k,i},2);
        %toa_col(k,i)=sum(mc_toa{k,i},2);
        toa_col(k,i)=max(mc_toa{k,i});

    end
end


% mc_path_gain contains the final complex value for the generated paths
% which is a coherent summation of all the MPC components
mc_path_gain=sum(path_gain,1)./sim_runs;
mc_toa_col=sum(toa_col,1)./sim_runs;

% Db representation
Db_mc_path_gain= 10.*log10(power(abs(mc_path_gain),2));

%barplot(Db_mc_path_gain(1,7))

%{
% Plot the Topology
set(0,'DefaultFigurePaperSize',[14.5 7.7]);
l.visualize([],[],0);
view(-33,60);
%}

%{
y=[Db_mc_path_gain(7) Db_mc_path_gain(13) Db_mc_path_gain(19) Db_mc_path_gain(25) Db_mc_path_gain(31)];
bar(y);
%}

% _______________________________________________________________________________________________________________________
% we keep the complex final values for the gains between the users and the
% uav
user_uav_final_pg_complex =[ mc_path_gain(7) mc_path_gain(13) mc_path_gain(19) mc_path_gain(25) mc_path_gain(31)];
user_uav_final_pg_complex=transpose(user_uav_final_pg_complex);

% results in dB
db=10.*log10(power(abs(user_uav_final_pg_complex),2));
% _______________________________________________________________________________________________________________________

% save mat files
total_users=l.no_tx;

ra_input_path_gain=[];
for i=1:1:sim_runs
   ra_input_path_gain(i,:)= [path_gain(i,index); path_gain(i,index2); path_gain(i,index3); path_gain(i,index4); path_gain(i,index5)];
end

%% input to the RA algorithm
ra_input_path_gain=power(abs(ra_input_path_gain),2);
ra_input_path_gain_without_RIS=transpose(ra_input_path_gain);

%% save the mat file
save('user_to_UAV_sub2.mat', "total_users", "user_uav_final_pg_complex","ra_input_path_gain_without_RIS");
% save number of users, averaged path gains, path gains per realization
% installation on colosseum 
%save('colosseum_just_uav.mat',"mc_path_gain","mc_toa_col","pos");