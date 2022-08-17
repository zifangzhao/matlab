function ch_2164 = DAT_INTAN64_to_32(ch_2132,bank)
% channel should be base 1
map_64=cell(2,1); %channels of corresponding 2132 in 2164
map_64{1}=[31 29 27 25 23 21 19 17 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 47 45 43 41 39 37 35 33]+1;
map_64{2}=[63 61 59 57 55 53 51 49 48 50 52 54 56 58 60 62 0 2 4 6 8 10 12 14 15 13 11 9 7 5 3 1]+1;

ch_2164=map_64{bank}(ch_2132);
