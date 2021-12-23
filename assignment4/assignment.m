clear all;
close all;

%% ��ȡͼ��
img = imread('��ҵ4ͼ��1.tif');
figure(1);
subplot(221);imshow(img);title('ԭʼͼ��');
% ֱ��ͼ���⻯ �߶Աȶ�
J = histeq(img);
subplot(222);imshow(J);title('ֱ��ͼ���⻯��');
% ��ֵ��ͼ��
img_bw = imbinarize(J);
subplot(223);imshow(img_bw);title('��ֵ����ͼ��');
% Ѱ�ұ߽�
img_edge = edge(img_bw);%Ѱ�Ҷ�ֵͼ��ı߽�
se1=strel('square',13);%���ͽṹԪ��
BW=imclose(img_edge,se1);%������ȥ������
A1 = bwmorph(BW,'hbreak',10);%����ͬ��ͨ��Ͽ�����
BW1 = bwareaopen(A1, 30000);%����ͨ�����С��30000�Ĳ���ɾ����ȥ����ɢ��
se2=strel('disk',5);
A2=imerode(BW1,se2);%����������ͨ��Ͽ�
BW2 = bwareaopen(A2, 10000);%����ͨ�����С��10000�Ĳ���ɾ����ȥ����ɢ��
se3=strel('disk',6);
A3=imdilate(BW2,se3);%���Ͳ����ָ�ԭ����ͨ���С
subplot(224),imshow(A3);title('��ȡ����оƬ����')
%��оƬ�����þ��λ�������ʾ
st = regionprops(A3, 'BoundingBox', 'Area' );
[maxArea, indexOfMax] = max([st.Area]);
rectangle('Position',.....
    [st(indexOfMax).BoundingBox(1),st(indexOfMax).BoundingBox(2),st(indexOfMax).BoundingBox(3),st(indexOfMax).BoundingBox(4)],......
    'EdgeColor','r','LineWidth',2)
figure(2)
subplot(221),imshow(img);title('оƬ����λ��');

rectangle('Position',.....
    [st(indexOfMax).BoundingBox(1),st(indexOfMax).BoundingBox(2),st(indexOfMax).BoundingBox(3),st(indexOfMax).BoundingBox(4)],......
    'EdgeColor','r','LineWidth',2)

crop_img = imcrop(img, [st.BoundingBox]);

se4=strel('disk',20);
A4=imdilate(BW2,se4);%���Ͳ����ָ�ԭ����ͨ���С
crop_A4 = imcrop(A4, [st.BoundingBox]);

subplot(222),imshow(crop_img);title('ԭͼROI�ü�');

img_enhance = adapthisteq(crop_img);
subplot(223),imshow(img_enhance);title('�ü�ROI��ǿ�Աȶ�');



img_enhance = imadjust(img_enhance,[],[],0.7);

subplot(224);imshow(img_enhance);title('��ǿ�ԱȶȺ�Gama����');
%% Ѱ�����Ե㡢���Ե�
% ��ʼ�������Ե���Ŀ
[m,n] = size(img_enhance);
chip_pad = padarray(img_enhance,[1 1],0,'both');
mean_value = mean(img_enhance(:));
bright_num = 0;
dark_num = 0;
%��ֹ������������ֵ�ظ�ʶ��
point_map = zeros(m,n);

figure(3)
subplot(1,2,1),imshow(img_enhance),title('ԭͼ')
subplot(1,2,2),imshow(img_enhance),title('��ɫ�����Ե㣬��ɫ�����Ե�')
hold on 
%����ѭ��ɸѡ���Ե�����Ե�
for i = 3:m-3
    for j = 3:n-3
        %Ѱ�����Ե�
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
        %Ѱ�����Ե�
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

str1=['���Ե����=' num2str(bright_num)];
disp(str1);
str2=['���Ե����=' num2str(dark_num)];
disp(str2);