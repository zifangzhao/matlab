%warning: only works with delay intervals = starttime intervals
[filename,pathname] = uigetfile('*.fig','Open A->B figure');
h=openfig([pathname '/' filename]);
all_cld=get(h,'Children');
all_img=findall(all_cld,'Tag','','-and','Type','image');
dataA1=get(all_img(2),'Cdata');
dataA2=get(all_img(1),'Cdata');
x_range=get(all_img(2),'Xdata');
y_range=get(all_img(2),'Ydata');
close(h);
% all_titl=findall(all_cld,'Tag','','-and','Type','Text');
[filename,pathname] = uigetfile('*.fig','Open B->A figure');
h=openfig([pathname '/' filename]);
all_cld=get(h,'Children');
all_img=findall(all_cld,'Tag','','-and','Type','image');
dataB1=get(all_img(2),'Cdata');
dataB2=get(all_img(1),'Cdata');
close(h)
dly_len=size(dataA1,1);
stp_len=size(dataA1,2)-size(dataA1,1);
new1=zeros(1+stp_len,2*dly_len-1)';
new2=zeros(1+stp_len,2*dly_len-1)';
new1(dly_len:end,:)=dataA1(:,dly_len:end);
new2(dly_len:end,:)=dataA2(:,dly_len:end);
% sel_mat=zeros(size(dataA1));
for y=1:dly_len
%     sel_mat(y,dly_len-y+1:dly_len-y+1+stp_len)=1;
new1(1+dly_len-y,:)=dataB1(y,dly_len-y+1:dly_len-y+1+stp_len);
new2(1+dly_len-y,:)=dataB2(y,dly_len-y+1:dly_len-y+1+stp_len);
end
figure()
subplot(211)
imagesc(x_range(dly_len:end),[fliplr(-y_range(2:end)+1) y_range-1],new1);axis xy;
subplot(212)
imagesc(x_range(dly_len:end),[fliplr(-y_range(2:end)+1) y_range-1],new2);axis xy;
% new1(1:dly_len,:)=flipud(dataB1(sel_mat));
