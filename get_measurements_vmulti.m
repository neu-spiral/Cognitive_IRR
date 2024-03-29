function [Y, Sigma_c, X_t] = get_measurements_vmulti(config, hypothesis, A, Phi_t, Phi_c)
% ------------------------------------------------------------------------------
% Cognitive Interference Resilient Radar (Cognitive_IRR) 
% Author: Helena Calatrava
% Affiliation: Northeastern University, Boston, United Sates
% Date: July 2023
%
% GET_MEASUREMENTS_VMULTI returns measurements Y as in statistical model from (2)
%
% References:
% 1 - Target Detection in Clutter Using Adaptive OFDM Radar
%     Authors: Satyabrata Sen, Arye Nehorai
% 2 - Adaptive OFDM Radar for Target Detection in Multipath Scenarios
%     Authors: Satyabrata Sen, Arye Nehorai
% ------------------------------------------------------------------------------

% Complex coefficients
% Calculate for H1 (target is present) and H0 (only clutter is present)
% We follow statistical model (2), i.e., clutter coefficients are 0
X_t_H1 = diag(get_coeff('target', config, A, 0)); % LxL complex diagonal matrix repressenting the scattering coefficients (target)
X_t_H0 = zeros(config.L);

% Complex coefficients
if strcmp(hypothesis, 'H1')
    X_t = X_t_H1;
else % strcmp(hypothesis, 'H0')
    X_t = X_t_H0; % all zeros
end

% Get clutter coefficients: following the model in (2), they are all zeros
clutter_coeffs = zeros(config.L,1);
% Build X_c with the computed clutter coefficients
X_c = diag(clutter_coeffs); % LxL complex diagonal matrix repressenting the scattering coefficients (clutter)

% Scale covariance matrix Sigma_c
% Sigma_c is used to get this noise term
% Get scaling factor for Sigma_c
sum_n = 0; % TODO: clean this loop
for n = 1:config.N
    sum_n = sum_n + (A*X_t_H1*Phi_t(:,n))'*(A*X_t_H1*Phi_t(:,n));
end
snr_lin = 10^(config.SNR/10);
alpha = 1/config.N*sum_n/snr_lin;
R_sqrt = (randn(config.L) + 1i*randn(config.L))*(1/sqrt(2));
R = R_sqrt'*R_sqrt;
k = sqrt(alpha/trace(R));
Sigma_c = k^2*R;

%[E, var_noise] = get_noise_mat(config, Sigma_c, A); % LxN measurements model noise matrix
E = get_noise_mat(config, Sigma_c);

% Build the measurements
Y = A*X_t*Phi_t + A*X_c*Phi_c + E;
end