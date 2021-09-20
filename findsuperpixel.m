function [prediction, absMax, absMin] = findsuperpixel(M, ima, model, pre_index, siz)

prediction = zeros(1,siz)';
absMax = -inf; %initials
absMin = 1;
for l=1:siz   % find the each partition prediction
    k = M ~= l;
    o = M*0;
    o(k) = 1;
    o = uint8(o);
    d = ima.*o;
    
    predicted = predict(model,d);
    predicted = predicted(pre_index);
    prediction(l)=predicted;
    
    if predicted > absMax
        absMax = predicted;
    end
    if predicted < absMin
        absMin = predicted;
    end
end
end


