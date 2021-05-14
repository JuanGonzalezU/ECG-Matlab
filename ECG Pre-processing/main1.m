% Código desarrolado por Juan Andrés González Urquijo 14/05/2021.
% Contacto: bioprogramming57@gmail.com
% URL: https://www.youtube.com/channel/UCniIDilqZApfeZ5E3EKZyaA

clc; clear; close all;
%% load ecg
load('ecg.mat')

Fs = 250;
G = 2000;

ecg = ecg/G;
ecg = (ecg - mean(ecg))/std(ecg);
t = (1:1:length(ecg))*(1/Fs);

figure;
plot(t,ecg)
xlim([0 4])
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
title('ECG Dominio del Tiempo')

%% FFT

F = fft(ecg);
F = abs(F);
F = F(1:ceil(end/2));
F = F/max(F);

L = length(F);

f = (1:1:L)*((Fs/2)/L);
figure;
plot(f,F)
xlabel('Frecuencia (Hz)');
ylabel('Mgnitud Normalizada');
title('ECG en Frecuencia');

%% Filtrado FIR

% Caracteristicas del filtro
orden = 200;
limi = 59;
lims = 61;

% Normalizar
limi_n = limi/(Fs/2);
lims_n = lims/(Fs/2);

% Crear filtro
a = 1;
b = fir1(orden,[limi_n lims_n],'stop');

% Filtrar señal
ecg_limpio = filtfilt(b,a,ecg);

figure;
% Graficar Dominio del tiempo --------------------------

% Graficar el ECG sin filtrar
subplot(2,2,1);
plot(t,ecg);
xlim([0 4])
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
title('ECG SIN filtro')

% Graficar el ECG filtrado
subplot(2,2,3);
plot(t,ecg_limpio);
xlim([0 4])
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
title('ECG CON filtro FIR')

% Graficar Dominio de la frecuencia  --------------------


% Graficar el ECG sin filtrar

F = fft(ecg);
F = abs(F);
F = F(1:ceil(end/2));
F = F/max(F);

subplot(2,2,2);
plot(f,F)
xlabel('Frecuencia (Hz)');
ylabel('Magnitud Normalizada');
title('ECG en Frecuencia SIN filtro');


% Graficar el ECG filtrado

F = fft(ecg_limpio);
F = abs(F);
F = F(1:ceil(end/2));
F = F/max(F);

subplot(2,2,4);
plot(f,F)
xlabel('Frecuencia (Hz)');
ylabel('Magnitud Normalizada CON filtro FIR');
title('ECG en Frecuencia');


%% Aplicar filtro de Filter Designer

Fs = 250;  % Sampling Frequency

N   = 10;    % Order
Fc1 = 59.7;  % First Cutoff Frequency
Fc2 = 60.3;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandstop('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

% Crear la señal filtrada
ecg_limpia2 = filter(Hd,ecg);

% Graficar
figure;
plot(t,ecg_limpia2);
xlim([0 4])
title('ECG Filtrado con Filter Designer')
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')























