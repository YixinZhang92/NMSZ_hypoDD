% to get phase.dat for each year
for i = 1:20
    target_year = 1999+i;
    if target_year <= 2014
        year = num2str(target_year)
        pre_ph2dt_arc(year)
    else
        year = num2str(target_year)
        pre_ph2dt_hyp(year)
    end
end
