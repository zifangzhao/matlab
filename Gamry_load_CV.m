function DTP_all_cell=Gamry_load_CV(dta_file,cyc_sel,plt_on,f_preprocess)
if nargin<1
    plt_on=1;
    [dta_file,pth]=uigetfile('*.dta',"MultiSelect","on");
    if(~iscell(dta_file))
    flist = {dta_file};
    else
        flist = dta_file;
    end
    flist=cellfun(@(x) [pth  x],flist,'uni',0);
end
if nargin<4
    f_preprocess=@(x) x;
end
if(~iscell(dta_file))
    flist = {dta_file};
else
    flist = dta_file;
end


N=length(flist);
data=cell(N,1);
plt_fun=@(x,c) plot(x(:,4),f_preprocess(x(:,5)),'color',c);
plt_fun_phase=@(x,c) semilogx(x(:,4),f_preprocess(x(:,9)),'color',c);
lgd=arrayfun(@(x)flist{x},1:N,'UniformOutput',0);
strstring=strsplit(pwd,'\');
titlestr=strstring{end};

% figure(1)
DTP_all_cell  = cell(N,1);
DTP_all=[];
for idx=1:N
    disp(['Process File:' flist{idx}])
    txt = fileread(flist{idx});
    loc1 = [strfind(txt,'CURVE')-1 length(txt)];
    loc2 = strfind(txt,'deg C')+5;
    idx_sel = false(length(txt),1);
    if isempty(cyc_sel)
        cyc_sel=1:length(loc2);
    end
    for idy = cyc_sel
        idx_sel(loc2(idy):loc1(idy+1))=1;
    end
    sav2log('temp.txt',txt(idx_sel),'w+');
    data{idx}=readmatrix('temp.txt','FileType','text');
    if(length(data{idx}<8)) %if experient is aborted, phase is not calculated

    end
    DTP_all_cell{idx}=data{idx};
end

if plt_on
    clr=hsv2rgb([linspace(0,1,N+1)' ones(N+1,1) 0.9.*ones(N+1,1)]);
    clr=reshape([clr]',3,[])';
    for idx= 1:N
        try            
            disp(['Plotting:' lgd{idx}])
            DTP = DTP_all_cell{idx};
%             subplot(121)
%             figure(1)
            plt_fun(DTP,clr(idx,:));
            hold on;
            xlabel('Voltage(V)');
            ylabel('Current(A)')
            title([titlestr ' CV'],'Interpreter','none');

        %save 2 xlsx file
        catch
            disp('Error!')
        end
    end
%     f_xls=pwd;
%     folder_idx=strfind(f_xls,'\');
%     folder_name=f_xls(folder_idx(end)+1:end);
%     f_xls=[folder_name '_Zmod.xls'];
%     fnames={flist{:}};
%     fnames=cellfun(@(x) x(1:end-4) ,fnames,'UniformOutput',0);
%     titles={'Frequency(Hz)' fnames{:}};
%     writecell(titles,f_xls,'Range','A1');
%     writematrix(DTP_all,f_xls,'Range','A2');
    legend(lgd,'Interpreter','None')
    hold off;
end