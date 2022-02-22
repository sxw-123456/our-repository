%%%%%%%%%%实值遗传算法求函数极值%%%%%%%%%%
%%%%%%%初始化%%%%%%%
clear,clc,close
D = 10;                      %基因数目
NP = 100;                    %染色体数目
Xs = 20;                     %上限
Xx = -20;                    %下限
G = 1000;                    %最大遗传代数
f = zeros(D,NP);             %初始种群赋空间
nf = zeros(D,NP);            %子种群赋空间
Pc = 0.8;                    %交叉概率
Pm = 0.1;                    %变异概率
f = rand(D,NP)*(Xs-Xx)+Xx;   %随机获得初始种群
%%%%%%%内存分配%%%%%%%
MSLL = zeros(1,NP);
NMSLL = zeros(1,NP);
%%%%%%%按适应度升序排列%%%%%%%
for np = 1:NP
    MSLL(np) = func2(f(:,np));
end
[SortMSLL,Index] = sort(MSLL);
Sortf = f(:,Index);
%%%%%%%遗传算法循环%%%%%%%
for gen = 1:G
    %%%%%%%采用君主方案进行选择交叉操作%%%%%%%
    Emper = Sortf(:,1);      %君主染色体
    NoPoint = round(D*Pc);   %每次交叉的点的个数
    PoPoint = randi(D,[NoPoint,NP/2]);
    nf = Sortf;
    for i = 1:NP/2
        nf(:,2*i-1) = Emper;
        nf(:,2*i) = Sortf(:,2*i);
        for k = 1:NoPoint
            nf(PoPoint(k,i),2*i-1) = nf(PoPoint(k,i),2*i);
            nf(PoPoint(k,i),2*i) = Emper(PoPoint(k,i));
        end
    end
    %%%%%%%变异操作%%%%%%%
    for m = 1:NP
        for n = 1:D
            r = rand(1,1);
            if r < Pm
                nf(n,m) = rand(1,1)*(Xs-Xx)+Xx;
            end
        end
    end
    %%%%%%%子群按适应度升序排列%%%%%%%%
    for np = 1:NP
        NMSLL(np) = func2(nf(:,np));
    end
    [NSortMSLL,Index] = sort(NMSLL);
    NSortf = nf(:,Index);
    %%%%%%%产生新种群%%%%%%%
    f1 = [Sortf,NSortf];              %子代和父代合并
    NMSLL1 = [SortMSLL,NSortMSLL];    %子代和父代的适应度值合并
    [SortMSLL1,Index] = sort(NMSLL1); %适应度按升序排列
    Sortf1 = f1(:,Index);             %按适应度排列个体
    SortMSLL = SortMSLL1(1:NP);       %取前NP个适应度值
    Sortf = Sortf1(:,1:NP);           %取前NP个个体
    trace(gen) = SortMSLL(1);         %历代最优适应度值
end
disp('最优个体')                        %最优个体
disp(num2str(Sortf(:,1))) 
disp(['最优值',num2str(trace(1,end))])    %最优值
figure
plot(trace)
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')
%%%%%%%适应度函数%%%%%%%
function result = func2(x)
summ = sum(x.^2);
result = summ;
end