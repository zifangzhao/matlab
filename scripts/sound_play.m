% sound convertion of rawdata
fs=1e3;
beep_s=sin(1:10:2000);
data=elec22;
% data_fil=fft_filter(data,4,8,fs);
data_fil=data;
sti_s=zeros(size(data_fil));
t=1:length(elec30);
for idx=1:length(ainp1_unit32)
    temp=abs(t-ainp1_unit32(idx)*fs);
    [~,idx_min]=min(temp);
    if length(data)<idx_min+length(beep_s)
        next=length(data)-(idx_min+length(beep_s));
    else
        next=length(beep_s);
    end
    sti_s(idx_min:idx_min+next-1)=beep_s(1:next);
end
combined=data_fil+max(data_fil)*sti_s;
sound(combined,1000)
