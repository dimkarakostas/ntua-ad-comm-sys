%���������� FM ������� �������� ��������

clear all;
close all;

%�������� �� ������ �� �� ���� ������� �����,�� ��������� �������������� Fs
%��� �� �������� ��� ���������� ��� ����� ��������� fc=[f1,f2],��������� ��
%���� Fs
load sima_lp;
F1=fc(1);
F2=fc(2);
figure;
pwelch(sima_lp,[],[],[],Fs);
%������� ������� ��� ��������� �������������� (xD)
D=8;
s=interp(sima_lp,D);
Fs=Fs*D;
s=s/max(s);
F1=F1/D; F2=F2/D; %�� ���������� ��� ��� ������
t=(1:length(s))'/Fs;
pwelch(s,[],[],[],Fs);
Fc=12500; %carrier frequency for SSB modulation

%���������� FM
freqdev=2500;
xmax=max(s);
kf=freqdev/xmax;

integral=cumtrapz(t,s);
y=cos(2*pi*Fc*t+2*pi*freqdev*integral);
figure;
pwelch(y,[],[],[],Fs);
y=awgn(y,40,'measured'); %�������� �������
figure;
pwelch(y,[],[],[],Fs);

%���������� ����������� ���� ��� �������������
DR=freqdev/(F2*Fs);
fl=Fc/Fs-(DR+2)*F2; fh=Fc/Fs+(DR+2)*F2; %Carson's rule
M=128;
hpm=firpm(M,[0 fl*0.95 fl*1.02 fh*0.98 fh*1.05 0.5]*2,[0 0 1 1 0 0]);
figure;
freqz(hpm,1,512,Fs);
y=conv(y,hpm,'same');
figure;
pwelch(y,[],[],[],Fs);

z=fmdemod(y,Fc,Fs,freqdev); %Demodulate
figure;
pwelch(z,[],[],[],Fs);
%���������� ����������� Parks-McClellan
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
legend('������ ����','������ ����')
figure;
pwelch(downsample(z_lp,D),[],[],[],Fs/D);