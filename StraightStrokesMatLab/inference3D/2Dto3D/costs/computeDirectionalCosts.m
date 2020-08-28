function pDirectional = computeDirectionalCosts(candidate_lines,...
                                                direction_prior,...
                                                cur_stroke,...
                                                pairsInterInter,...
                                                strokes_topology,...
                                                intersections)
  global USEMAXDIR;

  
  num_lines = length(candidate_lines);
  pDirectional = cell(num_lines,1);
    
  if ismember(cur_stroke.line_group, 1:3)
        % Lines towards vanishing points:
        pAngle = probabilitiesAngle(cat(1,candidate_lines.dir), direction_prior);       
%         [pAngle, ind_sorted] = sort(pAngle, 'descend');
%         candidate_lines = candidate_lines(ind_sorted);

        for i = 1:num_lines
            for j = 1:length(candidate_lines(i).configurations)
                pDirectional{i}(j) = pAngle(i);
            end
        end
  elseif cur_stroke.line_group == 4
       % Lines with no prior on their direction
       
        for i = 1:num_lines 
            try
%                 fig_num = 11;
%                 num_plot = min(length(candidate_lines), 10);
%                 plotCandidateLines(candidate_lines(i), ...
%                                    strokes_topology, ...s
%                                    cur_stroke, ...
%                                    intersections, ...
%                                    fig_num);
                if USEMAXDIR
                    pDirectional{i} = computeCost3DGeometryNonAxesAligned_v2(...
                                            candidate_lines(i),...
                                            pairsInterInter,...
                                            strokes_topology,...
                                            intersections,...
                                            cur_stroke);
                else
                    pDirectional{i} = computeCost3DGeometryNonAxesAligned_smartAverage(...
                        candidate_lines(i),...
                        pairsInterInter,...
                        strokes_topology,...
                        intersections,...
                        cur_stroke);
                end
%    
%                 pDirectional{i} = computeCost3DGeometryNonAxesAligned_smartAverage(...
%                                         candidate_lines(i),...
%                                         pairsInterInter,...
%                                         strokes_topology,...
%                                         intersections,...
%                                         cur_stroke);
%                                     
            catch e
                rethrow(e);
            end
        end
  elseif (cur_stroke.line_group == 5)
        orth_dirction_prior = getDirectionVec(cur_stroke.ind_orth_ax);
        pAngle = computeScoreOrthogonality(cat(1,candidate_lines.dir), orth_dirction_prior);
        for i = 1:num_lines
            for j = 1:length(candidate_lines(i).configurations)
                pDirectional{i}(j) = pAngle(i);
            end
        end
      
  end

end