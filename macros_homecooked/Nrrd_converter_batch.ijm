function Nrrd_converter(work_path){
	list = getFileList(work_path);
	dirName = File.getName(work_path);
	for(i=0;i<list.length;i++){
		if(endsWith(list[i], ".tif")){
			path = work_path+list[i];
			open(path);
			run("Flip Horizontally", "stack");
			run("Properties...", "channels=1 slices=101 frames=1 unit=micron pixel_width=0.295 pixel_height=0.295 voxel_depth=1");
			run("Save");
			basename = substring(list[i], 0, lastIndexOf(list[i], "."));
			run("Nrrd ... ", "nrrd=" + work_path + dirName + ".nrrd");
			close();
		}//end if
	}//end for i
}

macro "Nrrd_converter"{
	run("Close All");
	dir = getDirectory("Choose a directory ");
	list = getFileList(dir); // An array containing the names of the files (hyperstacks).
	dirName = File.getName(dir);
	for(i = 0;i<list.length;i++){
		print(list[i]);
		if(endsWith(list[i], "/")){
			wpath = dir + list[i];
			Nrrd_converter(wpath);
		}//endif
		
	}//end for
}