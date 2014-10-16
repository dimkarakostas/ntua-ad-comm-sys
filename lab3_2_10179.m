clear all; close all;

Fs=8192;
Ts=1/Fs;
A=1;
T=1.0;
t=0:Ts:T-Ts;
s=A*sin(2*pi*500*t)+A*sin(2*pi*1000*t)+A*sin(2*pi*2000*t);
figure; pwelch(s,[],[],[],Fs); pause;

H=[ones(1,Fs/8) zeros(1,Fs-Fs/4) ones(1,Fs/8)];

h=ifft(H,'symmetric');
middle=length(h)/2;
h=[h(middle+1:end) h(1:middle)];
h32=h(middle+1-16:middle+17);
h64=h(middle+1-32:middle+33);
h128=h(middle+1-64:middle+65);
wvtool(h32,h64,h128);
wh=hamming(length(h128));
wk=kaiser(length(h128),5);
figure; plot(0:128,wk,'r',0:128,wh,'b'); grid; pause;
h_hamming=h128.*wh';
h_kaiser=h128.*wk';
wvtool(h128,h_hamming,h_kaiser);
y_rect=conv(s,h128);
figure; pwelch(y_rect,[],[],[],Fs); pause;
y_hamm=conv(s,h_hamming);
figure; pwelch(y_hamm,[],[],[],Fs); pause;
y_kais=conv(s,h_kaiser);
figure; pwelch(y_kais,[],[],[],Fs); pause;

hpm=firpm(64, [0 0.10 0.15 0.5]*2, [1 1 0 0]);
s_pm=conv(s,hpm);
figure; pwelch(s_pm,[],[],[],Fs);