% %% ANALYSIS OF THE SYSTEM CHARACTERISTICS
%  - one single target

%% Initialize scenario
close all,
clear all,
clc,
config = load_config(6); % Load configuration

format long e; % for displaying purposes
%% 

% Configuration
rng('default') % Initialize seed

% Create figure
figure()

% Velocity is unknown, so we maximize the GLRT w.r.t. velocity.
% Nevertheless, we need to calculate the true LOS vector because the 
%received signal is shifted according to the relative Doppler shift along
%the signal path.
LOS_vector = get_LOS_vector(config); % get TRUE LOS vector, to compute the 
% TRUE \beta (true Doppler shift)

% \tau_0 is assumed to be known, so we calculate T_rangecell here
% (we assume that the receiver accurately estimates the TOA)
T_rangecell = sqrt(config.target_dist_east^2 + config.target_dist_north^2)*2/config.c; % roundtrip time

%% Different number of subcarriers    

L_vector = [1,2,3,4,5]; % values of L pqfor which a ROC curve is computed

subplot(2,1,2)

% Loop through different number of subcarriers L
for idx_L = 1:length(L_vector)

    config.L = L_vector(idx_L); % update number of subcarriers
    
    [pfa, pd] = get_ROC_from_config(config, LOS_vector, T_rangecell);
    
    % Plot ROC for this configuration
    semilogx(pfa(:,1), pd(:,1), 'displayname', ['L = ', num2str(L_vector(idx_L))], ...
        'linewidth', 1.5, 'color', config.plot_color(idx_L), ...
        'linestyle', config.plot_linestyle(idx_L));
    hold on,
end

legend('show', 'location', 'southeast')
grid on
% title('ROC')
axis([0 1 0 1])
xlim([0.005, 1]) % same x axis limit as in paper #2
title(['SNR = ', num2str(config.SNR_predefined), ' dB'])
xlabel('FPR P(D=1 | H0)')
ylabel('TPR P(D=1 | H1)')

% %% Different predefined SNR values
% 
% config.L = 2;
% SNR_predefined_vector = [-15, -10, -5]; 
% 
% subplot(2,1,1)
% 
% % Loop through different number of predefined SNR values
% for idx_SNR = 1:length(SNR_predefined_vector)
% 
%     % Generate OFDM measurements
%     config.SNR_predefined = SNR_predefined_vector(idx_SNR); % update number of subcarriers
% 
%     [pfa, pd] = get_ROC_from_config(config, LOS_vector, T_rangecell);
% 
%     % Plot ROC for this configuration
%     semilogx(pfa(:,1), pd(:,1), 'displayname', ['SNR = ', num2str(SNR_predefined_vector(idx_SNR))], ...
%         'linewidth', 1.5, 'color', config.plot_color(idx_SNR), ...
%         'linestyle', config.plot_linestyle(idx_SNR));
%     hold on,
% end
% 
% legend('show', 'location', 'southeast')
% grid on
% % title('ROC')
% axis([0 1 0 1])
% xlim([0.005, 1]) % same x axis limit as in paper #2
% xlabel('FPR P(D=1 | H0)')
% title(['L = ', num2str(config.L), ' subcarriers'])
% ylabel('TPR P(D=1 | H1)')