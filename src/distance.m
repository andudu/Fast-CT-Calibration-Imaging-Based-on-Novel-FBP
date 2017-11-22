%% ����1
clc; clear;
%% ̽������Ԫ֮��ľ���
load loc loc
coord = loc;
% СԲ��ͶӰ̽��������
circle_projection=coord(4,:) - coord(3,:); 
% ��Բ��ͶӰ̽��������
oval_projection=coord(2,:) - coord(1,:);

mid_value_circle = coord(3,:) + circle_projection / 2;
mid_value_oval = coord(1,:) + oval_projection / 2;

x = 1:180;
figure('Name', 'СԲ����ԲͶӰ��������')
plot(x, 512 - mid_value_circle, x, 512 - mid_value_oval);
% СԲͶӰƽ������̽��������
circle_mean_num = mean(circle_projection);
% ��Ϊ��ƽ��ͶӰ����λ��mm
detector_real_distance = 4 * 2 / circle_mean_num

%% CTϵͳʹ�õ�X���ߵ�180������
% ��Բ��СԲͶӰ����֮���ʵ�ʾ���
mid_distance = (mid_value_circle - mid_value_oval) * detector_real_distance
% ����Բ���ĺ�СԲ��������Ϊ0�ȣ���ʱ�뷽��Ϊ����������
degree1 = rad2deg(asin(mid_distance(1:152) / 45));
degree1
degree2 = rad2deg(asin(mid_distance(153:180) / 45));
degree2 = degree1(152) + degree1(152) - degree2;
degree = [degree1 degree2]
% save degree degree

%% ȷ��CTϵͳ��ת�����������������е�λ��
% y = a * sin(b * x + c)+d
% sinparam = [2 10 5 4];
xdata = deg2rad(degree);
% ���СԲ�������Һ���
options = optimset('MaxFunEvals',1000000); %��дһ���������������溯��lsqcurvefit������
sinparam_est1 = lsqcurvefit(@(sinparam, xdata) sinfunc(sinparam, xdata), [100 9 2 256], xdata, 512 - mid_value_circle);
figure('Name','���СԲ�������Һ���');
scatter(xdata, 512 - mid_value_circle);
hold on
plot(xdata, sinfunc(sinparam_est1,xdata), 'g-') ;
legend({'�۲�ֵ','���ֵ'});
figure('Name','�����Բ�������Һ���');
% �����Բ�������Һ���
sinparam_est2 = lsqcurvefit(@(sinparam, xdata) sinfunc(sinparam, xdata),[150 1 30 256], xdata, 512 - mid_value_oval);
scatter(xdata, 512 - mid_value_oval) ;
hold on
plot(xdata,sinfunc(sinparam_est2, xdata), 'g-');
legend({'�۲�ֵ','���ֵ'});

sinparam_est1
sinparam_est2
alpha = rad2deg(sinparam_est2(3) - sinparam_est1(3));
AB = sinparam_est2(1) / 256 * 100; AC = 45; BC = sinparam_est1(1) / 256 * 100;
beta = asin(AB / AC * sin(alpha))
% ��СԲԲ��Ϊ��׼
% y���� СԲԲ������ת���ľ���
delta_y = BC * sin(beta)
% x���� СԲԲ������ת���ľ���
delta_x = BC * cos(beta)






