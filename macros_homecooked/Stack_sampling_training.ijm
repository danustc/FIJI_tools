// This macro splits the stack 

function stack_sampling(tif_ID, n_sample, fish_name){
	selectImage(tif_ID);
	dirname = getDirectory("image");
	for(ir = 0; ir<n_sample; ir++){
		// takeout a slice from the stack and save it as a mask
		selectImage(tif_ID);
		z_sample = parseInt(floor(random()*nSlices));
		print(z_sample); 
		run("Make Substack...", "delete slices=" + z_sample);
		zs_ID = getImageID();
		saveAs("tiff", dirname+ fish_name + "_" + ir);
		close();
	}
	close();
}// end 

macro "Stack_sampling_"{
	run("Close All");
	open();
	fishID = getString("Please Type in the fish ID:", "");
	tif_ID = getImageID();
	stack_sampling(tif_ID, 50, fishID);
	
}// end macro
