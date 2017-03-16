macro "Substack_splitte" {
	// Using substack function. 
	run("Close All");
	nMed=getNumber("Slices per stack", 32);
	print(nMed);
	dir = getDirectory("Choose a Directory ");
	list = getFileList(dir); // An array containing the names of the files (hyperstacks).
	dirName = File.getName(dir); 
	print(dirName);
	print(list.length);
	path=dir+list[0];
	options="open=["+path+"] number=500 starting=1 increment=1 scale=100 file=[] or=[] sort";
	run("Image Sequence...",options);
	print("Number of slices");
	NS=nSlices;
	//while
	nCount = 0;
	while(NS>nMed){
		run("Make Substack...","delete slices=1-"+nMed); 
		//title=getTitle();
		
		title = dirName+"_TP_"+nCount;
		print(title);
		saveAs("tiff",dir+title);
		close();
		NS=nSlices;
		print(NS);
		nCount++;
	} // end while
	if(nSlices>0){
		title = dirName+"_TP_"+nCount;
		saveAs("tiff", dir+title);
		close();
	}
	for(i=0;i<list.length;i++){
			print(dir+list[i]);	
			ok = File.delete(dir+list[i]);
	}	
	//close();
}

