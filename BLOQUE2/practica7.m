% Práctica 7 : Velocidad de adquisición de imágenes
% script para calcular la velocidad de adquisición (frame rate) de nuestro
% dispositivo capturando una secuencia de imágenes y analizando los 
% instantes de tiempo en que fueron adquiridas.
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
%% Abrir una ventana de previsualización.
preview(cam)
%% Captura al menos 200 imágenes
nImagenes = 200;
tiempos = zeros(1,nImagenes);
for i = 1 : nImagenes
    % tomamos la captura
    [frame,timestamp] = snapshot(cam);
    tiempos(i) = timestamp;
end
% Cerramos la previsualización y liberamos la cámara
closePreview(cam);
delete(cam);

%% Utilizando la función stem, representar en la misma ventana el instante 
%  de tiempo en que ha sido capturada cada imagen y la diferencia de tiempo
%  entre cada captura.

diferencias = diff(tiempos);
figure;
subplot(2,1,1);
stem(tiempos);
title('Instante de tiempo de cada captura');
xlabel('Número de imagen');
ylabel('Tiempo (s)');

subplot(2,1,2);
stem(diferencias);
title('Diferencia de tiempo entre capturas');
xlabel('Intervalo entre capturas');
ylabel('Diferencia de tiempo (s)');

%% Calcular un promedio de la velocidad de adquisición tomando como
%  referencia el tiempo empleado en capturar toda la secuencia.
tiempoTotal = tiempos(end) - tiempos(1);
fps = nImagenes / tiempoTotal;
disp(['Tiempo total de captura: ' num2str(tiempoTotal) ' s'])
disp(['Velocidad de adquisición promedio: ' num2str(fps) ' fps'])

%%  Con el fin de observar la influencia del tiempo de lectura, repetir 
% todo el proceso utilizando una resolución distinta.

% Explicación :
% Para este apartado, se puede elegir la peor resolución disponible en el 
% sistema. En este caso no hemos notado diferencia en cuanto a la velocidad
% aunque hayamos bajado la resolución aunque este resultado puede variar
% dependiendo del dispositivo de prueba.

%% Para observar la influencia del tiempo de integración, repetir todo el 
% proceso tapando y destapando la cámara durante la captura.

% Explicación : En la representacion se pueden observar los picos debido
% al cambio de comportamiento. Se ve una diferencia clara dado que de la
% otra forma, sin obstruir la cámara, se apreciaba una representación
% lineal sin apenas iregularidades.