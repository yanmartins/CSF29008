clear all;
close all;
clc;

%INTERFERFERÊNCIA INTERSIMBÓLICA
%tau = [0 1 2 5]*1e-6; % vetor com atrasos do canal que gera ISI (Interferência Intersimbólica)
%pdb = [-20 -10 -10 0];

Rs = 100e3; % Taxa de transmissão de símbolos
num_bits = 1e5;
t2 = [0:1/Rs:num_bits/Rs-(1/Rs)];

info = randint(1,100000,2); % número de transmissão de bits
info_mod = pskmod(info, 2); % modulação em fase (sinal a ser transmitido pelo canal)

t = 1/10000; % taxa de amostragem do canal
doppler = 30; % espalhamento Doppler (30 Hz)

%canal = rayleighchan(t, doppler, tau, pdb); % Com interferência intersimbólica
canal = rayleighchan(t, doppler); % Sem interferência intersimbólica
canal.StoreHistory = 1;
sinal_recv = filter(canal, info_mod);

ganho = canal.PathGains;

figure(1)
subplot(211)
hist(real(ganho), 100); % Distribuição da parte real
title('Distribuição real do ganho')
subplot(212)
hist(imag(ganho), 100); % Distribuição da parte imaginária
title('Distribuição imaginária do ganho')

figure(2)
subplot(211)
hist(abs(ganho), 100); % Distribuição do módulo (alpha h)
title('Distribuição do módulo do ganho')
subplot(212)
hist(angle(ganho), 100); % Distribuição da fase
title('Distribuição da fase do ganho')

figure(3)
plot(t2, 20*log10(abs(ganho)))
title('Canal')
%plot(canal);