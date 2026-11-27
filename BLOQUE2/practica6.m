% Práctica 6 : Captura de imágenes
% El usuario debe selecciona algunos detalles de configuracion de la cámara
% a través de la consola de comandos ante de seguir

%% Seleccionar un dispositivo de todos los disponibles
disp('Dispositivos detectados:')
info = webcamlist;
nDEV = size(info,1);
for i = 1:nDEV
 nombre = info{i};
 disp(['[' num2str(i) '] ' nombre])
end
dID = input('> Selecciona dispositivo: [1]? ');
if(isempty(dID))
 dID = 1;
end
%% Menú de opciones para escoger la resolución de la imagen capturada

% Seleccionamos el webcam teniendo en cuenta la elección del usuario
cam = webcam(dID);
formatosDisponibles = cam.AvailableResolutions;
nResoluciones = size(formatosDisponibles,2); %2 para acceder a las columnas
for i = 1:nResoluciones
    nombreResolucion = formatosDisponibles{i};
    disp(['[' num2str(i) ']' nombreResolucion])
end
rID = input('> Selecciona la resolución :');
if(isempty(rID))
    rID = 1;
end
formato = cam.AvailableResolutions{rID};
% asignamos el formato a la camara
set(cam,"Resolution",formato);
%% Mostrar la información asociada al objeto de vídeo creado. 

get(cam)

%% Abrir una ventana de previsualización. 

preview(cam)

%% Capturar dos imágenes en tiempos distintos utilizando la función snapshot
pause % para que el usuario tenga que pulsar ENTER para sacar la foto
[frame1,timestamp1] = snapshot(cam);
disp(['imagen1 1 tomada en el instante ' num2str(timestamp1)])
imagen1 = im2double(frame1); % Almacenamos la imágen 1

pause
[frame2,timestamp2] = snapshot(cam);
disp(['Imágen 2 tomada en el instante ' num2str(timestamp2)])
imagen2 = im2double(frame2); % Almacenamos la imágen 2

% Cerramos el preview tras tomar las imagenes
closePreview(cam)
delete(cam)
%% Mostrar las dos imágenes capturadas.
figure('Name', 'Imágenes originales capturadas');
subplot(1,2,1);
imshow(imagen1);
title("Imágen 1");
subplot(1,2,2);
imshow(imagen2);
title("Imágen 2");

%% Señalar con un rectángulo de área mínima las diferencias entre ambas imágenes. 

% Primero pasamos las imagenes a gris, sabemos que al utilizar el
% webcamobject, siempre serán capturados en RGB
imagen1_gris = rgb2gray(imagen1);
imagen2_gris = rgb2gray(imagen2);
figure('Name', 'Imágenes en gris y la mascara creada');
subplot(2,2,1);
imshow(imagen1_gris);
title("Imágen 1 en gris");
subplot(2,2,2);
imshow(imagen2_gris);
title("Imágen 2 en gris");

% Restamos las dos imagenes en gris y ahi podremos observar las
% diferencias; todo lo que no haya cambiado tendrá un valor de 0 y los
% demás serán valores distintos de cero
mascara = abs(imagen1_gris - imagen2_gris);
subplot(2,2,3);
imshow(mascara);
title("Máscara inicial")

% Creamos un umbral para poder decidir que elementos han cambiado o no
umbral = 0.15;
mascara_bin = mascara > umbral;
subplot(2,2,4);
imshow(mascara_bin);
title("Máscara limpia");

% Eliminamos objetos pequeños de ruido
mascara_limpia = bwareaopen(mascara_bin, 100);

% Unimos regiones cercanas y rellenamos agujeros
se = strel('disk', 5);
mascara_limpia = imclose(mascara_limpia, se);
mascara_limpia = imfill(mascara_limpia, 'holes');

%mostramos la diferencia

[L, nDiff] = bwlabel(mascara_limpia);
rprop = regionprops(L, 'BoundingBox');
figure;
imshow(imagen2);
title(['Cambios detectados: ' num2str(nDiff)]);

for i = 1:nDiff
    caja = rprop(i).BoundingBox;
    rectangle('Position', caja, 'EdgeColor', 'y', 'LineWidth', 2);
end
%%
