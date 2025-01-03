pkg load image

w = 128;
h = 128;

% AFFICHAGE OUTPUT MOYENNEUR
data = load('Lena128x128g_8bits_r.dat');
d = mat2gray(bin2dec(num2str(data)));
im = reshape(d, w,h)';
imwrite(im, 'output.bmp');

subplot(1, 3, 1)
imshow(im);
title('Filtre en VHDL')

% AFFICHAGE FILTRE MATALB DE L'IMAGE ORIGINALE

data = load('Lena128x128g_8bits.dat');
d = mat2gray(bin2dec(num2str(data)));
imorign = reshape(d, w,h)';

kernel = fspecial('average', [3 3]);
im2 = imfilter(imorign, kernel);

subplot(1, 3, 2)
imshow(im2);
title('Filtre Matlab')

subplot(1, 3, 3)
imshow(imorign);
title('Image originale')
