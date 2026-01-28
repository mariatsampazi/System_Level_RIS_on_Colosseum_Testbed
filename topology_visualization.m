clc; clear all; close all;

sim_runs=1;  % number of Monte Carlo simulations (i.e. 100)

for k=1:1:sim_runs
    disp(k);
    [pos] = xlsread('random_static_5_topology_visualization_copy.xlsx');
    % layout setup
    l = qd_layout;  
    l.update_rate=0.1;                                 % resolution, observe the channel every 0.1 seconds 
    l.simpar.center_frequency = 5915e6;                       
    l.simpar.use_absolute_delays = 1;                  % Enables true LOS delay
    l.name='Urban Micro-Cell​ Environment';             % densely populated urban area
    l.no_tx=size(pos,1);
    l.no_rx=l.no_tx;

    % set-up of the scenarios
    % * 3GPP_38.901_UMi - 3GPP NR Urban Micro-Cell​ NLOS SCENARIO *
    NLOS='3GPP_38.901_UMi_NLOS';
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
    
    for i=1:1:size(b,1)
        b(i,1).scenpar.PerClusterDS = 0;   % Disable per-cluster delay spread for the 3gpp scenario
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
        if isequal(c(1,i).name ,'3GPP-38.901-UMi-NLOS_2_1')   % 2 -> 1
           index=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMi-NLOS_3_1')   % 3 -> 1  
           index2=i;
        end
       
        if isequal(c(1,i).name ,'3GPP-38.901-UMi-NLOS_4_1')   % 4 -> 1 
           index3=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMi-NLOS_5_1')   % 5 -> 1  
           index4=i;
        end

        if isequal(c(1,i).name ,'3GPP-38.901-UMi-NLOS_6_1')   % 6 -> 1    
           index5=i;
        end

        link_names{i}=c(1,i).name;                         % save link name
    
    end

end

% Plot the Topology

set(0,'DefaultFigurePaperSize',[14.5 7.7]);
set(gcf, 'Position', [100, 100, 400, 300]);
l.visualize([],[],0);
set(gca,'FontSize',25);
view(-33,60);
