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
xmax=max(x);
kf=freqdev/xmax;
b1=A1*kf/F1; b2=A2*kf/F2;
B=2*(freqdev+2*W);    %����� ����� ���������
D=freqdev/W;        %����� �����������

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
%������������� ���� ��� ����������� ��� ��������� �������������
s_=hilbert(y);
s=s_.*exp(-1j*2*pi*Fc*t);
theta=angle(s);
theta=unwrap(theta);
z=(1/(2*pi*kf))*(diff(theta)./diff(t));
figure(4);
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
%���������� ��������� �������
[H,F]=freqz(b,a,512,Fs);
figure(5);
plot(F,20*log(abs(H)));
title('LPF')
%LP filtering
z_lp=conv(z,b);
z_lp=z_lp(order/2+(1:length(x)));
figure(6);
pwelch(z_lp,[],[],[],Fs);
title('��������������� FM-narrow ���� �� ���������� ������')
%������� ������� ��� ������� �������
n=(40:600);
figure(7);
plot(t(n),x(n),'k-',t(n),z_lp(n),'r');
grid;
axis([min(t(n)) max(t(n)) 1.2*min(x(n)) 1.2*max(x(n))]);
legend('������ ����','������ ����');

%���������� ����������� ���������� �������
z1=[];
f=[];
for j=-4:4
    for i=-5:5
        f=[f Fc+j*F2+i*F1];
        z1=[z1 besselj(j,b2)*besselj(i,b1)];
    end
end
logz=100+10*log10((z1.^2)/2);
figure(8);
stem(f,logz);
title('FM-narrow ��� �����, ���������� ����������� ���������� �������')
axis([0 Fs/2 max(logz)-80 max(logz)+10]);
grid