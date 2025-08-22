% fourier_demo.m
% FFT 傅里叶变换示例

clc; clear; close all;

Fs = 1000; % 采样频率
t = 0:1/Fs:1-1/Fs;
x = sin(2*pi*50*t) + sin(2*pi*120*t);

Y = fft(x);
L = length(x);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;

plot(f,P1);
title('信号频谱');
xlabel('频率 (Hz)');
ylabel('|P1(f)|');