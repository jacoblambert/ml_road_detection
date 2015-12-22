% Make SVM tables
A=[0.05:0.05:0.7]';

for i = 1:5
matrix = zeros(14,4);
matrix(:,1)=A;
matrix(:,2:4)=SVM_error(1:14,:,i);
filename=sprintf('out%i.tex',i);
rowLabels = {'$\lambda_{training}$','um','umm','uu'};
matrix2latex(matrix, filename, 'format', '%-6.3f');
end