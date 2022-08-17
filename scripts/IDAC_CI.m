%%
close all
Volt1(isnan(Volt1))=0;
Volt(isnan(Volt))=0;
fs=1/diff(second(1:2));
V_fil=fft_filter(Volt,50e3,500e3,fs);
[pks,loc]=findpeaks(V_fil,'SORTSTR','none','Minpeakdistance',32*round(1/170e3*fs),'MINPEAKHEIGHT',prctile(V_fil,90));
figure(1)
plot(Volt1)
[x,y]=ginput(2);loc=x;

% loc=smooth(Volt,10)>prctile(Volt,99);
% diff_loc=diff(loc);
% duration=diff(find(diff_loc==1,2))/32;
% t_start=find(diff_loc==1,1)+0.5*duration;
% t_end=find(diff_loc==1,2)+0.5*duration;t_end(1)=[];
duration=diff(loc(1:2))/32;
t_start=round(loc(1)+0*duration);
t_end=round(loc(2)+0*duration);

V_smooth=smooth(Volt,100);
indc=zeros(size(Volt));
indc(t_start:duration:t_start+31*duration)=1;
figure(1);subplot(211);plot(Volt);
hold on; 
% plot(indc*max(Volt),'r');
hold off
subplot(212);plot(Volt1);
hold on; 
% plot(indc*max(Volt1),'r');
hold off
voff=V_smooth(t_start:duration:t_start+31*duration);

%% 
current_off='DB 057H,05FH,057H,05FH,05BH,05FH,043H,05FH,04FH,05FH,04DH,05FH,045H,05FH,059H,05FH DB 07FH,05FH,065H,05FH,070H,05FH,071H,05FH,069H,05FH,07FH,05FH,079H,05FH,07FH,05FH'
current_off=strrep(current_off,' DB ',',');
current_off=strrep(current_off,'DB ',' ');
locs=[0 strfind(current_off,',') length(current_off)+1];
offsets=arrayfun(@(x) hex2dec(current_off(locs(x)+1:locs(x+1)-2)),1:length(locs)-1);

%% template matching
V1_offset=Volt1(t_start:duration:t_start+31*duration);
ranking=zeros(size(V1_offset));
for idx=1:length(V1_offset)
    ranking(idx)=sum((circshift(zscore(V1_offset)',[0 idx])-zscore(offsets)).^2);
end
[~,ix]=min(ranking);
offset_idx=0;
V1_offset_shifted=circshift(V1_offset',[0 ix+offset_idx]);
voff=circshift(voff',[0 ix+offset_idx]);

indc=zeros(size(Volt));
indc(t_start+ix*duration:duration:t_start+31*duration+ix*duration)=1;
hold on;
plot(indc*max(Volt1),'g')
hold off
subplot(211)
hold on;
plot(indc*max(Volt),'g')
hold off
%% offset analysis
offset=0;
if exist('Volt2')
   Volt2(isnan(Volt2))=0;
   V2_smooth=smooth(Volt2,50);
   [V2_pks,loc]=findpeaks(V2_smooth,'Sortstr','descend','Minpeakdistance',32*round(1/170e3*fs));
   V2_offset=mean(V2_pks);
%    V_IA=mean(V_smooth(loc));
end
figure(2);
% plot(V1_offset_shifted);hold on;plot(offsets/256,'r');hold off;
plot(mapminmax(V1_offset_shifted,0,1));hold on;plot(mapminmax(offsets,0,1),'r');hold off
ADJ=5;
v_adj=-(ADJ*(voff-1.3));
v_adj=round(v_adj);
legend('Real','Calculated')
new_offset=offsets+v_adj;
% new_offset=new_offset-min(new_offset);
new_offset(new_offset>255)=255;
new_offset(new_offset<0)=0;

figure(3)
plot(offsets);
hold on
plot(new_offset,'r');
plot(mapminmax(voff,min(new_offset),max(new_offset)),'g')
legend('OLD SEQ','NEW SEQ','IA OUT')
hold off

new_cmd=['DB '];
for idx=1:length(new_offset)
    if idx==length(new_offset)
        new_cmd=[new_cmd '0' dec2hex(new_offset(idx),2) 'H'];
    else
        if ~mod(idx,16)
            new_cmd=[new_cmd '0' dec2hex(new_offset(idx),2) 'H DB '];
        else
            new_cmd=[new_cmd '0' dec2hex(new_offset(idx),2) 'H,'];
        end
    end
end