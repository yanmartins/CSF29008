close all
clear all
clc

Rs = 10e3;     % Taxa de símbolos da entrada do canal (equivalente a taxa de transmissão)

t = 1/Rs;       % Taxa de amostragem do canal
doppler = 10;   % Espalhamento Doppler (10 Hz)

SNR_min = 0;
SNR_max = 25;

M = 2;  % Ordem da constelação, ordem da modulação. 
        % M = representa a geração de bits. 
        % Para M = 4, cada símbolo representa 2 bits.

info = randint(10000, 1);   % número de transmissão de bits
info_mod = pskmod(info, M); 

canal_ray1 = rayleighchan(t, doppler); % Gerando o sinal que representa o canal de comunicação
canal_ray2 = rayleighchan(t, doppler);

canal_ray1.StoreHistory = 1; % Habilitando a gravação dos ganhos do canal
canal_ray2.StoreHistory = 1;

sinal_recv_ray1 = filter(canal_ray1, info_mod); % Representa o ato de transmitir o sinal modulado por um meio sem fio
sinal_recv_ray2 = filter(canal_ray2, info_mod);

ganho_ray1 = canal_ray1.PathGains; % Salvando os ganhos do canal
ganho_ray2 = canal_ray2.PathGains;

for SNR = SNR_min:SNR_max
    sinalRx_ray1_awgn = awgn(sinal_recv_ray1, SNR); % Modelando a inserção do ruído branco no sinal recebido
    sinalRx_ray2_awgn = awgn(sinal_recv_ray2, SNR);
    
    sinal_equalizado_ray1 = sinalRx_ray1_awgn./ganho_ray1;
    sinal_equalizado_ray2 = sinalRx_ray2_awgn./ganho_ray2;
    
    for t_aux = 1:length(info_mod)
        if abs(ganho_ray1) >= abs(ganho_ray2)
            sinal_demod(t_aux) = pskdemod(sinal_equalizado_ray1(t_aux), M);
        else
            sinal_demod(t_aux) = pskdemod(sinal_equalizado_ray2(t_aux), M);
        end
    end
    [num_erros(SNR+1), taxa(SNR+1)] = biterr(info, sinal_demod);
end

semilogy(SNR_min:SNR_max, taxa);
title('Desempenho de BER vs SNR')
xlabel('SNR [dB]')
ylabel('BER')
legend('h1', 'h2');
grid on