% stock analysis code for 1 min data
[f,p]=uigetfile('*.txt','Load stock txt file');
raw=importdata([p f]);
datetext=arrayfun(@(x,y) [x ' ' 