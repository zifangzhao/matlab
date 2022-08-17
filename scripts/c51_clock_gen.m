sysclk=61.48e6;
cmd_tim=3;
clk_mat=zeros(768/3,8);
clk_str=[];

for idx=1:size(clk_mat/3,1)
    
    clk_mat(idx,2)=mod(idx-1,16)==1;
    clk_mat(idx,1)=mod(idx-1,12/3)>=6/3;
    clk_mat(idx,7)=mod(idx-1,48/3)>=24/3;
    clk_mat(idx,8)=mod(idx-1,96/3)>=48/3;
    clk_mat(idx,6)=mod(idx-1,192/3)>=96/3;
    clk_mat(idx,5)=mod(idx-1,384/3)>=192/3;
    clk_mat(idx,4)=mod(idx-1,768/3)>=384/3;
    temp=[num2str(clk_mat(idx,:))];
    clk_str=[clk_str;num2str(strrep(temp,' ',''))];
end
% clk_mat(2:16:end,8)=1;
% clk_str=num2str(clk_mat);
% clk_temp=[clk_str(1,:)]
%clk_str=reshape(regexprep(reshape(clk_str,1,[]),' ',[]),768,[]);

cmd_b=repmat('MOV P2,#',[size(clk_mat,1),1]);
cmd_e=repmat('B',[size(clk_mat,1),1]);
cmd=[cmd_b clk_str cmd_e];
%cmd_final=char(size(cmd,1)*7,size(cmd,2));
cmd_final=repmat('NOP              ',size(cmd,1)*7,[]);
cmd_final(1:7:end,:)=cmd;