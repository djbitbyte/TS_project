clc, clear

filename = './new_dataset/data2.txt';
delimiterIn = '	';
headerlinesIn = 0;
A = importdata(filename, delimiterIn, headerlinesIn);

x = A.data;
[t, ~] = size(x);
h = 50;

figure
subplot(3,1,1)
plot(1:t, x)
title('Data2')  
grid on
hold on

x = x-mean(x); % mean != 0, try to remove non-zero means
% autocorr(x, h) 

xt = detrend(x, 'linear');
subplot(3,1,2)
autocorr(xt)
subplot(3,1,3)
parcorr(xt)

% the time series is MA(2) from ACF and PACF gragh.
EstMdl = estimate(arima(0,0,2),xt);
