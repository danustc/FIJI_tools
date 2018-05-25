macro "Nrrd_converter"{
	run("Close All");
	dir = getDirectory("Choose a directory ");
	dlist = getFileList(dir); // An array containing the names of the files (hyperstacks).
	dirName = File.getName(dir);
	for(ii=0;ii<dlist.length;ii++){		
		if(endsWith(dlist[ii], "/")){// a directory
			list = getFileList(dir+dlist[ii]);
			print("List length:");
			print(list.length);
			for(i=0;i<list.length;i++){
				if(endsWith(list[i], ".tif")){
					path = dir+dlist[ii]+list[i];
					print(path);
					print("Open path:");
					open(path);
					run("Flip Horizontally", "stack");
					run("Properties...", "channels=1 slices=101 frames=1 unit=micron pixel_width=0.295 pixel_height=0.295 voxel_depth=1");
					run("Save");
					basename = substring(dlist[ii], 0, lastIndexOf(dlist[ii], "/"));
					//basename = substring(list[i], 0, lastIndexOf(list[i], "."));
					print(basename);
					run("Nrrd ... ", "nrrd=" + dir + basename + ".nrrd");
					close();
					print("Finished!");
					wait(100);
				}//end if
			}//end for i
		} //end if folder
		print("End if.");
	}// end for ii
}