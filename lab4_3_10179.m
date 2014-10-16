clear all; close all;
load sima_lp;
F1=fc(1);
F2=fc(2);
figure;pwelch(sima_lp,[],[],[],Fs);
%s_dense=4*upsample(sima_lp,4);Fs=Fs*4;
s=interp(sima_lp,4);
F1=F1/4;F2=F2/4;
figure;pwelch(s,[],[],[],Fs);

%Βαθυπερατό φίλτρο
%order=256;hpm=firpm(order, [0 F1 F2 0.5]*2, [1 1 0 0]);
%[H,F]=freqz(hpm,1,512,Fs);
%figure;subplot(2,1,1);plot(F,20*log(abs(H)));grid;
%title('Αποκριση συχνότητας βαθυπερατού φίλτρου');
%subplot(2,1,2);plot(F,phase(H));grid;
%
%s=conv(s_dense,hpm); s=s(order/2+(1:length(s_dense)));
%clear s_dense;
%figure; pwelch(s,[],[],[],Fs);
s=s+2*max(abs(s));

%%%%Διαμόρφωση DSB
Fc=4*F2;
s_dsb=sqrt(2)*s.*cos(2*pi*Fc*(1:length(s))');
figure;pwelch(s_dsb,[],[],[],Fs);
s_dsb_dm=sqrt(2)*s_dsb.*cos(2*pi*Fc*(1:length(s_dsb))');
figure;pwelch(s_dsb_dm,[],[],[],Fs);
s_dsb_lp=decimate(s_dsb_dm,4); Fs=Fs/4;
%s_dsb_lp=conv(s_dsb_dm,hpm);
%s_dsb_lp=s_dsb_lp(order/2+(1:length(s_dsb)));
%figure; pwelch(s_dsb_lp,[],[],[],Fs);
%s_dsb_lp=downsample(s_dsb_lp,4); Fs=Fs/4;
figure;pwelch(s_dsb_lp,[],[],[],Fs);
n=(200:400);
t=(1:length(sima_lp))'/Fs;
figure;plot(t(n),sima_lp(n),t(n),s_dsb_lp(n),'r:');grid;
axis([min(t(n)) max(t(n)) 1.2*min(sima_lp(n)) 1.2*max(sima_lp(n))]);
legend('Αρχικό σήμα', 'Τελικό σήμα')