function w_band=freq2bands(w,freqlist,bands)
% w is a matrix of wavelet(absolute value),time x freqs x channel
% dim is the dimension of frequency axis;
% freqlist is the frequency defination of selected dimension
% band is a cell array contains a [x y] frequency defination mat in each cell
band_idx=cellfun(@(x) freqlist>=x(1)&freqlist<x(2),bands,'UniformOutput',0);
w_band_cell=cellfun(@(x) median(w(:,x,:),2),band_idx,'UniformOutput',0);
w_band=cat(2,w_band_cell{:});
