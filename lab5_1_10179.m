clear all; close all;
f1=1; f2=3; f3=12;
Fs=200;
order=256;
Fc=50;
t=(0:1/Fs:20)';
s=2*cos(2*pi*f1*t)+4*cos(2*pi*f2*t)+8*cos(2*pi*f3*t);
figure; pwelch(s,[],[],[],Fs);
title('����� ������� ������� �����')

%����� ��������������� hilbert ��� ��������� ����
%��������� �������� ������� FIR
%b=firpm(order,[0.01 0.99], [1 1], 'Hilbert');
%a=1;
%figure; stem(b(order/2-28:order/2+29)); grid;
%title('��������� �������� ������� ��������������� Hilbert')
%�������� ���������� �������
%[H,F]=freqz(b,a,512,Fs);
%figure; subplot(2,1,1); plot(F,20*log(abs(H))); grid;
%title('�������� ���������� ������� ������. Hilbert');
%subplot(2,1,2); plot(F,phase(H)); grid;
%title('����')
%
%u=[zeros(1,order/2) 1 zeros(1,order/2)]; %������ ������������
%s1=conv(s,u, 'same'); %������ ���� ������������� ���� order/2
%s2=conv(s,b, 'same'); %��������������� hilbert ��� �������

%���������� SSB ���� ��������� �����(����� Hartley)
%���� �������� ����
%ssb=sqrt(2)*(s1.*cos(2*pi*Fc*t)+s2.*sin(2*pi*Fc*t));
%��� �������� ����
%ssb1=sqrt(2)*(s1.*cos(2*pi*Fc*t)-s2.*sin(2*pi*Fc*t));
%figure; pwelch(ssb,[],[],[],Fs);
%title('����� ������� SSB')

%�������� ������� SSB ���� ��������������� Hilbert
y=hilbert(s);
ssb2=(real(y).*cos(2*pi*Fc*t)+imag(y).*sin(2*pi*Fc*t));
%ssb2=sqrt(2)*(real(y).*cos(2*pi*Fc*t)+imag(y).*sin(2*pi*Fc*t));
ssb2nn=awgn(ssb2,20,'measured');
figure; pwelch(ssb2nn,[],[],[],Fs);
title('����� SSB ������� �� ������');

fpts=[0 34 36 51 53 Fs/2]*2/Fs;
mag=[0 0 1 1 0 0];
bpf=firpm(order,fpts,mag);
[H,F]=freqz(bpf,1,512,Fs);
title('���������� ������ ������ 15 Hz');
figure; plot(F,20*log(abs(H))); grid;
ssb2n=conv(ssb2nn,bpf,'same');
figure;pwelch(ssb2n,[],[],[],Fs);
title('����� ����������������� SSB ������� �� ������')

dsb=2*s.*cos(2*pi*Fc*t);
figure; pwelch(dsb,[],[],[],Fs);
title('����� ������� DSB-SC')
fpts=[0 Fc-0.98*f1 Fc+0.98*f1 Fs/2]*2/Fs;
b=firpm(order,fpts,[1 1 0 0], [1 1]);
ssb1=conv(dsb,b,'same'); 
figure; pwelch(ssb1,[],[],[],Fs);
title('����� ������� ssb1')

clear z z1 z2;
z=2*ssb2n.*cos(2*pi*Fc*t);
figure; pwelch(z,[],[],[],Fs);
title('����� ���������������� ������� ���� �� ���������� �����������')

F1=1.1*f3/Fs; F2=1.5*F1;
fpts=[0 F1 F2 0.5]*2;
mag=[1 1 0 0];
wt=[1 1];
b=firpm(order,fpts,mag,wt);
a=1;
%[H,F]=freqz(b,a,512,'whole',Fs);
figure; freqz(b,a,512,Fs);
title('A������� ���������� ����������� �������')

z_lp=conv(z,b,'same'); 
figure; pwelch(z_lp,[],[],[],Fs);
title('����� ���������������� ������� ���� �� ���������� �����������')
n=(100:300); t1=t(n)*1000;
figure; subplot(2,1,1); plot(t1,s(n));
maxs=max(s); mins=min(s);
axis([min(t1) max(t1) mins*1.1 maxs*1.1]);
title('������ ����')
grid;
subplot(2,1,2); plot(t1, z_lp(n));
axis([min(t1) max(t1) mins*1.1 maxs*1.1]);
xlabel('������ (msec)');
title('���� ���� ��� �������������')
grid;
