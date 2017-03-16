
run("Close All");
dir = getDirectory("Choose a Directory ");
list = getFileList(dir); // An array containing the names of the files (hyperstacks).
print(list.length);
path=dir+list[0];
options="open=["+path+"] number=1 starting=2 increment=1 scale=100 file=[] or=[] sort";
run("Image Sequence...",options);
//option_sub=
nMed=31;
run("Make Substack...","delete slices=1-"+nSlices+"-"+nMed); 
title = getTitle();
print(title);
