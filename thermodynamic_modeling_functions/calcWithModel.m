function [x,y,gamma] = calcWithModel(T, p, par, modelInput)
    switch modelInput.name
        case 'nrtl'
            [x,y,gamma] = binary_Tp_flash(T, p, par, @nrtl, modelInput.A, modelInput.B, modelInput.C);
        case 'uniquac_sep'
            [x,y,gamma] = binary_Tp_flash(T, p, par, @uniquac_sep, modelInput.A, modelInput.B, modelInput.C, modelInput.r, modelInput.q);
        case 'uniquac_gl'
            [x,y,gamma] = binary_Tp_flash(T, p, par, @uniquac_gl, modelInput.A, modelInput.B, modelInput.C, modelInput.r, modelInput.q, modelInput.beta_i);
        otherwise
            error('Unknown model: %s', modelInput.name);
    end
end
