%%convert old SL data to new generalized data form
function g_data=oldSLconvert(collected_data)
collected_data=reshape(collected_data,1,[]);
g_data=cell(size(collected_data));
for fileidx=1:length(collected_data)
%     g_data{fileidx}.attr=collected_data{fileidx}.attr;
%     g_data{fileidx}.attrname=collected_data{fileidx}.attrname;
    g_data{fileidx}.name=collected_data{fileidx}.name;
    g_data{fileidx}.data.SL=[];

    datafield=fieldnames(collected_data{fileidx}.data);
    for dataidx=1:length(datafield)
        eval(['g_data{fileidx}.data.' datafield{dataidx} '=convertion(collected_data{fileidx}.data.' datafield{dataidx} ');']);
    end
    multiWaitbar('Files:',fileidx/length(collected_data));
end
multiWaitbar('Closeall');
end

function newcell=convertion(oldmat)
newcell=cell(1,size(oldmat,3));

for trial=1:size(oldmat,3)
    newcell{trial}=cell(size(oldmat,1),size(oldmat,2));
    for cha=1:size(oldmat,1)
        for chb=1:size(oldmat,2)
            newcell{trial}{cha,chb}=reshape(oldmat(cha,chb,trial),1,[]);
        end
    end
end

end