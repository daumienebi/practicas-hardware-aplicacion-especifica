%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETO 1: CONTEO DE MONEDAS DE EURO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentación: Separar fondo y objetos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = im2double(imread('im00.jpg'));
ImagenHSV = rgb2hsv(I);
I_gray = rgb2gray(I);

% Binarizar, invertir máscara y limpiar ruidos/huecos y mostramos pasos
% intermedios
umbral = graythresh(I_gray);
BW = not(imbinarize(I_gray, umbral));
BW_rellena = imfill(BW, 'holes');
BW_limpia = bwareaopen(BW_rellena, 100);

% Operación morfológica para suavizar bordes y arreglar el perímetro
se = strel('disk', 5); % Creamos un disco de radio 5
BW_limpia = imclose(BW_limpia, se); % El cierre suaviza el contorno

figure('Name', 'Pasos intermedios');
% Mostrar el BW_rellena
subplot(1,2,1);
imshow(BW_rellena);
title('BW Rellena');
% Mostrar el BW_limpia
subplot(1,2,2);
imshow(BW_limpia);
title('BW Limpia');

% Etiquetar objetos detectados
[L, num_objetos] = bwlabel(BW_limpia);

% Visualizar segmentación
figure('Name', 'Resultados Intermedios Reto 1');
subplot(1,2,1), imshow(BW_limpia), title('Máscara Limpia');
L_norm = mat2gray(L);
subplot(1,2,2), imshow(L_norm), title('Objetos etiquetados (Falso Color)');
colormap(jet(num_objetos + 1));
colorbar;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcular el factor de forma y la media del los valores de canalH
% para cada objeto detectado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rprop_geo = regionprops(L, 'Area', 'Perimeter');

% Usamos el canal H de la imagen y la media de todo eso seria la H que
% buscamos
canalH = ImagenHSV(:,:,1);
rprop_canalH = regionprops(L, canalH, 'PixelValues');

% Inicializamos vectores para guardar los resultados
factor_forma = zeros(1, num_objetos);
mediaCanalH = zeros(1, num_objetos);
area_obj = zeros(1,num_objetos);
for i = 1:num_objetos
    % F = (4 * pi * Area) / Perimetro^2
    area = rprop_geo(i).Area;
    perimetro = rprop_geo(i).Perimeter;
    factor_forma(i) = (4 * pi * area) / (perimetro^2);
    % Almacenamos el area para utilizarlo luego para su identificación
    area_obj(i) = area;

    % Cálculo de la media del canal H ya que eso nos indica el color de
    % cada uno de los objetos y de ahi podemos pillar el de la moneda
    valores = rprop_canalH(i).PixelValues;
    %obtener la media de cada uno de los objetos
    mediaCanalH(i) = mean(valores);
end

%Visualizamos los valores de la media del canal H para poder ver mas o
%menos que valor tendrán las monedas en su eje Y
figure('Name', 'Factor forma y media del canal H de los objeetos ');
% Ver el grafico con la media de canalH de cada objeto
subplot(1,2,1);
stem(mediaCanalH);
title('Media del canal H de cada uno de los objetos');
xlabel('Nº Objeto');
% Ver el grafico con el factor forma de cada objeto
subplot(1,2,2);
stem(factor_forma);
title('Factor forma de cada uno de los objetos');
xlabel('Nº Objeto');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Señalar los objetos que sean de euro y los identificamos tambien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Detección de las monedas Euro');
imshow(I);
title('Monedas de Euro');
rprop = regionprops(L, 'BoundingBox', 'Centroid');
contador = 0;
% Necesitamos clasificar los distintos tipos de monedas

for i = 1:num_objetos
    % Comprobamos la forma y el color
   if factor_forma(i) >= 0.95 && (mediaCanalH(i) < 0.161675)
        caja = rprop(i).BoundingBox;
        rectangle('Position', caja, 'EdgeColor', 'y', 'LineWidth', 3);
        centro = rprop(i).Centroid;
        % Para poder identificar cada uno, nos basamos en el area
        area_moneda = area_obj(i);
        if area_moneda < 31000
            valor = 0.1;
        elseif area_moneda < 40000
            valor = 0.2;
        else
            valor = 0.5;
        end
        text(centro(1), centro(2), num2str(valor), 'Color', 'w', 'FontSize', 12, ...
        'FontWeight', 'bold');
    end
end