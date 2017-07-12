/*
 * For registering long time-series image stacks.
 * 
*/

function Reference_Create(fpath, n_sub, n_offset){
	/*
	 * fpath: the complete file path to the original TS stack
	 * n_sub: number of slices each stack has, must be an even number
	 */
	open(fpath);
	TS_ID = getImageID(); // get the original imageID
	rename("TS_long");
	if(n_offset>0){
		run("Make Substack...", "delete slices=1-"+n_offset);
		close();
	}
	selectImage(TS_ID);
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
	selectImage(refID_0B);
	rename("headref_B");
	run("StackReg", "transformation=[Rigid Body]");
	title_0B = getTitle(); // get the title from refID_0B
	setSlice(nSlices);
	run("Add Slice");
	setSlice(1);
	selectImage(refID_0A);
	setSlice(nSlices);
	run("Add Slice");
	setSlice(1);
	
	run("MultiStackReg", "stack_1="+ title_0B+" action_1=[Use as Reference] file_1=[] stack_2="+ title_0A + " action_2=[Align to First Stack] transformation=[Rigid Body]");
	run("Concatenate...", "  title=ref_aligned image1=" +title_0A + " image2=" + title_0B +" image3=[-- None --]");	 
	title_refnew = getTitle();
	refID_new = getImageID();
	selectImage(refID_new);
	setSlice(n_sub/2+1);
	run("Delete Slice");
	setSlice(nSlices);
	run("Delete Slice");
	setSlice(1);
	run("Duplicate...", "title=Summed duplicate"); //
	meanID_new = getImageID();
	selectImage(meanID_new);
	setSlice(nSlices);
	run("Add Slice");
	setSlice(1);
	title_sum = getTitle();
	selectImage(TS_ID); // grab the original image
	NS = nSlices;
	niter = 2;
	while(NS > n_sub){
		run("Make Substack...", "delete slices=1-" +n_sub); // delete next nref slices
		coalign_ID = getImageID();
		setSlice(n_sub);
		run("Add Slice");
		rename("co_align");
		title_align = getTitle();
		setSlice(1);
		run("MultiStackReg", "stack_1="+ title_sum+" action_1=[Use as Reference] file_1=[] stack_2="+ title_align + " action_2=[Align to First Stack] transformation=[Rigid Body]");
		/*
		imageCalculator("Add create stack", title_sum, title_align);
		meanID_new = getImageID();
		selectWindow(title_sum);
		close();
		selectImage(meanID_new);
		rename("Summed");
		title_sum = getTitle();
		*/
		run("Concatenate...", "  title=ref_aligned image1=" +title_refnew + " image2=" + title_align +" image3=[-- None --]");	 
		title_refnew = getTitle();
		refID_new = getImageID();
		selectImage(refID_new);
		setSlice(nSlices);
		run("Delete Slice");
		setSlice(1);
		selectImage(TS_ID);
		NS = nSlices;
		niter ++;
	}//end while
	title_align = getTitle();
	if(NS < n_sub){
		selectImage(meanID_new);
		run("Make Substack...", "delete slices=1-" +NS);
		meanID_new = getImageID();
		selectWindow(title_sum);
		close();
		selectImage(meanID_new);
		rename("truncated");
		title_sum = getTitle();
		setSlice(nSlices);
		run("Add Slice");
		setSlice(1);
	}
	selectImage(TS_ID);
	setSlice(NS);
	run("Add Slice");
	setSlice(1);
	run("MultiStackReg", "stack_1="+ title_sum+" action_1=[Use as Reference] file_1=[] stack_2="+ title_align + " action_2=[Align to First Stack] transformation=[Rigid Body]");
	run("Concatenate...", "  title=ref_aligned image1=" +title_refnew + " image2=" + title_align +" image3=[-- None --]");	 
	finalID = getImageID();
	setSlice(nSlices);
	run("Delete Slice");

	selectImage(meanID_new);
	close();
	return finalID;
} // end function


macro "LongTS_Registration"{
	run("Close All");
	work_folder = getDirectory("Choose a Directory ");
	flist = getFileList(work_folder);
	
	for(i=0;i<flist.length;i++){
		print(work_folder+flist[i]);	
		path = work_folder+flist[i];
		finalID = Reference_Create(path, 300, 10);		
		saveAs("tiff", work_folder +  "rg_"+ flist[i] );
		close();
		ok = File.delete(work_folder + flist[i]);
	}// end for
	
}// end macro