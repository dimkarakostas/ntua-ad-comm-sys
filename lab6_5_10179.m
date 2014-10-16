
clear all;
close all;

%Φορτώνει το αρχείο με το σήμα βασικής ζώνης,τη συχνότητα δειγματοληψίας Fs
%και το διάνυσμα των συχνοτήτων της ζώνης μετάβασης fc=[f1,f2],ανηγμένων ως
%προς Fs
load sima_lp;
F1=fc(1);
F2=fc(2);
figure;
pwelch(sima_lp,[],[],[],Fs);
%Γίνεται πύκνωση του πλέγματος δειγματοληψίας (xD)
D=8;
s=interp(sima_lp,D);
Fs=Fs*D;
s=s/max(s);
F1=F1/D; F2=F2/D; %οι συχνότητες στο νέο πλέγμα
t=(1:length(s))'/Fs;
pwelch(s,[],[],[],Fs);
Fc=12500; %carrier frequency for SSB modulation

%Διαμόρφωση FM

freqdev=500;
kf=freqdev/max(s);
y=fmmod(s,Fc,Fs,freqdev); %Modulate
figure;
pwelch(y,[],[],[],Fs);
y=awgn(y,25,'measured'); %προσθήκη θορύβου
figure;
pwelch(y,[],[],[],Fs);

%Ζωνοπερατό φιλτράρισμα πριν την αποδιαμόρφωση
DR=freqdev/(F2*Fs);
fl=Fc/Fs-(DR+2)*F2; fh=Fc/Fs+(DR+2)*F2; %Carson's rule
M=128;
hpm=firpm(M,[0 fl*0.95 fl*1.02 fh*0.98 fh*1.05 0.5]*2,[0 0 1 1 0 0]);
figure;
freqz(hpm,1,512,Fs);
y=conv(y,hpm,'same');
figure;
pwelch(y,[],[],[],Fs);

%Demodulate
s_=hilbert(y);
V=s_.*exp(-1j*2*pi*Fc*t);
theta=angle(V);
theta=unwrap(theta);
z=(1/(2*pi*kf))*(diff(theta)./diff(t));
%z=fmdemod(y,Fc,Fs,freqdev);
figure;
pwelch(z,[],[],[],Fs);
%Βαθυπερατό φιλτράρισμα Parks-McClellan
f1=F2;
f2=1.1*f1;
order=64*D;
fpts=[0 f1 f2 0.5]*2;
mag=[1 1 0 0];
wt=[1 1];
b=firpm(order,fpts,mag,wt);
z_lp=conv(z,b,'same');
figure;
pwelch(z_lp,[],[],[],Fs);
%Plot the original and recovered signals
n=(40*D:40*D+600);
figure;
plot(t(n),s(n),'k-',t(n),z_lp(n),'r');
grid;
axis([min(t(n)) max(t(n)) 1.2*min(s(n)) 1.2*max(s(n))]);
legend('Αρχικό σήμα','Τελικό σήμα')
figure;
pwelch(downsample(z_lp,D),[],[],[],Fs/D);