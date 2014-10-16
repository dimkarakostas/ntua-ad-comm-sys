lear all; close all;
load sima_lp;

order=256;
Fc=5000;
F1=fc(1); F2=fc(2);
s=sima_lp;
s=interp(s,4);
Fs=Fs*4;
t=(0:1/Fs:(length(s)-1)/Fs)';
figure; pwelch(s,[],[],[],Fs);
title('Φάσμα σήματος βασικής ζώνης')

y=hilbert(s);
ssb2=(real(y).*cos(2*pi*Fc*t)+imag(y).*sin(2*pi*Fc*t));
%ssb2=sqrt(2)*(real(y).*cos(2*pi*Fc*t)+imag(y).*sin(2*pi*Fc*t));
ssb2n=awgn(ssb2,20,'measured');
figure; pwelch(ssb2n,[],[],[],Fs);
title('Φάσμα SSB σήματος με θόρυβο');

fpts=[0 3600 3800 5000 5200 Fs/2]*2/Fs;
mag=[0 0 1 1 0 0];
bpf=firpm(order,fpts,mag);
[H,F]=freqz(bpf,1,512,Fs);
figure; plot(F,20*log(abs(H))); grid;
title('Ζωνοπερατό Φίλτρο')
ssb2n=conv(ssb2n,bpf,'same');
figure;pwelch(ssb2n,[],[],[],Fs);
title('Φάσμα ζωνοπεριορισμένου SSB σήματος με θόρυβο')

z=2*ssb2n.*cos(2*pi*Fc*t);
z=decimate(z,4);
Fs=Fs/4;
figure; pwelch(z,[],[],[],Fs);
title('Φάσμα αποδιαμορφωμένου σήματος πριν το βαθυπερατό φιλτράρισμα')

fpts=[0 1200 1500 Fs/2]*2/Fs;
mag=[1 1 0 0];
wt=[1 1];
b=firpm(order,fpts,mag,wt);
a=1;
[H,F]=freqz(b,a,512,'whole',Fs);
figure; freqz(b,a,512,Fs);
title('Aπόκριση συχνότητας βαθυπερατού φίλτρου')

z_lp=conv(z,b,'same');
figure; pwelch(z_lp,[],[],[],Fs);
title('Φάσμα αποδιαμορφωμένου σήματος μετά το βαθυπερατό φιλτράρισμα')
t=(0:1/Fs:(length(sima_lp)-1)/Fs)';
n=(100:200); t1=t(n)*Fs;
figure; subplot(2,1,1); plot(t1,sima_lp(n));
maxs=max(sima_lp(n)); mins=min(sima_lp(n));
axis([min(t1) max(t1) mins*1.1 maxs*1.1]);
title('αρχικο σημα')
grid;
subplot(2,1,2); plot(t1, z_lp(n));
axis([min(t1) max(t1) mins*1.1 maxs*1.1]);
xlabel('χρονος (msec)');
title('σημα μετα την αποδιαμορφωση')
grid;
