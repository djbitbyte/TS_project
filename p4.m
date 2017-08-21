% kth sf2943 tidsan17 (time series analysis) project problem 4 (model selection)
clc, clear
addpath ./src

x = load('./all_series/Data_series_1.txt');
[N, ~] = size(x);

foo = [1:N];
plot(foo, x)

x = x-mean(x); % mean != 0, try to remove non-zero means
h = 100;
autocorr(y, h) % found seasonal components, period T = 12

% deseasonalization
T = 12;
m = movmean(x, T);
w = zeros(T, 1);
for i=1:T
  if i == T
    w(i) = mean(x(foo(mod(foo, T)==0))-m(foo(mod(foo, T)==0)));
  else
    w(i) = mean(x(foo(mod(foo, T)==i))-m(foo(mod(foo, T)==i)));
  end % if
end % for

bar = sum(w)/T;
s = w-bar;

d = zeros(N, 1);
for i=1:T
  if i == T
    bar = foo(mod(foo, T)==0);
    d(bar) = x(bar)-s(T);
  else
    bar = foo(mod(foo, T)==i);
    d(bar) = x(bar)-s(i);
  end % if
end % for
% autocorr(d, h) % some trends can be seen. try to remove the trends

y = zeros(N, 1);
for i=1:T
  if i == T
    bar = foo(mod(foo, T)==0);
    y(bar) = x(bar)-m(bar)-s(T);
  else
    bar = foo(mod(foo, T)==i);
    y(bar) = x(bar)-m(bar)-s(i);
  end % if
end % for

subplot(2,1,1)
autocorr(y)
subplot(2,1,2)
parcorr(y)

%{
  now we have the deseasonalized data with trends removed.
  try to fit with AR/MA/ARMA models.
%}

% [p, q] = order_selection(y, 10, 10);

% %{
%   for validation of the model we could apply residual analysis.
% 
%   we have finished analysing dataset 1.
%   it contains a small ascending trend, a seasonal compoment with period 12 (does the dataset come from a monthly report?), a mean value of around 180, and an (ARMA(3, 3)) component.
% 
%   we will now move on to dataset 2.
% %}
% 
% clc, clear
% x = load('./all_series/Data_series_2.txt');
% [N, ~] = size(x);
% 
% % foo = [1:N];
% % plot(foo, x)
% x = x-mean(x); % mean != 0, try to remove non-zero means
% h = 100;
% % autocorr(x, h) % found seasonal components, period T = 12
% 
% % deseasonalization
% T = 12;
% m = movmean(x, T);
% xt = x-m;
% 
% % below codes are de(season|trend)-izing calculations from mathworks documentation.
% sidx = cell(T,1);
% for i = 1:T
%  sidx{i,1} = i:T:N;
% end
% 
% sst = cellfun(@(x) mean(xt(x)),sidx);
% nc = floor(N/T); % no. complete years
% rm = mod(N, T); % no. extra months
% sst = [repmat(sst, nc, 1); sst(1:rm)];
% 
% sBar = mean(sst); % for centering
% sst = sst-sBar;
% 
% dt = x-sst; % now we have deseasonalized data.
% % use 'armax' tool and AICC statistics to select the orders.
% subplot(2,1,1)
% autocorr(dt)
% subplot(2,1,2)
% parcorr(dt)
% 
% mle = arma_mle(dt, 1, 0);

% %{
%   we have finished analysing dataset 2.
%   it contains a seasonal compoment with period 12 (does the dataset come from a monthly report?), a mean value of around 85, and an autoregression (AR(1)) component.
% 
%   now we will proceed to dataset 3.
% %}
% 
% clc, clear
% x = load('./all_series/Data_series_3.txt');
% [N, ~] = size(x);
% 
% foo = [1:N];
% % plot(foo, x)
% 
% h = 100;
% x = x-mean(x); % almost zero-mean, but we still need this step to ensure a pure zero mean dataset.
% % autocorr(x, h) % the ACF plot corresponds to a figure on the textbook (3-3), so we try MLE with AR(2) model.
% mle = arma_mle(x, 2, 0);

% %{
%   we have finished analysing dataset 3.
%   it contains a mean value around 0.01 and an autoregression (AR(2)) model.
% 
%   now we will move on to dataset 4.
% %}
% 
% clc, clear
% x = load('./all_series/Data_series_4.txt');
% [N, ~] = size(x);
% 
% foo = [1:N];
% % plot(foo, x)
% h = 100;
% x = x-mean(x);
% % autocorr(x, h) % trend detected, try to remove the trends
% 
% T = 30;
% m = movmean(x, T);
% % autocorr(m, h) % steadily decreasing ACF plot.
% xt = x-m;
% % plot(foo, xt) % the trends are removed successfully.
% % autocorr(xt, h) % try AR(p) model.
% subplot(2,1,1)
% autocorr(xt)
% subplot(2,1,2)
% parcorr(xt)
% 
% mle = arma_mle(xt, 2, 0);

%{
  we have finished analysing dataset 4.
  it contains an ascending trend, a mean value around 1.09 and an ARMA(4, 3) model.

  we will proceed to dataset 5.
%}

% clc, clear
% x = load('./all_series/Data_series_5.txt');
% [N, ~] = size(x);
% 
% foo = [1:N];
% % plot(foo, x) % an increasing-then-decreasing trend was found. try to remove the trend
% x = x-mean(x); 
% 
% T = 20;
% h = 100;
% m = movmean(x, T);
% % autocorr(m, h)
% xt = x-m;
% % autocorr(xt, h);
% % plot(foo, xt) % the trend was successfully removed
% [p, q] = order_selection(xt, 10, 10); % p = 3, q = 1
% mle = arma_mle(xt, 3, 1);

% %{
%   we have finished analysing dataset 5.
%   it contains an increasing-then-decreasing trend, a mean value and an ARMA(3, 1) model.
% 
%   we will now proceed to dataset 6.
% %}
% 
% clc, clear
% x = load('./all_series/Data_series_6.txt');
% [N, ~] = size(x);
% 
% foo = [1:N];
% % plot(foo, x)
% 
% h = 100;
% x = x-mean(x);
% subplot(2,1,1)
% autocorr(x)
% subplot(2,1,2)
% parcorr(x)
% 
% % [p, q] = order_selection(x, 10, 10);
% 
% EstMdl = estimate(arima(0,0,2),x);