function [Ri] = USER_RATE(n, x, G_i, power_vector, W, sigma_square, a_value, M_value)
    
    SINR=(x.*G_i(n))./(sum(G_i(n+1:end).*power_vector(n+1:end))+sigma_square);
    SINR=vpa(SINR);

    f_SINR=vpa(power(1-exp(-a_value.*SINR),M_value));

    %user rate in bps
    Ri=vpa(W.*(f_SINR));
end