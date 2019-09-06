clear all;
close all;
clc;

% Questão 4.25 página 121, Rappaport

Po = 0;             % Potencia recebida na distância d0
n = 4;              % Expoente de perda
d0 = 1;
desvio_padrao = 6;
P_r_min = -118;
P_r_Ho = -112;

d2 = [1600:-1:0];   % Distância até a segunda antena
d1 = 1600-d2;       % Distância até a primeira antena

mx1 = Po - 10*n*log10(d1/d0);   % Média da Potência média da área local (primeira antena) (dB)
mx2 = Po - 10*n*log10(d2/d0);   % Média da Potência média da área local (segunda antena)

Pr_P_r_Ho = qfunc((mx1 - P_r_Ho)/desvio_padrao); 
Pr_P_r_min = qfunc((P_r_min - mx2)/desvio_padrao);

Pr_transferencia = Pr_P_r_Ho.*Pr_P_r_min; % Probabilidade de que ocorra uma transferência


subplot(121)
plot(d1, mx1); hold on; grid on;
plot(d1, mx2);
hold off;
title('Média da potência média')
legend('BS1', 'BS2')
ylabel('dBm')
xlabel('metros')

% Letra A
subplot(122)
plot(d1, Pr_transferencia);
grid on
title('Probabilidade de transferência')
ylabel('probabilidade')
xlabel('metros')

% Letra B
% d = 1005 metros