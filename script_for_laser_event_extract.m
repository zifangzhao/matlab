%script for extracting all laser trigger
[f,p]=uigetfile('*.dat','Select original Data file, laser trigger Nch=33');
data=readmulti_frank([p f],33,33,0,inf);

%%
threshold=1.5e4;
laser_thre=20; %laser length threshold in millisecond
fs=20e3;

%%
locs=data>threshold;
locs_diff=diff([0 ;locs]);
locs_starts=find(locs_diff==1);
locs_ends=find(locs_diff==-1);
locs_length=locs_ends-locs_starts;


len_thre=laser_thre*fs/1000;
idx_high=find(locs_length>len_thre);
idx_low=find(locs_length<len_thre);

locs_high=zeros(length(idx_high),1);
events.description=cell(length(locs_high)*2,1);
for idx=1:length(locs_high)
    locs_high(2*idx-1)=locs_starts(idx_high(idx));
    events.description{2*idx-1}='Start';
    locs_high(2*idx)=locs_ends(idx_high(idx));
    events.description{2*idx}='End';
end
events.time=locs_high/fs;
if ispc
    system(['del ' p f(1:end-4) '.hls.evt']);
else
    system(['rm ''' p f(1:end-4) '.hls.evt''']);
end
SaveEvents([p f(1:end-4) '.hls.evt'],events);

locs_low=zeros(length(idx_low),1);
events.description=cell(length(locs_low)*2,1);
for idx=1:length(locs_low)
    locs_low(2*idx-1)=locs_starts(idx_low(idx));
    events.description{2*idx-1}='Start';
    locs_low(2*idx)=locs_ends(idx_low(idx));
    events.description{2*idx}='End';
end
events.time=locs_low/fs;
if ispc
    system(['del ' p f(1:end-4) '.lls.evt']);
else
    system(['rm ''' p f(1:end-4) '.lls.evt''']);
end
SaveEvents([p f(1:end-4) '.lls.evt'],events);