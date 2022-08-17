%script to generate stimulation pattern
%4 set of electrode
%LF-1                     RF-2
%LR-3                     RR-4
channel_num=4;
patterns={[1;2];[3;4];[4;3];[2;1];[1;3];[3;1];[2;4];[4;2]};
% patterns={[1,3];};
max_voltage=1;

pattern_num=length(patterns); %total number of stimulation patterns
stim_duration=60000;
stimulation_num=10; %stimulation number for each pattern
time_bin=100;       %micro-controller time bin in ms 1khz

PWM_bin=10;       % 1 PWM cycle
samples_each_cyc=400;
%Current_freq=4000/time_bin/PWM_bin/samples_each_cyc
t_min=40000;        %minimal time between 2 stimulations
t_max=60000;     % maximal time between 2 stimulations

s_mat=[1:pattern_num]'*ones(1,stimulation_num);  %matrix multiplcation to generate the initial matrix for arrange stimulation
s_mat=reshape(s_mat,1,[]); %change the matrix back to 1-D
%% perform the permutation
idx=randperm(length(s_mat)); %generate the randomized index for the permutation
s_mat=s_mat(idx);                          %rearrange the sequence by the randomized index

%% Add the randomized interval into the matrix, we take 0 as no do anything state
t_intevals=t_min/time_bin+(randi((t_max-t_min)/time_bin,length(s_mat),1)-1);  %generate the random numbers with in the [t_min t_max]

%generate a cell matrix to contain the data for each stimulation,just to
%get rid of for loops
c=arrayfun(@(x) [s_mat(x)*ones(1,stim_duration/time_bin) zeros(1,t_intevals(x))],1:length(s_mat),'UniformOutput',0);
t_mat=[c{:}];  %make the patterns combined together to make a time-domain sequence

%convert the t_mat to the format my program can recongnize(control bit)
control=zeros(8,length(t_mat)); %we have a 8 switches control system,so the command is 8 in one frame

%convert the pattern cell to a matrix
pattern_mat=zeros(channel_num,length(patterns));
for idx=1:size(patterns,1)
    p=patterns{idx};
    if(size(p,1)==1)
        p=p';
    end
    pattern_mat(p(1,:),idx)=1;
    pattern_mat(p(2,:),idx)=-1;
end

non_zero_idx=find(t_mat);

%here we need to add the PWM modulation
sin_w=round(mapminmax(sin(2*pi*(linspace(0,max_voltage,samples_each_cyc))),0,PWM_bin));
mask=zeros(PWM_bin*samples_each_cyc,1);
 for idx=1:samples_each_cyc
     mask(1+(idx-1)*PWM_bin:idx*PWM_bin)=[ones(sin_w(idx),1); zeros(PWM_bin-sin_w(idx),1)];
 end
mask_rep=repmat(mask,ceil(length(t_mat)/length(mask)),1)';
% t_mat=t_mat.*mask_rep(1:length(t_mat));

%vectorized version
for idx=1:size(pattern_mat,2)
    target_idx=(t_mat==idx);
    for chn=1:channel_num
        control(chn,target_idx)=pattern_mat(chn,idx);  
    end
end
%control(5:8,:)=control(1:4,:);
% control(1:4,:)=zeros(4,size(control,2));
control(:,end+1)=zeros(8,1);
file_st=reshape(control,1,[]);
fid=fopen('switch_command.txt','w');% 'w' for create new file if there's not,and will wipe out old data
fwrite(fid,file_st,'int8');
fclose(fid);
