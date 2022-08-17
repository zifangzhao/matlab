function [t_test ks_test ks_curve jobhandle]=pcmi_region_stat_new(yA,xA,yB,xB,channel_mask_A,channel_mask_B,pathname,filename,LegendA,LegendB,hist_diff_range,sch)
% 2012-4-23 revised by Zifang Zhao 增加histfft输出
% 2012-4-19 revised by Zifang Zhao 更改输出检验的格式为结构体，其中增加sd、t
% 2012-4-17 revised by Zifang Zhao 更改了scatter两个的颜色
% 2012-4-16 revised by Zifang Zhao 增加hist_diff_range，修正差分图范围
% 2012-4-16 revised by Zifang Zhao 修正内存占用过多的问题，batch figure
% 2012-4-14 revised by Zifang Zhao 修正legend下划线问题
% 2012-4-13 revised by Zifang Zhao 修正jobhandle，使每个batch对应一个handle
% 2012-4-12 revised by Zifang Zhao added kstest p value curve output(ks_curve)
% 2012-3-27 revised by Zifang Zhao added difference plot in histplot()
% 2012-3-26 revised by Zifang zhao added histplot()
% 2012-3-26 revised by zifang zhao fixed filename '_' in title
% 2012-3-24 revised by zzf @ added pathname
% 2012-3-19 new version for general statistical analysis
%% 初始化
% t_test=[];
% ks_test=nan;
if nargin<9
    LegendA='A';
    LegendB='B';
end
if nargin<11
    hist_diff_range=[];
end
jobhandle=[];
ks_curve=[];
loc_map_A=ones(size(yA))-cellfun(@isempty,yA);
loc_map_B=ones(size(yB))-cellfun(@isempty,yB);
if(nargin<5)
    non_zeros_locs_A=find(loc_map_A);
    non_zeros_locs_B=find(loc_map_B);
else
    %     channel_mask_A=reshape(channel_mask_A,1,[]);
    %     channel_mask_B=reshape(channel_mask_B,1,[]);
    non_zeros_locs_A=find(loc_map_A.*channel_mask_A);
    non_zeros_locs_B=find(loc_map_B.*channel_mask_B);
end
if(isempty(non_zeros_locs_A)||isempty(non_zeros_locs_B))
    t_test.p=nan;
    t_test.sd=nan;
    t_test.t=nan;
    ks_test.p=nan;
    ks_test.ks=nan;
    ks_test.cv=nan;
    
else
    yA_selected=yA(non_zeros_locs_A);
    xA_selected=xA(non_zeros_locs_A);
    yB_selected=yB(non_zeros_locs_B);
    xB_selected=xB(non_zeros_locs_B);
    
    yA_selected_line=[yA_selected{:}];
    yB_selected_line=[yB_selected{:}];
    xA_selected_line=[xA_selected{:}];
    xB_selected_line=[xB_selected{:}];
    if nargin<7
        filename=[];%'scatterplot'; 2012-3-26
    end
    
    if(nargin>11)
        ymin=min([yA_selected_line,yB_selected_line]);
        ymax=max([yA_selected_line,yB_selected_line]);
        ks_curve=kscurve(xA_selected_line,yA_selected_line,xB_selected_line,yB_selected_line,ymin:(ymax-ymin)/50:ymax);
        jobhandle=[jobhandle batch(sch,@histplot,0,{xA_selected_line,yA_selected_line,xB_selected_line,yB_selected_line,ymin:(ymax-ymin)/50:ymax,LegendA,LegendB,pathname,[filename '_hist'],hist_diff_range})];
        jobhandle=[jobhandle batch(sch,@scatterplot,0,{xA_selected_line,yA_selected_line,xB_selected_line,yB_selected_line,LegendA,LegendB,pathname,[filename '_scatter']})];
    else
        ymin=min([yA_selected_line,yB_selected_line]);
        ymax=max([yA_selected_line,yB_selected_line]);
        ks_curve=kscurve(xA_selected_line,yA_selected_line,xB_selected_line,yB_selected_line,ymin:(ymax-ymin)/50:ymax);
        histplot(xA_selected_line,yA_selected_line,xB_selected_line,yB_selected_line,ymin:(ymax-ymin)/50:ymax,LegendA,LegendB,pathname,[filename '_hist'],hist_diff_range);
        scatterplot(xA_selected_line,yA_selected_line,xB_selected_line,yB_selected_line,LegendA,LegendB,pathname,[filename '_scatter']);
    end
    [~,t_test.p,~,temp]=ttest2(yA_selected_line,yB_selected_line);
    t_test.t=temp.tstat;
    t_test.sd=temp.sd;
    [~,ks_test.p ks_test.ks]=kstest2(yA_selected_line,yB_selected_line);
    ks_test.cv=nan;
end
end

function ks_curve=kscurve(xA,yA,xB,yB,y_range)
x_uni_A=sort(unique(xA));
x_uni_B=sort(unique(xB));
ks_curve=[];
for idx=1:length(x_uni_A)
    temp=yA(xA==x_uni_A(idx));
    n_A(:,idx)=hist(temp,y_range);
end
for idx=1:length(x_uni_B)
    temp=yB(xB==x_uni_B(idx));
    n_B(:,idx)=hist(temp,y_range);
end
if length(x_uni_B)==length(x_uni_A)
    for idx=1:length(x_uni_A)
        [~,ks_curve(idx)]=kstest2(n_A(:,idx),n_B(:,idx));
    end
end
end

function histplot(xA,yA,xB,yB,y_range,LA,LB,pathname,filename,hist_diff_range)
close all;
h=figure();
LA=strrep(LA,'_','\_');
LB=strrep(LB,'_','\_');
x_uni_A=sort(unique(xA));
x_uni_B=sort(unique(xB));
for idx=1:length(x_uni_A)
    temp=yA(xA==x_uni_A(idx));
    n_A(:,idx)=hist(temp,y_range);
end
for idx=1:length(x_uni_B)
    temp=yB(xB==x_uni_B(idx));
    n_B(:,idx)=hist(temp,y_range);
end
if length(x_uni_B)==length(x_uni_A)
    subplot(3,1,1);
    imagesc(x_uni_A,y_range,n_A)
    legend(LA)
    xlabel('ms');
    titlename=strrep(filename,'_','\_');
    title(titlename);
    colorbar
    axis xy;
    
    
    subplot(3,1,2);
    imagesc(x_uni_B,y_range,n_B)
    legend(LB);
    xlabel('ms');
    colorbar
    axis xy;
    
    
    subplot(3,1,3)
    imagesc(x_uni_A,y_range,-n_A./repmat(sum(n_A,1),[size(n_A,1) 1])+n_B./repmat(sum(n_B,1),[size(n_B,1) 1]));
    colorbar
    if ~isempty(hist_diff_range)
        caxis(hist_diff_range);
    end
    axis xy
    legend('Difference')
    xlabel('ms');
    
    
else
    subplot(2,1,1);
    imagesc(x_uni_A,y_range,n_A)
    
    titlename=strrep(filename,'_','\_');
    title(titlename);
    colorbar
    axis xy;
    legend(LA)
    xlabel('ms');
    
    subplot(2,1,2);
    imagesc(x_uni_B,y_range,n_B)
    colorbar
    axis xy;
    legend(LB);
    xlabel('ms');
end
% set (h,'Position',[100,100,900,700], 'color','w')
saveas(h,[pathname filename],'fig')
print(h,'-djpeg90','-r600',[pathname filename]);
close(h)
if length(x_uni_B)==length(x_uni_A)
    h2=figure();
    L=length(x_uni_A);
    Fs=1000*L/max(x_uni_A);
    NFFT=2^nextpow2(L);
    YA = log10(abs(fft(max(n_A),NFFT)/L));
    YB = log10(abs(fft(max(n_B),NFFT)/L));
    f = Fs/2*linspace(0,1,NFFT/2+1);
    
    
    %area图@fig
    subplot(3,1,1)
    area(f,2*YA(1:NFFT/2+1))
    xlim([0 50]);
    title('Single-Sided Amplitude Spectrum')

    xlabel('Frequency (Hz)')
    ylabel('log_1_0|Y(f)|')
    alpha(0.5);
    subplot(3,1,2)
    area(f,2*YB(1:NFFT/2+1),'Facecolor','r')
    xlim([0 50])
    title('Single-Sided Amplitude Spectrum')
    xlabel('Frequency (Hz)')
    ylabel('log_1_0|Y(f)|')
    alpha(0.5);
    subplot(3,1,3)
    xlabel('Frequency (Hz)')
    ylabel('log_1_0|Y(f)|')
    area(f,2*YA(1:NFFT/2+1)) ;alpha(0.5);hold on;
    area(f,2*YB(1:NFFT/2+1),'Facecolor','r') ;alpha(0.5);
    xlim([0 50]);
    title('Single-Sided Amplitude Spectrum comparation')
    xlabel('Frequency (Hz)')
    ylabel('log_1_0|Y(f)|')
    saveas(h2,[pathname filename '_fft'],'fig')
    close(h2);
    %plot草图@jpg
    h2=figure();
    subplot(3,1,1)
    plot(f,2*YA(1:NFFT/2+1));
    xlim([0 50]);
    title('Single-Sided Amplitude Spectrum')
    xlabel('Frequency (Hz)')
    ylabel('log_1_0|Y(f)|')
    subplot(3,1,2)
    plot(f,2*YB(1:NFFT/2+1),'r');
    xlim([0 50])
    title('Single-Sided Amplitude Spectrum')
    xlabel('Frequency (Hz)')
    ylabel('log_1_0|Y(f)|')
    subplot(3,1,3)
    plot(f,2*YA(1:NFFT/2+1));hold on;
    xlabel('Frequency (Hz)')
    ylabel('log_1_0|Y(f)|')
    plot(f,2*YB(1:NFFT/2+1),'r');
    xlim([0 50]);
    title('Single-Sided Amplitude Spectrum comparation')
    xlabel('Frequency (Hz)')
    ylabel('log_1_0|Y(f)|')
    
    print(h2,'-djpeg90','-r600',[pathname filename '_fft']);
    close(h2);
end
end

function scatterplot(xA,yA,xB,yB,LA,LB,pathname,filename)
close all;
h=figure();
LA=strrep(LA,'_','\_');
LB=strrep(LB,'_','\_');
scatter(xA,yA,'.r');
hold on;

scatter(xB,yB,'xb');
titlename=strrep(filename,'_','\_');
title(titlename);
legend(LA,LB);
xlabel('ms');
hold off
% set (h,'Position',[100,100,900,700], 'color','w')
saveas(h,[pathname filename],'fig')
print(h,'-djpeg90','-r600',[pathname filename]);
close(h)
end

function pdf2plot(yA,yB,filename)
close all;
h=figure();
scatter(xA,yA,'.b');
hold on;
% legend(LegendA);
scatter(xB,yB,'xr');
titlename=strrep(filename,'_','\_');
title(titlename);
legend(LA,LB);
xlabel('ms');
hold off
% set (h,'Position',[100,100,900,700], 'color','w')
saveas(h,[pathname filename],'fig')
print(h,'-djpeg90','-r600',[pathname filename]);
close(h)
end
