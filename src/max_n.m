function [ output ] = max_n( input, n )
%MAX_4 �ҳ�����ǰ4�����ֵ��������λ��
%   ���ؾ���Ϊ1x4
    [value, index] = sort(input, 1, 'descend');
    output = index(1:n, :);
    output = sort(output, 1, 'ascend');
end

