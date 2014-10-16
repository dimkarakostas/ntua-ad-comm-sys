clear all
close all
clc

L=32;
Fs=1;
Ts=1/Fsl;
T=L*Ts;
n=[0:Ts:T-Ts];
A=1;
phi=0;
f=0.25;
w=blackman(L);
x=A*cos(2*pi*n*f+phi);
X=fft(x.*w');

figure(1);
subplot(3,1,1);
plot(n,x,'*k');
pause

hold on;
t=0:0.1:T;
plot(t,A*cos(2*pi*f*t+phi),'-b');
grid off;
title('Sinusoid at 1/4 the Sampling Rate');
xlabel('Time (samples)');
ylabel('Amplitude');
hold off;
pause

magX=abs(X);
N=length(X);
fn=[0:1/N:1-1/N];
subplot(3,1,2);
stem(fn,magX,'ok');
grid on;
xlabel('Normalized Frequency (cycles per sample))');
ylabel('Magnitude (Linear)');
pause

spec=20*log10(magX);
subplot(3,1,3);
plot(fn,spec,'--sr');
axis([0 1 -60 20]);
grid on;
xlabel('Normalized Frequency (cycles per sample))');
ylabel('Magnitude (dB)');

figure(2);
subplot(3,1,1);
plot(n,x,'*k');
pause

hold on;
t=0:0.1:T;
plot(t,A*cos(2*pi*f*t+phi),'-b');
grid off;
title('Sinusoid NEAR 1/4 the Sampling Rate');
xlabel('Time (samples)');
ylabel('Amplitude');
hold off;
pause

magX=abs(X);
N=length(X);
fn=[0:1/N:1-1/N];
subplot(3,1,2);
stem(fn,magX,'ok');
grid on;
xlabel('Normalized Frequency (cycles per sample))');
ylabel('Magnitude (Linear)');
pause

spec=20*log10(magX);
subplot(3,1,3);
plot(fn,spec,'--sr');
axis([0 1 -60 20]);
grid on;
xlabel('Normalized Frequency (cycles per sample))');
ylabel('Magnitude (dB)');