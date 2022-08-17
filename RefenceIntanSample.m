function RefenceIntanSample(fname,outfile,sps_start, sps_end, Nch, cycle,fs)
% Nch=2;
data=readmulti_frank(fname,Nch,1:Nch,sps_start,sps_end);

subplot(211)
plot(bsxfun(@plus,data(1:1000,:),2000*(1:Nch)))

% cycle=16;
x=1:cycle;
y=1:Nch;
[xm,ym]=meshgrid(x,y);
mean_offset=arrayfun(@(x,y) mean(data(x:cycle:end,y)),xm,ym);

fs_cyc=fs/cycle;
[fb,fa]=butter(2,0.5/fs_cyc*2,'high');
for a=1:cycle
    for b=1:Nch
        data(a:cycle:end,b)=filtfilt(fb,fa,data(a:cycle:end,b));
%         data(a:cycle:end,b)=data(a:cycle:end,b)-mean_offset(b,a);
    end
end

subplot(212)

plot(bsxfun(@plus,data(1:1000,:),2000*(1:Nch)))

sav2dat(outfile,data);

% [b,a]=butter(2,500/fs*2,'high');
% data=readmulti_frank([fname(1:end-4) '_fix.dat'],Nch,1:Nch,0,inf);
% data=filtfilt(b,a,data);
% sav2dat([fname(1:end-4) '_fix.fil'],data);