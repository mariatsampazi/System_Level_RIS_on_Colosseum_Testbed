function [P_min] = NOMA_optimization(n, G_i, power_vector, sigma_square)
  %10 dBm sensitivity --> 0.01 Watt
  %p_min is the lowest value of power permitted by the UAV for user transmission
  %p_min=(sum(power_vector(n+1:end).*G_i(n+1:end))+0.01)./G_i(n);
  syms p_min;
  eq=p_min.*G_i(n).*(1./(sigma_square))-sum(power_vector(n+1:end).*(G_i(n+1:end).*(1./(sigma_square))))==0.01;
  P_min = vpasolve(eq,p_min);
  %P_min =vpa(P_min );
  %disp(P_min); 
end