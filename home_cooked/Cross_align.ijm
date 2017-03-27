macro "Cross_align" {
	// Using substack function. 
	// Cross align one stack to another 
	run("Close All");
	
	dir = getDirectory("Choose a Directory ");
	list = getFileList(dir); // An array containing the names of the files (hyperstacks).
	dirName = File.getName(dir); 
	print(dirName);
	print(list.length);
	for(i=0;i<list.length;i++){
		print(dir+list[i]);	
		path = dir+list[i];
		open(path);
		run("StackReg", "transformation=[Rigid Body]");
		saveAs("tiff", dir + "rg_" + list[i] );
		close();
	}	

	for(i=0;i<list.length;i++){
			print(dir+list[i]);	
			ok = File.delete(dir+list[i]);
	}	
	//close();
