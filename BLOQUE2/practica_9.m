% Practica 9: Grabacion de video time-lapse
clear; close all; clc;

%% Seleccionar el dispositivo y crear el objeto de video
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

%% Crear el archivo de video y fijar velocidad de reproduccion a 24 fps
salida = input('Nombre del video time-lapse [timelapse.avi]: ', 's');
if isempty(salida)
    salida = 'timelapse.avi';
end
fps_reproduccion = 24;
Wobj = VideoWriter(salida);
set(Wobj, 'FrameRate', fps_reproduccion);

%% Pedir factor de aceleracion y tiempo de captura
aceleracion = input('Factor de aceleracion deseado [6]: ');
if isempty(aceleracion)
    aceleracion = 6;
end
tiempo_captura = input('Tiempo de captura en segundos [10]: ');
if isempty(tiempo_captura)
    tiempo_captura = 10;
end

%% Calcular y mostrar los parametros del video
fps_captura = fps_reproduccion / aceleracion;
n = round(tiempo_captura * fps_captura);
T = round(1 / fps_captura, 3);

disp(['Velocidad de reproduccion: ' num2str(fps_reproduccion) ' fps'])
disp(['Velocidad de captura: ' num2str(fps_captura, '%.2f') ' fps'])
disp(['Numero de imagenes a capturar: ' num2str(n)])
disp(['Intervalo entre capturas (T): ' num2str(T, '%.3f') ' s'])

%% Configurar el temporizador y grabar el video
open(Wobj);
tm = timer('Period', T, ...
           'TasksToExecute', n, ...
           'ExecutionMode', 'fixedRate', ...
           'TimerFcn', {@miFuncion, cam, Wobj});

disp('Iniciando grabacion time-lapse...')
start(tm);
wait(tm);
disp('Grabacion finalizada.')

delete(tm);
close(Wobj);
delete(cam);

%% Comprobar el archivo de video generado
if exist(salida, 'file')
    info_final = mmfileinfo(salida)
    V = VideoReader(salida);
    f1 = read(V, 1);
    f2 = read(V, V.NumFrames);
    figure
    subplot(1,2,1), imshow(f1), title('Primer fotograma')
    subplot(1,2,2), imshow(f2), title(['Ultimo fotograma (#' num2str(V.NumFrames) ')'])
end
