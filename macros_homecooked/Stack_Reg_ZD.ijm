macro "Stack_Reg_ZD" {
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
		subdir = dir+list[i];
		tif_list = getFileList(subdir);
		data_name = File.getName(subdir);
		for(j=0; j<tif_list.length;j++){
			path = subdir + tif_list[j];
			if(endsWith(path, ".tif")){
				open(path);
				run("StackReg", "transformation=[Rigid Body]");
				saveAs("tiff", subdir + data_name);
				close();

			}//end if
		}// enf for j
		//run("Save");
			
	}// end for
}// end macro	

	