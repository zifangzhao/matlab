%%script for calculating Gain from scope data
Group=[99:106;107:114;115:122];
Freq=[1 10 100 1000 10e3 100e3 200e3 500e3];
Gain=zeros(size(Group));

for idx=1:size(Group,1)*size(Group,2);
    dat=xlsread(['Scope_' num2str(Group(idx)) '.csv'],'A3:D10000');
    for idxx=size(dat,2)
        dat(:,idxx)=smooth(dat(:,idxx),100);
    end
    % dat=importdata(['Scope_' num2str(Group(idx)) '.csv']);
    Gain(idx)=range(dat(:,3))/range(dat(:,2));
end

%for origin
OUT=[Freq;Gain]';
