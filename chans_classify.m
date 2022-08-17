function channel=chans_classify(filename,matfile,rat_montage,initialword,attrword) %montage 包括.channel和.name属性
%% 2013-10-24 revised by zifang zhao revison for support mat structure
%% 2012-4-5 by Zifang Zhao change montage to rat_montage,增加新的参数initialword可选参数(attrword)
if nargin>4
    chans=channelpick(fieldnames(matfile),initialword,attrword); %选出有效通道(_unit2)
else
    chans=channelpick(fieldnames(matfile),initialword);
end
flds=fieldnames(matfile);
if isempty(chans) && length(flds)==1
    data=getfield(matfile,flds{1});
    chans=1:size(data,1); %please ensure each channel takes an row
end
channel.def=chans;
channel.name=filename;

for n=1:length(rat_montage)
    channel.region{n}.channel=[];
end


for n=1:length(rat_montage)
    channel.region{n}.name=rat_montage{n}.name;
    for m=1:length(chans)
        if(isempty(find(rat_montage{n}.channel==chans(m), 1)))%在montage各定义中查找目标通道号
        else
            channel.region{n}.channel=[channel.region{n}.channel ;chans(m)];
            
        end
    end
end
