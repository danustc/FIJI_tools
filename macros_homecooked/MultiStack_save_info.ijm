/*
 * Runs MultistackRegistration macro. 
 */

//Specify the first stack 
function slice_2_stack(refstack_ID, slice_ID, fpath){
	selectImage(refstack_ID); //activate the reference stack
	title_ref = getTitle(); // get the reference of the title
	print("reference title:", title_ref);
	selectImage(slice_ID);
	title_align = getTitle(); // get the reference of the cov image title
	print("to be aligned:", title_align);
	run("MultiStackReg", "stack_1="+ title_ref+" action_1=[Use as Reference] file_1=[] stack_2="+ title_align + " action_2=[Align to First Stack] file_2="+fpath +"dup2loc.txt transformation=[Rigid Body] save");	
	//run("MultiStackReg", "stack_1=ts_dup.tif action_1=[Use as Reference] file_1=[] stack_2=ts_dup_trans.tif action_2=[Align to First Stack] file_2=[] transformation=[Rigid Body] save");
	print("OK I finished!")
	return;
}


run("Close All");
work_folder = "/home/sillycat/Programming/Python/Image_toolbox/data_test/";
slice_1 = "loc.tif";
slice_2 = "ts_dup.tif";

open(work_folder+slice_1);
ref_ID = getImageID();
open(work_folder+slice_2);
align_ID = getImageID();

slice_2_stack(ref_ID,align_ID, work_folder);
close();
close();