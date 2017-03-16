// This macro demonstrate how to use the File.* functions.
// It creates a temporary directory, saves three images in it, 
// display information about the files, then deletes the
// files and the directory.
macro "Run" {
	
  	// Get path to temp directory
  	myDir = getDirectory("Choose a directory.");
 	list = getFileList(myDir);
  // Create a directory in temp
 	run("StackReg ", "transformation=[Rigid Body]")

  // Create some images and save them in the directory
  	setBatchMode(true);
 

  // Display info about the files
 
	for (i=0; i<list.length; i++)
    	  print(list[i]+": "+File.length(myDir+list[i])+"  "+File.dateLastModified(myDir+list[i]));

  // Delete the files and the directory
  	for (i=0; i<list.length; i++){
		ok = File.delete(myDir+list[i]);
		print("deleted.");
  	}
  
}