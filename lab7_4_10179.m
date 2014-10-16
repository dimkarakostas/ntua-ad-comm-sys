%Yπολογισμός της πιθανότητας Pb με επαναληπτική κληση της ask_errors

k=3;            
Nsymp=2000;
nsamp=16;
Pb=zeros(1,17);
errors=zeros(1,17);
for i=1:17
    EbNo=i;
    errors(i)=ask_errors(k,Nsymp,nsamp,EbNo);
    Pb(i)=errors(i)/(Nsymp*k);
end
figure
semilogy((1:17),Pb)
xlabel('E_b/N_o (dB)')
ylabel('BER')
grid;