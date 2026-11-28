% Practica 7: Velocidad de adquisicion de imagenes
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

%% Abrir previsualizacion y capturar secuencia de imagenes
preview(cam);
n = input('Numero de imagenes a capturar [200]: ');
if isempty(n) || n < 200
    n = 200;
end

t = zeros(1, n);
for i = 1:n
    [frame, t(i)] = snapshot(cam);
end

closePreview(cam);
delete(cam);

%% Calcular diferencias de tiempo y velocidad media de adquisicion
dt = diff(t);
tiempo_total = t(end) - t(1);
fps_medio = (n - 1) / tiempo_total;

disp(['Resolucion: ' res{rID}])
disp(['Tiempo total: ' num2str(tiempo_total, '%.4f') ' s'])
disp(['Velocidad media de adquisicion: ' num2str(fps_medio, '%.2f') ' fps'])

%% Representar instantes de captura y diferencias de tiempo
figure
subplot(1,2,1), stem(t), title(['Instante de captura (' res{rID} ')'])
xlabel('Numero de imagen'), ylabel('Tiempo (s)')
subplot(1,2,2), stem(dt), title(['Diferencia entre capturas (' num2str(fps_medio, '%.2f') ' fps)'])
xlabel('Numero de captura'), ylabel('Diferencia de tiempo (s)')
