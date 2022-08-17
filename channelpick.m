%% channel picking
%channelnamesΪ��Ҫ���н�����ַ�����findnameΪ��ѯ�����֣�findattrΪ����+��׺�ĺ�׺��digit�������ò�ѯ��ŵ�λ��
%2012-3-25 version by Zifang zhao modified,
%������LFP����ֻ��һ������ʱ��������findname��,����λ�����ɲ鲻ͬinitial words
function channels=channelpick(channelnames,findname,findattrname,digit)  %input fieldnames of days
channels=[];
if nargin<4
    digit=2;
end
if nargin<3
    for a=1:length(channelnames)
        num_temp=[];
        temp=channelnames(a);temp=temp{1};
        num_idx=(strfind(temp,findname)+length(findname));
        if length(temp)-num_idx<=digit;
            num_temp=(temp(num_idx:end));
        end
        if isempty(num_temp);
        else
            channels=[channels str2double(num_temp)];
        end
    end
else
    for a=1:length(channelnames)
        num_temp=[];
        temp=channelnames(a);temp=temp{1};
        num_idx=(strfind(temp,findname)+length(findname));
        attr_idx=strfind(temp,findattrname);
        if(length(temp)>=num_idx)
            if(strcmp(temp(end-length(findattrname)+1:end),findattrname))
                num_temp=(temp(num_idx:attr_idx-1));
                if(strcmp(num_temp(end),'_'))
                    num_temp=num_temp(1:end-1);
                end
                if isempty(num_temp);
                else
                    channels=[channels str2double(num_temp)];
                end
            end
        end
    end
end
channels=sort(channels);