%% Первая секция. Задание исходного сигнала.
% построение траектории
p = [1.29 -0.51466 -6.7952 2.242 11.911 -3.6167 -6.8425 4.4658 -3.4118 8.7944 -13.628];
x = 0:10:16250;
mu = 7891.8;
sigma = 4776.7;
z = (x-mu)/sigma;
y = p(1)*z.^10 + p(2)*z.^9 + p(3)*z.^8 + p(4)*z.^7 + p(5)*z.^6 + p(6)*z.^5 + p(7)*z.^4 + p(8)*z.^3 + p(9)*z.^2 + p(10)*z + p(11);

% сигнал без шумов
signalWithoutNoise = y;

% шумы
coeff = 1.2;
noise = randn(size(y))*coeff;

% сигнал с шумом
signalWithNoise = y + noise;

figure;
subplot(2, 1, 1);
plotSignalWithoutNoise = plot(x, signalWithoutNoise, 'b-');
xlabel('Time'), ylabel('Signal Amplitude'), title('Signal without noise'), grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');

subplot(2, 1, 2);
plotSignalWithNoise = plot(x, signalWithNoise, 'b-');
xlabel('Time'), ylabel('Signal Amplitude'), title('Signal with noise'), grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');

%% Вторая секция. Квантование.
% квантование будет производиться для разных уровней(0.1, 0.2 и 0.5)
quantizedSignal1 = quantization(signalWithNoise, 0.1);
quantizedSignal2 = quantization(signalWithNoise, 0.2);
quantizedSignal3 = quantization(signalWithNoise, 0.5);

figure;
subplot(3, 1, 1);
plotQuantizedSignal1 = plot(x, quantizedSignal1, 'ro', x, signalWithoutNoise, 'b-');
xlabel('Time'), ylabel('Signal Amplitude'), title('Quantized signal (level of quantization = 0.1)'), grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');
set(plotQuantizedSignal1, 'MarkerSize', 3);

subplot(3, 1, 2);
plotQuantizedSignal2 = plot(x, quantizedSignal2, 'ro', x, signalWithoutNoise, 'b-');
xlabel('Time'), ylabel('Signal Amplitude'), title('Quantized signal (level of quantization = 0.2)'), grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');
set(plotQuantizedSignal2, 'MarkerSize', 3);

subplot(3, 1, 3);
plotQuantizedSignal3 = plot(x, quantizedSignal3, 'ro', x, signalWithoutNoise, 'b-');
xlabel('Time'), ylabel('Signal Amplitude'), title('Quantized signal (level of quantization = 0.5)'), grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');
set(plotQuantizedSignal3, 'MarkerSize', 3);

%% Третья секция. Фитрация сигналов.
quantizedSignals = [quantizedSignal1; quantizedSignal2; quantizedSignal3];

filtredSignals = [];
figure;
saveSTD = [];
for i = 1:size(quantizedSignals, 1)
    signalToFilter = quantizedSignals(i, :);
    STD = [];
    for Tau = 0.15:0.01:5
        filtredSignals(i, :) = AlphaBetaFilter(signalToFilter, Tau);
        err = abs(signalWithoutNoise - filtredSignals(i, :));
        STD = [STD sqrt(sum(err.^2)/length(err))];
    end
    saveSTD(i, :) = STD;
    TauX = 0.15:0.01:5;
    plot(TauX, STD);
    hold on;
end
xlabel('Time'), ylabel('Signal Amplitude');
title('STD with different levels of quantization (0.1; 0.2; 0.5)'), grid on;
set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');

%% Четвёртая секция. Определение оптимального параметра Tau.
optimalTau = [];
for i = 1:size(saveSTD, 1)
    [minimumSTD optIndexSaveSTD] = min(saveSTD(i, :));
    allOptimalTau(i) = optIndexSaveSTD/100 + 0.15;
end
optimalTauResult = sum(allOptimalTau)/size(allOptimalTau, 2);
disp(optimalTauResult);
