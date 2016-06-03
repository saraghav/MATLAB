function [frf_mag, frf_phase, frf_freq] = get_frf2(sig_num, sig_den, time, CTorDS)

% if CTorDS == 0, Command Tracking - Linear Y-scale for FRF
% if CTorDS == 1, Dynamic Stiffness - Log Y-scale for FRF

Color_Order = [ 0 0 1 ; % blue
                0 1 0 ; % green
                1 0 0 ; % red
                0 0 0 ]; % black
            
set(groot, 'defaultAxesColorOrder', Color_Order);
plot_spec = '.r';
plot_spec_asymptote = '-.b';
p = 900;

fs=1;    % Sample frequency
T=1/fs;     % Sample Period
f_range = 0.5;   % +/- frequency range ONLY used for plotting
Post_Transient = 0;      %2/T;     % number of samples to skip (can be used to avoid transient)
samples = Post_Transient+1:length(time);  % vector to use samples after 2 second transient

lines = 100;
fb = fs/lines; %base frequency
span = fs/2;  %Frequency span is fixed by sample frequency
overlap = lines/2; % # of samples overlapped for averaging
averages = floor(length(samples)/(lines-overlap))  % # of averages

Ydata = sig_num;
Xdata = sig_den;

% % % FRF Calculation, tfestimate & mscohere have the following functions inpus:
% % % tfestimate(input signal, output signal, window type(window length),
% % % overlap for averaging, # lines for FFT, sample frequency), rectangular
% % % window can also be used
% % [FRF, f] = tfestimate(Xdata,Ydata,hanning(lines),overlap,lines,1/T);
% % [COH, f] = mscohere(Xdata,Ydata,hanning(lines),overlap,lines,1/T);
% % 
% % % Shifting of zero frequency to center of FRF & Coherence array
% % FRF = fftshift(FRF);
% % COH = fftshift(COH);
% % f=f-max(f)/2;
% % 
% % % Plotting of FRF
% % figure(p); p = p+1;
% % plot(f,abs(FRF),'.');
% % ylim([0 2]); xlim([-f_range,f_range]); grid on; hold on;
% % ylabel('I_{uc}(j\omega)/I_{uc}^*(j\omega)'); xlabel('frequency [Hz]');
% % 
% % figure(p); p = p+1;
% % plot(f,(angle(FRF))*180/pi,'.');
% % ylim([-180 180]); xlim([-f_range,f_range]); grid on;hold on;
% % ylabel('phase [deg.]'); xlabel('frequency [Hz]');
% % 
% % figure(p); p = p+1;
% % plot(f,COH,'.');
% % ylim([0 1]); xlim([-f_range,f_range]); grid on; hold on;
% % ylabel('Coherence [-]'); xlabel('frequency [Hz]');

% The following code will calculate FRF for iq/iq_star, which can be compared to the B&K FRF. The mathematics used by the B&K and this matlab script are equivalent
% FRF Calculation for iq/iq_star
[FRF, f] = tfestimate(detrend(Xdata),detrend(Ydata),hanning(lines),overlap,lines,1/T);
[COH, f] = mscohere(detrend(Xdata),detrend(Ydata),hanning(lines),overlap,lines,1/T);

figure(p); p = p+1;
if CTorDS == 0
    semilogx(f,abs(FRF),plot_spec); xlim([1e-4 f_range]); hold on; grid on;
elseif CTorDS == 1
    loglog(f,abs(FRF),plot_spec); xlim([1e-4 f_range]); hold on; grid on;
end

% loglog([0.01 2], K2./(2*pi*[0.01 2]*10), plot_spec_asymptote, 'LineWidth', 1 ); xlim([0.1 1e3]); hold on; grid on;
% loglog([0.5 20], K1*ones(2,1), plot_spec_asymptote, 'LineWidth', 1 ); xlim([0.1 1e3]); hold on; grid on;
% loglog([4 1e4], 2*pi*[4 1e4]*10, plot_spec_asymptote, 'LineWidth', 1 ); xlim([0.1 1e3]); hold on; grid on;

figure(p); p = p+1;
semilogx(f,(angle(FRF))*180/pi,plot_spec); xlim([1e-4 f_range]); hold on; grid on;

figure(p); p = p+1;
semilogx(f,COH,plot_spec); ylim([0 1]); xlim([1e-4 f_range]); hold on; grid on;