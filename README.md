# godel-escher-block
for printing 3D blocks with arbitrary letters in the style of the Godel Escher Bach book cover


# requirements

matlab (tested)

octave with 'image' package (not tested)


# workflow

1) edit lines 2-4 in three_letter_block.m to your letters of choice (for example 'G', 'E', and 'B')

2) run three_letter_block.m in matlab
   (uncomment line 81-82 to preview the 3D block: "scatter3(cloud(:,1),cloud(:,2),cloud(:,3)); axis style equal"

3) the matlab should now have generated "block.ply"

4) in meshlab import block.ply file

5) in meshlab filter->sampling->poisson disk sampling (check base mesh subsampling option)

6) in meshlab filter->normals->computer normals for point set

7) in meshlab filter->remeshing->surface ball pivoting
