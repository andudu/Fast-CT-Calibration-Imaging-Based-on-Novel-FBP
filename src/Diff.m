function [ output ] = Diff( input, relu )
%DIFF �Ծ�����һ�β�ִ���
%   �Ծ����ÿ��Ԫ�أ�����ȥ����ǰһ��Ԫ�ء�
    slide = [zeros(1, 180); input(1 : 511, :)];
    output = input - slide;
    if relu
        output = max(output, 0);
    end
end

