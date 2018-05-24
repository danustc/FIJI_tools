macro "Nrrd_converter"{
	run("Close All");
	dir = getDirectory("Choose a directory ");
	list = getFileList(dir); // An array containing the names of the files (hyperstacks).
	dirName = File.getName(dir); 
	for(i=0;i<list.length;i++){
		if(endsWith(list[i], ".tif")){
			path = dir+list[i];
			open(path);
			run("Flip Horizontally", "stack");
			run("Properties...", "channels=1 slices=101 frames=1 unit=micron pixel_width=0.295 pixel_height=0.295 voxel_depth=1");
			run("Save");
			basename = substring(list[i], 0, lastIndexOf(list[i], "."));
			run("Nrrd ... ", "nrrd=" + dir + basename + ".nrrd");
			close();
		}//end if
	}//end for

}
