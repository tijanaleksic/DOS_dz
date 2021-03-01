filename='snimak1.wav';
Fs=8000;
recObj=audiorecorder;
disp('Start speaking.');
t=1; %1 sekund
recordblocking(recObj,t);
disp('End of Recording');
x=getaudiodata(recObj);
play(recObj);
audiowrite(filename,x,Fs);
