RGB = imread('crop.jpg');
figure 
imshow(RGB)


grayImage = rgb2gray(RGB);


binaryImage = grayImage < 128;
% Remove small blobs;


binaryImage = bwareaopen(binaryImage,0);
% Skeletonize
skeletonImage = bwmorph(binaryImage, 'skel', inf);



j = skeletonImage;

RGB = double(cat(3,j,j,j));


horizontalProfile = sum(double(RGB), 1);  % double may not be required - not sure.
logicalSpaceIndexes = horizontalProfile <= 1;

[x,y]=size(RGB);
x
y
% t = RGB;
% for i = 1:x
%     prev = 0;
%     for j = 1:y
%         if logicalSpaceIndexes(j) == 1
%             t(i, j) = 1;
%         end
%     end
% end
% figure
% imshow(t)

for i = 1:x
    prev = 0;
    prevmid = 0;
    flag = 0;
    for j = 1:round(y/3)
        if logicalSpaceIndexes(j) == 1 && flag==0
            flag = 1;
            prev = j;
        end
        if logicalSpaceIndexes(j) == 0 && flag==1
            flag = 0;
            mid = round((prev+j)/2);
            if abs(prev-j)>8 && abs(prevmid-mid)>60
                RGB(i, mid, 1) = 1; 
                prevmid = mid;
            end
        end
    end
end
figure
imshow(RGB)