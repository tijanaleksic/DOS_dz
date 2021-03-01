clear all;close all;clc;

%definisanje imena falja koji se ucitava,prethodno snimljen u snimanje.m
filename='snimak1.wav'
[x,fs]=audioread(filename);
%definisanje vremenske ose da bi se nacrtao snimak
t=0:1/fs:(length(x)-1)/fs;

%iscrtavanje originalnog signala koji je ucitan iz snimak.wav
figure(1)
plot(t,x)
xlabel('t[s]'),ylabel('x(t)'),title('Snimak');
saveas(figure(1),'ZAD_4_original.png');
%test primer za funkciju sa kraja spectar_of_20_ms koja vraca amplitudsku
%karakteristiku signala koji je duzine 20ms.Duzina od 160 je 8000/50 koliko
%ima odbiraka u 20 ms;
x120=x(1:161);
[Sp1,fp1]=spectar_of_20_ms(x120,fs);
ssr=zeros(1,length(Sp1))';


%usrednjavanje spektra originalnog signala
for i=0:49
    [spkr,fsp]=spectar_of_20_ms(x(160*i+1:160*(i+1)),fs);
    ssr=ssr+spkr;
end
ssr=ssr./50;
%iscrtavanje usrednjenog spektra signala na ulazu svih 50 puta
figure(2)
plot(fsp,ssr);
xlabel('f[Hz]'),ylabel('|X(jf)|'),title('Usrednjeni amplitudski spektar');
saveas(figure(2),'ZAD_4_original_usrednjen_spektar.png');
%izbrisi ne treba ti
N=2^nextpow2(160);
%X=fft(x,N)/length(x);
%X1=abs(X(1:N/2+1));
%X1(2:N/2+1)=2*X1(2:N/2+1);
%f1=0:fs/N:fs/2;


%butterworth;


%frekvencija Koju treba da ne propustimo:
Frekv=220;%[Hz]

%opsezi u kojima ce biti zakrivljenje filtra
 Wp1=[85*Frekv/100 120*Frekv/100]*2/fs;
 Ws1=[30*Frekv/100 180*Frekv/100]*2/fs;
%drugi opseg je da bi se smanjio red filtra radi objasnjenja
 Ws11=[0.1*Frekv/100 250*Frekv/100]*2/fs;

%opsezi u kojima ce biti zakrivljenje filtra
%otk Wp1=[90*Frekv/100 110*Frekv/100]*2/fs;
%otk Ws1=[75*Frekv/100 125*Frekv/100]*2/fs;
%drugi opseg je da bi se smanjio red filtra radi objasnjenja
%otk Ws11=[50*Frekv/100 150*Frekv/100]*2/fs;

%maksimalno slabljenje u propusnom opsegu
Rp1=2;%[dB]
%minimalno slabljenje u nepropusnom opsegu
Rs1=40;%[dB]

%pravljenje digitalnog filtra i izracunavanje reda n1 i opsega Wn1
[n1, Wn1]=buttord(Wp1,Ws1,Rp1,Rs1);
%izracunavanje parametara filtra a i b koji se prosledjuju funkciji filter
[b1, a1] = butter(n1,Wn1,'stop');

%projektovanje filtra manjeg reda
[n11, Wn11]=buttord(Wp1,Ws11,Rp1,Rs1);
[b11,a11]=butter(n11,Wn11,'stop');
%odziv filtra manjeg reda
[h11, f11]=freqz(b11,a11,N/2+1,fs);

%odziv filtra
[h1, f]=freqz(b1,a1,N/2+1,fs);


%amlitudska frekvencijska karakteristika filtra
figure(3)
hold on;
plot(f,20*log10(abs(h1)),'r','LineWidth',1.5);
plot(f11,20*log10(abs(h11)),'b','LineWidth',1.5);
xlabel('f[Hz]');grid on;
title('Amplitudske karakteristike Butterworth filtara za razlicit red filtra');
legend('vece n','manje n');
saveas(figure(3),'ZAD_4_aks_razlicito_n.png');

figure(8)
plot(f,20*log10(abs(h1)),'r','LineWidth',1.5);
xlabel('f[Hz]');grid on;
title('Amplitudska karakteristika Butterworth filtara');
saveas(figure(8),'ZAD_4_aks_vece_n.png');

%filtriranje x primenom Butterwoth filtra
y1=filter(b1,a1,x);

%usrednjavanje spektra filtriranog signala
ssr1=zeros(1,length(Sp1))';
for i=0:49
    [spkr,fsp]=spectar_of_20_ms(y1(160*i+1:160*(i+1)),fs);
    ssr1=ssr1+spkr;
end

ssr1=ssr1./50;

figure(4)
plot(fsp,ssr,'Linewidth',1.5);hold on;
plot(fsp,ssr1,'Linewidth',1.5);
xlabel('f[Hz]');ylabel('|X(jf)|,|Yz(jf)|');grid on;
title('Amplitudske karakteristike ulaznog i filtriranog signala');
legend('ulazi signal','filtriran signal');
saveas(figure(4),'ZAD_4_aks_nakon_butt_filtra.png');


%figure(5)
%plot(t,x);
%xlabel('t[s]');ylabel('x(t)');grid on;title('Ulazni signal');
%figure(6)
%plot(t,y1,'r');
%xlabel('t[s]');ylabel('y(t)');grid on;title('Izlazni signal y(t)');



%Pravljenje eliptic filtra

[n2,Wn2]=ellipord(Wp1,Ws1,Rp1,Rs1);
[b2,a2]=ellip(n2,Rp1,Rs1,Wp1,'stop');
[h2,f2]=freqz(b2,a2,N/2+1,fs);


%amlitudska frekvencijska karakteristika filtra
figure(5)
plot(f2,20*log10(abs(h2)),'k-','Linewidth',1.5);
xlabel('f[Hz]');grid on;
title('Amplitudska karakteristika eliptic filtra');
saveas(figure(5),'ZAD_4_aks_eliptic_filtra.png')
%filtriranje x
y2=filter(b2,a2,x);

%usrednjavanje spektra filtriranog signala
ssr2=zeros(1,length(Sp1))';
for i=0:49
    [spkr,fsp]=spectar_of_20_ms(y1(160*i+1:160*(i+1)),fs);
    ssr2=ssr2+spkr;
end
ssr2=ssr2./50;
figure(6)
plot(fsp,ssr,'Linewidth',1.5);hold on;
plot(fsp,ssr2,'Linewidth',1.5);
xlabel('f[Hz]');ylabel('|X(jf)|,|Yz(jf)|');grid on;
title('Amplitudske karakteristike ulaznog i filtriranog signala eliptickim filtrom');
legend('ulazi signal','filtriran signal');
saveas(figure(6),'ZAD_4_aks_original_i_eliptic.png');

figure(7)
plot(fsp,ssr,'Linewidth',1.5);hold all;
plot(fsp,ssr1,'Linewidth',1.5);
plot(fsp,ssr2,'Linewidth',1.5);
xlabel('f[Hz]');ylabel('|X(jf)|,|Yz(jf)|');grid on;
title('Amplitudske karakteristike originala i filtriranih ');
legend('original','Butterwoth','Eliptic');

figure(8)
plot(t,x);hold on;
plot(t,y1);
xlabel('t[s]');ylabel('y(t)');grid on;
title('Izlazni signal nakon primene Butterwoth filtra');
legend('original','filtriran');
saveas(figure(8),'ZAD_4_izlaz_nakon_filtra_butt.png');

figure(9)
plot(t,x);hold on;
plot(t,y1);
xlabel('t[s]');ylabel('y(t)');grid on;
title('Izlazni signal nakon primene Eliptic filtra');
legend('original','filtriran');
saveas(figure(9),'ZAD_4_izlaz_nakon_filtra_elpitic.png');

%funkcija koja je trazena da vraca spektar signala od 20,ms;
function [X1,fsp] = spectar_of_20_ms(x,fs)
    N=2^nextpow2(length(x));
    X=fft(x,N)/length(x);
    X1=abs(X(1:N/2+1));
    X1(2:N/2+1)=2*X1(2:N/2+1);
    fsp=0:fs/N:fs/2
end

