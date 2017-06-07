macro Single_slice_stackreg{
	/*
	 */
	run("Close All");
	fpath = getDirectory("Choose a directory to store the registration output:" );
	fname = getString("Type in the file name:", "sliceReg.txt")
	print("Open reference slice");
	open();
	ZD_ID = getImageID();
	title_ref = getTitle(); // get the reference of the title
	print("reference title:", title_ref);
	print("Open slice to be registered");
	open();
	TS_ID = getImageID();
	selectImage(TS_ID);
	title_align = getTitle(); // get the reference of the cov image title
	print("to be aligned:", title_align);
	run("MultiStackReg", "stack_1="+ title_ref+" action_1=[Use as Reference] file_1=[] stack_2="+ title_align + " action_2=[Align to First Stack] file_2="+fpath+fname+" transformation=[Rigid Body] save");	
	//run("MultiStackReg", "stack_1=ts_dup.tif action_1=[Use as Reference] file_1=[] stack_2=ts_dup_trans.tif action_2=[Align to First Stack] file_2=[] transformation=[Rigid Body] save");
	print("OK I finished!");
}