clear all; close all;

f1=1; f2=3; f3=12;
Fc=50; Fs=200; order=256;
t=(0:1/Fs:20);
s=2*cos(2*pi*f1*t)+4*cos(2*pi*f2*t)+8*cos(2*pi*f3*t);
figure; pwelch(s,[],[],[],Fs);
title('Φάσμα σήματος βασικής ζώνης')
dsb=2*s.*cos(2*pi*Fc*t);
figure; pwelch(dsb,[],[],[],Fs);
title('DSB διαμορφωμένο σήμα')

delay=order/8; %rolloff=0.10;
%vsb_lp_fltr=vsb_lp_filter(Fc, Fs, rolloff, delay);

fpts=[0 44.5 45 55 55.5 Fs/2]*2/Fs;
amp=[1 1 1 0 0 0];
vsb_lp_fltr=firpm(order,fpts,amp);

[H,f]=freqz(vsb_lp_fltr,1,401);
H=abs(H); f=f*Fs/2/pi;
figure; subplot(2,1,1); stem(vsb_lp_fltr(delay-31:delay+32));
title('κρουστικη αποκριση φιλτρου vsb');
subplot(2,1,2); plot(f,abs(H));
axis([0 Fs/2 0 1.1]); grid;
xlabel('συχνοτητα (Hz)');
title('αποκριση συχνοτητας (πλατος) φιλτρου vsb')
hold off;

vsb_lp=conv(dsb,vsb_lp_fltr,'same');
figure; pwelch(vsb_lp,[],[],[],Fs);
title('VSB διαμορφωμένο σήμα');

s_dm=2*vsb_lp.*cos(2*pi*Fc*t);
figure; pwelch(s_dm,[],[],[],Fs);
title('Αποδιαμορφωμένο σήμα πριν το βαθυπερατό φιλτράρισμα');

%hpm=firpm(order, [0 f3*1.5/Fs f3*2/Fs 0.5]*2, [1 1 0 0]);
hpm=fir1(order,55*2/Fs);
%pwelch(freqz(hpm,1,Fs),[],[],[],Fs);
s_pm=conv(s_dm,hpm,'same'); 
figure; pwelch(s_pm,[],[],[],Fs);
title('Αποδιαμορφωμένο σήμα')
n=(100:300); t1=t(n)*1000;
figure; subplot(2,1,1); plot(t1,s(n));
maxs=max(s); mins=min(s);
axis([min(t1) max(t1) mins*1.1 maxs*1.1]);
title('αρχικο σημα')
grid;
subplot(2,1,2); plot(t1, s_pm(n));
axis([min(t1) max(t1) mins*1.1 maxs*1.1]);
xlabel('χρονος (msec)');
title('τελικο σημα')
grid;