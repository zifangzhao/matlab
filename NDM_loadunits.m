%% load cluster and spike files
function units=NDM_loadunits(f,loadCluType,load_waveform,waveform_win)
if nargin<1
    [f,p]=uigetfile({'*.lfp','*.lfp|Select lfp files';'*.dat','*.dat|Select dat files';}); %get file need to be clippered
    f=[p f];
end
if nargin<2
    loadCluType=0;
end

if nargin<3
    load_waveform=0;
end

if nargin<4
    waveform_win=20;
end
fbase=[f(1:end-4) '.dat'];
fraw=f;
[p,f,e]=fileparts(fbase);
if ~ispc
    p=[p '/'];
else
    p=[p '\'];
end

for idx=1:length(f)
    fc_all=dir([p f(1:idx) '.clu.*']);
    if ~isempty(fc_all)
        break;
    end
end

gain=0.195; %from digit to uV
% waveform_win=20;

if ~isempty(fc_all)
    [Nch,fs,~,~,~,~,~,~]=DAT_xmlread(fbase);
    units.data=cell(length(fc_all),1);
    units.data_cell=cell(length(fc_all),1);
    units.name=cell(length(fc_all),1);
    for idx=1:length(fc_all)
        try
            fc=fc_all(idx).name;
            clu=importdata([p fc]);
            spk_time=importdata([p strrep(fc,'.clu.','.res.')])/fs; %spike time
            spk_Nclu=clu(1);
            spk_clu=clu(2:end);  %cluster index for each spike
            
            %% remove Noise and MUA
            sel_idx=spk_clu>1;
            spk_clu=spk_clu(sel_idx);
            spk_time=spk_time(sel_idx);
            
            
            spk_uniq=unique(spk_clu);
            if loadCluType~=0
                unit_type=importdata([p strrep(fc,'.clu.','.cls.')]); %load unit type
                units.data{idx}=[spk_time,spk_clu,unit_type];
                units.data_cell{idx}=arrayfun(@(x) spk_time(spk_clu==x),spk_uniq,'uni',0);
            else
                units.data{idx}=[spk_time,spk_clu];
                units.data_cell{idx}=arrayfun(@(x) spk_time(spk_clu==x),spk_uniq,'uni',0);
            end
            
            if load_waveform
                units.filtWaveform{idx}=cell(length(units.data_cell{idx}),1);
                for uidx=1:length(units.data_cell{idx})
                    waveform=arrayfun(@(x) gain*readmulti_frank(fraw,Nch,1:Nch,x*fs-waveform_win/2,x*fs+waveform_win/2),units.data_cell{idx}{uidx},'uni',0);
                    waveform_len=cellfun(@length,waveform);
                    waveform=waveform(waveform_len==max(waveform_len));
                    waveform_cat=cat(3,waveform{:});
                    units.filtWaveform{idx}{uidx}=waveform_cat;
                end
            end
            units.name{idx}=fc;
        end
    end
else
    units=[];
end