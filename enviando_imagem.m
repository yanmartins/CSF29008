clear all;
close all;
clc;

Rs = 100e3; % Taxa de símbolos da entrada do canal (equivalente a taxa de transmissão)
num_sym = 1e6; % número de símbolos a serem transmitidos

SNR = 10;

k = 100; % Fator Riciano
t = 1/Rs; % taxa de amostragem do canal
doppler = 300; % espalhamento Doppler (300 Hz)

M = 2;  % ordem da constelação, ordem da modulação. 
        % M = representa a geração de bits. 
        % Para M = 4, cada símbolo representa 2 bits.
        

% Tratando imagem a ser enviada
A = imread('mario.png');
subplot(131)
image(A)
title('Imagem original')

A_serial = reshape(A, 1, (size(A,1)*size(A,2)*size(A,3)));
A_bin = de2bi(A_serial);
A_bin_serial = reshape(A_bin, 1, (size(A_bin,1)*size(A_bin,2)));

info = double(A_bin_serial)';
info_mod = pskmod(info, M); % modulação em fase (sinal a ser transmitido pelo canal)

canal_ray = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação
canal_ric = ricianchan(t, doppler, k);

canal_ray.StoreHistory = 1; % Habilitando a gravação dos ganhos do canal
canal_ric.StoreHistory = 1;

sinal_recv_ray = filter(canal_ray, info_mod); % Representa o ato de transmitir o sinal modulado por um meio sem fio
sinal_recv_ric = filter(canal_ric, info_mod);

ganho_ray = canal_ray.PathGains; % Salvando os ganhos do canal
ganho_ric = canal_ric.PathGains;

% Recepção da imagem
sinalRx_ray_awgn = awgn(sinal_recv_ray, SNR); % Modelando a inserção do ruído branco no sinal recebido
sinalRx_ric_awgn = awgn(sinal_recv_ric, SNR);
sinal_equalizado_ray = sinalRx_ray_awgn./ganho_ray; % Equalizando os efeitos de rotação de fase e alteração de amplitude do sinal recebido
sinal_equalizado_ric = sinalRx_ric_awgn./ganho_ric;
sinal_demodulado_ray = pskdemod(sinal_equalizado_ray, M); % Demodulando o sinal equalizado
sinal_demodulado_ric = pskdemod(sinal_equalizado_ric, M);
[num_erros_ray, taxa_ray] = symerr(info, sinal_demodulado_ray) % Comparando a sequência de informação gerada com a informação demodulada
[num_erros_ric, taxa_ric] = symerr(info, sinal_demodulado_ric)

% Tratando imagem recebida
image_rec_ray = uint8(sinal_demodulado_ray)';
image_rec_ric = uint8(sinal_demodulado_ric)';

image_rec_ray = reshape(image_rec_ray, size(A_bin,1), size(A_bin,2));
image_rec_ray = bi2de(image_rec_ray);
image_rec_ray = reshape(image_rec_ray, size(A,1), size(A,2), size(A,3));

image_rec_ric = reshape(image_rec_ric, size(A_bin,1), size(A_bin,2));
image_rec_ric = bi2de(image_rec_ric);
image_rec_ric = reshape(image_rec_ric, size(A,1), size(A,2), size(A,3));

subplot(132)
image(image_rec_ray)
title('Imagem Recebida (Rayleigh)')

subplot(133)
image(image_rec_ric)
title('Imagem Recebida (Rician)')
