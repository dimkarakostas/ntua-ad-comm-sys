%Θεωρητικός υπολογισμός της πιθανότητας Pb συναρτήσει του Eb/No
Pb=zeros(3,18); Pe=zeros(3,18);
for k=1:3       %Αριθμός bits ανά σύμβολο
    L=2^k;      %Αριθμός διαφορετικών πλατών
    EbNo=(1:18);
        Pe(k,:)=((L-1)/L)*erfc(sqrt((3*log2(L)*10.^(EbNo/10))/(L^2-1)));
        Pb(k,:)=Pe(k,:)/log2(L);
end

figure 
semilogy(EbNo,Pb(1,:),'g')
hold on
semilogy(EbNo,Pb(2,:),'k')
hold on
semilogy(EbNo,Pb(3,:),'r')
xlabel('E_b/N_o (dB)')
ylabel('BER')
legend('k=1','k=2','k=3')