%
[f,p]=uigetfile('*.clu.*','Multiselect','on');
if ~iscell(f)
    temp=f;
    f=cell(1);
    f{1}=temp;
end

[info,waveform]=cellfun(@(x) neurosuite_loadunits([p x]),f,'UniformOutput',0);

%% reduce data size by cutting off the none contributing channels
waveform_reduced=[];
for idx=1:8
    ch_sel=4*(idx-1)+1:4*idx;
    waveform_reduced{idx}=cellfun(@(x) x(:,ch_sel,:),waveform{idx},'UniformOutput',0);
end

%% detect amplitude
search_win=8:24;
amplitude=[];
for idx=1:8
    amplitude{idx}=cellfun(@(x) squeeze(abs(max(x(search_win,:,:),[],1)-min(x(search_win,:,:),[],1))),waveform_reduced{idx},'UniformOutput',0);
end

%% plot amplitude scatter plot
% sel_ch=2:3;
conveff=0.195;
figure(1);
chgroup={[1,2],[3,4],[1,3],[2,4]};
for ch=1:length(chgroup)
    for idx=1:length(amplitude)
        subplot(8,4,ch+(idx-1)*length(chgroup));
        try
            DTP=cellfun(@(x) x(chgroup{ch},:), amplitude{idx},'UniformOutput',0);
            Dgroup=cat(2,DTP{:});
            index=arrayfun(@(x) x*ones(length(DTP{x}),1),1:length(DTP),'UniformOutput',0);
            Dgroup=[Dgroup.*conveff ;cat(1,index{:})'];
            % gscatter(
            gscatter(Dgroup(1,:),Dgroup(2,:),Dgroup(3,:));
            xlim([0 500]);
            ylim([0 500])
            set(gca,'yticklabel',[],'xticklabel',[])
            legend off;
        catch
            disp(['index' num2str(idx) ' Skipped'])
        end
    end
end

%% plot amplitude scatter plot manual selected features
% sel_ch=2:3;
conveff=0.195;
h=figure(2);
chgroup={[3,4],[1,3],[1,3],[2,4],[1,2],[1,3],[2,4],[1,2]};

for idx=1:length(amplitude)
    
    try
        DTP=cellfun(@(x) x(chgroup{idx},:), amplitude{idx},'UniformOutput',0);
        Dgroup=cat(2,DTP{:});
        index=arrayfun(@(x) x*ones(length(DTP{x}),1),1:length(DTP),'UniformOutput',0);
        Dgroup=[Dgroup.*conveff ;cat(1,index{:})'];
        % gscatter(
        gscatter(Dgroup(1,:),Dgroup(2,:),Dgroup(3,:));
        xlim([0 500]);
        ylim([0 500])
        set(gca,'yticklabel',[],'xticklabel',[])
        legend off;
        saveas(h,['Group' num2str(idx) '.jpg']);
    catch
        disp(['index' num2str(idx) ' Skipped'])
    end
    
end
