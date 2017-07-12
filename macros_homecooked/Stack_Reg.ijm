macro "Stack_Reg" {
	// Using substack function. 
	// Also, take out the first one or few slices of each time point and build a new stack.
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
		run("StackReg", "transformation=[Affine]");
		//run("Save");
		saveAs("tiff", dir + "af_" + list[i] );
		close();
	}// end for
}// end macro	

	