function [Ui, SINR] = USER_UTILITY(n, x, G_i, power_vector, W, sigma_square, a_value, M_value)
%     sigma_square=0; disp(sigma_square);
    SINR=(x.*G_i(n))./(sum(G_i(n+1:end).*power_vector(n+1:end))+sigma_square);
    SINR=vpa(SINR);

    f_SINR=vpa(power(1-exp(-a_value.*SINR),M_value));

    %utility function for users
    Ui=vpa(W.*(f_SINR)./x);
end