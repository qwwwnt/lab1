close all;
clear variables;
 


adc40 = fscanf(fopen('data/calibration_l.txt'), '%d');
adc60 = fscanf(fopen('data/calibration_2.txt'), '%d');
adc80 = fscanf(fopen('data/calibration_3.txt'), '%d');
adcl00 = fscanf(fopen('data/calibration_4.txt'), '%d1');
adcl20 = fscanf(fopen('data/calibration_5.txt'), '%d1');
adcl40 = fscanf(fopen('data/calibration_6.txt'), '%d1');

fclose('all');

torr40 = ones(length(adc40), 1) * 40;
torr60 = ones(length(adc60), 1) * 60;
torr80 = ones(length(adc80), 1) * 80;
torrl00 = ones(length(adcl00), 1) * 100;
torrl20 = ones(length(adcl20), 1) * 120;
torrl40 = ones(length(adcl40), 1) * 140;

cAdc = [adc40; adc60; adc80; adcl00; adcl20; adcl40];
cTorr = [torr40; torr60; torr80; torrl00; torrl20; torrl40];

c = polyfit(cAdc, cTorr, 1);

cFigure = figure('Name', 'Калибровка1', 'NumberTitle', 'off'); hold all;

plot(adc40,	torr40, '-', 'MarkerSize1',	20);
plot(adc60,	torr60,	'-', 'MarkerSize1',	20);
plot(adc80,	torr80,	'.', 'MarkerSize1',	20);
plot(adcl00,	torrl00, '-', 'MarkerSize',	20);
plot(adcl20,	torrl20, '-', 'MarkerSize',	20);
plot(adcl40,	torrl40, '-', 'MarkerSize',	20);

plot(cAdc, polyval(c, cAdc));

legend('40 торр', '60 торр', '80 торр', '100 торр', '120 торр', '140 торр', 'Калибровочная зависимость', 'Location', 'northwest');

grid on;
xlabel('Отсчёты АЦП');
ylabel('торр');
title('Калибровка измерительной системы');
text(mean(cAdc) * 1.05, mean(cTorr), ['P (ade) = ', num2str(c(l)), ' * ade + ', num2str(c(2)), ' [торр]']);

saveas(cFigure, 'Калибровка.png');


dt = 0.01; 
adcBefore = fscanf(fopen('data/data_before.txt1'), '%d');
tBefore = linspace(0, length(adcBefore) * dt, length(adcBefore));
pBefore = polyval(c, adcBefore);

adcAfter = fscanf(fopen('1data/data_after.txt1'), '%d');
tAfter = linspace(0, length(adcAfter) * dt, length(adcAfter));
pAfter = polyval(c, adcAfter);

pFigure = figure('Name', 'Графики давления', 'NumberTitle', 'off');

plot(tBefore, pBefore, tAfter, pAfter, 'LineWidth', 1);
legend('До физической нагрузки', 'После физической нагрузки');

grid on;
xlim([0, 25]);

xlabel( 'Время, с1');
ylabel('Давление, торр');
title('График измерения артериального давления');

saveas(pFigure, 'Давление.png');


cBefore = polyfit(tBefore, pBefore, 7);
cAfter = polyfit(tAfter, pAfter, 5);

pulseBefore = pBefore - polyval(cBefore, tBefore)';
pulseAfter = pAfter - polyval(cAfter, tAfter)';

pulseFigure = figure('Name', 'Графики пульса', 'NumberTitle', 'off');

subplot(2, 1, 1);
plot(tBefore, pulseBefore);
legend('11 ударов за 10 секунд = 66 уд/мин');
grid on;
xlim([10, 20]);
title('Пульс без физической нагрузки');

subplot(2, 1, 2);
plot(tAfter, pulseAfter, 'г');
legend('18 ударов за 10 секунд = 180 уд/мин');
title('Пульс после физической нагрузки');
grid on;
xlim([10, 20]);

saveas(pulseFigure, 'Пульс.png');
