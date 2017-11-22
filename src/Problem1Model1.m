%% �߽���Ϣ��ȡ
% ��ȡ����
datasheet1 = xlsread('../A/A�⸽��.xls','����1');
datasheet2 = xlsread('../A/A�⸽��.xls','����2');
datasheet3 = xlsread('../A/A�⸽��.xls','����3');
datasheet5 = xlsread('../A/A�⸽��.xls','����5');

% ���ò������+ReLU���б߽���ȡ
angleID = 50;
figure('Name', sprintf('��� + ReLU����������%d�����ݣ�', angleID));
diff_res = datasheet2;
subplot(2, 2, 1)
plot(1:512, diff_res(1:512, angleID))
xlim([0,512])
set(gca,'XTick',0:128:512);
title('ԭʼ����')
diff_res_2 = Diff(diff_res, false);
subplot(2, 2, 2)
plot(1:512, diff_res_2(1:512, angleID))
xlim([0,512])
set(gca,'XTick',0:128:512);
title('1�ײ�ֽ��')
diff_res_3 = Diff(diff_res_2, true);
subplot(2, 2, 3)
plot(1:512, diff_res_3(1:512, angleID))
xlim([0,512])
set(gca,'XTick',0:128:512);
title('2�ײ�� + ReLU������')
diff_res_4 = diff_res_3;
for i = 1:200
    diff_res_4 = Diff(diff_res_4, true);
end
subplot(2, 2, 4)
plot(1:512, diff_res_4(1:512, angleID))
xlim([0,512])
set(gca,'XTick',0:128:512);
title('�������')

% Ѱ�ұ߽�
line_num = 4;
loc = max_n(diff_res_4, line_num);
% [x, y] = find(loc == 1); % [14, 22, 109]
loc = preprocess(loc, line_num);

loc([2,4], 1:180) =  loc([2,4], 1:180) - 1;
figure('Name','ͼ��߽�');
imshow(datasheet2,[])
hold on
plot (1:180,loc(1,:),'LineWidth',1)
plot (1:180,loc(2,:),'LineWidth',1)
plot (1:180,loc(3,:),'LineWidth',1)
plot (1:180,loc(4,:),'LineWidth',1)
save loc loc
%% ̽������Ԫ֮��ľ���
load loc loc
coord = loc;
% СԲ��ͶӰ̽��������
circle_projection=coord(4,:) - coord(3,:); 
% ��Բ��ͶӰ̽��������
oval_projection=coord(2,:) - coord(1,:);

mid_value_circle = coord(3,:) + circle_projection ./ 2;
mid_value_oval = coord(1,:) + oval_projection ./ 2;

x = 1:180;
% figure('Name', 'СԲ����ԲͶӰ��������')
% plot(x, 512 - mid_value_circle, x, 512 - mid_value_oval);
% СԲͶӰƽ������̽��������
circle_mean_num = mean(circle_projection)
% ��Ϊ��ƽ��ͶӰ����λ��mm
detector_real_distance = (4 * 2 +0.135) / circle_mean_num

%% CTϵͳʹ�õ�X���ߵ�180������
% ��Բ��СԲͶӰ����֮���ʵ�ʾ���
rescale_factor = max(abs(mid_value_circle - mid_value_oval)) * detector_real_distance / 45;
mid_distance = (mid_value_circle - mid_value_oval) .* (detector_real_distance / rescale_factor) ;
% mid_distance(mid_distance < -45) = -45;
% mid_distance(mid_distance > 45) = 45;
% ����Բ���ĺ�СԲ��������Ϊ0�ȣ���ʱ�뷽��Ϊ����������
degree1 = rad2deg(asin(mid_distance(1:152) ./ 45));
degree2 = rad2deg(asin(mid_distance(153:180) ./ 45));
degree2 = degree1(152) + degree1(152) - degree2;
degree = [degree1 degree2];
degree = 180 - degree
save degree degree

%% ȷ��CTϵͳ��ת�����������������е�λ��
xdata = deg2rad(degree(1))-deg2rad(degree);
% ���СԲ�������Һ���
options = optimset('MaxFunEvals',10000000); %��дһ���������������溯��lsqcurvefit������
cosparam_est1 = lsqcurvefit(@(cosparam, xdata) cosfunc(cosparam, xdata), [206 0 239], xdata, mid_value_circle);
figure('Name','�����Բ��СԲ�������Һ���')
scatter(xdata, mid_value_circle, 'x');
hold on
plot(xdata, cosfunc(cosparam_est1,xdata), 'g-', 'LineWidth', 1.5) ;
legend({'�۲�ֵ','���ֵ'});
% figure('Name','�����Բ�������Һ���');
% �����Բ�������Һ���
cosparam_est2 = lsqcurvefit(@(cosparam, xdata) cosfunc(cosparam, xdata),[46 0 247], xdata, mid_value_oval);
scatter(xdata, mid_value_oval, 'x')
hold on
plot(xdata, cosfunc(cosparam_est2, xdata), 'g-', 'LineWidth', 1.5);
legend({'�۲�ֵ','���ֵ'});
cosparam_est1
cosparam_est2

%% ������ת��������
% ������ԭ����ϵ�У�2��������ʵ����������ת���ĵ�����
rotate_center_projection = (cosparam_est1(3) + cosparam_est2(3)) / 2;
radius_circle = detector_real_distance * cosparam_est1(1);
theta_circle = cosparam_est1(2) + deg2rad(degree(1)) - pi/2;
pos_from_circle = [95 - radius_circle * cos(theta_circle) ;50 - radius_circle * sin(theta_circle)];
radius_oval = detector_real_distance * cosparam_est2(1);
theta_oval = cosparam_est2(2) + deg2rad(degree(1)) - pi/2;
pos_from_oval = [50 - radius_oval * cos(theta_oval) ;50 - radius_oval * sin(theta_oval)];

% ���ð뾶��Ϣ�����ù�������������꣬������ת��������
ang = acos((radius_oval*radius_oval + 45*45 - radius_circle*radius_circle)/2/45/radius_oval);
final_pos = [50 + radius_oval * cos(ang); 50 + radius_oval * sin(ang)];

ttt = theta_circle - theta_oval;
radius_circle = 45 / abs(sin(ttt)) * abs(sin(theta_oval));
final_pos_2 = [95 - radius_circle * cos(theta_circle) ;50 - radius_circle * sin(theta_circle)];
rotate_center_pos = pos_from_circle

%% ���»���ͼ��
circle_image = zeros(512, 128);
for i = 1:180
    for j = 1:512
        circle_image(j, i) = cross_circle(j, deg2rad(degree(i)));
    end
end
figure('Name','���ݼ��������»�ͼ');
subplot(1, 4, 1)
imshow(circle_image,[])
title('СԲͶӰͼ')
oval_image = zeros(512, 128);
for i = 1:180
    for j = 1:512
        oval_image(j, i) = cross_oval(j, deg2rad(degree(i)));
    end
end
subplot(1, 4, 2)
imshow(oval_image,[])
title('��ԲͶӰͼ')
sum_image = circle_image + oval_image;
subplot(1, 4, 3)
imshow(sum_image,[])
title('�ϳ�ͶӰͼ')
subplot(1, 4, 4)
imshow(datasheet2,[])
title('��ʵͶӰͼ')

%% ͳ�Ʒ���
figure('Name','���ݼ��������»�ͼ');
original_data = reshape(datasheet2, 512*180, 1);
generated_data = reshape(sum_image, 512*180, 1);
scatter(generated_data, original_data, 'x');
hold on
C = corr(original_data, generated_data)
B = regress(original_data, generated_data)
plot([0, max(generated_data)], B*[0, max(generated_data)], 'g-', 'LineWidth',1.5);
legend({'���ݵ�','���ֱ��'});




