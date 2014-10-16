clear all
close all
clc

load sima;

figure; pwelch(s,[],[],[],Fs); pause;

H=[zeros(1,599) ones(1,301) zeros(1,Fs-900) ones(1,301) zeros(1,599)];
h=ifft(H, 'symmetric');
middle=length(h)/2;
h=[h(middle+1:end) h(1:middle)];
h32=h(middle+1-16:middle+17);
h64=h(middle+1-32:middle+33);
h128=h(middle+1-64:middle+65);

figure; stem((0:length(h64)-1),h64); grid; pause;

figure; freqz(h64,1); pause;

wvtool(h32, h64, h128); pause;

wh=hamming(length(h64));
wk=kaiser(length(h64),5);

figure; plot(0:64,wk,'r',0:64,wh,'b'); grid; pause;

h_hamming=h64.*wh';
h_kaiser=h64.*wk';
wvtool(h64,h_hamming,h_kaiser);

y_rect=conv(s,h64);
figure; pwelch(y_rect,[],[],[],Fs); pause;
y_hamm=conv(s,h_hamming);
figure; pwelch(y_hamm,[],[],[],Fs); pause;
y_kais=conv(s,h_kaiser);
figure; pwelch(y_kais,[],[],[],Fs); pause;

hpm=firpm(64, [0 0.10 0.15 0.5]*2, [1 1 0 0]);

s_pm=conv(s,hpm);
figure; pwelch(s_pm,[],[],[],Fs); legend('Parks-MacClellan 64');