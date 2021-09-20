function [str2, str_h, str_m, str_l]=text_explanations(YPred, max_score, sorted_data, sorted_labels)
[sorted_data, new_indices] = sort(sorted_data, 'descend'); 

[~,topIdx] = maxk(sorted_data, 3);
sorted_labels = sorted_labels(new_indices); 
sorted_labels = categorical(sorted_labels);

high=sorted_data(sorted_data>75);
low=sorted_data(sorted_data<50);
mid=[high; low];
mid=setdiff(sorted_data,mid);
 
str2 = compose("The model`s prediction is \n %s (%.2f).\n",YPred,max_score');
if length(high)==1
    if length(mid)==1
        str_h=compose("-The most important evidence is '%s'\n for the prediction. \n", sorted_labels(1));
        str_m=compose("-The '%s' is not an essential but \n contributing feature. \n", sorted_labels(2));
        if length(low)==2
            str_l=compose("-The '%s' and '%s' are\n not relevant for the prediction. \n", sorted_labels(3), sorted_labels(4));
        else
            str_l=compose("-The '%s', '%s', and '%s' are\n not relevant for the prediction. \n", sorted_labels(3), sorted_labels(4),sorted_labels(5));
        end        
    elseif isempty(mid)
        str_h=compose("-The most important evidence is '%s' \n for the prediction. \n", sorted_labels(1));
        str_m=compose("-The '%s' and '%s' are not\n so significant but contributing\n features. \n", sorted_labels(2), sorted_labels(3));
        str_l=compose("-The '%s' is not an relevant\n evidence for the prediction. \n", sorted_labels(4));
    else
        str_h=compose("-The most important evidence is\n '%s' for the prediction. \n", sorted_labels(1));
        str_m=compose("-The '%s', '%s', '%s', and '%s'\n are not essential but \n contributing features. \n", sorted_labels(2), sorted_labels(3), sorted_labels(4), sorted_labels(5));
        str_l=compose("-The '%s' is not an relevant\n evidence for the prediction. \n", sorted_labels(6));    
            if isempty(low)
                str_l=compose(" ");
            end
    end
elseif length(high)==2
    
    if length(mid)==1
        str_h=compose("-The most important evidences are\n '%s' and '%s' for the prediction. \n", sorted_labels(1),...
            sorted_labels(2));
        str_m=compose("-The '%s' is not so significant but \n contributing feature. \n", sorted_labels(3));
        if length(low)<=2
            str_l=compose("-The '%s' is not relevant\n for the prediction. \n", sorted_labels(3));
        else
            str_l=compose("-The '%s', '%s, and '%s' are not\n relevant features for the prediction. \n", sorted_labels(4), sorted_labels(5), sorted_labels(6));
        end
    elseif isempty(mid)
        str_h=compose("-The most important evidences are\n '%s' and '%s' for the prediction. \n", sorted_labels(1),...
        sorted_labels(2));
        str_m=compose(" ");
        str_l=compose(" ");
    else
        str_h=compose("-The most important evidences are\n '%s' and '%s' for the prediction. \n", sorted_labels(1),...
        sorted_labels(2));
        str_m=compose("-The '%s' and '%s' are not\n essential but contributing\n features. \n", sorted_labels(3),sorted_labels(4));
        str_l=compose("-The '%s' is not a significant\n evidence for the prediction. \n", sorted_labels(5));
    end
else
    if length(mid)==1
        str_h=compose("-The most important evidences are\n '%s', '%s' and '%s' for the prediction. \n", sorted_labels(1),...
        sorted_labels(2), sorted_labels(3));
        str_m=compose("-The '%s'is not an essential but \n contributing feature. \n", sorted_labels(4));
        str_l=compose("-The '%s' is not a significant\n evidence for the prediction. \n", sorted_labels(5));   
    else
        str_h=compose("-The most important evidences are\n '%s', '%s' and '%s' \nfor the prediction. \n", sorted_labels(1),...
            sorted_labels(2), sorted_labels(3));
        if isempty(mid)
            str_m=compose(" ");
            str_l=compose(" ");
        else
            str_m=compose("-The '%s' and '%s' are not\n essential but \n contributing features. \n", sorted_labels(4),sorted_labels(5));
            str_l=compose("-The '%s' is not an relevant\n evidence for the prediction. \n", sorted_labels(6));
        end
    end
end
