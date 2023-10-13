clc
clear all
close all

iWidth = 160;
iHeight = 120;
frame = 100;

% 选取log数据
% inFileID = fopen('40klux室外测试/白板反射率67/1m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('40klux室外测试/白板反射率67/2m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('40klux室外测试/白板反射率67/3m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('40klux室外测试/白板反射率67/4m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('40klux室外测试/白板反射率67/5m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('40klux室外测试/白板反射率67/6m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('40klux室外测试/白板反射率67/7m_DEPTH_DATA.dat', 'r');

% inFileID = fopen('85klux室外测试/白板反射率67/1m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/白板反射率67/2m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/白板反射率67/3m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/白板反射率67/4m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/白板反射率67/5m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/白板反射率67/6m_DEPTH_DATA.dat', 'r');

% inFileID = fopen('85klux室外测试/纸板反射率17/1m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/纸板反射率17/2m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/纸板反射率17/3m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/纸板反射率17/4m_DEPTH_DATA.dat', 'r');
% inFileID = fopen('85klux室外测试/纸板反射率17/5m_DEPTH_DATA.dat', 'r');
inFileID = fopen('85klux室外测试/纸板反射率17/6m_DEPTH_DATA.dat', 'r');

%数据导入
data = fread(inFileID, iWidth*iHeight*frame, 'uint16')';
data = reshape(data,[iWidth iHeight frame]);

% 数据可视化打印
% for i = 1:frame
%     mesh(data(:,:,i))
%     colorbar
%     pause(0.2);
% end

middle_point_row = iWidth/2;
middle_point_column = iHeight/2;
point_count = 10;
point_count_half = point_count /2;

% 计算时域波动
for r = middle_point_row - point_count_half : middle_point_row+point_count_half-1
    for c = middle_point_column - point_count_half : middle_point_column +point_count_half-1
        for i = 1:frame
            noise(i) = data(r,c,i);
        end    

        if (((r-(middle_point_row-point_count_half)+1) == 6) && ((c-(middle_point_column-point_count_half)+1) == 7))
            figure
            plot(noise)
            xlabel('帧序');
            ylabel('该点的实际深度值（mm）');
            legend('坐标(6,7)的时域波动');
        end

        if (((r-(middle_point_row-point_count_half)+1) == 5) && ((c-(middle_point_column-point_count_half)+1) == 5))
            figure
            plot(noise)
            xlabel('帧序');
            ylabel('该点的实际深度值（mm）');
            legend('坐标(5,5)的时域波动');
        end
        
        result(r-(middle_point_row-point_count_half)+1,c-(middle_point_column-point_count_half)+1) = std(noise);
    end
end
Time_domain_noise = mean2(result)

figure
mesh(result)
xlabel('行方向');
ylabel('列方向');
zlabel('标准差（mm）');
legend('10*10区域每一个像素点的时域波动');

% 计算空域波动
for i = 1:frame
    num = 1;
    for r = middle_point_row - point_count_half : middle_point_row+point_count_half-1
        for c = middle_point_column - point_count_half : middle_point_column +point_count_half-1
            temp(num)=data(r,c,i);
            num = num + 1;
        end
    end
    space_noise(i) = std(temp);
end
space_domain_noise = mean(space_noise)

% 图表的绘制
% figure 
% plot(space_noise);
% xlabel('帧序');
% ylabel('标准差（mm）');
% legend('空域波动随时间的变化');

% figure
% mesh(data(:,:,24));
% legend('第24帧深度图');
% figure 
% mesh(data(:,:,31));
% legend('第31帧深度图');

colorbar
%关闭文件操作
pusDepth_1 = permute(data, [2 1 3]);
fclose(inFileID);





