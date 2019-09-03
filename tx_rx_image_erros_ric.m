clear all;
close all;
clc;

Rs = 1e3; % Taxa de símbolos da entrada do canal

% Descomentar a linha de acordo com os valores de SNR e Fator Riciano desejados
%SNR = 100; k = 1; % Sem erros
%SNR = 100; k = 1000; % Sem interferência do canal sem fio (linha de visada)
%SNR = 0; k = 1000; % Imagem com erros do ruído (aleatório)
SNR = 10; k = 1; % Imagem com erros em rajadas

t = 1/Rs; % taxa de amostragem do canal
doppler = 4; % espalhamento Doppler (4 Hz)

M = 2;  % ordem da constelação, ordem da modulação. 
        % M = representa a geração de bits. 
        % Para M = 4, cada símbolo representa 2 bits.
        
% Tratando imagem a ser enviada
A = imread('mario.png');
A_serial = reshape(A, 1, (size(A,1)*size(A,2)*size(A,3)));
A_bin = de2bi(A_serial);
A_bin_serial = reshape(A_bin, 1, (size(A_bin,1)*size(A_bin,2)));

info = double(A_bin_serial)';
info_mod = pskmod(info, M); % modulação em fase (sinal a ser transmitido pelo canal)

canal_ric = ricianchan(t, doppler, k); % Gerando o sinal que representa o canal de comunicação
canal_ric.StoreHistory = 1; % Habilitando a gravação dos ganhos do canal
sinal_recv_ric = filter(canal_ric, info_mod); % Representa o ato de transmitir o sinal modulado por um meio sem fio
ganho_ric = canal_ric.PathGains; % Salvando os ganhos do canal

% Recepção da imagem
sinalRx_ric_awgn = awgn(sinal_recv_ric, SNR); % Modelando a inserção do ruído branco no sinal recebido
sinal_equalizado_ric = sinalRx_ric_awgn./ganho_ric; % Equalizando os efeitos de rotação de fase e alteração de amplitude do sinal recebido
sinal_demodulado_ric = pskdemod(sinal_equalizado_ric, M); % Demodulando o sinal equalizado
[num_erros_ric, taxa_ric] = symerr(info, sinal_demodulado_ric) % Comparando a sequência de informação gerada com a informação demodulada

% Tratando imagem recebida
image_rec_ric = uint8(sinal_demodulado_ric)';
image_rec_ric = reshape(image_rec_ric, size(A_bin,1), size(A_bin,2));
image_rec_ric = bi2de(image_rec_ric);
image_rec_ric = reshape(image_rec_ric, size(A,1), size(A,2), size(A,3));

figure(1)
subplot(121)
image(A)
title('Imagem original')
subplot(122)
image(image_rec_ric)
title('Imagem Recebida (Rician)');
