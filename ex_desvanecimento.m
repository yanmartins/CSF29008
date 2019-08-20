clear all;
close all;
clc;

tau = [0 2 3 5]*1e-6; % vetor com atrasos do canal que gera ISI (Interferência Intersimbólica)
pdb = [0 -10 0 -20];

info = randint(1,100,2);
info_mod = pskmod(info, 2); % modulação em fase

t = 1/10000; % taxa de amostragem do canal
doppler = 30; % espalhamento Doppler (30 Hz)

canal = rayleighchan(t, doppler, tau, pdb);
canal.StoreHistory = 1;
sinal_recv = filter(canal, info_mod);

plot(canal); 