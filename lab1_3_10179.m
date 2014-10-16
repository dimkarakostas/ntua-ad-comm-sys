clear all
close all
clc
Fs=500;
Ts=1/Fs;
L=1000;
T=L*Ts;
t=0:Ts:(L-1)*Ts;
x=sin(2*pi*20*t)   + 0.8*sin(2*pi*70*(t-2));

figure(1)
plot(t,x)
title('Time domain plot of x')
xlabel('t (sec)')
ylabel('Amplitude')
pause
axis([0 0.2 -2 2])
pause

N = 2^nextpow2(L);
Fo=Fs/N;
f=(0:N-1)*Fo;
X=fft(x,N);

figure(2)
plot(f(1:N/2)),abs(X(1:N/2))
title('Frequency domain plot of x')
xlabel('f (Hz)')
ylabel('Amplitude')
pause

figure(3)

f=f-Fs/2;
X=fftshift(X);
plot(f,abs(X));title('Two sided spectrum of x'); xlabel('f (Hz)'); ylabel('Amplitude')
pause

power=X.*conj(X)/N/L;
figure(4)
plot(f,power)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Periodogram}')
pause

disp('Part 2')

noise=randn(size(x))

figure(5)
plot(t,noise)
title('Time domain plot of noise')
xlabel('t (sec)')
ylabel('Amplitude')
pause
axis([0 0.2 -2 2])
pause

Fnoise=fft(noise,N)

Fs=500;
Ts=1/Fs;
L=1000;
T=L*Ts;
t=0:Ts:(L-1)*Ts;
N = 2^nextpow2(L);
Fo=Fs/N;
f=(0:N-1)*Fo;

figure(6)
power1 = Fnoise.*conj(Fnoise)/N/L;
plot(f,power1)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Periodogram}')
pause

sum=x+noise;
SUM=fft(sum,N);

figure(7)
plot(t,sum)
title('Time domain plot of s')
xlabel('t (sec)')
ylabel('Amplitude')
pause
axis([0 0.2 -2 2])
pause

figure(8)

f=f-Fs/2;
SUM=fftshift(SUM);
plot(f,abs(SUM)); title('Two sided spectrum of s'); xlabel('f (Hz)'); ylabel('Amplitude')
pause

disp('Part 3')

Fs=500;
Ts=1/Fs;
L=1000;
T=L*Ts;
t=0:Ts:(L-1)*Ts;
k=sin(2*pi*100*t);

mul=k.*sum;

figure(9)
plot(mul,sum)
title('Time domain plot of multiplied')
xlabel('t (sec)')
ylabel('Amplitude')
pause
axis([0 0.2 -2 2])
pause

Fmult=fft(mul,N)

figure(10)
f=f-Fs/2;
Fmult=fftshift(Fmult);
plot(f,abs(Fmult));title('Two sided spectrum of multiplied'); xlabel('f (Hz)'); yla bel('Amplitude')
pause