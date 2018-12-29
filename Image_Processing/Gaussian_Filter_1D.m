function output = Gaussian_Filter_1D(sigma, mean, N)

for i = 1 : N
     x = (N + 1)/2 - i;
    
     Gaussian_Matrix(i) = (1/(sqrt(2*pi)*sigma)* exp(-((x - mean)^2)/(2*(sigma)^2)));
end

output = Gaussian_Matrix