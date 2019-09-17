clear all
close all
clc
%clear hRicChan hMultipathGain;
%release(hRayChan);
sampleRate500KHz = 5000e3;      % Sample rate of 500K Hz
sampleRate20KHz  = 20e3;        % Sample rate of 20K Hz
maxDopplerShift  = 3;           % Maximum Doppler shift of diffuse components (Hz)
%delayVector = (0:5:15)*1e-6; % Discrete delays of four-path channel (s)
%gainVector  = [0 -3 -6 -9];
delayVector = (0:5:15)*1e-6; % Discrete delays of four-path channel (s)
gainVector  = [0 -30 -20 -20];
SNR = 20;   % ruído
bitsPerFrame = 1000;
hRayChan = comm.RayleighChannel( ...
    'SampleRate',          sampleRate500KHz, ...
    'PathDelays',          delayVector, ...
    'AveragePathGains',    gainVector, ...
    'MaximumDopplerShift', maxDopplerShift, ...
    'RandomStream',        'mt19937ar with seed', ...
    'Seed',                10, ...
    'PathGainsOutputPort', true);

hRayChan.PathDelays = delayVector;
hRayChan.AveragePathGains = gainVector;
hRayChan.MaximumDopplerShift = 5;

% Configure a Constellation Diagram System object to show received signal
hConstDiagram = comm.ConstellationDiagram( ...
    'Name', 'Received Signal After Rayleigh Fading');

numFrames = 5000;

for n = 1:numFrames
    msg = randi([0 3],bitsPerFrame,1);
    modSignal = pskmod(msg, 4);
    %modSignal = step(hMod,msg);
    rayChanOut = step(hRayChan,modSignal);
    rayChanOut = awgn(rayChanOut, SNR);
    % Display constellation diagram for Rayleigh channel output
    step(hConstDiagram,rayChanOut);
end