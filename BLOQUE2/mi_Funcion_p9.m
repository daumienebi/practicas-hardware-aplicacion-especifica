%% Función del temporizador para realizar las capturas de la práctica 9.
% tm : El temporizador
% event : El evento que provoca la llamada
% cam : La webcam disponible en el momento
% wObj : El objeto para de VideoWriter creado
function mi_Funcion_p9(tm,event,cam,wObj)
    % Capturamos una imagen desde la webcam
    frame = snapshot(cam);
    % Guardamos la imagen en el archivo de vídeo
    writeVideo(wObj, frame);
end