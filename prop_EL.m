clear all
close all
clc

% PROPAGAÇÃO ESPAÇO LIVRE
% Estimativa de potência

d = [1:1:500e3];   % distância
Pt_dBm = 14;        % potência transmitida
Gt_dBi = 2.55;      % ganho transmissor
Gr_dBi = 2.55;      % ganho receptor
L_db = 6;           % perdas
fc = 915e6;         % frequência portadora

lambda = 3e8/fc;
Pt = 10^(Pt_dBm/10)*1e-3;
Gt = 10^(Gt_dBi/10);
Gr = 10^(Gr_dBi/10);
L = 10^(L_db/10);

Pr = (Pt*Gt*Gr*(lambda^2))./((4*pi)^2*(d.^2)*L);   % potência recebida

Pr_dBm = 10*log10(Pr./1e-3);

% Pr_dBm(x), onde x é o valor da distâcia em quilômetros
% A visualização dos dados é mais viável em dB

semilogx(d,Pr_dBm)  % exibe em escala logaritmica