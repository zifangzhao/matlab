%merge binary files
function DAT_mergeALL(f_all,outdir,Nch)
p=[];
if nargin<1
    [f_all,p]=uigetfile({'*.dat','*.dat|Binary data file'},'Select files needed to be merged','Multiselect','on');
end
cd(outdir);
fh=fopen([outdir 'Merged.dat'],'w+');
for idx=1:length(f_all)    
    f=f_all{idx};
    bulk=1e5;
    st=1;
    finfo=dir([p f]);
    Nsamples=finfo(1).bytes/2/Nch;
    while(st<Nsamples)
        disp(['File:' num2str(idx) '/' num2str(length(f_all)) ' Merging:' num2str(st/Nsamples*100) '%'] );
        data=readmulti_frank([p f],Nch,1:Nch,st,st+bulk-1);
        fwrite(fh,data','int16');
        st=st+bulk;
    end
end
fclose(fh);