% stft_A=get(gco,'CData');
% stft_B=get(gco,'CData');
stft_A_sel=stft_A(1:49,stft_t>=4000 & stft_t<=8000);
stft_B_sel=stft_B(1:49,stft_t>=4000 & stft_t<=8000);
stft_A_intp=interp2(1:49',1:81',stft_A_sel',1:49',linspace(1,81,101)')';
stft_B_intp=interp2(1:49',1:81',stft_B_sel',1:49',linspace(1,81,101)')';
stft_sl_A=stft_A_intp.*dataA;
stft_sl_B=stft_B_intp.*dataB;
figure();
subplot(211);imagesc(result.startpoint,1:49,stft_sl_A);axis xy;caxis([0 4e8])
subplot(212);imagesc(result.startpoint,1:49,stft_sl_B);axis xy;caxis([0 4e8])