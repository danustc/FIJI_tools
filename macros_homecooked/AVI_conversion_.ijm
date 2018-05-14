function avi_conversion(fname, fps){
	open(fname);
	tif_ID = getImageID();
	dirname = getDirectory("image");
	fname_avi = replace(getTitle(), "tif", "avi");
	run("AVI... ", "compression=JPEG frame=" +fps+" save=" + dirname + fname_avi);
	close();
} // convert a tiff stack into avi


macro "AVI_conversion"{
	run("Close All");
	work_folder = getDirectory("Choose a directory for conversion: ");
	tiff_list = getFileList(work_folder);
	for(i = 0; i< tiff_list.length;i++){
		if(endsWith(tiff_list[i], "tif")){
			print(tiff_list[i]);
			data_path = work_folder + tiff_list[i];
			avi_conversion(data_path, 10);
		}// endif 
	}// end for

	
}// the macro of avi conversion
