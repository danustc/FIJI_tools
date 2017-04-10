macro "Cross_align" {
	// Using substack function. 
	// Cross align one stack to another 
	run("Close All");
	print("Open a reference image:")
	open(); // 
	z_step = getNumber("Z step in the reference image", 1.0); // get the reference number 
	title_ref = getTitle();
	ref_image_ID = getImageID();
	print("The reference image ID is:", ref_image_ID);
	
	print("The reference image title is:", title_ref);
	print("Z step in the reference image:", z_step);
	dir_ts = getDirectory("Choose a directory containing the associated time-series stacks");
	list = getFileList(dir_ts); // An array containing the names of the files (hyperstacks).
	dirName = File.getName(dir_ts); 
	print(dirName);
	print(list.length);
	z_ts = getNumber("Z step in the time series", 4.0);
	print("Z step in the time series:", z_ts);
	for(i=0;i<list.length;i++){
		path = dir_ts+list[i];
		string_parts = split(list[i], "_");
		ts_tail = string_parts[string_parts.length-1];	
		ts_strip = split(ts_tail, ".");
		ts_number = parseInt(ts_strip[0]); // This only applies to the strings which contains "_<number>.tif". Really awkward.
		print("Time series number:", ts_number);
		
		if(isNaN(ts_number)){ 
			print("Error! The image is not a TS series.")
		}// end if 
		else{
			open(path); // open the image stack
			z_identify = ts_number * z_ts; 
			title_ts = getTitle();
			ts_image_ID = getImageID();
			selectImage(ref_image_ID);
			if(ts_number == 0){
				z_start = z_identify+1;
			}// endif
			else{
				z_start = z_identify - parseInt(z_ts/z_step)+1; 
			}//end else
			if(z_identify == nSlices-1 ){
				z_end = nSlices;
			}//end if 
			else{
				z_end = z_identify + parseInt(z_ts/z_step);
			}
			
			run("Make Substack..."," slices="+ z_start + "-" + z_end);
			title_subZD = "ZD_"+ts_number;  
			subZD_image_ID = getImageID(); // get the ID of the substack; 
			selectImage(ref_image_ID);
			close();
			//run("Make Substack...","delete slices=1-"+nSlices + "-" + nZmx); 
			selectImage(ts_image_ID);
			startNum = getNumber("Enter the starting slice in the t series:", 3);
			avgNum = getNumber("Enter the number of averages:", 3);
			run("Make Substack..."," slices=" + startNum + "-" + startNum+avgNum);
			title_subTS = "TS_"+ts_number;
			subTS_image_ID = getImageID();
			
			selectImage(ts_image_ID);
			close();
			/* Now, align the slice in TS to the substack of the ZD stack
			 *  
			 */

			selectImage(subZD_image_ID);
			rename(title_subZD); // Renamed title_subZD
			selectImage(subTS_image_ID);
			rename(title_subTS);

			
		}//end else
		
	} //end for	

