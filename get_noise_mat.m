function [noise_mat] = get_noise_mat(config, Sigma_c, A)
%GET_NOISE_MAT returns the measurements model noise matrix

%Sigma_E = kron(eye(config.N), config.sigma_e^2*eye(config.L));
%noise_mat = sqrt(config.var_noise/2)*(randn(config.L,config.N) + 1i*randn(config.L,config.N));

% From Equation (13)
%var_noise = real(trace(A*Sigma_c*A'))/config.L/config.CNR;
var_noise = config.var_noise;
noise_mat = sqrt(var_noise/2)*(randn(config.L,config.N) + 1i*randn(config.L,config.N));
end