clear all; close all;
load sima_lp;
F1=fc(1);
F2=fc(2);
figure;pwelch(sima_lp,[],[],[],Fs);
s=interp(sima_lp,4);
F1=F1/4;F2=F2/4;
figure;pwelch(s,[],[],[],Fs);

s=s+2*max(abs(s));
figure; pwelch(s,[],[],[],Fs);

Fc=4*F2;
s_dsb=sqrt(2)*s.*cos(2*pi*Fc*(1:length(s))');
figure;pwelch(s_dsb,[],[],[],Fs);
sp=hilbert(s_dsb);
V=abs(sp)/sqrt(2); 
s_dsb_lp=V-mean(s);        
s_dsb_lp=decimate(s_dsb_lp,4);        
figure;pwelch(s_dsb_lp,[],[],[],Fs);
n=(200:400);
t=(1:length(sima_lp))'/Fs;
figure;plot(t(n),sima_lp(n),t(n),s_dsb_lp(n),'r:');grid;
axis([min(t(n)) max(t(n)) 1.2*min(sima_lp(n)) 1.2*max(sima_lp(n))]);
legend('Αρχικό σήμα', 'Τελικό σήμα')