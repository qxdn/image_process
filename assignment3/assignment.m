close all;
clear all;

%作业图 Sample1 2 3
img = imread('Sample3.bmp');
[h,w,c] = size(img);
OUT = uint8(zeros(size(img)));
% 通过网关法获取的 获取见test2.m
a1 =[53.404593001665960,0.837153049594800,-0.260679390543970,7.064390717316536e-04];
a2 =[1.197321607897413e+02,-0.347230769324406,0.804619001476134,5.396141899079825e-04];
for rgb = 1:c
    for i = 1:w
        for j = 1:h
            % 灰度邻近法
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