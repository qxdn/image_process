clear all;
% 首先创建 100*100的纹理:

H = repmat(linspace(0, 1, 100), 100, 1);     % 100*100 hues
S = repmat([linspace(0, 1, 50) ...           % 100*100 saturations
            linspace(1, 0, 50)].', 1, 100);  
B = repmat([ones(1, 50) ...                  % 100*100 brightness
            linspace(1, 0, 50)].', 1, 100);  
hsbImage = cat(3, H, S, B);                  % 绘制 HSB
C = hsv2rgb(hsbImage);                       % 转换为rgb

theta = linspace(0, 2*pi, 100); 
X = [zeros(1, 100); ...         
     cos(theta); ...
     zeros(1, 100)];
Y = [zeros(1, 100); ...         
     sin(theta); ...
     zeros(1, 100)];
Z = [2.*ones(2, 100); ...        
     zeros(1, 100)];

surf(X, Y, Z, C, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
axis equal