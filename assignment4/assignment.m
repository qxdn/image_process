clear all;
close all;

%% 读取图像
img = imread('作业4图像1.tif');
figure(1);
subplot(221);imshow(img);title('原始图像');
% 直方图均衡化 高对比度
J = histeq(img);
subplot(222);imshow(J);title('直方图均衡化后');
% 二值化图像
img_bw = imbinarize(J);
subplot(223);imshow(img_bw);title('二值化后图像');
% 寻找边界
img_edge = edge(img_bw);%寻找二值图像的边界
se1=strel('square',13);%方型结构元素
BW=imclose(img_edge,se1);%闭运算去除干扰
A1 = bwmorph(BW,'hbreak',10);%将不同连通域断开连接
BW1 = bwareaopen(A1, 30000);%将连通体面积小于30000的部分删除，去除杂散点
se2=strel('disk',5);
A2=imerode(BW1,se2);%将相连的连通体断开
BW2 = bwareaopen(A2, 10000);%将连通体面积小于10000的部分删除，去除杂散点
se3=strel('disk',6);
A3=imdilate(BW2,se3);%膨胀操作恢复原来联通体大小
subplot(224),imshow(A3);title('提取出的芯片区域')
%将芯片区域用矩形画出并显示
st = regionprops(A3, 'BoundingBox', 'Area' );
[maxArea, indexOfMax] = max([st.Area]);
rectangle('Position',.....
    [st(indexOfMax).BoundingBox(1),st(indexOfMax).BoundingBox(2),st(indexOfMax).BoundingBox(3),st(indexOfMax).BoundingBox(4)],......
    'EdgeColor','r','LineWidth',2)
figure(2)
subplot(221),imshow(img);title('芯片所在位置');

rectangle('Position',.....
    [st(indexOfMax).BoundingBox(1),st(indexOfMax).BoundingBox(2),st(indexOfMax).BoundingBox(3),st(indexOfMax).BoundingBox(4)],......
    'EdgeColor','r','LineWidth',2)

crop_img = imcrop(img, [st.BoundingBox]);

se4=strel('disk',20);
A4=imdilate(BW2,se4);%膨胀操作恢复原来联通体大小
crop_A4 = imcrop(A4, [st.BoundingBox]);

subplot(222),imshow(crop_img);title('原图ROI裁剪');

img_enhance = adapthisteq(crop_img);
subplot(223),imshow(img_enhance);title('裁剪ROI增强对比度');



img_enhance = imadjust(img_enhance,[],[],0.7);

subplot(224);imshow(img_enhance);title('增强对比度后Gama矫正');
%% 寻找阳性点、阴性点
% 开始计算阳性点数目
[m,n] = size(img_enhance);
chip_pad = padarray(img_enhance,[1 1],0,'both');
mean_value = mean(img_enhance(:));
bright_num = 0;
dark_num = 0;
%防止领域内有其他值重复识别
point_map = zeros(m,n);

figure(3)
subplot(1,2,1),imshow(img_enhance),title('原图')
subplot(1,2,2),imshow(img_enhance),title('红色：阳性点，蓝色：阴性点')
hold on 
%利用循环筛选阳性点和阴性点
for i = 3:m-3
    for j = 3:n-3
        %寻找阳性点
        if (img_enhance(i,j)>34000) && (img_enhance(i,j)<50000)
            if ismember(1,point_map(i-2:i+2,j-2:j+2)) || ismember(-1,point_map(i-2:i+2,j-2:j+2))
                continue;
            end
            temp = reshape(chip_pad(i-1:i+1,j-1:j+1),1,[]);
            temp = sort(temp,'descend');
            if img_enhance(i,j) > temp(3) 
                if  j > n/2
                   if (mean(chip_pad(i-2:i+2,j-2:j+2))<1.5*mean_value)
                       plot(j, i,'r.')
                       bright_num = bright_num + 1;
                       point_map(i,j) = 1;
                   end
                else
                    plot(j, i,'r.')
                    bright_num = bright_num + 1;
                    point_map(i,j) = 1;
                    
                end
            end
        end
        %寻找阴性点
        if (img_enhance(i,j)>10000) && (img_enhance(i,j)<25000) 
            if ismember(-1,point_map(i-2:i+2,j-2:j+2)) || ismember(1,point_map(i-2:i+2,j-2:j+2))
                continue;
            end
            temp = reshape(chip_pad(i-1:i+1,j-1:j+1),1,[]);
            temp = sort(temp,'descend');
            if img_enhance(i,j) > temp(3) && ((temp(1)-temp(9))>4000)
                if (mean(chip_pad(i-1:i+1,j-1:j+1))>11000)
                    plot(j, i,'b.')
                    dark_num = dark_num +1;
                    point_map(i,j) = -1;
                end
            end
        end
                    
    end
end
hold off

str1=['阳性点个数=' num2str(bright_num)];
disp(str1);
str2=['阴性点个数=' num2str(dark_num)];
disp(str2);