// This is the very first plugin written by Dan. :)
//
//
import ij.*;
import ij.plugin.filter.PlugInFilter;
import ij.process.*;
import java.awt.*;

public class Toy_plugin_ implements PlugInFilter{
    public int setup(String arg, ImagePlus imp){
        if (arg.equals("about"))
            {showAbout(); return DONE;}
        return DOES_8G+DOES_STACKS+SUPPORTS_MASKING;

    }//end public int setup

    public void run(ImageProcessor ip){
        byte [] pixels = (byte [])ip.getPixels();
        int width = ip.getWidth();
        Rectangle r = ip.getRoi();

        int offset, i;
        for (int y=r.y;y<(r.y+r.height);y++){
            offset = y*width;
            for (int x=r.x; x<(r.x+r.width); x++){
                i = offset + x;
                pixels[i] = (byte)(255-pixels[i]);
            }//end for inner 
        }//end for outer
    }//end public void run

    void showAbout(){
        IJ.showMessage("About Inverter...",
                "This sample plugin filter inverts 8-bit images. Look \n" + 
                "at the Inverter_.java source file to see how easy it is\n");
    }//end void showAbout

    


}
