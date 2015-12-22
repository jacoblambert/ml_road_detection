function G = sigmoid(u,v)
% sigmoid function matlab
gamma = 1;
c = 0;
G = tanh(gamma*u*v'+c);
end
