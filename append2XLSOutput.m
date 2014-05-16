function append2XLSOutput(hasEpiphyses)
% compute results for all available methods. 
% results need to be recomputed (1 for juveniles, 3 for adults)
% tibia length
% filename (select with save as dialog)

global AGE SEX AGE_GROUP IND_NAME LEFT_SIDE STATURE TOT_LENGTH XLS_OUT GRAVE SITE DATE;

distEpi = computeDistancesToEpiphyes();
start = size(XLS_OUT, 1);

if (hasEpiphyses)
   results_maat = computeMaat()';
   results_clarke = computeClarke()';
   results_byers = computeByers()';
   size_distal = size(results_maat, 1);
   size_byers = size(results_byers, 1);
   start_distal = size_byers - size_distal+1;
   
   for row = 1:size_byers
        idx = start + row ;
        XLS_OUT(idx, 1) = {IND_NAME};
        XLS_OUT(idx, 2) = {GRAVE};
        XLS_OUT(idx, 3) = {SITE};
        XLS_OUT(idx, 4) = {DATE};
        XLS_OUT(idx, 5) = {AGE};
        XLS_OUT(idx, 6) = {SEX};
        if (LEFT_SIDE)
             XLS_OUT(idx, 7) = {'l'};
        else
            XLS_OUT(idx, 7) = {'r'};
        end
        XLS_OUT(idx, 8) = {STATURE};
        XLS_OUT(idx, 9) = {TOT_LENGTH};
        XLS_OUT(idx, 10) = {distEpi(row, 1)};
        if (row >= start_distal)
            XLS_OUT(idx, 11) = {'distal'};
            XLS_OUT(idx, 12) = {results_byers(row, 1)};
            XLS_OUT(idx, 13) = {results_maat(row-start_distal+1, 1)};  
            XLS_OUT(idx, 14) = {results_clarke(row-start_distal+1, 1)};
        else
            XLS_OUT(idx, 11) = {'proximal'};          
            XLS_OUT(idx, 12) = {results_byers(row, 1)};
        end
   end
else
   results_juveniles = computeHvgJuveniles()';
   size_juv = size(results_juveniles, 1);
  
   for row = 1:size_juv-1
       idx = start + row ;
       XLS_OUT(idx, 1) = {IND_NAME};
       XLS_OUT(idx, 2) = {GRAVE};
       XLS_OUT(idx, 3) = {SITE};
       XLS_OUT(idx, 4) = {DATE};
       XLS_OUT(idx, 5) = {cell2mat(AGE_GROUP)};
       XLS_OUT(idx, 6) = {SEX};
        if (LEFT_SIDE)
             XLS_OUT(idx, 7) = {'l'};
        else
            XLS_OUT(idx, 7) = {'r'};
        end
       XLS_OUT(idx, 8) = {STATURE};
       XLS_OUT(idx, 9) = {TOT_LENGTH};
       XLS_OUT(idx, 10) = {distEpi(row, 1)};
       XLS_OUT(idx, 11) = {'distal'};
       XLS_OUT(idx, 15) = {results_juveniles(row, 1)};
   end
end