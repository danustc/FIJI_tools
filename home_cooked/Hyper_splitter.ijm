/**
 * Batch Hyperstack Image Splitter
 *
 * Description:
 * An ImageJ macro that splits a batch of hyperstack image files in the format of (x,y,c,z,t). 
 * To use it, install the LOCI plugin first, then simply select a single image or a folder 
 * with all image files under this folder will be automatically split and the extracted stacks
 * will be saved under the same folder.
 * For large stacks, 64-bit of ImageJ as well as >3GB memory might be necessary.
 *
 * Input:
 * A list of hyperstacks
 * Output:
 * Splitted 3D or 4D stacks with new file names indicating the channel # and timepoint #
 *
 * Author: Yu, Gu; Hongyu Miao
 * Department of Biostatistics and Computational Biology
 * University of Rochester, School of Medicine and Dentistry
 * Sep 26, 2011
 */
 
macro "Batch Hyperstack Splitter" {
	//close all unrelated images
	if (nImages!=0)
	exit("Please close all opened images first.");
	
	// User options
	//Dialog.create("Batch Hyperstack Splitter Options");
	//Dialog.addCheckbox("Split by channels",false);
	//Dialog.addCheckbox("Split by timepoints",false);
	//Dialog.addCheckbox("Split a single image",false);
	//Dialog.show();
	
	//Get user input of options
	//cOption = Dialog.getCheckbox;
	//tOption = Dialog.getCheckbox;
	//sImage  = Dialog.getCheckbox;
	cOption=0;
	tOption=1;
	cOP="";
	tOP="split_timepoints";
	//Transform user options into macro parameters
	//if (cOption==1){cOP="split_channels";} else {cOP="";}
	//if (tOption==1){tOP="split_timepoints";} else {tOP="";}
	//if (cOption==0 && tOption==0) {
		//exit("No change in original image");
	//} 
	//else {

			dir = getDirectory("Choose a Directory ");
			run("Bio-Formats Macro Extensions");
			list = getFileList(dir); // An array containing the names of the files (hyperstacks).
			print(list.length);
			// Batch split
			for (i=0; i<list.length; i++) {
				//need to check exception
				print(dir);
				path = dir + list[i];
				Ext.setId(path);
				dimOrder="";
				Ext.getDimensionOrder(dimOrder); 
				
				options="open=["+path+"] view=[Standard ImageJ] stack_order="+dimOrder+" " +cOP+" "+tOP+" autoscale";
				run("Bio-Formats Importer",options);
				
				numOfImages = nImages;
				print(nImages);
				//close();
				// Save and close the splitted substacks
				for(k=0; k<numOfImages; k++){
					title = getTitle();
					print(title);
					saveAs("tiff",dir+title);
					close();
				}// end for  	
				

				Ext.close();
			 }// end for i < list.length
			 
			 while (nImages>0) { 
          		selectImage(nImages); 
          		print("closed");
         	 close(); 
     		 } 
			for(i=0;i<list.length;i++){
				print(dir+list[i]);	
				ok = File.delete(dir+list[i]);
			}
}
	
