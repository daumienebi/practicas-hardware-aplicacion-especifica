% Practica 10: Procesado en tiempo real (Chroma Key)
clear; close all; clc;

%% Seleccionar dispositivo de captura y resolucion
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

%% Seleccionar la imagen del nuevo fondo
nom_fondo = input('Imagen del nuevo fondo [im21.jpg]: ', 's');
if isempty(nom_fondo)
    nom_fondo = 'im21.jpg';
end
while ~exist(nom_fondo, 'file')
    disp('El fichero no existe');
    nom_fondo = input('Imagen del nuevo fondo: ', 's');
end
A_fondo = im2double(imread(nom_fondo));

%% Capturar una imagen que contenga unicamente el fondo que se desea eliminar
preview(cam);
input('Pulsa Enter para capturar el fondo que se desea eliminar...');
fondo_eliminar = im2double(snapshot(cam));
[filas, columnas, ~] = size(fondo_eliminar);

% Ajustar tamano del nuevo fondo y comprobar que no hay valores fuera de rango
nuevo_fondo = imresize(A_fondo, [filas columnas]);
nuevo_fondo = max(min(nuevo_fondo, 1), 0);

Rf = fondo_eliminar(:,:,1);
Gf = fondo_eliminar(:,:,2);
Bf = fondo_eliminar(:,:,3);

Rn = nuevo_fondo(:,:,1);
Gn = nuevo_fondo(:,:,2);
Bn = nuevo_fondo(:,:,3);

%% Pedir numero de imagenes y velocidad de reproduccion del video final
n = input('Numero de imagenes a capturar [100]: ');
if isempty(n)
    n = 100;
end
fps_reproduccion = input('Velocidad de reproduccion del video final (fps) [24]: ');
if isempty(fps_reproduccion)
    fps_reproduccion = 24;
end

salida = 'chroma_tiempo_real.avi';
Wobj = VideoWriter(salida);
set(Wobj, 'FrameRate', fps_reproduccion);
open(Wobj);

%% Proceso del efecto chroma en tiempo real para cada fotograma
umbral = 0.25;
figure
inicio = tic;

for i = 1:n
    frame1 = im2double(snapshot(cam));
    R = frame1(:,:,1);
    G = frame1(:,:,2);
    B = frame1(:,:,3);

    % Distancia de color respecto al fondo capturado
    dist = abs(R - Rf) + abs(G - Gf) + abs(B - Bf);
    alpha = imbinarize(dist, umbral);
    alpha = imfill(alpha, 'holes');
    alpha = bwareaopen(alpha, 100);

    % Composicion con el nuevo fondo
    Rc = R .* alpha + Rn .* (1 - alpha);
    Gc = G .* alpha + Gn .* (1 - alpha);
    Bc = B .* alpha + Bn .* (1 - alpha);
    frame2 = cat(3, Rc, Gc, Bc);

    writeVideo(Wobj, frame2);

    subplot(1,2,1), imshow(frame1), title(['Frame capturado #' num2str(i)])
    subplot(1,2,2), imshow(frame2), title('Frame procesado')
    drawnow
end

tiempo_total = toc(inicio);
closePreview(cam);
close(Wobj);
delete(cam);

%% Calcular rendimiento del sistema y aceleracion del video final
fps_sistema = n / tiempo_total;
aceleracion = fps_reproduccion / fps_sistema;

disp(['Tiempo total: ' num2str(tiempo_total, '%.4f') ' s'])
disp(['Rendimiento del sistema: ' num2str(fps_sistema, '%.2f') ' fps'])
disp(['Velocidad de reproduccion: ' num2str(fps_reproduccion) ' fps'])
disp(['Aceleracion del video final: ' num2str(aceleracion, '%.2f')])
