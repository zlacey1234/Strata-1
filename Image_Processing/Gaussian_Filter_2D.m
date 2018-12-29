function output = Gaussian_Filter_2D(sigma, mean, N)

for i = 1 : N
    for j = 1 : N
        x = (N + 1)/2 - i;
        y = (N + 1)/2 - j;
        
        Gaussian_Matrix(i,j) = (1/((2*pi)*(sigma)^2)) * exp(-((x - mean)^2 + (y - mean)^2)/(2*(sigma)^2));
    end
end

output = Gaussian_Matrix;