clc;
clear all;
close all;
warning off all;


[file path]=uigetfile('Images\*.jpg','Select an iris image for enrollment ');
file=strcat(path,file);
I=imread(file);
m = zeros(size(I,1),size(I,2));
m(111:222,123:234) = 1;
I = imresize(I,.5); 
m = imresize(m,.5);         
figure('Name','Input image','Numbertitle','off');
imshow(I);
figure('Name','Segmenting','Numbertitle','off');
seg1 = seg(I, m, 350);
figure('Name','Segmented image','numbertitle','off')
imshow(seg1)

seg=seg1;


cc=bwconncomp(seg);
stats=regionprops(cc,'Centroid');
ct=cat(1,stats.Centroid);


figure('name','Center point detection','numbertitle','off')
imshow(seg)
hold on;

plot(ct(:,1),ct(:,2),'b*')

[x1 y1]=DrawCircle(ct(:,1),ct(:,2), 40, 1000, 'b-');
x=ct(:,1);y=ct(:,2);

figure('name','outer circle coordinates image','numbertitle','off')

% First create the image.
imageSizeY = size(seg,1);
imageSizeX = size(seg,2);
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
centerX = x;
centerY = y;
radius = 40;
circlePixels = (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius.^2;
% circlePixels is a 2D "logical" array.
% Now, display it.
imshow(circlePixels) ;



for i=1:size(seg,1)
    for j=1:size(seg,2)
        if seg(i,j)==1
            im4(i,j)=0;
        else
            im4(i,j)=circlePixels(i,j);
        end
    end
end
figure('name','Circle merged image ','numbertitle','off')
imshow(im4)
for i=1:size(im4,1)
    for j=1:size(im4,2)
        if im4(i,j)==1
            im3(i,j)=I(i,j);
        else
            im3(i,j)=0;
        end
    end
end
figure('name','MBIR format image','numbertitle','off')
imshow(uint8(im3))
[x2 y2]=find(im4==1);

im2=zeros(2,125);
q=1;
for i=1:size(im2,1)
    for j=1:size(im2,2)
        im2(i,j)=im3(x2(q),y2(q));
        q=q+1;
    end
end
im2=imresize(im2,[120 200]);
figure('name','Normalised IRIS template','numbertitle','off')
imshow(uint8(im2))
A1=dct2(mean(im2));
% num=A1(:);
char_in_bit = abs(round(A1'));
% mesage1=readText;
% display(char_in_bit);
ascii_binary = dec2bin(char_in_bit,8);
t1=1;



[file path]=uigetfile('*.*');
I =imread(strcat(path,file));
I=imresize(I,[256 256]);
figure;imshow(I);title('input image');
if size(I,3)>1
    I=rgb2gray(I);
end
LS = liftwave('cdf2.2','Int2Int');
[CA,CH,CV,CD] = lwt2(double(I),LS);
[U,S,V] = svd(CH);
S1=S;
t1=1;
t2=1;
for i=1:128
    for j=1:128
        t2=t2+1;
        if t1>size(ascii_binary,1)
            e(i,j)=S1(i,j);
        else
            if ascii_binary(t1,t2)==0
                if rem(I(1,1),2)~=0
                    e(1,1)=S1(1,1)+1;
                end
            else
                if rem(I(1,1),2)==0
                    e(1,1)=S1(1,1)+1;
                end
            end
        end
        if t2==8
            t1=t1+1;
            t2=1;
        end
    end
end
[U1,S1,V1] = svd(e);
