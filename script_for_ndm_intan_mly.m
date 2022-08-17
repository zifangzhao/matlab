%%script for processing cerebus data file
% this script is designed for use in linux
%20160811 zz.
%% enciorment preparation
% Save library paths
MatlabPath = getenv('LD_LIBRARY_PATH');
% Make Matlab use system libraries
setenv('LD_LIBRARY_PATH',getenv('PATH'))
cwd=pwd; %save current folder

%% convert nsx to dat file
% msgbox('Please select the xml file for resampling data');
f_xml_res=[];
p_xml_res=[];
% [f_xml_res,p_xml_res]=uigetfile({'*.xml','*.xml|xml file for resampling data'},'Please select the xml file for resampling data');
% msgbox('Please select xml file for data pre-processing')
[f_xml_ndm,p_xml_ndm]=uigetfile({'*.xml','*.xml|xml file for data pre-processing'},'Please select xml file for data pre-processing');
f_dat=0;
p_dat=0;
% try
%     [f_dat,p_dat]=nsx2dat;
%     
% end
%% resample
% msgbox('Please select the file needs to be resampled');
if f_xml_res~=0
    if f_dat==0
        [f_dat,p_dat]=uigetfile({'*.dat','*.dat|file needs to be resampled'},'Please select the file needs to be resampled');
    end
    cd(p_dat)
    dat_files=([p_dat '*.dat']);
    if length(dat_files)~=0
        if ~iscell(dat_files)
            cd(p_dat);
            res_temp_file=[f_xml_res(1:end-4) '-raw.dat'];
            system(['mv ''' f_dat ''' ''' res_temp_file '''']); % rename file
            system(['cp ''' p_xml_res f_xml_res ''' ''' p_dat f_xml_res '''']); %copy xml file to dest folder
            system(['ndm_resample ''' f_xml_res '''']); %resample target file
            system(['mv ''' res_temp_file ''' ''' f_dat '''']); %rename file back to original name
            system(['rm ''' f_xml_res '''']);               %remove resample xml file
        else
            msgbox('Please make sure this is the only DAT file in the same folder','replace');
        end
        
    else
        msgbox('Please make sure this is the only DAT file in the same folder','replace');
    end
end
msgbox('Computation started, do not close this window until the script finishes','replace')
%% running ndm scripts
if f_xml_ndm~=0
    if p_dat==0
        [f_dat,p_dat]=uigetfile({'*.dat','*.dat|file needs to be processed'},'Please select the file needs to be processed');
    end
    cd(p_dat);
    locs=strfind(p_dat,'/');
    dir_name=p_dat(locs(end-1)+1:locs(end)-1);
    system(['mv ''' f_dat ''' ''' dir_name '.dat''']);
    cd('..');
    
    
    system(['cp ''' p_xml_ndm f_xml_ndm ''' proc.xml']);
    system(['ndm_start proc.xml ' dir_name])
%     system(['rm ''' p_dat f_dat ''''])
    system(['rm proc.xml']);
end
%% clustering
if p_dat==0
    p_dat=uigetdir([],'Select target folder');
end
cd(p_dat);
fet_file=dir('*.fet.*');
loc=strfind(fet_file(1).name,'.');
if ~iscell(fet_file)
    for idx=1:length(fet_file)
        c_idle=check_load_linux;
        while c_idle<10
            disp(['System resource is low now(' num2str(c_idle) '%), will wait for 10 seconds to resubmit the job.']);
            pause(10)
            c_idle=check_load_linux;
        end
%         system(['KlustaKwik ' fet_file(1).name(1:loc(end-1)-1) ' ' num2str(idx) ...
%             ' -UseDistributional 0 -MinClusters 20 -MaxClusters 21 '...
%         ' -MaxPossibleClusters 50 -DropLastNfeatures 1 &' ]);
        system(['KlustaKwik ' fet_file(1).name(1:loc(end-1)-1) ' ' num2str(idx) ...
            ' -MinClusters 5 -MaxClusters 30 '...
        ' -MaxPossibleClusters 50 &' ]);
        disp(['Job submitted ' num2str(idx) '/' num2str(length(fet_file)) ' current system resource:' num2str(c_idle) '%']);
    end
end
disp(['All Jobs submitted to backend, come back later to check .clu files'])
%% recovery matlab enviorment
% Reassign old library paths
cd(cwd); % go back to original folder
setenv('LD_LIBRARY_PATH',MatlabPath)
