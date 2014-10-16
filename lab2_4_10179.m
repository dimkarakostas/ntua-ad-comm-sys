clear all 
close all 
clc 
L=32; 
Fs=1; 
Ts=1/Fs; 
T=L*Ts; 
n=[0:Ts:T-Ts]; 
A=1; 
phi=0; 
f=0.25+0.5/L; 
x=A*cos(2*pi*n*f+phi);
zpf=10;
X=fft(x,zpf*L);

m=A*cos(2*pi*n*f+phi);
M=fft(m);

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

magM=abs(M);
magX=abs(X);
N=length(X);
J=length(M);
fn=[0:1/N:1-1/N];
pn=[0:1/J:1-1/J];

subplot(3,1,2);


plot(fn,magX,'-k');

grid on;
xlabel('Normalised Frequency (cycles per sample)');
ylabel('Magnitude (Linear)');
hold on;
stem(pn,magM,'-r');
hold off;

pause


spec=20*log10(magX);

spec=max(spec,-30*ones(1,length(spec)));
subplot(3,1,3);

plot(fn,spec,'-r');
grid on;

axis([0 1 -30 30]);
grid on;
xlabel('Normalized  Frequency (cycles per sample)');
ylabel('Magnitude (dB)');

figure(2);
subplot(3,1,1);
plot(n,x,'*k');

pause

t=0:0.1:T;
plot(t,A*cos(2*pi*f*t+phi),'-b');

grid off;
title('Sinusoid at 1/4 the Sampling Rate');
xlabel('Time (samples)');
ylabel('Amplitude');

pause

magM=abs(M);
magX=abs(X);
N=length(X);
J=length(M);
fn=[0:1/N:1-1/N];
pn=[0:1/J:1-1/J];
subplot(3,1,2);


plot(fn,magX,'-k');

grid on;
xlabel('Normalised Frequency (cycles per sample)');
ylabel('Magnitude (Linear)');
hold on 
stem(pn,magM,'-r');
hold off
pause

spec=20*log10(magX);

spec=max(spec,-30*ones(1,length(spec)));
subplot(3,1,3);

plot(fn,spec,'-r');
grid on;

axis([0 1 -30 30]);
grid on;
xlabel('Normalized  Frequency (cycles per sample)');
ylabel('Magnitude (dB)');
