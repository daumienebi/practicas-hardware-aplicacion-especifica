% Practica 6: Captura de imagenes
clear; close all; clc;

%% Seleccionar dispositivo de captura
disp('Dispositivos detectados:')
info = webcamlist;
nDEV = size(info, 1);
for i = 1:nDEV
    nombre = info{i};
    disp(['[' num2str(i) '] ' nombre])
end
dID = input('> Selecciona dispositivo: [1]? ');
if isempty(dID)
    dID = 1;
end
cam = webcam(dID);

%% Seleccionar resolucion de la camara
disp('Resoluciones disponibles:')
res = cam.AvailableResolutions;
nRES = length(res);
for i = 1:nRES
    disp(['[' num2str(i) '] ' res{i}])
end
rID = input('> Selecciona resolucion: [1]? ');
if isempty(rID)
    rID = 1;
end
cam.Resolution = res{rID};

%% Informacion del objeto de video y previsualizacion
get(cam)
preview(cam);

%% Capturar dos imagenes en instantes distintos
input('Pulsa Enter para capturar la primera imagen...');
[img1, t1] = snapshot(cam);

input('Cambia la escena y pulsa Enter para capturar la segunda imagen...');
[img2, t2] = snapshot(cam);

closePreview(cam);
delete(cam);

%% Mostrar las dos imagenes capturadas
figure
subplot(1,2,1), imshow(img1), title(['Imagen 1 (t = ' num2str(t1, '%.2f') ' s)'])
subplot(1,2,2), imshow(img2), title(['Imagen 2 (t = ' num2str(t2, '%.2f') ' s)'])

%% Detectar y senalar las diferencias entre ambas imagenes
G1 = im2double(rgb2gray(img1));
G2 = im2double(rgb2gray(img2));

% Diferencia absoluta y umbralizacion
dif = abs(G2 - G1);
BW = imbinarize(dif, 0.15);

% Limpieza morfologica para aislar los objetos modificados
BW = imclose(BW, strel('disk', 8));
BW = imfill(BW, 'holes');
BW = bwareaopen(BW, 800);

[L, num] = bwlabel(BW);
rprop = regionprops(L, 'BoundingBox');

figure
subplot(1,2,1), imshow(img1), title('Primera captura')
subplot(1,2,2), imshow(img2), title(['Diferencias detectadas: ' num2str(num)])
for i = 1:num
    rectangle('Position', rprop(i).BoundingBox, 'EdgeColor', 'y', 'LineWidth', 2);
end
