function Substack_splitter(IM_ID,ns_substack){
	/*
	 * Open an image stack specified by the file path, then just take out the nth slice.
	 */
	 selectImage(IM_ID);
	 NS = nSlices;
	 n_splits = parseInt(NS/ns_substack)+1; // the number of substacks 
	 im_flags = newArray(n_splits); // initialize a new array to save image IDs
	 ii = 0;
	 while(NS>ns_substack){
	 	run("Make Substack...","delete slices=1-"+ns_substack); 
	 	rename("Sub"+ii);
	 	im_flags[ii] = getImageID(); // Save the image ID of the substacks.
	 	selectImage(IM_ID);
	 	ii++;
	 }//end while

	 
	 open(fpath, nslice);
	 slice_ID = getImageID();
	 return slice_ID;
} // done with substack_splitter 


function Stack_interlacer(ID_dest, ID_enter){
	// interlace one image to another 
	// Assume: number of dest stack is equal or larger than number of enter stack.
	
	selectImage(ID_dest);
	ns_dest = nSlices;
	selectImage(ID_enter);
	ns_enter = nSlices;
	n_ratio = parseInt(ns_dest/ns_enter);
	print("n_ratio:", n_ratio);
	substack_flags = newArray(ns_enter);
	ii=0;

	while(ns_dest>n_ratio){
		selectImage(ID_dest);
		run("Make Substack...", "delete slices=1-"+n_ratio);
		subID_dest = getImageID();	
		selectImage(subID_dest);
		rename("sub_dest");
		
		selectImage(ID_enter);
		run("Make Substack...", "delete slices=1-1");
		subID_enter = getImageID();
		selectImage(subID_enter);
		rename("sub_enter");
		run("Concatenate...", " title=substack_"+ii+" image1=sub_dest  image2=sub_enter image3=[-- None --]");
		ii++;
		substack_flags[ii] = getImageID(); // save this substack flags
		selectImage(ID_dest);
		ns_dest = nSlices;
	};// end while  

	close();
	selectImage(ID_enter);
	close();
		
	return substack_flags;	
}// end function Stack interlacer

run("Close All");
filelist = getArgument();
files = split(filelist, '#');
print("Arguments are:", files[0], files[1]);

open(files[0]);
ID_dest = getImageID();
open(files[1]);
ID_enter = getImageID();


substack_flags = Stack_interlacer(ID_dest,ID_enter); // split the merged stack into small stacks. Then 

