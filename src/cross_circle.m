function [ output ] = cross_circle( sensor_id, angle )
%CROSS_CIRCLE �� sensor_id ��̽������Ӧ�� X���� �� angle �Ƕ� ��Բ�� �����ľ���
	sensor_pos = [39.1272 56.3769] + (sensor_id - 256.6706) * [sin(angle) -cos(angle)] * 0.2844;
    distance = abs((sensor_pos - [95 50]) * [sin(angle); -cos(angle)]);
    if distance >= 4
        output = 0;
    else
        output = 2 * sqrt(16 - distance * distance);
    end
end

