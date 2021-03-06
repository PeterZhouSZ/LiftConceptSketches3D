function [inds_strks_zero_cnddts, strokes_topology, intersections ] =  ...
                cleanUpTree(cur_stroke, ...
                            strokes_topology, ...
                            intersections,...
                            candidate_line_all_configurations)
            
    inds_strks_zero_cnddts = [];
    strks_cleaned = [];
    
    for j = 1:length(cur_stroke.inds_intrsctns_eval_mltpl_cnddts)
        
       ind_intrsctn_update = cur_stroke.inds_intrsctns_eval_mltpl_cnddts(j);
       ind_intrsctng_strk =  cur_stroke.inds_intrsctng_strks_eval_mltpl_cnddts(j);


        if ~isfield(strokes_topology(ind_intrsctng_strk), 'candidate_lines') || ...
                isempty(strokes_topology(ind_intrsctng_strk).candidate_lines)
        
            inds_strks_zero_cnddts(end+1) = ind_intrsctng_strk;
            continue;
        end
           % Update stuctures
           try
               [strokes_topology, ...
               intersections, ...
               strks_cleaned_] = removeNonFeasibleIntersectionPositions(...
                    strokes_topology, ...
                    intersections,...
                    candidate_line_all_configurations,... % the optimal candidate line (with all configurations)
                    cur_stroke,...
                    ind_intrsctn_update,...
                    ind_intrsctng_strk);
                strks_cleaned = unique([strks_cleaned, strks_cleaned_]);
           catch e
              rethrow(e);
           end
    end
    
    
     %% Clean 
    for iclean = strks_cleaned
        ind_cnddt_lns_remove = [];
        for i = 1:length(strokes_topology(iclean).candidate_lines)
            if isempty(strokes_topology(iclean).candidate_lines(i).configurations)
                ind_cnddt_lns_remove(end+1) = i;                    
            end
        end

        strk_edit = strokes_topology(iclean);
        strk_edit.ind = iclean;
        UP_TO_LAST = true;
        [strk_edit.inds_intrsctns_eval,...
         strk_edit.inds_intrsctns_eval_actv,...
         strk_edit.inds_intrsctns_eval_mltpl_cnddts,...
         strk_edit.inds_intrsctng_strks_eval,...
         strk_edit.inds_intrsctng_strks_eval_actv,...
         strk_edit.inds_intrsctng_strks_eval_mltpl_cnddts] = ...
            returnIndicesNodesTypes(strk_edit, ...
                                cat(1, strokes_topology(:).depth_assigned),...
                                            intersections,...
                                            UP_TO_LAST);


        if ~isempty(ind_cnddt_lns_remove)
            [strokes_topology, intersections] = ...
                        removeCandidateLine(strokes_topology, ...
                                            strk_edit,...
                                            ind_cnddt_lns_remove,...
                                            intersections);
        end
    end
end  