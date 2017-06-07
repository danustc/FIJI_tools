/*
 * Runs MultistackRegistration macro. 
 */

function TS_loc_ZD(ZDstack_ID, TSstack_ID, fpath, fname){
	/*
	 * Assume that the substack has been made
	 */
	selectImage(ZDstack_ID); //activate the reference stack
	title_ref = getTitle(); // get the reference of the title
	print("reference title:", title_ref);
	selectImage(TSstack_ID);
	title_align = getTitle(); // get the reference of the cov image title
	print("to be aligned:", title_align);
	run("MultiStackReg", "stack_1="+ title_ref+" action_1=[Use as Reference] file_1=[] stack_2="+ title_align + " action_2=[Align to First Stack] file_2="+fpath + fname+" transformation=[Affine] save");	
	//run("MultiStackReg", "stack_1=ts_dup.tif action_1=[Use as Reference] file_1=[] stack_2=ts_dup_trans.tif action_2=[Align to First Stack] file_2=[] transformation=[Rigid Body] save");
	print("OK I finished!");
}

function fname_number_parsing(fname, delim){
	// parse the name from a file name.
	fhead = split(fname, delim);
	lf = fhead.length;
	nf = parseInt(fhead[lf-1]);
	return nf;
}// fname_number_parsing 


// processing the alignment 

macro "MultiStack_save_info"{
	run("Close All");
	work_folder = getDirectory("Choose a Directory ");
	flist = getFileList(work_folder);
	// iterate through the list of files.
	TS_path = ""; // Initialize an empty path
	n_TS_folder = 0;
	for(i=0;i<flist.length;i++){
		print(work_folder+flist[i]);	
		path = work_folder+flist[i];
		if (endsWith(flist[i], '/' )){ // if is a directory
			TS_path = path;
			n_TS_folder++;
		} // find the subfolder containing the processed data
		else if (endsWith(flist[i], ".tif")){
			open(path);
			ZD_ID = getImageID();
			print("Z-stack:",ZD_ID);
		} // end 
	}// end for

	if (n_TS_folder ==1){
		// the processed data folder is found
		ZP_list = getFileList(TS_path); // get all the ZP
		for(j=0;j< ZP_list.length;j++){
			if (endsWith(ZP_list[j], ".tif")){
				ZP_path = TS_path+ ZP_list[j];
				ZP_name = split(ZP_list[j], '.');
				print(ZP_name[0]);
				nZ_TS = fname_number_parsing(ZP_name[0], '_'); // the Z number in the TS stack
				print(nZ_TS);		// Finally the last part extracted.	
				open(ZP_path); // open the figure 
				TS_ID = getImageID();
				zstep_number =4; // the z step between two adjacent slices.
				nZ_ZD = nZ_TS*zstep_number;
				zrange = zstep_number/2; // The uncertainty within z slice. 
				// redetermine the ZP-cut range

				
				if(nZ_ZD>zrange){
					// the z-range does not exceed the ZD stack boundary 
					z_start = nZ_ZD-zrange;
				}
				else{
					z_start = 1;
				} // set the starting point

				selectImage(ZD_ID);
				if(nZ_ZD<nSlices - zrange){
					z_end = nZ_ZD+zrange;				
				}
				else{
					z_end = nSlices;
				}
				print("z_start:", z_start);
				print("z_end:", z_end);

				selectImage(ZD_ID);
				run("Make Substack..."," slices="+ z_start + "-" + z_end);
				subZD_id = getImageID();
				rename('ZD_sub');
				nTrunc = nSlices; // 
				selectImage(TS_ID);
				run("Make Substack..."," slices=1-"+nTrunc);
				subTS_id = getImageID();
				rename('TS_sub');
				fname = "TS2ZD_"+toString(nZ_TS)+".txt";
				TS_loc_ZD(subZD_id,subTS_id, work_folder, fname);
				selectImage(subZD_id);
				close();
				selectImage(subTS_id);
				close();
				selectImage(TS_ID);
				close();
			}// end if
			
		}// end for
		
	}// end if


	run("Close All");
} //end Macro