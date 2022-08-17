%%script_submit_kk
%% clustering
[fet_file,p_dat]=uigetfile('*.fet.*','multiselect','on');
cd(p_dat);
if ~isempty(fet_file)
    if ~iscell(fet_file)
        temp=fet_file;
        fet_file=cell(1);
        fet_file{1}=temp;
    end
    loc=strfind(fet_file{1},'.');
    for idx=1:length(fet_file)
        c_idle=check_load_linux;
        while c_idle<10
            disp(['System resource is low now(' num2str(c_idle) '%), will wait for 10 seconds to resubmit the job.']);
            pause(10)
            c_idle=check_load_linux;
        end
        system(['KlustaKwik ' fet_file{1}(1:loc(end-1)-1) ' ' num2str(idx) ...
            ' -UseDistributional 0 -MinClusters 20 -MaxClusters 21 '...
            ' -MaxPossibleClusters 50 -DropLastNfeatures 1 &' ]);
        %         system(['KlustaKwik ' fet_file(1).name(1:loc(end-1)-1) ' ' num2str(idx) ...
        %             ' -MinClusters 20 -MaxClusters 30 '...
        %         ' -MaxPossibleClusters 50 &' ]);
        disp(['Job submitted ' num2str(idx) '/' num2str(length(fet_file)) ' current system resource:' num2str(c_idle) '%']);
    end
end
disp(['All Jobs submitted to backend, come back later to check .clu files'])