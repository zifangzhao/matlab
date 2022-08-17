%merge plexon matlab file
[f,p]=uigetfile('*.mat');
mo=matfile([p f]);
vars=who(mo);
raw_name=regexpi(vars,'\d+$','match');
filled_index=~(cellfun(@isempty,raw_name));
elec_names=vars(filled_index);
eval(['len=length(mo.' elec_names{2} ');']);
data=zeros(length(elec_names),len);
for idx=2:length(elec_names)
    eval(['data(idx,:)=mo.' elec_names{idx} ';']);
end

%%
[f,p]=uiputfile('*.mat');
% save([p f],'data');
convert_eff=200/65535;
fh=fopen([p f(1:end-4) '.dat'],'w+');
fwrite(fh,data/convert_eff,'int16');
fclose(fh);

