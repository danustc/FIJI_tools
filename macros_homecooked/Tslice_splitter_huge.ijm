function Merge_stacks(path, name_flag, nfile){
	// merge all the data files with the same name_flag.
	options="open=["+path+"] number=" +nfile +" starting=1 increment=1 scale=100 file=" +name_flag+" or=[] sort";
	run("Image Sequence...",options);
	title_merge = getTitle();
	merge_ID = getImageID();
	return merge_ID;
}



macro "Tslice_splitter" {
	// Using substack function. 
	run("Close All");
	nMed=getNumber("Slices per stack", 26);
	n_groups = 4;
	print(nMed);
	dir = getDirectory("Choose a Directory ");
	list = getFileList(dir); // An array containing the names of the files (hyperstacks).
	dirName = File.getName(dir); 
	print(dirName);
	print("Number of files", list.length);
	p_groups = parseInt(list.length/n_groups) +1;
	print("Number of files per group:", p_groups);
	nstart = 1;
	path=dir+list[0];
	residue_ID = 1; // Initialize residue_ID

	for(ord_group = 0; ord_group < n_groups; ord_group ++){
		nZmx=nMed;
		print("start from:", nstart);
		options="open=["+path+"] number=" +p_groups +" starting=" + nstart+" increment=1 scale=100 file=MM or=[] sort";
		run("Image Sequence...",options);
		title_sequence = getTitle();
		if(residue_ID <0){
			selectImage(residue_ID);
			title_res = getTitle();
			run("Concatenate...", "  title=Full_sequence image1="+ title_res +" image2=" + title_sequence+" image3=[-- None --]");
		}
		
		NS=nSlices;
		original_ID = getImageID();
	

		NTS = floor(NS/nMed);
		print("Number of time points:", NTS);
		n_kept = NTS*nMed;
		n_left = NS-n_kept;
		print("Number of slices left",n_left);

		if(n_left>0){
			run("Make Substack...","delete slices=" + n_kept+1 + "-" + NS); 
			residue_ID = getImageID();
			print("Residue ID:", residue_ID);
			rename("MMResidue");
		}//endif
		else{
			print("No residues at this point!");
			residue_ID = 0;  
		}
	
	//while
		nCount = 0;
		print("original_ID:", original_ID);
		selectImage(original_ID);
		NS = nSlices;
		print(NS);
		
		while(nZmx>1){
			print(NS);
			run("Make Substack...","delete slices=1-"+NS+ "-" + nZmx); 
			//title=getTitle();
			title = dirName+"_ZP_"+nCount + "_" + ord_group;
			print(title);
			saveAs("tiff",dir+title);
			close();
			selectImage(original_ID);
			NS = nSlices;
			nCount++;
			nZmx--;
		} // end while	
		if(NS>0){
			title = dirName+"_ZP_"+nCount + "_" + ord_group;
			saveAs("tiff", dir+title);
			close();
		}//endif
		nstart +=p_groups;
	} // end for

	for(i=0;i<nMed;i++){
			merge_ID = Merge_stacks(dir, "_ZP_"+i, n_groups);
			selectImage(merge_ID);
			title = dirName + "_ZP_"+i;
			saveAs("tiff", dir+title);
			close();
			for(k=0; k<n_groups; k++){
				ok = File.delete(dir+title+'_'+k+".tif");
			}
	}	// end for
	
		
	/*for(i=0;i<list.length;i++){
			print(dir+list[i]);	
			ok = File.delete(dir+list[i]);
	}	// end for
	*/
}

