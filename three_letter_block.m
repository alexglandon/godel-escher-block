letters = cell(1,3);
letters{1} = 'R';
letters{2} = 'A';
letters{3} = 'K';


%for each deposition layer

granularity = 0.005;
locations = 0:granularity:1;

dimension = length(locations);

letter_matrix = cell(1,3);
for letter_index = 1:3

    letter_matrix{letter_index} = insertText(zeros(200,200),[0,0],letters{letter_index},'Font','Arial Black','TextColor','white','BoxColor','black','FontSize',100);
    letter_matrix{letter_index} = double(letter_matrix{letter_index}(:,:,1) > 0);
    [letter_rows, letter_cols] = ind2sub(size(letter_matrix{letter_index}),find(letter_matrix{letter_index}(:)));
    letter_start_row = min(letter_rows);
    letter_end_row = max(letter_rows);
    letter_start_col = min(letter_cols);
    letter_end_col = max(letter_cols);
    letter_matrix{letter_index} = letter_matrix{letter_index}(letter_start_row:letter_end_row, letter_start_col:letter_end_col);
    letter_matrix{letter_index} = imresize(letter_matrix{letter_index},[dimension,dimension]);
end

figure(1)
subplot(1,3,1);
imshow(letter_matrix{1});
subplot(1,3,2);
imshow(letter_matrix{2});
subplot(1,3,3);
imshow(letter_matrix{3});


block = zeros(dimension,dimension,dimension);
cloud = zeros(0,3);
for height = 1:dimension
    for width = 1:dimension
        for depth = 1:dimension
            o_row = dimension-height+1;
            o_col = width;
            o_min_row=max(1,o_row-1);
            o_max_row=min(o_row+1,dimension);
            o_min_col=max(1,o_col-1);
            o_max_col=min(o_col+1,dimension);

            d_row = depth;
            d_col = height;
            d_min_row=max(1,d_row-1);
            d_max_row=min(d_row+1,dimension);
            d_min_col=max(1,d_col-1);
            d_max_col=min(d_col+1,dimension);

            u_row = depth;
            u_col = dimension-width+1;
            u_min_row=max(1,u_row-1);
            u_max_row=min(u_row+1,dimension);
            u_min_col=max(1,u_col-1);
            u_max_col=min(u_col+1,dimension);
            if ...
                    letter_matrix{1}(dimension-height+1,width) && ...
                    letter_matrix{2}(depth,height) && ...
                    letter_matrix{3}(depth,dimension-width+1)
                
                if ...
                    numel(find(letter_matrix{1}(o_min_row:o_max_row,o_min_col:o_max_col)))<9 || ...
                    numel(find(letter_matrix{2}(d_min_row:d_max_row,d_min_col:d_max_col)))<9 || ...
                    numel(find(letter_matrix{3}(u_min_row:u_max_row,u_min_col:u_max_col)))<9

%                 block(height,width,depth) = 1;
                cloud(end+1,:) = [depth*granularity,1-width*granularity,height*granularity]; %#ok<SAGROW>
                end
            end

        end
    end
end

%figure(2);
%scatter3(cloud(:,1),cloud(:,2),cloud(:,3));
%axis('equal')


fileID = fopen('block.ply','w');
fprintf(fileID,'ply\n');
fprintf(fileID,'format ascii 1.0\n');
fprintf(fileID,'element vertex %d\n',length(cloud));
fprintf(fileID,'property float x\n');
fprintf(fileID,'property float y\n');
fprintf(fileID,'property float z\n');
fprintf(fileID,'end_header\n');
for i = 1:length(cloud)
    fprintf(fileID,'%f %f %f\n',cloud(i,1),cloud(i,2),cloud(i,3));
end
fclose(fileID);

%meshlab
%import .ply file
%filter->sampling->poisson disk sampling (base mesh subsampling)
%filter->normals->computer normals for point set
%filter->remeshing->surface ball pivoting
