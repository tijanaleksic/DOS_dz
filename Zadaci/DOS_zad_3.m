%Eliptic i Chebishev 1
clear all;close all;clc;

%parametar za koji se radi zadatak
R=1;
%ucitavanje signala koji se obradjuje
data=load(['ekg' num2str(R) '.mat']);
x=data.x;
fs=data.fs;
%vremenski domen
t=0:1/fs:(length(x)-1)/fs;
figure(1);
plot(t,x);
%xlim([0 4])
xlabel('vreme t'),ylabel('signal x(t)'),title('Vremenski signal x(t)');
saveas(figure(1),'ZAD_3_vremenski_signal.png');

%frekvencijski domen

N=2^nextpow2(length(x));
X=fft(x,N)/length(x);
X1=abs(X(1:N/2+1));
X1(2:N/2+1)=2*X1(2:N/2+1);
f1=0:fs/N:fs/2;


figure(2);
plot(f1,X1);
xlabel('f'),ylabel('|X(jf)|'),title('Amplitudska karakteristika signala x(t)');
saveas(figure(2),'ZAD_3_amplitudska_karakteristika.png');



%chebishev type 1;


%frekvencija Koju treba da ne propustimo:
Frekv=25;%[Hz]

%pravljenje parametara za Cheby filtar

%opsezi u kojima ce biti zakrivljenje filtra
Wp1=[90*Frekv/100 110*Frekv/100]*2*pi;
Ws1=[80*Frekv/100 120*Frekv/100]*2*pi;
%maksimalno slabljenje u propusnom opsegu
Rp1=2;%[dB]
%minimalno slabljenje u nepropusnom opsegu
Rs1=40;%[dB]

%pravljenje analognog filtra i izracunavanje reda n1 i opsega Wn1
[n1, Wn1]=cheb1ord(Wp1,Ws1,Rp1,Rs1,'s');
%izracunavanje parametara filtra a i b koji se prosledjuju funkciji filter
[b1, a1] = cheby1(n1,Rp1,Wp1,'stop','s');

%diskretizacija bilinearnom metodom
fp=10;
[bz,az]=bilinear(b1,a1,fs,fp);

%odziv analognog filtra
[h1, w1]=freqs(b1,a1,N/2+1);
%odziv digitalnog filtra 
[hz,fz]=freqz(bz,az,N/2+1,fs);


%amlitudska frekvencijska karakteristika filtra
figure(3)
plot(w1/(2*pi),20*log10(abs(h1)),'k-','Linewidth',1.5);hold on;
plot(fz,20*log10(abs(hz)),'r','LineWidth',1.5);
xlabel('f[Hz]');grid on;
title('Ampl. karakteristika Chebisev 1 analognog i digitalnog filtra');
legend('analogni','digitalni')
saveas(figure(3),'ZAD_3_afk_aid_cheb1.png')

%filtriranje x


yz=filter(bz,az,x);
ya=filter(b1,a1,x);
%digitalan filtar;
Yz=fft(yz,N)/length(yz);
Yz1=abs(Yz(1:N/2+1));
Yz1(2:N/2+1)=2*Yz1(2:N/2+1);
%analogni filtar
Y=fft(ya,N)/length(ya);
Ya1=abs(Y(1:N/2+1));
Ya1(2:N/2+1)=2*Ya1(2:N/2+1);

%crtanje karakterisitka ulaznog i izlaznog 
figure(4)
plot(f1,X1,'Linewidth',1.5);hold on;
plot(f1,Yz1,'Linewidth',1.5);
xlabel('f[Hz]');ylabel('|X(jf)|,|Yz(jf)|');grid on;
title('Ampl. karakteristike ulaznog i izlaznog signala posle Chebisev 1');
legend('ulazi signal','izlazni signal');
saveas(figure(4),'ZAD_3_akf_aid_uii.png');


figure(5)
subplot(2,1,1)
plot(t,x);
xlabel('t[s]');ylabel('x(t)');grid on;title('Ulazni signal');
subplot(2,1,2)
plot(t,yz,'r');
xlabel('t[s]');ylabel('x(t)');grid on;title('Izlazni signalza Chebisev 1');
saveas(figure(5),'ZAD_3_ulaz_izlaz_cheb.png');





%eliptic 

[n2,Wn2]=ellipord(Wp1,Ws1,Rp1,Rs1,'s');
[b2,a2]=ellip(n2,Rp1,Rs1,Wp1,'stop','s');

%diskretizacija bilinearnom metodom
fp2=10;
[bze,aze]=bilinear(b2,a2,fs,fp2);

%odziv analognog filtra
[h2, w2]=freqs(b2,a2,N/2+1);
%odziv digitalnog filtra 
[hze,fze]=freqz(bze,aze,N/2+1,fs);


%amlitudska frekvencijska karakteristika filtra
figure(7)
plot(w1/(2*pi),20*log10(abs(h2)),'k-','Linewidth',1.5);hold on;
plot(fze,20*log10(abs(hze)),'r','LineWidth',1.5);
xlabel('f[Hz]');grid on;
title('Amplitudska karakteristika analognog i digitalnog Eliptic filtra');
legend('analogni filtar','digitalni filtar');
saveas(figure(7),'ZAD_3_afk_aid_eliptic.png');

%filtriranje x
yze=filter(bze,aze,x);
yae=filter(b2,a2,x);
Yze=fft(yze,N)/length(yze);
Yz1e=abs(Yze(1:N/2+1));
Yz1e(2:N/2+1)=2*Yz1e(2:N/2+1);

Ye=fft(yae,N)/length(yae);
Ya1e=abs(Ye(1:N/2+1));
Ya1e(2:N/2+1)=2*Ya1e(2:N/2+1);

figure(8)
plot(f1,X1,'Linewidth',1.5);hold on;
plot(f1,Yz1e,'Linewidth',1.5);
xlabel('f[Hz]');ylabel('|X(jf)|,|Yz(jf)|');grid on;
title('Ampl. karakteristike ulaznog i izlaznog signala posle eliptic');
legend('ulazi signal','izlazni signal');
saveas(figure(8),'ZAD_3_afk_ulaz_izlaz_eliptic.png');

figure(9)
subplot(2,1,1)
plot(t,x);
xlabel('t[s]');ylabel('x(t)');grid on;title('Ulazni signal');
subplot(2,1,2)
plot(t,yze,'r');
xlabel('t[s]');ylabel('x(t)');grid on;title('Izlazni signal za eliptic');
saveas(figure(9),'ZAD_3_ulaz_izlaz_eliptic.png');
