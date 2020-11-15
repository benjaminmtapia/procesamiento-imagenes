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
%e sensibilidad de borde
%t balance de ruido y especifica bordes
%fi controla la transicion de bordes

sigma = 0.9; %desviacion estandar, grosor del borde
k = 1.6; %recomendado en el enunciado
e = -0.1;
T = 0.99;
fi = 100; %calcula el grosor, the boldness
%XDoG (Imagen, desviacion, e, gamma, fi, nombre grafico)
%entonces: la desviacion marca mas los bordes, e ve

%}
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
Einstein_Threshold = XDoG(I4,1,0.03,0.94,80,'Einstein XDoG');

plotAndSave(I1,Tigre_XDoG,Tigre_Threshold,'Tigre');
plotAndSave(I2,Siberiano_XDoG,Siberiano_Threshold,'Siberiano');
plotAndSave(I3,Mujer_XDoG,Mujer_Threshold,'Mujer');
plotAndSave(I4,Einstein_XDoG,Einstein_Threshold,'Einstein');

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
