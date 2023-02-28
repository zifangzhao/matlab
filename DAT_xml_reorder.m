function DAT_xml_reorder(ch_maps,colorMode)
% function for changing XML file channel order/group and color
% input:
% ch_new is a cell array has each cell be a group of channels , base is 0
% colorMode: 
%   'group' color each group of channel by a color
%   'individual', color each channel by a color
% 20200325 created zifang zhao


[f_all,p]=uigetfile('*.xml','multiselect','on');

if ~iscell(f_all)
    f_all={f_all};
end

if nargin<2
    colorMode='group';
end

for idx=1:length(f_all)
    f=f_all{idx};
    t_xml=fileread([p f]);
    loc_groupStart=strfind(t_xml,'<channelGroups>')+length('<channelGroups>')-1;
    loc_groupEnd=strfind(t_xml,'</channelGroups>');
    
    loc_channelStart=strfind(t_xml,'<channels>')+length('<channels>')-1;
    loc_channelEnd=strfind(t_xml,'</channels>');
    
    Nch_str=regexpi(t_xml(1:loc_groupEnd),'(?<=<nChannels>)\d+(?=</nChannels>)','match');
    Nch=str2num(Nch_str{1});
    
   loc_chGroupStart=strfind(t_xml,'<group>')+length('<group>')-1;
   loc_chGroupEnd=strfind(t_xml,'</group>');
   
   ch_old=cell(length(loc_chGroupStart),1);
   for gidx=1:length(ch_old)
       ch_str=regexpi(t_xml(loc_chGroupStart(gidx):loc_chGroupEnd(gidx)),'(?<=>)\d+(?=</channel>)','match');
       ch_old{gidx}=cellfun(@(x) str2num(x),ch_str);
   end

   if(iscell(ch_maps))
    if(iscell(ch_maps{1}))
        N_chs = cellfun(@(x) sum(cellfun(@length,x)),ch_maps);
        offset  = [0 N_chs(1:end-1)];
        ch_maps=arrayfun(@(x) cellfun(@(g) g+offset(x),ch_maps{x},'uni',0),1:length(offset),'uni',0);
        ch_new= cat(2,ch_maps{:});
    else
        ch_new = ch_maps;
    end
   else
       ch_new = {ch_maps};
   end
   if(isempty(ch_new))
       ch_new=ch_old;
   end
    if(Nch~=sum(cellfun(@length,ch_new)))
        disp(['Error,' f 'Channel number mismatch']);
    else
        new_txt=t_xml(1:loc_groupStart);
        for g_idx=1:length(ch_new)
            new_txt=[new_txt newline '<group>' ];
            ch_list=ch_new{g_idx};
            ch_str=arrayfun(@(x) [newline '<channel skip="0">' num2str(x) '</channel>'],ch_list,'UniformOutput',0);
            new_txt=[ new_txt cat(2,ch_str{:})];
            new_txt=[new_txt newline '</group>' ];
        end
        new_txt=[new_txt t_xml(loc_groupEnd:loc_channelStart)];
        clrs=cell(Nch,1);
        txt_ch=[];
        switch colorMode
            case 'group'
                hue_this=[0:length(ch_new)]./length(ch_new)+0.55;
                hue_this=hue_this-fix(hue_this);
                clrs_grp=arrayfun(@(x) hsv2rgb([x,1,1]),hue_this,'UniformOutput',0);
                for g_idx=1:length(ch_new)
                    ch_list=ch_new{g_idx};
                    for c_idx=1:length(ch_list)
                        clr_str=['#' dec2hex(round(clrs_grp{g_idx}(1)*255),2) dec2hex(round(clrs_grp{g_idx}(2)*255),2) dec2hex(round(clrs_grp{g_idx}(3)*255),2)];
                        txt_ch=[txt_ch newline '<channelColors>  '...
                            newline  '  <channel>' num2str(ch_list(c_idx)) '</channel> ' ...
                            newline   '<color>' clr_str '</color>' ...
                            newline '<anatomyColor>' clr_str '</anatomyColor>'...
                            newline '<spikeColor>' clr_str '</spikeColor>'...
                            newline '</channelColors>'...
                            newline '<channelOffset>'...
                            newline '<channel>' num2str(ch_list(c_idx))  '</channel>'...
                            newline '<defaultOffset>'  '</defaultOffset>'...
                            newline '</channelOffset>'];
                    end
                end
              
            case 'individual'
                hue_this=[0:Nch]./Nch+0.55;
                hue_this=hue_this-fix(hue_this);
                clrs_all=arrayfun(@(x) hsv2rgb([x,1,1]),hue_this,'UniformOutput',0);
                clr_idx=1;
                for g_idx=1:length(ch_new)
                    ch_list=ch_new{g_idx};
                    for c_idx=1:length(ch_list)
                        clr_str=['#' dec2hex(round(clrs_all{clr_idx}(1)*255),2) dec2hex(round(clrs_all{clr_idx}(2)*255),2) dec2hex(round(clrs_all{clr_idx}(3)*255),2)];
                        clr_idx=clr_idx+1;
                        txt_ch=[txt_ch newline '<channelColors>  ' ...
                            newline '  <channel>' num2str(ch_list(c_idx)) '</channel> ' ...
                            newline   '<color>' clr_str '</color>' ...
                            newline '<anatomyColor>' clr_str '</anatomyColor>'...
                            newline '<spikeColor>' clr_str '</spikeColor>'...
                            newline '</channelColors>'...
                            newline '<channelOffset>'...
                            newline '<channel>' num2str(ch_list(c_idx))  '</channel>'...
                            newline '<defaultOffset>'  '</defaultOffset>'...
                            newline '</channelOffset>'];
                    end
                end
                
        end
        new_txt=[new_txt txt_ch t_xml(loc_channelEnd:end)];
    end
    fh=fopen([p f ],'w');
    fprintf(fh,'%s',new_txt);
    fclose(fh);
end