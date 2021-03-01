clear all;
close all;
clc;

%parametar Q=2

filename='audio2.wav';
[x,Fs]=audioread(filename);
t=0:1/Fs:(length(x)-1)/Fs;
%plot(t,x);
%sound(x,Fs);
Fs1=440;
%aproksimirano koji je korak odabira za sempling od 440Hz
apr=round(Fs/Fs1);
j=1;
for i=1:apr:length(x)
    y(j)=x(i);
    ty(j)=t(i);
    j=j+1;
end


figure(1);
hold all;
plot(t,x);
scatter(ty,y,'r*');
grid on;
xlim([0 30/Fs1]);
xlabel('t'),ylabel('x(t),x[n]'),title('Signal x(t) i prvih 30 odbiraka sa frekvencijom 440Hz'),legend('x(t)','Odbirci')
saveas(figure(1),'ZAD_2_signal_i_odabran.png')

figure(4);
hold all;
plot(t,x);
scatter(ty,y,'r*');
grid on;
xlabel('t'),ylabel('x(t),x[n]'),title('Signal x(t) i prvih 30 odbiraka sa frekvencijom 440Hz'),legend('x(t)','Odbirci')
saveas(figure(4),'ZAD_2_signal_i_odabran_ceo.png')

%amplitudska karakteristika

N=2^nextpow2(length(x));
X=fft(x,N)/length(x);
X1=abs(X(1:N/2+1));
X1(2:N/2+1)=2*X1(2:N/2+1);
f1=0:Fs/N:Fs/2;

figure(2);
plot(f1,X1)
xlabel('f'),ylabel('|X(jf)|'),title('Amplitudska frekvencijska karakteristika');
saveas(figure(2),'ZAD_2_amp_karakteristika.png')

%deo zadatka sa pronalazenjem frekvencija

for i=1:12
    mult(i)=2^(i/12);
    freq(i)=220*mult(i);
end

%
tones=["b", "h", "c", "cis", "d", "dis", "e", "f" ,"fis", "g", "gis", "a"];
%vrednost od 0.17 odredjena je na osnovu spektra u opsegu 220 do 440 Hz gde
%se nalazi jedna cela oktava od a do a1(od a u velikoj do a u maloj oktavi)
finds=find(X1>0.17);
for i=1:2:length(finds)
    for j=1:length(freq)
        if((f1(finds(i))<freq(j)) && (f1(finds(i+1))>freq(j)))
            fprintf('Ton koji je odsviran je %s   \n',tones(j));
        end 
    end
end
figure(3)
plot(f1,X1)
xlabel('f'),ylabel('|X(jf)|'),title('Amplitudska frekvencijska karakteristika');
xlim([200 450])
saveas(figure(3),'ZAD_2_amp_od_200_do_450Hz.png')
%tonovi su a d fis


