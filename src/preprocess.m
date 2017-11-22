function [ output ] = preprocess( input, n )
%PREPROCESS �Գ�ȡ���ı߽��������Ԥ����
%   �������ÿһ�а�����[��ԲͶӰ��ʼ����, ��ԲͶӰ��������, ԲͶӰ��ʼ����, ԲͶӰ��������]
%   ÿ�θ���ǰ2�н������һ���������Ԥ�⣬������Ԥ�����������У���Ҫʱ��������һ������
%   ���㷨����ʼ2�����ݵ�������Ϊground truth���Զ��������к�������
output = input;
target = zeros(n, 1); % �洢Ԥ��λ��
for i = 3:180
    % ʹ�ã��ֲ������Բ�ֵԤ����һ������
    for j = 1:n
        target(j, 1) = 2 * output(j, i-1) -  output(j, i-2);
    end
    vacancy = length(find(input(:, i) == 1));
    res = zeros(n, 1); % �洢��ʵ��λ�õ����н��
    occupy = zeros(n, 1); % ���ڶԺ�ѡ������з���
    if vacancy > 0 % ���ڿ����꣬˵���������غ���
        for j = vacancy + 1 : n
            current = 0;
            dist = inf;
            for k = 1:n
                if occupy(k, 1) == 0 && abs(input(j, i) - target(k, 1)) < dist
                    dist = abs(input(j, i) - target(k, 1));
                    current = k;
                end
            end
            occupy(current, 1) = 1;
            res(current, 1) = input(j, i);
        end
        [x, y] = find(occupy == 0);
        current = vacancy+1;
        for j = vacancy+2:n
            if abs(input(j, i) - target(x, 1)) < abs(input(current, i) - target(x, 1))
                current = j;
            end
        end
        res(x, 1) = input(current, i);
    else % ֱ�Ӹ���Ԥ�������С˳������ʵ������
        [value, index] = sort(target, 1, 'ascend');
        res(index, 1) = input(:, i);
    end
    output(:, i) = res;

end

