%%
[f,p]=uigetfile('digitalin.dat');
data=readmulti_frank([p f],1,1,0,inf,'uint16');
digital_sig=dec2digits(data,16);
fs=20e3;
for c_idx=1:16
    diffSig=diff([0 digital_sig(:,c_idx) 0]);
    locs_this=find(diffSig==1);
    locs_ends=find(diffSig==-1);
    
    locs_this=zeros(length(idxs{c_idx}),1);
    events.description=cell(length(locs_this)*2,1);
    for idx=1:length(locs_this)
        locs_this(2*idx-1)=locs_starts(idxs{c_idx}(idx));
        events.description{2*idx-1}='Start';
        locs_this(2*idx)=locs_ends(idxs{c_idx}(idx));
        events.description{2*idx}='End';
    end
    events.time=locs_this/fs;
    
    events.description=cell(length(locs_this),1);
    for idx=1:length(locs_this)
        events.description{idx}=['Digit' num2str(c_idx-1)];
    end
    events.time=locs_this/fs;
    if ispc
        system(['del "' p f(1:end-4) '.c'  num2str(c_idx-1,'%.2d') '.evt"']);
    else
        system(['rm ''' p f(1:end-4) '.c'  num2str(c_idx-1,'%.2d')  '.evt''']);
    end
    SaveEvents([p f(1:end-4) '.c'  num2str(c_idx-1,'%.2d')  '.evt'],events);
end