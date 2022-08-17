cwd=pwd;
cd('c:');
fid=fopen('wanlab_info.txt','r');
found=0;
if fid~=-1
    addr=fscanf(fid,'%s');
    fclose(fid);
    disp(['Obtained IP address from last session,validating:' addr]);
    [~,res]=system(['tcping -a -s 0 -w 0.1 -n 1 ' addr ' 959']);
    if ~isempty(strfind(res,'open'))
        disp('Target IP found')
        targetip=addr;
        found=1;
    end
end
if ~found
    for ip3=48:60
        for ip4=1:255
            if ~found
                addr=['211.71.' num2str(ip3) '.' num2str(ip4)];
                disp(['checking IP:' addr]);
                [~,res]=system(['tcping -a -s 0 -w 0.1 -n 1 ' addr ' 959']);
                if ~isempty(strfind(res,'open'))
                    disp('Target IP found')
                    found=1;
                    targetip=addr;
                end
            end
        end
    end
end
if found
    fid=fopen('wanlab_info.txt','w+');
    fprintf(fid,'%s',targetip);
    fclose(fid);
    disp('Host IP already found, checking Online PCs...');
    port=[8080:8086];
    for idx=1:length(port)
        [~,res]=system(['tcping -a -s 0 -w 0.1 -n 1 ' addr ' ' num2str(port(idx))]);
        if ~isempty(strfind(res,'open'))
            fprintf(2,['LAB00' num2str(idx-1) ' [']);
            fprintf([ addr ':' num2str(port(idx)) '] is online \n'])
        end
    end
    port=[8180:8186];
    for idx=1:length(port)
        [~,res]=system(['tcping -a -s 0 -w 0.1 -n 1 ' addr ' ' num2str(port(idx))]);
        if ~isempty(strfind(res,'open'))
            fprintf(2,['LAB00' num2str(idx-1) '-ubuntu [']);
            fprintf([ addr ':' num2str(port(idx)) '] is online \n'])
        end
    end
    port=[8087]; %additional
    name={'aero-think-pc'};
    for idx=1:length(port)
        [~,res]=system(['tcping -a -s 0 -w 0.1 -n 1 ' addr ' ' num2str(port(idx))]);
        if ~isempty(strfind(res,'open'))
            fprintf(2,[name{idx} ' [']);
            fprintf([ addr ':' num2str(port(idx)) '] is online \n'])
        end
    end
end
cd(cwd)