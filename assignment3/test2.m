clear all;
close all;
% ����Ѱ�ҵ�λ
% ʹ����ҵͼ
I = imread('Sample2.bmp');

imshow(I)
% ��ʾ����
axis on
xlabel x
ylabel y
impixelinfo


% x y  w h
origin = [[350,190];[350,245];[416,189];[416,250];[281,190];[284,249];[153,190];[151,249];[548,193];[551,248]];
fixed = [[350,190];[350,245];[411,175];[415,231];[283,202];[280,261];[144,233];[134,286];[529,137];[539,201]];
% ���Ƶ�λ�鿴
hold on
scatter(origin(:,1),origin(:,2),'r')
scatter(fixed(:,1),fixed(:,2),'g')

% ���
a = [1 1 1 1];
a1 = lsqcurvefit('fixfun',a,origin,fixed(:,1));
a2 = lsqcurvefit('fixfun',a,origin,fixed(:,2));