% ------------------------------------------------------------------------------
% Cognitive Interference Resilient Radar (Cognitive_IRR) 
% Helena Calatrava
%
% June 2023
% ------------------------------------------------------------------------------

%% Initialize Scenario
config = load_config;

%% Build Measurements Model Y

% OFDM weights
% These weights can be updated in the Adaptive Waveform Design (AWD) module
A = eye(config.L); % LxL complex diagonal matrix ontaining the transmitted weights

% Complex coefficients
X_t = diag(get_coeff('target', config)); % LxL complex diagonal matrix repressenting the scattering coefficients (target)
X_c = diag(get_coeff('clutter', config)); % LxL complex diagonal matrix repressenting the scattering coefficients (clutter)

% Doppler information
Phi_c = ones(config.L, config.N); % LxN matrix containing the Doppler information (clutter)
% Phi_c is an all-ones matrix given that the clutter is considered to be static
Phi_t = get_doppler_mat(config); % LxN matrix containing the Doppler information through the parameter config.eta (target)

% Measurements model noise
% e(t) accounts for the measurement noise and co-channel interference (CCI)
E = get_noise_mat(config); % LxN measurements model noise matrix

% Build the measurements
Y = A*X_t*Phi_t + A*X_c*Phi_c + E;
