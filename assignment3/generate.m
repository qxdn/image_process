clear all;
close all;

pixel = 40;
J = (checkerboard(pixel,4,6)>0.5);
figure, imshow(J);