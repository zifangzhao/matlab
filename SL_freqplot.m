
% rat_tag='Rat17';
% loc_R=cellfun(@(x) ~isempty(strfind(x,rat_tag)),result.A.tags);
pair_tag='OFC_ACC';
loc_r=cellfun(@(x) ~isempty(strfind(x,pair_tag)),result.A.tags);
% loc_r=loc_r.*loc_R;
% freq_tag={ 'L4' 'L5' 'L6' 'L7' };
freq_tag={ 'L1 ' 'L2 ' 'L3 ' 'L4 ' 'L5 ' 'L6 ' 'L7 ' 'L8 ' 'L9 ' ...
    'L10' 'L11' 'L12' 'L13' 'L14' 'L15' 'L16' 'L17' 'L18' 'L19'...
    'L20' 'L21' 'L22' 'L23' 'L24' 'L25' 'L26' 'L27' 'L28' 'L29'...
    'L30' 'L31' 'L32' 'L33' 'L34' 'L35' 'L36' 'L37' 'L38' 'L39'...
    'L40' 'L41' 'L42' 'L43' 'L44' 'L45' 'L46' 'L47' 'L48' 'L49' };

dataA=zeros(length(freq_tag),size(result.A.data,2));
for f_idx=1:length(freq_tag)
     loc_f=cellfun(@(x) ~isempty(strfind(x,freq_tag{f_idx})),result.A.tags);
     loc=find(loc_r.*loc_f);
     dataA(f_idx,:)=result.A.data(loc,:);
end

dataB=zeros(length(freq_tag),size(result.B.data,2));
for f_idx=1:length(freq_tag)
     loc_f=cellfun(@(x) ~isempty(strfind(x,freq_tag{f_idx})),result.B.tags);
     loc=find(loc_r.*loc_f);
     dataB(f_idx,:)=result.B.data(loc,:);
end

figure()
subplot(121)
imagesc(result.startpoint,1:length(freq_tag),dataA);axis xy; ca1=caxis;
subplot(122)
imagesc(result.startpoint,1:length(freq_tag),dataB);axis xy; ca2=caxis;
ca=[min([ca1 ca2]) max([ca1 ca2])];
caxis(ca);
subplot(121)
caxis(ca);

band1=mean(dataA(4:8,:),1);
band2=mean(dataB(4:8,:),1);
figure()
subplot(211)
plot(result.startpoint,band1)
subplot(212)
plot(result.startpoint,band2)

% % Q1=sum(band1(result.startpoint>=1 & result.startpoint<=761))-sum(band1(result.startpoint>=-749 & result.startpoint<1))
Q2=sum(band2(result.startpoint>=1 & result.startpoint<=761))-sum(band2(result.startpoint>=-749 & result.startpoint<1))