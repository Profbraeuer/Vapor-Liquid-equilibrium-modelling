function T = T_Antoine(p,A,B,C)
    T = B./(A-log10(p))-C;
end