function [labels,numlabels] = SLICO(img,showImgs)
% GetSP computes superpixels using SLICO for a grayscale or RGB 'img'
% showImg = 1 if you want it to show figures

[labels,numlabels] = slicomex(img,800);

if showImgs == 1
% show image before superpixels
    figure(1)
    imagesc(img)
% show image superpixel labels
    figure(2)
    imagesc(labels)
% show the superpixel borders
    border_img = superpixelBorder(img,labels);
    figure(3)
    imagesc(border_img)
end

end