function age = byers_age_lookup(hl, table)
%hl = percentage of occurence of harris line in distal adult diaphyses

do_return = false;
num_ages = size(table, 1);

if (hl < table(1, 1))
   age = 0;
   do_return = true;
end
if (hl >= table(num_ages, 1))
   age = table(num_ages, 2);
   do_return = true;
end

for i = 1:num_ages-1
   p1 = table(i, 1);
   p2 = table(i+1, 1);
   if (hl >= p1 && hl <= p2)
       m = (p1 + p2) / 2;
       if (hl < m)
           age = table(i, 2);
       else
           age = table(i+1, 2);
       end
       do_return = true;
   end
   if (do_return)
       break;
   end
end