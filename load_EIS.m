function DTP_all_cell=load_EIS(dta_file,plt_on)
if(~iscell(dta_file))
    flist = {dta_file};
else
    flist = dta_file;
end


N=length(flist);
data=cell(N,1);
plt_fun=@(x,c) loglog(x(:,4),x(:,8),'color',c);
lgd=arrayfun(@(x)flist{x},1:N,'UniformOutput',0);
strstring=strsplit(pwd,'\');
titlestr=strstring{end};

figure(1)
DTP_all_cell  = cell(N,1);
DTP_all=[];
for idx=1:N
    disp(['Process File:' flist{idx}])
    txt = fileread(flist{idx});
    loc = strfind(txt,'ZCURVE');
    sav2log('temp.txt',txt(loc:end),'w+');
    data{idx}=readmatrix('temp.txt','FileType','text');
    DTP_all_cell{idx}=data{idx};
end

if plt_on
    clr=hsv2rgb([linspace(0,1,N+1)' ones(N+1,1) 0.9.*ones(N+1,1)]);
    clr=reshape([clr]',3,[])';
    for idx= 1:N
        DTP = DTP_all_cell{idx};
        fx=plt_fun(DTP,clr(idx,:));
    
        hold on;
        if(~isempty(strfind(lgd{idx},'PEDOT')))
            set(fx,'linestyle','--');
        end
        xlabel('Frequency(Hz)');
        ylabel('Zmod(Ohm)')
        %save 2 xlsx file
    end
    f_xls=pwd;
    folder_idx=strfind(f_xls,'\');
    folder_name=f_xls(folder_idx(end)+1:end);
    f_xls=[folder_name '_Zmod.xls'];
    fnames={flist{:}};
    fnames=cellfun(@(x) x(1:end-4) ,fnames,'UniformOutput',0);
    titles={'Frequency(Hz)' fnames{:}};
    writecell(titles,f_xls,'Range','A1');
    writematrix(DTP_all,f_xls,'Range','A2');
    legend(lgd,'Interpreter','None')
    title([titlestr ' Zmod'],'Interpreter','none');
    xlim([1 1e5]);
    hold off;
end