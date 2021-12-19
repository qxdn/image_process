clear all;
close all;
% ������������Ѱ�ҵ�λ
% ʹ���Լ�����ͼ
I = imread('test0.bmp');

imshow(I)
% ��ʾ������Ϣ
axis on
xlabel x
ylabel y
impixelinfo

% ��Ӧ��λ
% x y  w h
origin = [[297,293];[297,242];[349,242];[349,293];[100,293];[100,242];[498,293];[495,243]];
fixed = [[297,293];[302,243];[352,260];[352,304];[97,221];[107,154];[508,331];[506,295]];
hold on
% ���ƶ�Ӧ��λ
scatter(origin(:,1),origin(:,2),'r')
scatter(fixed(:,1),fixed(:,2),'g')

% ��Ϻ���
a = [1 1 1 1];
a1 = lsqcurvefit('fixfun',a,origin,fixed(:,1));
a2 = lsqcurvefit('fixfun',a,origin,fixed(:,2));