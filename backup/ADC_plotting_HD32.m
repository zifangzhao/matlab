chn_num=1;
chn=1;
mux_num=32;X=4;%Y=8;
channel_list=[1:32];%[1:mux_num];
precision=1;
if ~exist('read_mode')
read_mode=2;
end
offset=ones(100000,1)*655350*[1:chn_num];
fs=5710*32;
% fs=214.56e3/5;
% fs_d=20e3;
Wn=[5000];
Rs=fs/mux_num;
n=2;
[bb,aa]=butter(n,Wn/Rs,'low');
cont=1;
% if ~exist('display_time')
display_time=30;% in Second
% end
convert_eff=1/65535*3/600*1e6;
% if ~exist('Yrange')
Yrange=[-32768*convert_eff 32767*convert_eff];
% end

f=dir('*.dat');
[s,v] = listdlg('PromptString','Select a file:',...
                'SelectionMode','single',...
                'ListString',arrayfun(@(x) f(x).name,1:length(f),'UniformOutput',0));
 filename=f(s).name;
 
 figure ('Name',cat(2,'Voltage range = ' ,num2str(Yrange) ,'uV', 'time scale= ', num2str(display_time),'s' ));

while(cont)
    a=readmulti_frank(filename,chn_num,1:precision:chn_num,-display_time*2*fs,0,'int16');
%     cont=~isequal(a_new,a);
%     a=a_new;
    if(read_mode==2)
         a_bin=dec2bin(a+32768,16);
         counter=bin2dec(a_bin(:,end-4:end));
         a_bin(:,end-4:end)=repmat('00000',size(a,1),1);
         a=bin2dec(a_bin(:,1:end-6))-32768;
         
    end
a=a*convert_eff;         
%     a=fft_filter(a',0,200e3,fs)';
%    a=smooth(a,10);
%    a=resample(a,fs_d,fs);
%     b=a./65535;%*3/200*1e6;
% c=mean(b,1);
% b=smooth(a(:,2),20);
%     c1=dec2bin(a(:,1));
%     c2=dec2bin(a(:,1));
%     cnt=bin2dec([c2(:,4:end) c1(:,end)]);
% %    c2(:,4:end)=repmat('0',size(c2,1),5);
%     a2=a(:,1);
%     a2(:,2)=bin2dec(c2);
% offset = 1e4;    
% b=[b(:,1) b(:,2)+offset b(:,3)+2*offset b(:,4)+3*offset];

%     plot(a(:,2))
% x=(1:size(a,1))/fs;
% x2=(1:size(a,1)/mux_num)/Rs;
% plot(x,a);


for idx=1:length(channel_list)
%     subplot(1,1,1)
subplot(ceil(length(channel_list)/X),X,idx)
% temp=fft_filter(a(idx:mux_num:end,1),0,500,5.6e3)';
temp=filter(bb,aa,a(channel_list(idx):mux_num:end,chn));
% temp=a(idx:mux_num:end,end);
x2=(1:size(temp,1))/Rs;
plot(x2,temp)
axis tight
set(gca,'xtick',[],'ytick',[])

if(read_mode==2)
    ylim([-1e4 1024]);
else
    ylim(Yrange);
% ylim([1.5e4,4.2e4])
% ylim([-1e4 1e4])
% ylim([3e4 5.5e4]);
end
% drawnow
end
% subplot(3,1,3)
% plot(a(:,3));
% ylim([0 65535])
% ylim([0 1])
% xlabel('time/s');
% ylabel('voltage /uV')

   % xlim([-300,300*chn_num])
    %ylim([0,65535]);
    %axis tight
    drawnow;
end