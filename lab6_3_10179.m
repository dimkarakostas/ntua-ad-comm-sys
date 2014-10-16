clear all;close all; clc;

%Διαμόρφωση FM με σήμα δύο τόνων
Fs=20000; %συχνότητα δειγματοληψίας
t=(0:2*Fs+1)'/Fs;       %πλέγμα δειγματοληψίας
F1=20; F2=400;
A1=0.2; A2=1;
W=max(F1,F2);
%μικροί σχετικά δείκτες διαμόρφωσης
freqdev=480;
x=A1*cos(2*pi*F1*t)+A2*cos(2*pi*F2*t);
xmax=max(abs(x));
kf=freqdev/xmax;
b1=A1*kf/F1; b2=A2*kf/F2;
D=freqdev/W;        %Λόγος διαμόρφωσης
B=2*(D+2)*W;    %Εύρος ζώνης μετάδοσης

figure(1);
pwelch(x,[],[],[],Fs);
title('Σήμα δύο τόνων')
Fc=5000;           %συχνότητα φέροντος

%Διαμόρφωση FM
%y=cos(2*pi*Fc*t+b1*sin(2*pi*F1*t)+b2*sin(2*pi*F2*t));
%εναλλακτικά,με χρήση της fmmod
y=fmmod(x,Fc,Fs,kf); %Modulate
figure(2);
pwelch(y,[],[],[],Fs);
title('Σήμα δύο τόνων, FM narrow');
y=awgn(y,15,'measured'); %πρόσθεση θορύβου
figure(3);
pwelch(y,[],[],[],Fs);
title('FM-narrow με θόρυβο')

%Demodulate
%Με κλίση φωρατή περοβάλλουσας
order=512;
fl=Fc-B/2;
fh=Fc+B/2;
fpts=[0 0.95*fl fl fh 1.05*fh Fs/2]*2/Fs;
b = firpm (order,fpts,[0 0 0 1 0 0]);
a=1;
[H,F] = freqz (b,a,512,Fs);
figure (4);
subplot (2,1,1); plot (F,abs(H)); grid
subplot (2,1,2); plot (F,phase(H)); grid
am=conv(y,b,'same');
sp=hilbert(am);         %προπεριβάλουσα
V=abs(sp);              %περιβάλουσα
z=V-mean(V);            %αφαίρεση DC συνιστώσας
z=z*B/kf;
figure(5);
pwelch(z,[],[],[],Fs);
title('Αποδοαμορφωμένο FM-narrow πριν το LPF')

%Βαθυπερατό φίλτρο Parks-McClellan
f1=F2/Fs;
f2=1.5*f1;
order=240;
fpts=[0 f1 f2 0.5]*2;
mag=[1 1 0 0];
wt=[1 1];
b=firpm(order,fpts,mag,wt);
a=1;