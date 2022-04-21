function [ acc_dev, acc_eval ] = testAcc( lan_class )
    for i = 2:3
        correct = 0;
        total = 0;
        for j = 1 : 24
            sz = size(lan_class{i,j});
            for k = 1: sz(1)
                if lan_class{i,j}(sz(1),1) == j
                    correct = correct +1;
                end
                total = total+1;
            end
        end
        acc(i-1,1) = correct/total;
    end
    acc_dev = acc(1,1);
    acc_eval = acc(2,1);
end

