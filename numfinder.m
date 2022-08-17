%% find ratnumber in filename,after 'word'
function rat_num=numfinder(name,word)
numloc=strfind(name,word);
rat_num=[];
if(isnan(numloc))
else
    wordlength=length(word);
    wordleft=length(name)-wordlength-numloc+1;
    if(wordleft>0)
        for m=0:wordleft-1
            if(isnan(str2double(name(numloc+wordlength+m))))
                break;
            else
                rat_num=[rat_num name(numloc+wordlength+m)];
            end
            
        end
    end
end
rat_num=str2double(rat_num);