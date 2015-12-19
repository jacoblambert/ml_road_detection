function [border_img] = superpixelBorder(img,labels)
% Shows the boundaries of the superpixels computed by SLICO (denoted by labels) 
% on the img.

N = size(labels,1);
M = size(labels,2);
border_img = img;

% Loop left-right
for i=1:N
    for j=1:(M-1)
        if labels(i,j)~=labels(i,j+1)
            border_img(i,j,:)=0;
            try
            border_img(i,j-1,:)=0;
            end
        end
    end
end

% Loop up-down

for j=1:M
    for i=1:(N-1)
        if labels(i,j)~=labels(i+1,j)
            border_img(i,j,:)=0;
            try
            border_img(i-1,j,:)=0;
            end
        end
    end
end
        

end

