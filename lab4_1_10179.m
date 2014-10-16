clear all; close all;clc;
t = 0:.001:1-0.001; % διάνυσμα χρόνος
x = cos(2*pi*30*t) + 0.5*sin(2*pi*300*t); % ημιτονικό σήμα 
Fs=1000;
N=1024;
Fo=Fs/N;
y = downsample(x,4); % αποδεκάτιση σήματος
f=(-N/2:N/2-1)*Fo;
x1=x(1:240);
figure(1);subplot(3,1,1)
stem(x1); title('\bf Original Signal')
y1=y(1:60);
figure(1);subplot(3,1,2)
stem(y1); axis([0 60 -1.2 1.2]);title('\bf Downsampled Signal')
X=fft(x,N);
figure(2);subplot(3,1,1);plot(f,fftshift(abs(X)))
title('\bf Φάσμα αρχικού σήματος');xlabel('Frequency (Hz)')
Y=fft(y,N);figure(2);subplot(3,1,2);plot(f,fftshift(abs(Y)))
title('\bf Φάσμα μετά από υποδειγματοληψία');xlabel('Frequency (Hz)')
yd=decimate(x,4);
figure(1);subplot(3,1,3)
stem(yd(1:60)); axis([0 60 -1.2 1.2]);title('\bf Decimated Signal')
Yd=fft(yd,N);
figure(2);subplot(3,1,3);plot(f,fftshift(abs(Yd)))
title('\bf Φασμα μετά από υποδειγματοληψία και φιλτράρισμα');xlabel('Frequency (Hz)')

z = upsample(x,4);
x1=x(1:60);
z1=z(1:240);
figure(3);subplot(3,1,1);
stem(x1);title('\bf Original Signal')
figure(3);subplot(3,1,2);
stem(z1);axis([0 240 -1.2 1.2]);title('\bf Upsampled Signal')
figure(4);subplot(3,1,1);plot(f,fftshift(abs(X)))
title('\bf Φάσμα αρχικού σήματος');xlabel('Frequency (Hz)')
Z=fft(z,N);
figure(4);subplot(3,1,2);plot(f,fftshift(abs(Z)))
title('\bf Φάσμα μετά από υπερδειγματοληψία');xlabel('Frequency (Hz)')

zi=interp(x,4);
figure(3);subplot(3,1,3)
stem(zi(1:240)); axis([0 240 -1.2 1.2]);title('\bf Interpolated Signal')
Zi=fft(zi,N);
figure(4);subplot(3,1,3);plot(f,fftshift(abs(Zi)))
title('\bf Φασμα μετά από υπερδειγματοληψία και φιλτράρισμα');xlabel('Frequency (Hz)')

yr1=resample(x,2,3);
 figure(5)
 subplot(2,1,1);stem(x(1:60));title('\bf Original Signal')
 subplot(2,1,2);stem(yr1(1:40));title('\bf Resampled Signal by 2/3')
 Yr1=fft(yr1,N);
 
  yr2=resample(x,3,2);
 figure(6)
 subplot(2,1,1);stem(x(1:60));title('\bf Original Signal')
 subplot(2,1,2);stem(yr2(1:90));title('\bf Resampled Signal by 3/2')
 Yr2=fft(yr2,N);
 
 figure(7)
 subplot(3,1,1);plot(f,fftshift(abs(X)))
 title('\bf Original Signal');xlabel('Frequency (Hz)')
 subplot(3,1,2);plot(f,fftshift(abs(Yr1)))
 title('\bf 2/3 Resampled Signal');xlabel('Frequency (Hz)')
 subplot(3,1,3);plot(f,fftshift(abs(Yr2)))
 title('\bf 3/2 Resampled Signal');xlabel('Frequency (Hz)')