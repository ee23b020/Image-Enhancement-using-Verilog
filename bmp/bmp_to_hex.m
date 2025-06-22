b=imread("input_image.bmp"); %input image

k=1;
for i=1:833 % image data is written row by row
    for j=1:1280
          a(k)=b(i,j,1);          %R value
          a(k+1)=b(i,j,2);        %G value
          a(k+2)=b(i,j,3);        %B value
k=k+3;
end
end
fid = fopen("input_image.hex", 'wt');
fprintf(fid, '%x\n', a);
disp('Text file write done');disp(' ');
fclose(fid);
