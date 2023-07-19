%cell_count2
function cell_angle=cell_judge(input,rmax)
%input must be bw

[m n]=size(input);
cell_angle=zeros(m,n);
%% ��ͼ�����ܼ���հױ߽磬��������ԵԽ�������
temp=zeros(m+2*(rmax-1),n+2*(rmax-1));

temp(rmax:m+rmax-1,rmax:n+rmax-1)=input;

%% ����Ƕȳ˷�������45��Ϊ������λ
angle_div=16;
angle_cell=cell(angle_div,1);
% angle_temp=zeros(2*rmax-1);

%% ��������ϵ�ĽǶ�
[x,y]=meshgrid(1:2*rmax-1,1:2*rmax-1);
angle_temp=arrayfun(@(x,y) y-rmax+(rmax-x)*1i,x,y);
% for x=1:2*rmax-1                                              
%     for y=1:2*rmax-1
%         angle_temp(y,x)=y-rmax+(rmax-x)*1i;
%     end
% end
angle_temp=angle(angle_temp);
for num=1:angle_div
    angle_cell{num,1}=(angle_temp>=num*pi/angle_div).*(angle_temp<(num+1)*pi/angle_div);  %���ɽǶ��о�����
end
[x,y]=meshgrid(1:n,1:m);
cell_angle_temp=zeros(m,n,num);
parfor num=1:angle_div
    cell_angle_temp(:,:,num)=arrayfun(@(y,x) ~isempty(find(temp(y:y+2*rmax-2,x:x+2*rmax-2).*angle_cell{num}>0, 1)),y,x);
end
cell_angle=arrayfun(@(y,x) sum(cell_angle_temp(y,x,:)),y,x);
% for x=1:n
%     for y=1:m
%         
%         for num=1:angle_div
%             lookforNZ=temp(y:y+2*rmax-2,x:x+2*rmax-2).*angle_cell{num}>0;
%             if isempty(find(lookforNZ, 1))
%             else
%                 cell_angle(y,x)=1+cell_angle(y,x);
%             end
%         end
%         
%     end
end



