%%matlab code to generate HD32C channel list
list=[ 1 8;1 7;1 6; 1,5;1,4;1,3;1,2;1,1;2,9;2,10;2,11;2,12;2,13;2,14;2,15;2,16;...
    2,8;2,7;2,6;2,5;2,4;2,3;2,2;2,1;1,9;1,10;1,11;1,12;1,13;1,14;1,15;1,16];
code=arrayfun(@(x) 16*list(x,1)+list(x,2)-1,1:size(list,1));
code_h=dec2hex(code);
string_h='DB ';
for idx=1:size(code_h,1);
    string_h=[string_h code_h(idx,:) 'H,0'];
end
string_h(end-1:end)=[];
