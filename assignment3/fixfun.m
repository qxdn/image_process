function [F] = fixfun(a,b)
% ˫���Ա任
x = b(:,1);
y = b(:,2);
F = a(1)+a(2)*x+a(3)*y+a(4)*x.*y;
end
