function [ output ] = cross_circle( sensor_id, angle )
%CROSS_CIRCLE �� sensor_id ��̽������Ӧ�� X���� �� angle �Ƕ� ����Բ�� �����ľ���
	sensor_pos = [39.1272 56.3769] + (sensor_id - 256.6706) * [sin(angle) -cos(angle)] * 0.2844 - [50 50];
    k = tan(angle);
    if abs(k) < 1
        h = sensor_pos(2) - k * sensor_pos(1);
        a = 15;
        b = 40;
        A = a*a * k*k + b*b;
        B = 2 * k * h * a*a;
        C = a*a * (h*h - b*b);
        delta = B*B - 4*A*C;
        if delta <= 0
            output = 0;
        else
            output = sqrt(delta) / A * sqrt(1 + k*k);
        end
    else
        sensor_pos = [-sensor_pos(2) sensor_pos(1)];
        k = -1 / k;
        h = sensor_pos(2) - k * sensor_pos(1);
        a = 40;
        b = 15;
        A = a*a * k*k + b*b;
        B = 2 * k * h * a*a;
        C = a*a * (h*h - b*b);
        delta = B*B - 4*A*C;
        if delta <= 0
            output = 0;
        else
            output = sqrt(delta) / A * sqrt(1 + k*k);
        end
    end
end

