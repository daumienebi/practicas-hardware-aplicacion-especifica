% =========================================================================
% RETO 1: CONTEO DE MONEDAS DE EURO
% =========================================================================
clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentación: Separar fondo y objetos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('im00.jpg');
I_gray = rgb2gray(I);

% Binarizar, invertir máscara y limpiar ruidos/huecos
umbral = graythresh(I_gray);
BW = not(imbinarize(I_gray, umbral));
BW_rellena = imfill(BW, 'holes');
BW_limpia = bwareaopen(BW_rellena, 100);

% Etiquetar objetos detectados
[L, num_objetos] = bwlabel(BW_limpia);

% Visualizar segmentación
figure('Name', 'Resultados Intermedios Reto 1');
subplot(1,2,1), imshow(BW_limpia), title('Máscara Limpia');
L_norm = mat2gray(L);
subplot(1,2,2), imshow(L_norm), title('Objetos etiquetados (Falso Color)');
colormap(jet(num_objetos + 1));
colorbar;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracción de Descriptores (Geometría, Textura y Color)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Descriptores Geométricos
rprop_geo = regionprops(L, 'BoundingBox', 'Area', 'Perimeter');