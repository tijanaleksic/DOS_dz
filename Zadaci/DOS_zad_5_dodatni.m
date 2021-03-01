clear all;close all;clc;

%definisanje imena falja koji se ucitava,prethodno snimljen u snimanje.m
filename='snimak1.wav'
[x,fs]=audioread(filename);
%definisanje vremenske ose da bi se nacrtao snimak
t=0:1/fs:(length(x)-1)/fs;

%ocekivana vrednost
a=pitch(x,fs);
pitch_wanted=sum(a)/length(a);
%iznosi 213.1044



%furijeova transformacija
N=2^nextpow2(length(x));
X=fft(x,N)/length(x);
X1=abs(X(1:N/2+1));
X1(2:N/2+1)=2*X1(2:N/2+1);
f1=0:fs/N:fs/2;

figure(1)
plot(f1,X1);
xlabel('f[Hz]'),ylabel('|X(jf)|'),title('Amplitudski spektar');
x120=x(161:160*2+1);
[Sp1,fp1]=spectar_of_20_ms(x120,fs);
ssr=zeros(1,length(Sp1))';
%usrednjavanje spektra originalnog signala
for i=0:49
    [spkr,fsp]=spectar_of_20_ms(x(160*i+1:160*(i+1)),fs);
    ssr=ssr+spkr;
end
ssr=ssr./50;
%proba na jednom delu signala
pitch=pitch_of_20_ms(Sp1,fp1);

pitch_sum=0;
num=50;
for i=0:49
    [spkr,fsp]=spectar_of_20_ms(x(160*i+1:160*(i+1)),fs);
    pitch_to_sum=pitch_of_20_ms(spkr,fsp);
    if(pitch_to_sum>300)
        num=num-1;
    else
        pitch_sum=pitch_sum+pitch_to_sum;
    end
end


%konacna dobijena frekvencija dobijena usrednjavanjem signala je 218.75
konacno=pitch_sum/num;
%funkcija koja je trazena da vraca spektar signala od 20,ms;
function [X1,fsp] = spectar_of_20_ms(x,fs)
    N=2^nextpow2(length(x));
    X=fft(x,N)/length(x);
    X1=abs(X(1:N/2+1));
    X1(2:N/2+1)=2*X1(2:N/2+1);
    fsp=0:fs/N:fs/2;
end
function pitch_freq = pitch_of_20_ms(X1,f1)
    max_to_find=max(X1);
    for i=1 :length(X1)
        if(X1(i)==max_to_find)
            index=i;
            pitch_freq=f1(index);
            break;
        end
    end
    
end
