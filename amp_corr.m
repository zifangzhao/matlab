function X=amp_corr(data,win,stps,delays)
data_ht=abs(hilbert(data)); %run column-wise
% data_ht=bsxfun(@minus,data_ht,mean(data_ht,1));
Nch=size(data_ht,2);
X=ones(Nch,Nch,length(stps),length(delays));
for ch1=1:Nch
    for ch2=1:Nch
        for s_idx=1:length(stps)
            for d_idx=1:length(delays)
                st=stps(s_idx)+1;
                dl=delays(d_idx);
                X(ch1,ch2,s_idx,d_idx)=corr(data_ht(st:st+win-1,ch1),data_ht(st+dl:st+dl+win-1,ch2));
            end
        end
    end
end