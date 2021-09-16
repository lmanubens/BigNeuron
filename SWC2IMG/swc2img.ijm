avSNR = 237.9214; 
scalingdt = File.openAsRawString("/Users/linusmg/Desktop/bigneuron/Both_GS_and_auto/SWC2IMG_gold163/scaling_gold.csv",35000);
scalingdtarr = split(scalingdt, "\n");
print(scalingdtarr[0]);
print(scalingdtarr.length)
for (i = 1; i < scalingdtarr.length; i++) {
	filesplit = split(scalingdtarr[i],",");
	//print(filesplit[0]);
	swcfile = replace(filesplit[0], "Data", "Desktop");
	//swcfile = replace(swcfile, "gold_163_all_soma_sort_s1", "gold_163_all_soma_sort_s1_backup");
	swcfile = replace(swcfile, "gold_163_all_soma_sort_s1", "gold_163_all_soma_sort_s1_restim");
	swcfile = replace(swcfile, "home", "Users");
	swcfile = swcfile + "_resampled.swc.radius.swc";
	print(swcfile);
	print("x_y_pix");
	print(filesplit[2]);
	print("z_pix");
	print(filesplit[3]);
	
	print("Generated image will be saved as:");
	swcfilesplit = split(swcfile,"/");
	print(swcfilesplit[7] + ".swc2img.tif");
	File.makeDirectory("/Users/linusmg/Desktop/bigneuron/Both_GS_and_auto/SWC2IMG_gold163/" + filesplit[1]);
	File.copy(swcfile, "/Users/linusmg/Desktop/bigneuron/Both_GS_and_auto/SWC2IMG_gold163/" + filesplit[1] + "/" + swcfilesplit[7]);
	swcfile2 = "/Users/linusmg/Desktop/bigneuron/Both_GS_and_auto/SWC2IMG_gold163/" + filesplit[1] + "/" + swcfilesplit[7];
	//run("SWC2IMG", "file=&swcfile2 lateral=" + filesplit[2] + " axial=" + filesplit[3] + " background=10 correlation=2 snr=" + avSNR + " rescale correct save");
	run("SWC2IMG", "file=&swcfile2 lateral=1 axial=1 background=10 correlation=2 snr=" + avSNR + " rescale correct save");
	//saveAs("/Users/linusmg/Desktop/bigneuron/Both_GS_and_auto/SWC2IMG_gold163/" + filesplit[1] + "/" + swcfilesplit[7] + ".SWC2IMG.tiff");
	//close();
	run("Collect Garbage");
}
//swc = "/Users/linusmg/Desktop/bigneuron/Both_GS_and_auto/gold_163_all_soma_sort_s1_backup/1/00_sorted_GMR_57C10_AD_01-Two_recombinase_flipouts_A-m-A-20111005_5_B5-left_optic_lobe.v3draw.extract_0.v3dpbd.ano_stamp_2015_06_17_11_23.swc"; /*** Update this line to the correct path on your system ***/
//run("SWC2IMG", "file=&swc lateral=0.3 axial=1 background=10 correlation=2 snr=70 display");
//run("Z Project...", "projection=[Max Intensity]");
//setOption("ScaleConversions", true);
//run("8-bit");
//run("Green");