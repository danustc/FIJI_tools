/*
 * For registering long time-series image stacks.
 * 
*/

function Reference_Create(fpath, n_sub){
	/*
	 * fpath: the complete file path to the original TS stack
	 * n_sub: number of slices each stack has, must be an even number
	 */
	open(fpath);
	TS_ID = getImageID(); // get the original imageID
	rename("TS_long");
	NS_TS = nSlices;  // get the total number of slices
	run("Make Substack...","delete slices=1-"+n_sub); // make the first two slices into a substack
	refID_00 = getImageID();
	rename("headref_00");
	selectImage(refID_00); // select the image
	run("Make Substack...","delete slices=1-"+n_sub/2);
	refID_0A = getImageID();
	rename("headref_A");
	title_0A = getTitle();
	selectImage(refID_00);
	refID_0B = getImageID();
	rename("headref_B");
	run("StackReg", "transformation=[Rigid Body]");
	title_0B = getTitle(); // get the title from refID_0B
	
	run("MultiStackReg", "stack_1="+ title_0B+" action_1=[Use as Reference] file_1=[] stack_2="+ title_0A + " action_2=[Align to First Stack] transformation=[Rigid Body]");
	run("Concatenate...", "  title=ref_aligned image1=" +title_0A + " image2=" + title_0B +" image3=[-- None --]");	 

	title_refnew = getTitle();
	refID_new = getImageID();
	mergedID = getImageID();
	nref = nSlices;
	
	selectImage(TS_ID); // grab the original image
	while(nSlices >= nref){
		run("Make Substack...", "delete slices=1-" +nref); // delete next nref slices
		rename("co_align");
		title_align = getTitle();
		run("MultiStackReg", "stack_1="+ title_refnew+" action_1=[Use as Reference] file_1=[] stack_2="+ title_align + " action_2=[Align to First Stack] transformation=[Rigid Body]");
		imageCalculator("Average create stack", title_refnew, title_align);
		rename("Averaged");
		ref_mean = getTitle();
		refID_new = getImageID();
		run("Concatenate...", "  title=ref_aligned image1=" +title_refnew + " image2=" + title_align +" image3=[-- None --]");	 
		title_refnew = getTitle();
		refID_new = getImageID();
		nref = nSlices;
		selectImage(TS_ID);
		
	}//end while


	
} // end function


macro "LongTS_Registration"{
	run("Close All");
	work_folder = getDirectory("Choose a Directory ");
	flist = getFileList(work_folder);
	
	for(i=0;i<flist.length;i++){
		print(work_folder+flist[i]);	
		path = work_folder+flist[i];
		Reference_Create(path, 100);		
		//run("Save");
		saveAs("tiff", dir + "rg_" + list[i] );
		close();
	}// end for
	
}// end macro
