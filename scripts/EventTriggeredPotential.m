%Evoked response analysis for Wanlab data
dirlist=dir('*.*');
dirlist=dirlist([dirlist.isdir]);
dirlist(1:2)=[];
multiWaitbar('close all');
multiWaitbar('Directory',0);
multiWaitbar('File',0);

fs=1e3;
spike_plot_on=1;
tf_plot_on=0;
freq_plot_on=1;


freq_band=[0 4;4 8;8 12;12 30 ;30 80;];
freq_name=arrayfun(@(x) [num2str(freq_band(x,1)) '-' num2str(freq_band(x,2)) ],1:size(freq_band,1),'UniformOutput',0);
hue=mapminmax(size(freq_band,1):-1:1,0.3,1);

for diridx=1:length(dirlist)
    cd(dirlist(diridx).name)
    filelist=dir('*.dat');
    multiWaitbar('Directory',diridx/length(dirlist));
    for fileidx=1:length(filelist)
        multiWaitbar('File',fileidx/length(filelist));
        fname=filelist(fileidx).name;
        
        % fname=['Rat10_laser_pain_20110714_raw.dat'];
        load([fname(1:end-4) '_chnlist']);
        
        if spike_plot_on           
            spike_file=dir([fname(1:end-4) '_units']);
            if ~isempty(spike_file)
                spike_plot_on_this=1;
                load(spike_file);
            end
        end
        
        channum=length(elec_list)+1;
        
        freq=1:50;
        t_range=[-0.5 1].*fs; %in second
        data=readmulti_frank(fname,channum,1:channum,0,inf)*200/1e9;
        triggered_loc=find(diff([0 ;data(:,end)])>0);
        
        
 
        %% get the waveform in all windows and plot all of them
        h=figure(2);
        clf(h)
        data_cell=cell(size(data,2)-1,1);
        locs=[triggered_loc+t_range(1),triggered_loc+t_range(2)];
        time=(t_range(1):t_range(2))/fs;
        for chn=1:size(data,2)-1
            subplot(8,4,chn)
            data_cell{chn}=cell2mat(arrayfun(@(x) data(locs(x,1):locs(x,2),chn),1:size(locs,1),'UniformOutput',0));
            imagesc(time,1:size(locs,1),data_cell{chn}');
            caxis([-200e-6,200e-6]);
        end
        xlabel('time(s)')
        ylabel('trials');
        set(h,'PaperUnits','inches','PaperSize',[5 4])
        saveas(h,[fname(1:end-4) '_ERP'],'fig')
        print(h,[fname(1:end-4) '_ERP'],'-djpeg','-r100','-zbuffer');
        %% get the spike in all stimulate windows, and plot overlap on the averaged waveform

            spk=cell(size(data,2)-1,1);
            h=figure(7);
            clf(h);
            if spike_plot_on
            for chn=1:size(data,2)-1
                subplot(8,4,chn)
                for cell_idx=1:size(units{chn},2)
                    ts=units{chn}{cell_idx}*fs;
                    spk_tim=sort(cell2mat(arrayfun(@(x,y) ts(ts>x&ts<y)-x+t_range(1),locs(:,1),locs(:,2),'UniformOutput',0)));
                    spk{chn}{cell_idx}=spk_tim;
                end
                
                if ~isempty(spk{chn})
%                 units_bin=zeros(nbin,size(spk{chn},2));
                x_bin=linspace(t_range(1),t_range(2),diff(t_range)/5);
                units_bin=cellfun(@(x) hist(x,x_bin),spk{chn},'UniformOutput',0);
               [ax,h1,h2]=plotyy(time,mean(data_cell{chn},2),x_bin/fs,cell2mat(units_bin')','plot','bar');

               set(h2,'linestyle','none','barwidth',1);
               axes(ax(2));
               alpha(0.5);
               xlim(ax(1),[min(time) max(time)]);
               xlim(ax(2),[min(time) max(time)]);
                else
                    plot(time,mean(data_cell{chn},2));
                    xlim([min(time) max(time)]);
            end
            end
            set(h,'PaperUnits','inches','PaperSize',[5 4])
            saveas(h,[fname(1:end-4) '_Units'],'fig')
            print(h,[fname(1:end-4) '_Units'],'-djpeg','-r100','-zbuffer');
        end
        
        h=figure(3);
        clf(h)
        for chn=1:size(data,2)-1
            subplot(8,4,chn)
            shadedErrorBar(time,data_cell{chn}',{@mean,@ste},{'markerfacecolor','r'});
            xlim([min(time) max(time)]);
        end
        xlabel('time(s)')
        ylabel('Voltage(V)')
        set(h,'PaperUnits','inches','PaperSize',[5 4])
        saveas(h,[fname(1:end-4) '_ERP_avg'],'fig')
        print(h,[fname(1:end-4) '_ERP_avg'],'-djpeg','-r100','-zbuffer');
        

        %Time-frequency analysis
        if tf_plot_on
            h=figure(4);
            clf(h)
            % P_temp_cell=cell(size(data,2)-1,1);
            P_temp=zeros(length(time),length(freq),size(locs,1),size(data,2)-1);
            for chn=1:size(data,2)-1
                parfor trial=1:size(locs,1)
                    P_temp(:,:,trial,chn)=awt_freqlist(data_cell{chn}(:,trial),fs,freq,'Gabor');
                end
            end
            
            for chn=1:size(data,2)-1
                subplot(8,4,chn)
                imagesc(time,freq,abs(mean(P_temp(:,:,:,chn),3)'));
                axis xy;
            end
            xlabel('time')
            ylabel('freq(Hz');
            set(h,'PaperUnits','inches','PaperSize',[5 4])
            saveas(h,[fname(1:end-4) '_TF'],'fig')
            print(h,[fname(1:end-4) '_TF'],'-djpeg','-r100','-zbuffer');
        end
        
        %% Band-waveform plot
        if freq_plot_on
            h=figure(5);
            
            for freq_idx=1:size(freq_band,1)
                clf(h)
                for chn=1:size(data,2)-1
                    subplot(8,4,chn)
%                     hold on             
                    temp=fft_filter(data_cell{chn}',freq_band(freq_idx,1),freq_band(freq_idx,2),fs);
                    shadedErrorBar(time,temp,{@mean,@ste},{'markerfacecolor','r'});
                    %                     plot(time,fft_filter(mean(data_cell{chn},2),freq_band(freq_idx,1),freq_band(freq_idx,2),fs),'Color',hsv2rgb(hue(freq_idx),1,1));
                    xlim([min(time) max(time)]);
                    ylim([-5e-5 5e-5]);
                end
                
                xlabel('time')
                ylabel('Voltage(V)');
%                 legend(freq_name);
                set(h,'PaperUnits','inches','PaperSize',[5 4])
                saveas(h,[fname(1:end-4) '_Bandwave_' freq_name{freq_idx}],'fig')
                print(h,[fname(1:end-4) '_Bandwave_'  freq_name{freq_idx}],'-djpeg','-r100','-zbuffer');
                
            end
            
            h=figure(6);
            
            
            clf(h)
            for chn=1:size(data,2)-1
                for freq_idx=size(freq_band,1):-1:1
                    subplot(8,4,chn)
                    hold on
                    temp=fft_filter(data_cell{chn}',freq_band(freq_idx,1),freq_band(freq_idx,2),fs);
                    %                     shadedErrorBar(time,temp,{@mean,@ste},{'markerfacecolor','r'});
                    plot(time,fft_filter(mean(data_cell{chn},2),freq_band(freq_idx,1),freq_band(freq_idx,2),fs),'Color',hsv2rgb(hue(freq_idx),1,1));
                    xlim([min(time) max(time)]);
                    %                     ylim([-5e-5 5e-5]);
                end
            end
            xlabel('time')
            ylabel('Voltage(V)');
            legend(freq_name(end:-1:1));
            set(h,'PaperUnits','inches','PaperSize',[5 4])
            saveas(h,[fname(1:end-4) '_Bandwave'],'fig')
            print(h,[fname(1:end-4) '_Bandwave' ],'-djpeg','-r100','-zbuffer');
        end
    end
    cd('..')
end


