close all
clc

Rs = 100e3; % Taxa de símbolos da entrada do canal (equivalente a taxa de transmissão)
num_sym = 1e6; % número de símbolos a serem transmitidos

k = 10; % Fator Riciano
t = 1/Rs; % taxa de amostragem do canal
doppler = 300; % espalhamento Doppler (300 Hz)

M = 2;  % ordem da constelação, ordem da modulação. 
        % M = representa a geração de bits. 
        % Para M = 4, cada símbolo representa 2 bits.

info = randint(num_sym, 1, M); % gerando informação a ser transmitida
info_mod = pskmod(info, M); % modulação em fase (sinal a ser transmitido pelo canal)

canal_ray = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação
canal_ric = ricianchan(t, doppler, k);

canal_ray.StoreHistory = 1; % Habilitando a gravação dos ganhos do canal
canal_ric.StoreHistory = 1;

sinal_recv_ray = filter(canal_ray, info_mod); % Representa o ato de transmitir o sinal modulado por um meio sem fio
sinal_recv_ric = filter(canal_ric, info_mod);

ganho_ray = canal_ray.PathGains; % Salvando os ganhos do canal
ganho_ric = canal_ric.PathGains;

% O ruído branco é gerado no receptor
for SNR = 0:30 % ruído de 0 a 30 db
    sinalRx_ray_awgn = awgn(sinal_recv_ray, SNR); % Modelando a inserção do ruído branco no sinal recebido
    sinalRx_ric_awgn = awgn(sinal_recv_ric, SNR);
    sinal_equalizado_ray = sinalRx_ray_awgn./ganho_ray; % Equalizando os efeitos de rotação de fase e alteração de amplitude do sinal recebido
    sinal_equalizado_ric = sinalRx_ric_awgn./ganho_ric;
    sinal_demodulado_ray = pskdemod(sinal_equalizado_ray, M); % Demodulando o sinal equalizado
    sinal_demodulado_ric = pskdemod(sinal_equalizado_ric, M);
    [num_erros_ray(SNR+1), taxa_ray(SNR+1)] = symerr(info, sinal_demodulado_ray); % Comparando a sequência de informação gerada com a informação demodulada
    [num_erros_ric(SNR+1), taxa_ric(SNR+1)] = symerr(info, sinal_demodulado_ric);
end

semilogy([0:30], taxa_ray, [0:30], taxa_ric);
title('Desempenho de BER vs SNR')
legend('Rayleigh', 'Rician');
grid on