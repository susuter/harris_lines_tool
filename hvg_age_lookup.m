function age = hvg_age_lookup(hl, table)


num_ages = size(table, 1);
for i = 1:num_ages
    if (hl <= table(i, 1))
        age = table(i, 2);
    break;
    end
end
