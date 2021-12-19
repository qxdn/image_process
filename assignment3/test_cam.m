close all;
clear all;

% 使用相机程序 作业图见assignment.m
img = imread('test0.bmp');
% 尺寸
[h,w,c] = size(img);
OUT = uint8(zeros(size(img)));
% 通过网关法获取的 见test.m
a1 =[59.812327514411740,0.889138279864561,-0.229939047720916,4.889340975140624e-04];
a2 =[-2.272024670281924e+02,0.748010196072295,1.458926995779197,-0.001598878564683];
for rgb = 1:c
    for i = 1:w
        for j = 1:h
            % 邻近法
            x = round(fixfun(a1,[i,j]));
            y = round(fixfun(a2,[i,j]));
            if(x>=1&&x<=w&&y>=1&&y<=h)
                OUT(j,i,rgb) = img(y,x,rgb);
            end
        end
    end
end
% 显示图
%imshow(OUT);
figure; imshowpair(img,OUT,'montage');
title('原图 (左) vs. 矫正 (右)');

