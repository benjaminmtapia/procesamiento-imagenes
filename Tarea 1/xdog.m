%aplicacion de Gaussian filter (G)
%Se aplica en dos casos, una con sigma, y otra con sigma y k
%la funcion de matlab solo pide el parametro sigma, que representa la
%desviacion estandar
%epsilon corresponde a la sensibilidad
%gamma cambia el peso de la diferencia de filtros, es decir se encarga de
%la intensidad de diferencia de tonos

I1 = imread('tigre.png');
I2 = imread('siberiano.png');
I3 = imread('mujer.png');
I4 = imread('Einstein.png');
sigma = 0.9; 
k = 1.6; %recomendado en el enunciado
e = -0.1;
T = 0.99;
fi = 100; %calcula el grosor, the boldness


%XDoG (Imagen, desviacion, e, gamma, fi, nombre grafico)
% sigma es la densidad de borde
% fi es el nivel de binarizacion
% e es el umbral
% T es la nitidez

%Tigre 

Tigre_XDoG = XDoG(I1,1,-0.1,0.99,90,'Tigre XDoG');
Tigre_Threshold = XDoG(I1,1,0.03,0.91,80,'Tigre Threshold');

%Siberiano
Siberiano_XDoG = XDoG(I2,1.5,0.0001,0.97,80,'Siberiano XDoG');
Siberiano_Threshold = XDoG(I2,1.3,0.03,0.95,100,'Siberiano Threshold');

%Mujer
Mujer_XDoG = XDoG(I3,1,0.0005,0.98,230,'Mujer XDoG');
Mujer_Threshold = XDoG(I3,1.3,0.03,0.938,100,'Mujer Threshold');

%Einstein
Einstein_XDoG = XDoG(I4,1.4,0.0001,0.98,100,'Einstein XDoG');
Einstein_Threshold = XDoG(I4,1,0.03,0.94,80,'Einstein Threshold');

plotAndSave(I1,Tigre_XDoG,Tigre_Threshold,'Tigre');
plotAndSave(I2,Siberiano_XDoG,Siberiano_Threshold,'Siberiano');
plotAndSave(I3,Mujer_XDoG,Mujer_Threshold,'Mujer');
plotAndSave(I4,Einstein_XDoG,Einstein_Threshold,'Einstein');

%%PRUEBAS EXPERIMENTALES
%se realizan estas pruebas con la imagen del tigre para comprender que
%realiza cada parametro
%{
%cambiando desviacion estandar
Tigre_XDoG = XDoG(I1,0.5,-0.1,0.98,150,'XDoG');
Tigre_XDoG1 = XDoG(I1,1,-0.1,0.98,150,'XDoG');
Tigre_XDoG2 = XDoG(I1,2,-0.1,0.98,150,'XDoG');
Tigre_XDoG3 = XDoG(I1,3,-0.1,0.98,150,'XDoG');
Tigre_XDoG4 = XDoG(I1,4,-0.1,0.98,150,'XDoG');
%}
%{
%cambiando fi
%fi controla el balance de ruido y el orden del borde
Tigre_XDoG = XDoG(I1,0.5,-0.1,0.98,50,'XDoG');
Tigre_XDoG1 = XDoG(I1,1,-0.1,0.98,100,'XDoG');
Tigre_XDoG2 = XDoG(I1,2,-0.1,0.98,150,'XDoG');
Tigre_XDoG3 = XDoG(I1,3,-0.1,0.98,200,'XDoG');
Tigre_XDoG4 = XDoG(I1,4,-0.1,0.98,300,'XDoG');
%}
%{
%cambiando e
%e califica el ummbral y lo denso del efecto, si es menor a 0 hace calculo
%de contraste local
Tigre_XDoG4 = XDoG(I1,1,0.00001,0.98,150,'XDoG');
Tigre_XDoG5 = XDoG(I1,1,0.002,0.98,150,'XDoG'); %potencial threshold
Tigre_XDoG = XDoG(I1,0.5,-0.1,0.98,150,'XDoG');
Tigre_XDoG1 = XDoG(I1,1,0.003,0.98,150,'XDoG');
Tigre_XDoG2 = XDoG(I1,2,0.004,0.98,150,'XDoG');
Tigre_XDoG3 = XDoG(I1,3,0.005,0.98,150,'XDoG');
%}

function XDoG = XDoG(I,sigma,e,T,fi,label)
I = rgb2gray(I);
%se trabaja en double porque si no, no funciona tanh
I = im2double(I);
k=1.6;
g1 = imgaussfilt(I,sigma);
g2 = imgaussfilt(I,sigma*k);

Do = g1 - T*g2;

%se procede a calcular el Ex
x = size(Do,1);
y = size(Do,2);
Ex = Do;
for i=1:x
    for j=1:y
        if Do(i,j) < e
            Ex(i,j) = 1;
        else
            factor = fi * Do(i,j);
            Ex(i,j) = 1 + tanh(factor);
        end
        
        
    end
end

fileName = strcat(label,'.png');
XDoG = mat2gray(Ex);
imwrite(XDoG,fileName,'png');
end

function plotAndSave(image,xdog,thresholded,label)
xdogName = strcat(label, ' XDoG');
thresholdName = strcat(label,' Threshold');
xdogFile = strcat(label,'_result.png');
plot = figure,
subplot(1,3,1),imshow(image),title(label),
subplot(1,3,2),imshow(xdog),title(xdogName),
subplot(1,3,3),imshow(thresholded),title(thresholdName);
exportgraphics(plot,xdogFile);
end
