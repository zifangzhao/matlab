%% general  PCMI for formalin
function [rate_all]=general_for_rate_bhv(time_range)
%% load ��Ϊxls (including starts,ends)
bhvfile=dir('*.xls');
newData = importdata(bhvfile.name);
clear('bhvfile');
%% load MAT-files
matfile=dir('*002.mat');
for i=1:length(matfile)
    days{i}=load(matfile(i).name);
end
%% channel picking
chans=channelpick(fieldnames(days{1}),'unit2');
%% data_reorganize
for i = 1:length(chans)
    eval(['channels_ori{' num2str(i) '} = days{1}.elec' num2str(chans(i)) '_unit2;']);
end

%% �ֲ�ͬ��Ϊ��3��ʱ�����PCMI����
phas_size=size(time_range);
bhv_name=fieldnames(newData);
datasheet_size=size(fieldnames(newData));
for bhv=1:datasheet_size(1);
    fieldname=bhv_name(bhv);fieldname=fieldname{1};
    for phas=1:phas_size(1);
        %����time_range���н�ȡ
        eval(['temp=newData.' fieldname ';'])
        bhv_time=findinrange(temp,time_range(phas,:)); clear temp;
        %�ٶ�ȡ��ʼ������ʱ��
        if(isempty(bhv_time))
            starts=[];
            ends=[];
            rate(:,phas+1)=nan(size(channels_ori'));
        else
            starts=bhv_time(:,1);
            ends=bhv_time(:,2);
            chose_range=[starts ends];
            chose_time=sum(ends-starts);
            
            for i=1:length(channels_ori)
                rate(i,1)=chans(i);
                if chose_time==0
                    rate(i,phas+1)=0;
                else
                    tobe=channels_ori{1,i};
                    tobe2=[tobe tobe];
                    chosen=findinrange(tobe2,chose_range);
                    counts=size(chosen,1);
                    rate(i,phas+1)=counts/chose_time;
                end
            end
        end
    end
    rate_all{bhv}.name=fieldname;
    rate_all{bhv}.data=rate;
end
end
