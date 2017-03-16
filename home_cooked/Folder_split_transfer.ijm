macro "Split_transfer" {
	run("Close All");
	dir = getDirectory("Choose a Directory ");
	list = getFileList(dir); // An array containing the names of the files (hyperstacks).
	print(list.length);
	path=dir+list[0];
	pname = File.getName(dir);
	for(i=0;i<list.length;i++){
		print(dir+list[i]);	
		path = dir+list[i];
		open(path);
		saveAs("tiff", dir+"RS_" + list[i] );
		close();
		
					
	}	

	

}