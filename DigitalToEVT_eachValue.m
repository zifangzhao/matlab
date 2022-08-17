%%
[f,p]=uigetfile('*digitalin.dat');
data=readmulti_frank([p f],1,1,0,inf,'uint16');
data_diode=bitand(data,hex2dec('080'));
data_bhv=bitand(data,hex2dec('7f'));
minDuration=5;  %minimal signal duration in ms
fs=20e3;
data_types=unique(data_bhv);
data_types(data_types==0)=[];

for idt=1:length(data_types)
    ind=[data_bhv; 0]==data_types(idt);
    diff_ind=diff([0; ind]);
    sts=find(diff_ind>0);
    eds=find(diff_ind<0);
    lens=eds-sts;
    id_sel=find(lens>minDuration*fs/1000);
    
    events=[];
    for idx=1:length(id_sel)
        
        events.time(2*idx-1)=sts(id_sel(idx))/fs;
        events.description{2*idx-1}='Start';
        events.time(2*idx)=eds(id_sel(idx))/fs;
        events.description{2*idx}='End';
    end
    
    if(data_types(idt)<100)
        attr=['A' num2str(data_types(idt),'%.2d')];
    else
        attr=['B' num2str(mod(data_types(idt),100),'%.2d')];
    end
    
    if(~isempty(events))
        if ispc
            system(['del "' p f(1:end-3) attr '.evt"']);
        else
            system(['rm ''' p f(1:end-3) attr '.evt''']);
        end
        SaveEvents([p f(1:end-3) attr  '.evt'],events);
    end
end

ind=[data_diode; 0]~=0;
diff_ind=diff([0; ind]);
sts=find(diff_ind>0);
eds=find(diff_ind<0);
lens=eds-sts;
id_sel=lens>minDuration*fs;
events=[];
for idx=1:length(id_sel)
    events.time(2*idx-1)=sts(idx)/fs;
    events.description{2*idx-1}='Start';
    events.time(2*idx)=eds(idx)/fs;
    events.description{2*idx}='End';
end
if(~isempty(events))
    if ispc
        system(['del "' p f(1:end-3)  'dio.evt"']);
    else
        system(['rm ''' p f(1:end-3) 'dio.evt''']);
    end
    SaveEvents([p f(1:end-3) 'dio.evt'],events);
end