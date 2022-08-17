%script for SLV count in Original SL files
function SL=SLV_count(data)
SL=reshape(cell2mat(data.SL{1}),1,[]);
SL=zeros(length(data.SL),length(SL));
for trial=1:length(data.SL)
    SL(trial,:)=reshape(cell2mat(data.SL{trial}),1,[]);
end
