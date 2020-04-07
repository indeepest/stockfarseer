function res = dz_dezscore(data,para)
    res = data .* para.sig + para.mu;
end
