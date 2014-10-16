% Απόκριση Προσαρμοσμένων Φίλτρων -
% DC4υαδική μετάδοση με ημιτονικούς παλμούς διαφορετικών συχνοτήτων
clear all; close all;
b=randint(1,20000);
t=(0:0.1:2*pi)';
Ns=length(t);
s1=sin(t); s2=sin(2*t);
E1=sum(s1.^2); E2=sum(s2.^2);
g1=s1(Ns:-1:1);
g2=s2(Ns:-1:1);
SNRdb=-10; SNRin=10^(SNRdb/10);
Sin=1/2*(E1+E2)/Ns;
Nin=Sin/SNRin;
Ho1=zeros(Ns,length(b));Ho2=zeros(Ns,length(b));
Ho3=zeros(1,length(b));Ho4=zeros(1,length(b));
R=zeros(Ns,length(b));S=zeros(Ns,length(b));
for k=1:length(b)
    if b(k)==1 
            s=s1;
    else s=s2;
    end
    w=wgn(Ns,1,10*log10(Nin));
    r=s+w;
    S(:,k)=s; R(:,k)=r;
    ho=conv(g1,r); Ho1(:,k)=ho(1:Ns);
    ho=conv(g2,r); Ho2(:,k)=ho(1:Ns);
    ho_=s1'*r; Ho3(k)=ho_; 
    ho_=s2'*r; Ho4(k)=ho_;
    clear s ho;
end

%Σύγκριση συνέλιξης και συσχετιστή
diff=(Ho1(Ns,:)-Ho3);
same=1;
for k=1:length(b)
   if abs(diff(k))>10^(-12)
       same=0;
   end
end

if same==1
   disp('Ο συσχετιστης και και το τελευταίο στοιχείο της συνέλιξης ταυτίζονται')
end

%Μετρηση εσφαλμένων Bit
count=0;
bit_est=(Ho3>Ho4);
errors=length(b)-sum(b==bit_est);
disp('erros=');disp(num2str(errors))