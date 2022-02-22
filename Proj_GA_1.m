%%%%%%%f(x) = x+10xin(5x)+7cos(4x)%%%%%%%
%clear,close,clc      %初始化
draw();             %绘制本题的函数图像
%%%%%%%初始化参数%%%%%%%
NP = 50;               %种群数量
L = 20;                %二进制位串长度
Pc = 0.8;              %交叉率
Pm = 0.1;              %变异率
G = 100;               %最大遗传代数
Xs = 10;               %上限
Xx = 0;                %下限
f = randi(2,[NP,L])-1; %随机获得初始种群
%%%%%%%分配内存%%%%%%%
nf = zeros(NP,L);      %临时编码，最后将复制给f，作为下一代的基因
Fit = zeros(1,NP);     %适应度值
x = zeros(1,NP);       %染色体编码对应的x值
trace = zeros(1,G);    %记录每一代种群中最优秀个体的情况
%%%%%%%遗传算法循环%%%%%%%
for  k = 1:G   %循环次数为G次
    for i = 1:NP      %将每一个个体的编码都转化为十进制
        m = change2_10(L,f(i,:));   %将二进制数转化为十进制数
        x(i) = Xx + m*(Xs-Xx)/(2^L-1);   %转化为对应的x
        Fit(i) = func1(x(i));    %计算每个x对应的函数值，临时存储在Fit中
    end
    %%%%%%%量化适应度%%%%%%%
    [Fit,fBest,xBest,maxFit] = normalization(Fit,f,x);  %对适应度进行量化
    %%%%%%%复制&交叉&变异%%%%%%%
    nf = wheel(NP,L,f,Fit);                      %基于轮盘赌的复制操作
    nf = cross(NP,nf,L,Pc);                      %基于概率的交叉操作
    nf = variation(NP,Pm,L,nf);                  %基于概率的变异操作
    %%%%%%%一轮自然选择完成%%%%%%%
    f = nf;
    f(1,:) = fBest;
    trace(k) = maxFit;
end
%%%%%%%绘图%%%%%%%
figure
hold on
plot(trace)
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')
%%%%%%%输出最优解%%%%%%%
str1 = ['在 x = ',num2str(xBest),' 取到最大值'];
str2 = ['最大值为：',num2str(maxFit)];
disp(str1);
disp(str2);
%%%%%%%%%%%%%%函数区%%%%%%%%%%%%%%
%%%%%%%绘图函数%%%%%%%
function draw(~)
x = 0:0.01:10;
y = x+10*sin(5*x)+7*cos(4*x);
plot(x,y);
xlabel('x');
ylabel('f(x)');
title('f(x)=x+10xin(5x)+7cos(4x)');
end
%%%%%%%适应度函数%%%%%%%
function result = func1(x)
fit = x+10*sin(5*x)+7*cos(4*x);
result = fit;
end
%%%%%%%适应度归一化%%%%%%%
function [Fit,fBest,xBest,maxFit] = normalization(Fit,f,x)
maxFit = max(Fit);                    %最大值
minFit = min(Fit);                    %最小值
rr = find(Fit==maxFit);               %查找最优解
fBest = f(rr(1,1),:);                 %历代最优个体（函数值
xBest = x(rr(1,1));                   %历代最优个体（自变量值
Fit = (Fit-minFit)/(maxFit-minFit);   %归一化适应度值
end
%%%%%%%将二进制编码为十进制%%%%%%%
function m = change2_10(L,U)
m = 0;
for j = 1:L
    m = U(j)*2^(j-1) + m;
end
end
%%%%%%%基于轮盘赌的繁衍操作%%%%%%%
function nf = wheel(NP,L,f,Fit)
nf = zeros(NP,L); 
sum_Fit = sum(Fit);
fitvalue = Fit./sum_Fit;
fitvalue = cumsum(fitvalue);
ms = sort(rand(NP,1));
fiti = 1;
newi = 1;
while (newi <= NP)
    if (ms(newi)) < fitvalue(fiti)
        nf(newi,:) = f(fiti,:);
        newi = newi+1;
    else
        fiti = fiti+1;
    end
end
end
%%%%%%%基于概率的交叉操作%%%%%%%
function nf = cross(NP,nf,L,Pc)
for i = 1:2:NP
    p = rand;
    if p < Pc
    q = randi(1,L);
    for j=1:L
        if q(j)==1
            temp = nf(i+1,j);
            nf(i+1,j) = nf(i,j);
            nf(1,j) = temp;
        end
    end
    end
end
end
%%%%%%%基于概率的变异操作%%%%%%%
function nf = variation(NP,Pm,L,nf)
i = 1;
while i <= round(NP*Pm)
    h = randi(NP);       %随机选取一个需要变异的染色体
    for j = 1:round(L*Pm)
        g = randi(L);    %随机选取需要变异的基因数
        nf(h,g) =~ nf(h,g); 
    end
    i = i+1;
end
end