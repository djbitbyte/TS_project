clc, clear
addpath ./src

filename = './new_dataset/data3.txt';
delimiterIn = '	';
headerlinesIn = 0;
A = importdata(filename, delimiterIn, headerlinesIn);

x = A.data;
[t, ~] = size(x);
h = 50;

figure
subplot(2,2,1)
plot(1:t, x)
title('Data3')
grid on
hold on

x = x-mean(x); % mean != 0, try to remove non-zero means
% autocorr(x, h) % found seasonal components, period T = 12

% detrend
s = 5;
m = movmean(x, s);
xt = x-m;

p = plot(m, 'r', 'LineWidth', 2);
legend(p, 'Moving Average')
hold off

subplot(2,2,2)
plot(1:t, xt)


sidx = cell(s, 1);
for i=1:s
    sidx{i, 1} = i:s:t;
end

sst = cellfun(@(x) mean(xt(x)), sidx);

% Put smoothed values back into a vector of length N
nc = floor(t/s);
rm = mod(t, s);
sst = [repmat(sst,nc,1); sst(1:rm)];

% Center the seasonal estimate 
sBar = mean(sst);
sst = sst - sBar;

dt = xt-sst; % now we have deseasonalized data.
% dt = x-sst;
subplot(2,2,3)
autocorr(dt, 50)
subplot(2,2,4)
parcorr(dt, 50)

% use 'armax' tool and AICC statistics to select the orders.
[p, q] = order_selection(dt, 10, 10);

% the time series is MA(2) from ACF and PACF gragh.
EstMdl = estimate(arima(p,0,q),xt);



