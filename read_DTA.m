function DTP_all = read_DTA(flist)
if nargin<1
    [flist,pth] =uigetfile("MultiSelect","on");
    if ~iscell(flist)
        flist = {flist};
    end
    flist=cellfun(@(x) [pth x],flist,'UniformOutput',0);
end
N=length(flist);
data=cell(N,1);
plt_fun=@(x,c) loglog(x(:,4),x(:,8),'color',c);
data_fun=@(x) [x(:,8)];
lgd=arrayfun(@(x)flist{x},1:N,'UniformOutput',0);
clr=hsv2rgb([linspace(0,1,N+1)' ones(N+1,1) 0.9.*ones(N+1,1)]);
clr=reshape([clr clr]',3,[])';
strstring=strsplit(pwd,'\');
titlestr=strstring{end};
data_collected=[];
figure()
DTP_all=[];
for idx=1:N
    data{idx}=readmatrix(flist{idx},'FileType','text');
    DTP=data{idx};
%     data_collected=[data_collected data_fun(DTP)];
    fx=plt_fun(DTP,clr(idx,:));

    hold on;
    if(~isempty(strfind(lgd{idx},'PEDOT')))
        set(fx,'linestyle','--');
    end
    xlabel('Frequency(Hz)');
    ylabel('Zmod(Ohm)')
    %save 2 xlsx file

end

legend(lgd,'Interpreter','None')
title([titlestr ' Zmod'],'Interpreter','none');
hold off;
% saveas(gcf,'Amod.jpg');
%%
figure()
DTP_all_phase=[];
plt_fun=@(x,c) semilogx(x(:,4),x(:,9),'color',c);
for idx=1:N
    data{idx}=readmatrix(flist{idx},'FileType','text');
    DTP=data{idx};
    fx=plt_fun(DTP,clr(idx,:));
    hold on;
    if(~isempty(strfind(lgd{idx},'PEDOT')))
        set(fx,'linestyle','--');
    end
    xlabel('Frequency(Hz)');
    ylabel('Angle(Degree)')
end
legend(lgd,'Interpreter','None','location','NE')
title([titlestr ' Phase'],'Interpreter','none');
hold off;
% saveas(gcf,'Aphase.jpg');

for idx=1:N
    if(isempty(DTP_all))
        DTP_all=[DTP(:,[4,8])];
    else
        DTP_all=[DTP_all DTP(:,[8])];
    end
end

% f_xls=pwd;
% folder_idx=strfind(f_xls,'\');
% folder_name=f_xls(folder_idx(end)+1:end);
% f_xls=[folder_name '_Zmod.xls'];
% fnames={flist{:}};
% fnames=cellfun(@(x) x(1:end-4) ,fnames,'UniformOutput',0);
% titles={'Frequency(Hz)' fnames{:}};
% writecell(titles,f_xls,'Range','A1');
% writem3atrix(DTP_all,f_xls,'Range','A2');
% loglog(DTP(:,4),f_GBW((DTP(:,4))),'--');