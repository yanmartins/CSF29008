clear all;
close all;
clc;

Rs = 10e3; % Taxa de transmissão de símbolos

info = randint(1, 10000);   % número de transmissão de bits
info_mod = pskmod(info, 2);     % modulação em fase (sinal a ser transmitido pelo canal)

k = 1000;       % Fator Riciano
t = 1/Rs;       % taxa de amostragem do canal
doppler = 10;   % espalhamento Doppler (10 Hz)

canal_ray1 = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação
canal_ray2 = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação
canal_ray3 = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação
canal_ray4 = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação
canal_ray5 = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação
canal_ray6 = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação

canal_ray1.StoreHistory = 1;
canal_ray2.StoreHistory = 1;
canal_ray3.StoreHistory = 1;
canal_ray4.StoreHistory = 1;
canal_ray5.StoreHistory = 1;
canal_ray6.StoreHistory = 1;

sinal_recv_ray1 = filter(canal_ray1, info_mod);
sinal_recv_ray2 = filter(canal_ray2, info_mod);
sinal_recv_ray3 = filter(canal_ray3, info_mod);
sinal_recv_ray4 = filter(canal_ray4, info_mod);
sinal_recv_ray5 = filter(canal_ray5, info_mod);
sinal_recv_ray6 = filter(canal_ray6, info_mod);

ganho_ray1 = canal_ray1.PathGains;
ganho_ray2 = canal_ray2.PathGains;
ganho_ray3 = canal_ray3.PathGains;
ganho_ray4 = canal_ray4.PathGains;
ganho_ray5 = canal_ray5.PathGains;
ganho_ray6 = canal_ray6.PathGains;

ganho_equivalente = max(ganho_ray1, ganho_ray2);
ganho_equivalente = max(ganho_equivalente, ganho_ray3);
ganho_equivalente = max(ganho_equivalente, ganho_ray4);
ganho_equivalente = max(ganho_equivalente, ganho_ray5);
ganho_equivalente = max(ganho_equivalente, ganho_ray6);

figure(1)
plot(20*log10(abs(ganho_ray1)))
title('Diversidade do canal')
hold on
plot(20*log10(abs(ganho_ray2)))
plot(20*log10(abs(ganho_ray3)))
plot(20*log10(abs(ganho_ray4)))
plot(20*log10(abs(ganho_ray5)))
plot(20*log10(abs(ganho_ray6)))
plot(20*log10(abs(ganho_equivalente)), '--k', 'LineWidth', 2)
legend('Rayleigh1', 'Rayleigh2', 'Rayleigh3', 'Rayleigh4', 'Rayleigh5', 'Rayleigh6', 'Ganho equivalente');
hold off