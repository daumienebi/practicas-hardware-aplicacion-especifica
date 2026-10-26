% Práctica 4: Imágenes binarias

clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Selección de la imagen del blíster
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('im6.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mostrar la imagen y su histograma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Imagen original e Histograma');
subplot(1,2,1), imshow(I), title('Imagen original');
subplot(1,2,2), imhist(I), title('Histograma');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentar los objetos (pastillas) y visualizar resultados intermedios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
umbral = graythresh(I);
% Dado que las pastillas son oscuras y el fondo claro, imbinarize les asigna 0 (negro) y 1 al fondo.
% Usamos 'not' para invertir la máscara y que las pastillas pasen a ser los objetos de interés (1).
BW = not(imbinarize(I, umbral));

% Rellenar agujeros internos y limpiar ruido exterior
BW_rellena = imfill(BW, 'holes');
BW_limpia = bwareaopen(BW_rellena, 100);

figure('Name', 'Resultados Intermedios');
subplot(1,3,1), imshow(BW), title('Binarización inicial');
subplot(1,3,2), imshow(BW_rellena), title('Huecos rellenados');
subplot(1,3,3), imshow(BW_limpia), title('Máscara limpia');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualizar la matriz de etiquetas con mapa de color y barra de color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[L, num_objetos] = bwlabel(BW_limpia);
L_norm = mat2gray(L);

figure('Name', 'Matriz de Etiquetas');
imshow(L_norm);
colormap(jet(num_objetos + 1)); % El +1 asegura un color para el fondo (0)
colorbar;
title('Objetos etiquetados en falso color');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Señalar sobre la imagen original los objetos detectados y enumerarlos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rprop = regionprops(L, 'BoundingBox', 'Centroid');

figure('Name', 'Objetos Detectados');
imshow(I);
title('Pastillas detectadas');

% Utilizamos un bucle for para recorrer cada objeto detectado
for i = 1:num_objetos
    % Dibujar rectángulo de área mínima
    caja = rprop(i).BoundingBox;
    rectangle('Position', caja, 'EdgeColor', 'g', 'LineWidth', 2);
    
    % Obtener el centro y enumerar usando num2str
    centro = rprop(i).Centroid;
    text(centro(1), centro(2), num2str(i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ¿Cuántas ranuras horizontales hay? Mostrar imagen y señalarlas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inicializar imagen vacía y contador
[filas, columnas] = size(BW_limpia);
BW_ranuras = false(filas, columnas);
contador = 0;

% Filtrar ranuras horizontales
for i = 1:num_objetos
    caja = rprop(i).BoundingBox;
    ancho = caja(3);
    alto = caja(4);
    
    % Si el ancho es mayor que el alto, la consideramos ranura horizontal
    if ancho > alto
        contador = contador + 1;
        BW_ranuras = BW_ranuras | (L == i);
    end
end

disp(['Aproximadamente hay ', num2str(contador), ' ranuras horizontales.']);

% Visualizar según las dos instrucciones finales del enunciado
figure('Name', 'Ranuras Horizontales');

% Mostrar una imagen solo con las ranuras horizontales
subplot(1,2,1);
imshow(BW_ranuras);
title('Solo ranuras');

% Señalar sobre la imagen original
subplot(1,2,2);
imshow(I);
title('Ranuras en imagen original');

for i = 1:num_objetos
    caja = rprop(i).BoundingBox;
    % Comparamos el valor del ancho caja(3) con el alto caja(4) para poder
    % separar las ranurar horizontales
    if caja(3) > caja(4)
        rectangle('Position', caja, 'EdgeColor', 'g', 'LineWidth', 2);
    end
end