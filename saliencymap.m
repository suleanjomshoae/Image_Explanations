function [map3, d, CI, masked]= saliencymap(M, ima, predictions, absMax, absMin, siz)
d=absMax-predictions;
CI= zeros(1,siz)';
abs=(absMax-absMin);
for j = 1:siz
    if d(j) == 0 && abs==0
        CI(j) = 0.001/0.001;
        CI(j)=round(CI(j),2);
        
    elseif d(j) == 0
        CI(j) = 0.001/abs;
        CI(j)=round(CI(j),2);
    else
        CI(j) = d(j)/abs;
        CI(j)=round(CI(j),2);
    end
end

map3=zeros(224,224);
map3=uint8(map3);

masked=zeros(224,224);
masked=uint8(masked);

for l=1:siz   % find the superpixel for the map
    m = M == l;
    p = M*0;
    p(m) = 1;
    p = uint8(p);
    part = ima.*p;

    if CI(l) >= 0.75 && CI(l) <= 1
        part1 = rgb2gray (part);
        masked = masked+p;
         
        if CI(l) >= 0.95 && CI(l) <= 1
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=2;
            map3=map3+labelim;
        else
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=3;
            map3=map3+labelim;
        end
    elseif CI(l) < 0.75 && CI(l) >= 0.50
        part1 = rgb2gray (part);
        masked = masked+p;
       if CI(l) < 0.75 && CI(l) >= 0.70
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=4;
            map3=map3+labelim;
            
       elseif CI(l) < 0.70 && CI(l) >= 0.65
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=5;
            map3=map3+labelim;
            
       else
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=6;
            map3=map3+labelim;
           
        end
        
    else
        part1 = rgb2gray (part);
               
        if CI(l) < 0.50 && CI(l) >= 0.45
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=7;
            map3=map3+labelim;

        elseif CI(l) < 0.45 && CI(l) >= 0.35
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=8;
            map3=map3+labelim;
        elseif CI(l) < 0.35 && CI(l) >= 0.20
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=9;
            map3=map3+labelim;
        else
            labelim = part1;
            labelin = find(labelim);
            labelim(labelin)=10;
            map3=map3+labelim;
        end
        
    end
end
end
