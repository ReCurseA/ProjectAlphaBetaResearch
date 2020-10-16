function resultAlphaBeta = AlphaBetaFilter(inputSignal, tau)
resultAlphaBeta = [];

alpha = (0.5).^(tau);
beta = 8 - 4 * alpha - 8 * sqrt(1 - alpha);

xFiltered = inputSignal(1);
xFiltered_dot = 0;

for j = 1:size(inputSignal, 2)
    forecast = xFiltered + xFiltered_dot;
    err = inputSignal(j) - forecast;
    xFiltered = forecast + alpha * err;
    xFiltered_dot = xFiltered_dot + beta * err;
    
    resultAlphaBeta = [resultAlphaBeta xFiltered];
end

end