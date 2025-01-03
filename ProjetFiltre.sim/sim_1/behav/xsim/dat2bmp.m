pkg load image
data = load('Lena128x128g_8bits_r.dat');

d = mat2gray(bin2dec(num2str(data)));
im = reshape(d, 3,3)';
imwrite(im, 'output.bmp');

figure 1
imshow(im);


figure 2

data = load('Lena128x128g_8bits.dat');

w = 128;
h = 128;

d = mat2gray(bin2dec(num2str(data)));
im = reshape(d, w,h)';
imshow(im);