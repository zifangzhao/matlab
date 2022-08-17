%function stock_bias_fix
function stock=stock_bias_fix(stock)
%��Ȩ��Ϣ��=(��Ȩ�Ǽ��յ����̼ۣ�ÿ�����ֺ����ֽ��+��ɼۡ�ÿ�������)��(1+ÿ���ͺ����+ÿ�������)
%��ɳ�Ȩ��=����Ȩ�Ǽ������̼�+��ɼ�*ÿ����ɱ�����/��1+ÿ����ɱ�����
%share ratio= 6xN double [ÿn1����n2Ԫ ��n3�� ת��n4�� ��n5�� ��ɼ�n6]
for idx=1:length(stock)
    stock{idx}=stock_process(stock{idx});
end

function s=stock_process(s) %��������Ʊ
data=s.data;
sr_all=s.shareratio;
bias=zeros(size(data,1),1);
for idx=1:size(s.shareratio,2)
%     day_idx=find(cellfun(@(x) ~isempty(strfind(x,s.sharedate{idx})),s.date));
    sr=sr_all(:,idx);
    day_idx=find(s.date==s.sharedate(idx),1,'first');
    price=data(day_idx,4); %��Ȩǰһ������̼�
    price_new=(price-sr(2)/sr(1)+sr(6)*sr(5)/sr(1))/(1+sr(3)/sr(1)+sr(5)/sr(1));
    bias(day_idx:end)=bias(day_idx:end)-(price-price_new);
end
s.bias=bias;