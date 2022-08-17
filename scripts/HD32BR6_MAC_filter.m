%HD32R6 MAC filter code generator
%filter is stored in Num, should be FIR filter
asm_code=['DB '];
cnt=0;
line=1;
x_abs=Num*2^15;
x_abs(x_abs<0)=x_abs(x_abs<0)+65536;
x_abs=round(x_abs);
b=zeros(length(Num),1);
C51_code=[];
for idx=1:length(Num)
    x=Num(idx);
    B=[];

    C51_code=[num2str(x_abs(idx)) ',' C51_code];
    B=dec2bin(x_abs(idx),16);   
    t=-str2double(B(1));
    for i=1:length(B)-1;
        t=t+2^(-i)*str2double(B(i+1));
    end
    b(idx)=t;
    H=dec2hex(bin2dec(B),4);
    
    if cnt==8;
        cnt=0;
        asm_code(end)=[];
        asm_code=[asm_code ' DB 0' H(1:2) 'H,' '0' H(3:4) 'H,'];
    else
        asm_code=[asm_code '0' H(1:2) 'H,' '0' H(3:4) 'H,'];
    end
    cnt=cnt+1;
end
asm_code(end)=[];
C51_code(end)=[];
