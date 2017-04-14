// This is the phase retrieval pluging written by Dan. 
//
import ij.IJ;
import ij.ImagePlus; // the class of images in IJ
import ij.plugin.filter.PlugInFilter;
import ij.process.*;
import java.awt.*;
import java.io.File;

public class phase_retrieval_ implements PlugIn{
    /*Below are global private variables.
     * The default unit are microns unless otherwise notified.
     */
    private double NA=1.0;
    private double px_size; // The pixel size
    private double obj_fl = 5000; 
    private double nfrac = 1.33; // refractive index 
    private int Niter = 11;
    private int r_mask = 40; // the mask size


    private ImagePlus raw_psf;
    private ImagePlus masked_psf;
    private Imageplus pupil;

    public void core(String psf_stack){
        /*The goals of this function: read the psf_stack from the path. ()
         *
        */

    }// end public void core


    public void run(){
    }// end public void run


    public int retrieve(ImagePlus)


    private void add_mask(double [][] raw_frame, double [][] msk_frame){
    }//end private void add_mask


}

