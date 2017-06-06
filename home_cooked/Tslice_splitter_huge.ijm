macro "Tslice_splitter" {
	// Using substack function. 
	run("Close All");
	nMed=getNumber("Slices per stack", 26);
	n_groups = 4;
	nZmx=nMed;
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
		
		options="open=["+path+"] number=" +p_groups +" starting=" + nstart+" increment=1 scale=100 file=MM or=[] sort";
		run("Image Sequence...",options);
		title_sequence = getTitle();
		if(residue_ID <0){
			selectImage(residue_ID);
			title_res = getTitle();
			run("Concatenate...", "  title=Full_sequence image1=]"+ title_res +" image2=" + title_sequence+" image3=[-- None --]");
		}
		
		NS=nSlices;
		original_ID = getImageID();
	

		NTS = parseInt(NS/nMed)-1;
		print("Number of time points:", NTS);
		n_kept = NTS*nMed;
		n_left = NS-n_kept;
		print("Number of slices left",n_left);

		if(n_left>0){
			run("Make Substack...","delete slices=" + n_kept+1 + "-" + NS); 
			residue_ID = getImageID();
			print("Residue ID:", residue_ID);
			title = "MMResidue";
		}//endif
	
	
	//while
		nCount = 0;
		print(original_ID);
		selectImage(original_ID);
		
		while(nZmx>1){
			run("Make Substack...","delete slices=1-"+nSlices + "-" + nZmx); 
			//title=getTitle();
			title = dirName+"_ZP_"+nCount + "_" + ord_group;
			print(title);
			saveAs("tiff",dir+title);
			close();
			NS=nSlices;
			print(NS);
			nCount++;
			nZmx--;
		} // end while	
		if(nSlices>0){
			title = dirName+"_ZP_"+nCount + "_" + ord_group;
			saveAs("tiff", dir+title);
			close();
		}
		nstart +=p_groups;

		
	/*for(i=0;i<list.length;i++){
			print(dir+list[i]);	
	*/		ok = File.delete(dir+list[i]);
	}	// end for
	close();
}

