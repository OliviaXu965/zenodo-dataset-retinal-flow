function         computeHistAllFromIdx(lookup_table,these_idx,myPath)



theseFiles = lookup_table(these_idx,1);


histsAll =chunkedHistCombination(theseFiles);



save(myPath,'histsAll');



end