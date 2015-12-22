axis equal
% axis([0 size(img,2) 0 size(img,1)])
axis off
filename = sprintf('/home/spaceape/Documents/Courses/CSC2515/csc2515_project/tex/figs/SVM_result.pdf');
export_fig(gcf, filename, '-transparent');