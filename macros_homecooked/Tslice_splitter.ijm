macro "Tslice_splitter" {
	// Using substack function. 
	run("Close All");
	nMed=getNumber("Z slices per stack", 9);
	nZmx=nMed;
	print(nMed);
	dir = getDirectory("Choose a Directory ");
	list = getFileList(dir); // An array containing the names of the files (hyperstacks).
	dirName = File.getName(dir); 
	print(dirName);
	print(list.length);
	path=dir+list[0];
	options="open=["+path+"] number=400 starting=1 increment=1 scale=100 file=[] or=[] sort";
	run("Image Sequence...",options);
	print("Number of slices");
	NS=nSlices;
	//while
	nCount = 0;
	while(nZmx>1){
		run("Make Substack...","delete slices=1-"+nSlices + "-" + nZmx); 
		//title=getTitle();
		title = dirName+"_ZP_"+nCount;
		print(title);
		saveAs("tiff",dir+title);
		close();
		NS=nSlices;
		print(NS);
		nCount++;
		nZmx--;
	} // end while	
	if(nSlices>0){
		title = dirName+"_ZP_"+nCount;
		saveAs("tiff", dir+title);
		close();
	}
	for(i=0;i<list.length;i++){
			print(dir+list[i]);	
			//ok = File.delete(dir+list[i]);
	}	
	//close();
}

