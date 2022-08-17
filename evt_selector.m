%% evt file trail rejector
[f p]=uigetfile('*.evt','Select a event file');
x=LoadEvents([p f]);
str=num2str(x.time(1:3:end));
N=length(x.time)/3;
sel=ones(N,1);
[s,~] = listdlg('PromptString','Select events to be rejected',...
    'SelectionMode','multiple',...
    'ListString',str);
sel(s)=0;
sel_mat=find(reshape((sel*ones(1,3))',1,[]));
x.time=x.time(sel_mat);
x.description=x.description(sel_mat);
system(['del "' p f(1:end-8) '_rej' f(end-7:end) '"']);
SaveEvents([p f(1:end-8) '_rej' f(end-7:end)],x)