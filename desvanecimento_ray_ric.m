clear all;
close all;
clc;
%INTERFERFERÊNCIA INTERSIMBÓLICA
%tau = [0 1 2 5]*1e-6; % vetor com atrasos do canal que gera ISI (Interferência Intersimbólica)
%pdb = [-20 -10 -10 0];

Rs = 100e3; % Taxa de transmissão de símbolos
num_bits = 1e6;
t2 = [0:1/Rs:num_bits/Rs-(1/Rs)];

info = randint(1,num_bits,2); % número de transmissão de bits
info_mod = pskmod(info, 2); % modulação em fase (sinal a ser transmitido pelo canal)

k = 1000; % Fator Riciano
t = 1/Rs; % taxa de amostragem do canal
doppler = 300; % espalhamento Doppler (300 Hz)

canal_ray = rayleighchan(t, doppler); % Sem interferência intersimbólica
canal_ric = ricianchan(t, doppler, k); % Sem interferência intersimbólica

canal_ray.StoreHistory = 1;
canal_ric.StoreHistory = 1;

sinal_recv_ray = filter(canal_ray, info_mod);
sinal_recv_ric = filter(canal_ric, info_mod);

ganho_ray = canal_ray.PathGains;
ganho_ric = canal_ric.PathGains;

figure(1)
plot(t2, 20*log10(abs(ganho_ray)))
title('Canal Rayleigh e Rician')
hold on
plot(t2, 20*log10(abs(ganho_ric)))
legend('Rayleigh', 'Rician');

figure(2)
subplot(221)
hist(real(ganho_ray), 100); % Distribuição da parte real
title('Distribuição real do ganho Rayleigh')
subplot(223)
hist(imag(ganho_ray), 100); % Distribuição da parte imaginária
title('Distribuição imaginária do ganho Rayleigh')
subplot(222)
hist(real(ganho_ric), 100); % Distribuição da parte real
title('Distribuição real do ganho Rician')
subplot(224)
hist(imag(ganho_ric), 100); % Distribuição da parte imaginária
title('Distribuição imaginária do ganho Rician')

figure(3)
subplot(221)
hist(abs(ganho_ray), 100); % Distribuição do módulo (alpha h)
title('Distribuição do módulo do ganho Rayleigh')
subplot(223)
hist(angle(ganho_ray), 100); % Distribuição da fase
title('Distribuição da fase do ganho Rayleigh')
subplot(222)
hist(abs(ganho_ric), 100); % Distribuição do módulo (alpha h)
title('Distribuição do módulo do ganho Rician')
subplot(224)
hist(angle(ganho_ric), 100); % Distribuição da fase
title('Distribuição da fase do ganho Rician')

