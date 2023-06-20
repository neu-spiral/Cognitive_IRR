function [coefficients, Sigma_c] = get_coeff(source, config)
%GET_COEFF returns the Lx1 complex vector representing the scattering
%coefficients of the target or clutter

if strcmp(source,'target')
    % Generate target coefficients to build X_t
    coefficients = sqrt(config.varX/2)*(randn(config.L,1) + 1i*randn(config.L,1));

else % strcmp(source,'clutter')
    % Generate clutt er coefficients to build X_c

    R_aux = randn(config.L) + 1i*randn(config.L);
    R = R_aux'*R_aux;

    L = chol(R);
    coefficients = L'*(randn(config.L,1) + 1i*randn(config.L,1))/sqrt(2);
    Sigma_c = R;
end