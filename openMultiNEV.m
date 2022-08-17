%open multiple NEV at same time
[f p]=uigetfile('.nev','Select the NEV files to be converted','MultiSelect','On');
parfor f_idx=1:length(f);
    openNEV([p f{f_idx}]);
end