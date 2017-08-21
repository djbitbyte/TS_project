clc, clear

filename = './new_dataset/data1.txt';
delimiterIn = '	';
headerlinesIn = 0;
A = importdata(filename, delimiterIn, headerlinesIn);

x = A.data;
[t, ~] = size(x);
h = 50;

figure
subplot(2,2,1)
plot(1:t, x)
title('Data1')  %% period T = 24
grid on
hold on

% sW26 = [1/50; repmat(1/25, 24, 1); 1/50];
% xS = conv(x, sW26, 'same');
% xS(1:13) = xS(14);
% xS(t-12:t) = xS(t-13);
% 
% xt = x - xS;  %% detrended time series xt

x = x-mean(x); % mean != 0, try to remove non-zero means
% autocorr(x, h) % found seasonal components, period T = 12

% detrend, almost no trend for dataset 1.
s = 24;
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

% subplot(2,2,3)
% plot(sst)

% dt = xt-sst; % now we have deseasonalized data.
dt = x-sst;
% use 'armax' tool and AICC statistics to select the orders.
subplot(2,2,3)
autocorr(dt)
subplot(2,2,4)
parcorr(dt)

% the time series is AR(2) from ACF and PACF gragh.
EstMdl = estimate(arima(2,0,0),dt);


