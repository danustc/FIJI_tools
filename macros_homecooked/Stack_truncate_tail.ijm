// This macro demonstrate how to use the File.* functions.
// It creates a temporary directory, saves three images in it, 
// display information about the files, then deletes the
// files and the directory.
macro "Stack_truncate_tail"{
	
  	// Get path to temp directory
  	run("Close All");
	work_folder = getDirectory("Choose a Directory ");
	flist = getFileList(work_folder);
	nStop=getNumber("Stop at slice", 1220);
	for(i=0;i<flist.length;i++){
		print(work_folder+flist[i]);	
		path = work_folder+flist[i];
		open(path);
		TS_ID = getImageID();
		nTotal = nSlices;
		run("Make Substack...", "delete slices="+ nStop + "-" + nTotal);
		close();
		selectImage(TS_ID);
		run("Save");
		close();

  	}
  
}