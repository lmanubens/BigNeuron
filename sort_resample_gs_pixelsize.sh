#for D in `find . -type d`
for D in `ls gold_163_all_soma_sort_s1_pixelsize/`
do
    I1="gold_163_all_soma_sort_s1_pixelsize/$D/"*resampled.swc
    vaa3d -x sort_neuron_swc_lmg -f sort_swc_lmg -i $I1
done
