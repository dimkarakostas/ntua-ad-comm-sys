clear all; close all;clc;

load 'sima_lp'
order=256;
Fc=5000;
F1=fc(1); F2=fc(2);
s=sima_lp;
s=interp(s,4);
Fs=4*Fs;
t=(0:1/Fs:(length(s)-1)/Fs)';
figure; pwelch(s,[],[],[],Fs);
title('Φάσμα σήματος βασικής ζώνης')

dsb=2*s.*cos(2*pi*Fc*t);
figure; pwelch(dsb,[],[],[],Fs);
title('Φάσμα DSB διαμορφωμένου σήματος')    
delay=order/8;
fpts=[0 4450 4500 5500 5550 Fs/2]*2/Fs;
amp=[1 1 1 0 0 0];
vsb_lp_fltr=firpm(order,fpts,amp);

[H,f]=freqz(vsb_lp_fltr,1,Fs);
H=abs(H); f=f*Fs/2/pi;
figure; subplot(2,1,1); stem(vsb_lp_fltr(delay-31:delay+32));
title('κρουστικη αποκριση φιλτρου vsb');
subplot(2,1,2); plot(f,abs(H));
axis([0 Fs/2 0 1.1]); grid;
xlabel('συχνοτητα (Hz)');
title('αποκριση συχνοτητας (πλατος) φιλτρου vsb')
hold off;

vsb_lp=conv(dsb,vsb_lp_fltr,'same');
%vsb_lp=awgn(vsb_lp,15,'measured');
%vsb_lp=vsb_lp(delay+(1:length(s)));
figure; pwelch(vsb_lp,[],[],[],Fs);
title('Φάσμα VSB διαμορφωμένου σήματος');
%demodulation
s_dm=2*vsb_lp.*cos(2*pi*Fc*t);
figure; pwelch(s_dm,[],[],[],Fs);
title('Αποδιαμορφωμένο σήμα πριν το βαθυπερατό φιλτράρισμα');

hpm=firpm(order, [0 1000/Fs 1500/Fs 0.5]*2, [1 1 0 0]);
s_pm=conv(s_dm,hpm,'same');
s_pm=decimate(s_pm,4);
Fs=Fs/4;
figure; pwelch(s_pm,[],[],[],Fs);
title('Φάσμα αποδιαμορφωμένου σήματος');
t1=(0:1/Fs:(length(sima_lp)-1)/Fs)';
n=(100:300); t2=t1(n)*Fs;
figure; subplot(2,1,1); plot(t2,sima_lp(n));
maxs=max(sima_lp(n)); mins=min(sima_lp(n));
axis([min(t2) max(t2) mins*1.1 maxs*1.1]);
title('αρχικο σημα')
grid;
subplot(2,1,2); plot(t2, s_pm(n));
axis([min(t2) max(t2) mins*1.1 maxs*1.1]);
xlabel('χρονος (msec)');
title('τελικο σημα')
grid;