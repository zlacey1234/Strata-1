function output = Gaussian_Filter_3D(sigma, mean, N)

for i = 1 : N
    for j = 1 : N
        for k = 1 : N
            
            x = (N + 1)/2 - i;
            y = (N + 1)/2 - j;
            z = (N + 1)/2 - k;
        
            Gaussian_Matrix(i,j,k) = (1/((2*pi)^(3/2)*(sigma)^3)) * exp(-((x - mean)^2 + (y - mean)^2 + (z - mean)^2)/(2*(sigma)^2));
        end
    end
end

output = Gaussian_Matrix;