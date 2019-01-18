lnoise = 1;
normalize = @(x) x/sum(x);

gaussian_kernel = normalize(...
    exp(-((-ceil(5*lnoise):ceil(5*lnoise))/(2*lnoise)).^2));