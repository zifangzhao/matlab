% pre-validate version of probability stock model
cd('e:\stock');
s=stock_read_v3(1,1,1000);
d_a=s{1}.data(:,[4 6]);
d_a(:,1)=[0 ; diff(d_a(:,1))./d_a(1:end-1,1)];
d_a(:,2)=mapminmax(d_a(:,2)',0,1);

d_n=d_a;
n=30;
v_max=0.15;
v_level=2*v_max/n;
for l=1:n   %��ɢ��
    locs=d_a(:,2)>(l-1)/n&d_a(:,2)<=l/n;
    d_n(locs,2)=l;
    locs=d_a(:,1)>-v_max+(l-1)*v_level&d_a(:,1)<=-v_max+l*v_level;
    d_n(locs,1)=l;
end
locs=d_a(:,1)>-v_max+l*v_level;
d_n(locs,1)=n;
locs=d_a(:,1)<-v_max;
d_n(locs,1)=1;

%����ͳ��
N=1; %ʹ�ü�������ݽ��н�ģ��N*2Ԫģ�ͣ�
p=zeros(ones(1,N*2+1)*n);  %����Ƶ�Ⱦ���

p_e=zeros(size(d_n,1)-1,3); %�����¼�����
for day=1:size(d_n,1)-1;
    p_e(day,:)=[d_n(day+1,1) d_n(day,:)];
%     loc=[d_n(day+1,1) d_n(day,:)];
    p(d_n(day+1,1),d_n(day,1),d_n(day,2))=p(d_n(day+1,1),d_n(day,1),d_n(day,2))+1;
end

% [x,y,z]=meshgrid(1:n,1:n,1:n);%����ά������


%���������Կ���ʹ��good-turing��ʽ��������