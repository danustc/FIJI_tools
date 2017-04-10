function Open_select(fpath, nslice){
	/*
	 * Open an image stack specified by the file path, then just take out the nth slice.
	 */
	 open(fpath, nslice);
	 slice_ID = getImageID();
	 return slice_ID;
}

path = "/home/sillycat/Programming/Python/FIJI_tools/A2_HB_ZD.tif"
slice_ID1 = Open_select(path, 10);
work_folder = getDirectory("image");
makeRectangle(194, 172, 400, 400);
run("Crop");
crop_1 = getImageID();
rename("crop_1");
save(work_folder + getTitle()+".tif");
close();

slice_ID2 = Open_select(path, 10);
makeRectangle(190, 170, 400, 400);
run("Crop");
crop_2 = getImageID();
rename("crop_2");
save(work_folder + getTitle()+".tif");
close();

