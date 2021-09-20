load('test\2008_002760.mat', 'LabelMap')
% load('C:\Users\sulea\Desktop\dataset\trainval\2008_000415.mat', 'LabelMap')
net = googlenet('Weights','places365');

% net = googlenet;
% net = resnet18;

label = 'labels.xlsx';
[numlabels,str] = xlsread(label);

inputSize = net.Layers(1).InputSize(1:2);
classes = net.Layers(end).Classes;

I = imread("test\2008_002760.jpg");
% I = imread("C:\Users\sulea\Desktop\VOC2010\JPEGImages\2008_000415.jpg");
I = imresize(I,inputSize);
figure;
imshow(I);


[YPred,scores] = classify(net,I);
[~,topIdx] = maxk(scores, 20);
topScores = scores(topIdx);
topClasses = classes(topIdx);
max_score = max(scores);
YPred2=topClasses(2);
pre_index = find(max_score==scores);
% pre_index = 104;
max_score2=topScores(2);

labels = zeros(inputSize);
labels = uint8(labels);
 
L = imresize(LabelMap, [224,224], 'nearest');
B = labeloverlay(I, L, 'Transparency',0.5);

num2=unique(L);
siz = size(num2,1);

BW = boundarymask(L);
BL = imoverlay(I,BW,'black');

for l=1:siz
    k = L == num2(l);
    o = L*0;
    o(k) = l;
    o = uint8(o);
    labels = labels+o;
end

[predictions, absMax, absMin]=findsuperpixel(labels, I, net, pre_index,siz);
absMax=round(absMax,2);
absMin=round(absMin,2);
predictions=round(predictions,2);

[map, d, CI, masked]=saliencymap(labels, I, predictions, absMax, absMin, siz);

map = uint16(map);
labelmap=map;
mask = boundarymask(map);
maskin=find(mask);
labelmap(maskin)=1;
labelim=label2rgb(labelmap,'bone');

mask_in=find(masked==1);
[rows, columns]=find(masked==0);
masked = cast(masked, class(I));
maskedRgbImage = bsxfun(@times, I, cast(masked, class(I)));

siz = size(columns,1);
for l=1:siz
    maskedRgbImage(rows(l),columns(l),:)=[154 154 154];
end

CI_percent=CI*100;
context_labels = str(num2);
% context_labels2 = [context_labels2, num2cell(CI_percent, 2)];

zero_instaces=all(CI_percent,2);
out = CI_percent(zero_instaces,:);
inn=find(zero_instaces==0);
context_labels(inn) = [];

[sorted_data, new_indices] = sort(out); % sorts in *ascending* order
sorted_labels = context_labels(new_indices); 

figure
titleString = compose("Prediction %s (%.2f)",YPred,max_score');
sgtitle(sprintf(join(titleString, "; ")), 'FontSize', 9);
subaxis(1,3,1,'SpacingVert',0,'MR',0,'ML',0,'pl',0.01,'pr',0,...
              'SpacingHoriz',0,'pb',0,'MT',0,'PaddingTop',0); 
          
imshow(I);
subaxis(1,3,2,'SpacingVert',0,'MR',0,'ML',0,'pl',0.01,'pr',0,...
              'SpacingHoriz',0,'MT',0,'PaddingTop',0);
imshow(labelim);
f=subaxis(1,3,3,'SpacingVert',0,'MR',0,'ML',0,'pl',0,'pr',0,...
              'SpacingHoriz',0,'MT',0,'PaddingTop',0);
          
hBar=bar(1,sorted_data,'stacked','FaceColor','flat');
set(f,'Position',[.6559 .3329 .1304 .4348])

for i = 1:length(sorted_data)
  
    if sorted_data(i)>75
        hBar(i).CData = [0.2 0.2 0.2];
        hBar(i).EdgeColor = [0.2 0.2 0.2];
        hBar(i).EdgeAlpha=.1;
        hBar(i).FaceAlpha=.7;
    elseif sorted_data(i)>50
        hBar(i).CData = [0.5 0.6 0.6];
        hBar(i).EdgeColor = [0.5 0.6 0.6];
        hBar(i).EdgeAlpha=.1;
        hBar(i).FaceAlpha=.7;
    else
        hBar(i).CData = [0.8 0.9 0.9];
        hBar(i).EdgeColor = [0.8 0.9 0.9];
        hBar(i).EdgeAlpha=.1;
        hBar(i).FaceAlpha=.7;
    end
    
end

set(gca,'box','off')
set(gca,'XColor','none','TickDir','out')
set(gca,'YColor','none','TickDir','out')
set(gca,'xtick',[])
set(gca,'ytick',[])

barbase = cumsum([zeros(size(sorted_data',1),1) sorted_data(1:end-1,:)'],2);
joblblpos = sorted_data/2 + barbase;
x = zeros(i,1) + 0.9;
x2 = zeros(i,1) + 1.2;
text(x, joblblpos(1,:), sorted_labels, 'HorizontalAlignment','center', 'FontSize', 7)
text(x2, joblblpos(1,:), num2str(sorted_data,'  %g%%'), 'HorizontalAlignment','center', 'FontSize', 7)
pbaspect([0.8 2 2])
print(gcf,'im1.png','-dpng','-r400');

 [str2, str4, str_m, str_l]=text_explanations(YPred, max_score, sorted_data, sorted_labels);

figure
titleString = compose("Prediction (%.2f)",topScores(1)'); %max_score topScores(10)
sgtitle(sprintf(join(titleString, "; ")), 'FontSize', 9);
subaxis(1,2,1,'SpacingVert',0,'MR',0,'ML',0,'pl',0.01,'pr',0,...
              'SpacingHoriz',0,'pb',0, 'MT',0); 
          
imshow(maskedRgbImage);
subaxis(1,2,2,'SpacingVert',0,'MR',0,'ML',0,'pl',0.01,'pr',0.01,...
              'SpacingHoriz',0, 'MT',0);
set(gca,'Position',[.5086 .2262 .48 .65])
dim = [.5179 .2619 .4575 .5838];

str4=join(str4);
str3 = {str2,str4,str_m,str_l};
annotation('textbox',dim,'String',str3,'FitBoxToText','on','EdgeColor','white');

set(gca,'box','off')
set(gca,'XColor','none','TickDir','out')
set(gca,'YColor','none','TickDir','out')
set(gca,'xtick',[])
set(gca,'ytick',[])
print(gcf,'im2.png','-dpng','-r400');  
         

