P=3;
N=(P+1)*10;

%kreiranje niza x
x=0:N-1;
for i=N/2:N-1
    x(i+1)=1-i-N/2;
end
%kreiranje niza y[n]
t=0:N-1;
y=zeros(1,N);
for i=0:N-1;
    if(i<N/2)        
        y(i+1)=2*cos((P+1)*i+pi/4);
    end
end



figure(1),
hold all;
stem(t,x);
stem(t,y);
ylabel('x[n],y[n]'),xlabel('n[1:N-1]'),title('Grafici x[n] i y[n]');
legend('x[n]','y[n]')
saveas(figure(1),'zad_1_xy.png');


%linearna kovolucija 


%rucno racunata
xp=cat(2,x,zeros(1,length(x)));
yp=cat(2,y,zeros(1,length(y)));
lin_rucno=zeros(1,length(x)+length(y)-1);
for n=1:length(lin_rucno)
    for k=1:n
        lin_rucno(n)=lin_rucno(n)+xp(k)*yp(n-k+1);
    end
end




lin_conv=conv(x,y);
tlin=0:length(lin_conv)-1;
figure(2);
hold all;
subplot(2,1,1);
stem(tlin,lin_conv);
ylabel('z[n]'),xlabel('n'),title('Linearna konvolucija signala x[n] i y[n] dobijena sa conv');
saveas(figure(2),'zad_1_lin_konv.png');
subplot(2,1,2); 
stem(tlin,lin_rucno);
ylabel('z[n]'),xlabel('n'),title('Linearna konvolucija signala x[n] i y[n] dobijena rucno');
saveas(figure(2),'zad_1_lin_konv.png');


%ciklicna konvolucija

%rucno kucana;
cikl_rucno=zeros(1,length(x));
for n=1:length(cikl_rucno)
    for k=1:length(cikl_rucno)
        cikl_rucno(n)=cikl_rucno(n)+x(k)*y(mod(n-k,N)+1);
    end
end
 

cikl_conv=cconv(x,y,N);
tcik=0:length(cikl_conv)-1;
figure(3);
hold all;
subplot(2,1,1);
stem(tcik,cikl_rucno);
ylabel('z[n]'),xlabel('n'),title('Ciklicna konvolucija signala x[n] i y[n] u N tacaka dobijena rucno')
legend('rucno','ugradjeno')
subplot(2,1,2);
stem(tcik,cikl_conv);
ylabel('z[n]'),xlabel('n'),title('Ciklicna konvolucija signala x[n] i y[n] u N tacaka dobijena sa cconv')
legend('rucno','ugradjeno')
saveas(figure(3),'zad_1_cik_konv.png')

%preklapanje ciklicne i linearne konvolucije
for i=1:max(length(lin_conv),length(cikl_conv))
    if(i<min(length(lin_conv),length(cikl_conv)))
        cc_to_compare(i)=cikl_conv(i);
    else
        cc_to_compare(i)=cikl_conv(i-min(length(lin_conv),length(cikl_conv))+1);
    end
end

preklapanja=(abs(cc_to_compare-lin_conv)<0.00001);
for i=1:length(preklapanja)
    if(preklapanja(i)==1)
        fprintf('Preklapaju se u %i \n',i);        
    end
end
yosa=0:78;
figure(4)
stem(yosa,preklapanja);
title('Indeksi kada se preklapaju linearna i ciklicna konvolucija');
saveas(figure(4),'ZAD_1_preklapanja.png');