function result = hvg_lookup(age, hl)
%...

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


result = 0;
if (strcmp(age,'1'))
    table = [69.4, 0.5; 100, 1];
    result = hvg_age_lookup(hl, table);
else
    if (strcmp(age,'2'))
        table = [54.2, 0.5; 78.1, 1; 100, 2];
        result = hvg_age_lookup(hl, table);
    else
        if (strcmp(age,'3'))
            table = [46.4, 0.5; 66.8, 1; 85.5, 2; 100, 3];
            result = hvg_age_lookup(hl, table);
        else 
            if (strcmp(age,'4'))
                table = [42.1, 0.5; 60.6, 1; 77.5, 2; 90.7, 3; 100, 4];
                result = hvg_age_lookup(hl, table);
            else 
                if (strcmp(age, '5'))
                    table = [38.5, 0.5; 55.5, 1; 71, 2; 83.1, 3; 91.6, 4; 100, 5];
                    result = hvg_age_lookup(hl, table);  
              else
                    if (strcmp(age, '6-7'))
                        table = [33, 0.5; 47.7, 1; 61.1, 2; 71.5, 3; 78.8, 4; 86, 5; 100, 7];
                        result = hvg_age_lookup(hl, table);
                    else
                        if (strcmp(age,'8-9')) 
                            table = [29.1, 0.5; 41.9, 1; 53.6, 2; 62.7, 3; 69.1, 4; 75.5, 5; 87.7, 7; 100, 9];
                            result = hvg_age_lookup(hl, table);
                        else
                            if (strcmp(age, '10-11'))
                            table = [27.8, 0.5; 40, 1; 51.3, 2; 60, 3; 66.1, 4; 72.2, 5; 83.9, 7; 95.6, 9; 100, 11];
                            result = hvg_age_lookup(hl, table);
                            else 
                                if (strcmp(age, '12-13'))
                                    table = [23.9, 0.5; 34.4, 1; 44, 2; 51.5, 3; 56.8, 4; 62, 5; 72.1, 7; 82.1, 9; 85.9, 11; 100, 13];
                                    result = hvg_age_lookup(hl, table);
                              	else
                                    if (strcmp(age,'14-16'))
                                        table = [20.2, 0.5; 29.1, 1; 37.2, 2; 43.5, 3; 48, 4; 52.4, 5; 60.9, 7; 69.4, 9; 72.6, 11; 84.5, 13; 100, 16];
                                        result = hvg_age_lookup(hl, table);
                                    end
                                 end
                            end
                        end
                    end
                end
            end
        end
    end
end

if (result == 7)
    result = 6;
end
if (result == 9)
    result = 8;
end
if (result == 11)
    result = 10;
end
if (result == 13)
    result = 12;
end
if (result == 16)
    result = 14;
end



