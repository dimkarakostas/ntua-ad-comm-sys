clear all;close all; clc;

%���������� FM �� ���� ��� �����
Fs=20000; %��������� ��������������
t=(0:2*Fs+1)'/Fs;       %������ ��������������
F1=20; F2=400;
A1=0.2; A2=1;
W=max(F1,F2);
%������ ������� ������� �����������
freqdev=480;
x=A1*cos(2*pi*F1*t)+A2*cos(2*pi*F2*t);
xmax=max(abs(x));
kf=freqdev/xmax;
b1=A1*kf/F1; b2=A2*kf/F2;
D=freqdev/W;        %����� �����������
B=2*(D+2)*W;    %����� ����� ���������

figure(1);
pwelch(x,[],[],[],Fs);
title('���� ��� �����')
Fc=5000;           %��������� ��������

%���������� FM
%y=cos(2*pi*Fc*t+b1*sin(2*pi*F1*t)+b2*sin(2*pi*F2*t));
%�����������,�� ����� ��� fmmod
y=fmmod(x,Fc,Fs,kf); %Modulate
figure(2);
pwelch(y,[],[],[],Fs);
title('���� ��� �����, FM narrow');
y=awgn(y,15,'measured'); %�������� �������
figure(3);
pwelch(y,[],[],[],Fs);
title('FM-narrow �� ������')

%Demodulate
%�� ����� ������ �������������
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
sp=hilbert(am);         %��������������
V=abs(sp);              %�����������
z=V-mean(V);            %�������� DC ����������
z=z*B/kf;
figure(5);
pwelch(z,[],[],[],Fs);
title('��������������� FM-narrow ���� �� LPF')

%���������� ������ Parks-McClellan
f1=F2/Fs;
f2=1.5*f1;
order=240;
fpts=[0 f1 f2 0.5]*2;
mag=[1 1 0 0];
wt=[1 1];
b=firpm(order,fpts,mag,wt);
a=1;