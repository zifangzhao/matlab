%%merge image series into video
pathname=uigetdir();
cwd=pwd;
cd(pathname);
files=dir('*.jpg');

mov(length(files)) = struct('cdata',[],'colormap',[]);
% img=arrayfun(@(x) importdata(x.name),files,'UniformOutput',0);
% img=cell(1,length(files));

multiWaitbar('Files:',0,'Color',[0.1 0.5 0.8])
for idx=1:length(files)
%     mov(idx)=im2frame(img{idx});
       mov(idx)=im2frame(importdata(files(idx).name));
       multiWaitbar('Files:',idx/length(files))
end
% mov=cellfun(@(x) im2frame(x),img,'UniformOutput',0);
% for idx=1:length(files)
% 
%         mov(frm)=im2frame;
% 
% end
loc=strfind(pathname,'\');
filename=pathname(loc(end):end);
movie2avi(mov,[pathname '\' filename ],'compression','None');
multiWaitbar('CloseAll');