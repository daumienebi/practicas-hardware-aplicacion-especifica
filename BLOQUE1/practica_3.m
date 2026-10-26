% Práctica 3 Chroma Key

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lectura de las imágenes
%%%%%%%%%%%%%%%%%%%%%%%%%%

nom_obj = input('Imagen del objeto (ej. im13.jpg): ', 's');
nom_fondo = input('Imagen del nuevo fondo (ej. img14.jpg): ', 's');

I_obj = imread(nom_obj);
I_fondo = imread(nom_fondo);

I_obj_d = im2double(I_obj);
I_fondo_d = im2double(I_fondo);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualizar ambas imagenes en una ventana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Imágenes Originales');
subplot(1,2,1), imshow(I_obj), title('Motivo Principal');
subplot(1,2,2), imshow(I_fondo), title('Nuevo Fondo');

% Separar canales y seleccionar el color del fondo
R = I_obj_d(:,:,1);
G = I_obj_d(:,:,2);
B = I_obj_d(:,:,3);

R_fondo = I_fondo_d(:,:,1);
G_fondo = I_fondo_d(:,:,2);
B_fondo = I_fondo_d(:,:,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tecnica 1 : Distancia de color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Haz doble click en un píxel del fondo verde/azul');
[x, y, P] = impixel(I_obj_d);
rf = P(1); 
gf = P(2); 
bf = P(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mascarillas, ajustes y binariazión
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha_sin_ajustar = abs(R - rf) + abs(G - gf) + abs(B - bf);
% umbral cercano a cero según el derrame, con 0.2 y 0.1, todavia se veian
% bastantes pixeles verdes
umbral = 0.3; 
alpha = imbinarize(alpha_sin_ajustar, umbral);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualizar mascarillas en una misma ventana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Distancia de Color: Mascarillas');
subplot(1,2,1), imshow(alpha_sin_ajustar), title('Sin ajustar');
subplot(1,2,2), imshow(alpha), title('Ajustada (\alpha)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Primer plano y fondo multiplicados por sus canales alfa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R_obj_mult = R .* alpha;
G_obj_mult = G .* alpha;
B_obj_mult = B .* alpha;
Obj_mult = cat(3, R_obj_mult, G_obj_mult, B_obj_mult);

R_fondo_mult = R_fondo .* (1 - alpha);
G_fondo_mult = G_fondo .* (1 - alpha);
B_fondo_mult = B_fondo .* (1 - alpha);
Fondo_mult = cat(3, R_fondo_mult, G_fondo_mult, B_fondo_mult);

% Composición final
Composicion = Obj_mult + Fondo_mult;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mostrar primer plano, fondo multiplicados y composición final
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Distancia de Color: Composición');
subplot(1,3,1), imshow(Obj_mult), title('Primer Plano x \alpha');
subplot(1,3,2), imshow(Fondo_mult), title('Fondo x (1-\alpha)');
subplot(1,3,3), imshow(Composicion), title('Composición final');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tecnica 2 : Diferencia de color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cálculo de la matriz de diferencia (asumiendo fondo verde)
% Si el fondo fuera azul, usaríamos : M = B - max(R, G);
M = G - max(R, B);

% Ajuste y binarización
umbral_dif = 0.1; % Valor cercano a cero según el derrame
M_bin = imbinarize(M, umbral_dif);

% Invertimos la máscara para obtener el canal alfa final
alpha_dif = not(M_bin);

% Visualizar mascarillas en una misma ventana
figure('Name', 'Diferencia de Color: Mascarillas');
subplot(1,2,1), imshow(M), title('Sin ajustar (M invertida)');
subplot(1,2,2), imshow(alpha_dif), title('Ajustada (\alpha)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Primer plano y fondo multiplicados por sus canales alfa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R_obj_mult_dif = R .* alpha_dif;
G_obj_mult_dif = G .* alpha_dif;
B_obj_mult_dif = B .* alpha_dif;
Obj_mult_dif = cat(3, R_obj_mult_dif, G_obj_mult_dif, B_obj_mult_dif);

R_fondo_mult_dif = R_fondo .* (1 - alpha_dif);
G_fondo_mult_dif = G_fondo .* (1 - alpha_dif);
B_fondo_mult_dif = B_fondo .* (1 - alpha_dif);
Fondo_mult_dif = cat(3, R_fondo_mult_dif, G_fondo_mult_dif, B_fondo_mult_dif);

% Composición final 
Composicion_dif = Obj_mult_dif + Fondo_mult_dif;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualización del resultado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Diferencia de Color: Composición');
subplot(1,3,1), imshow(Obj_mult_dif), title('Primer Plano x \alpha');
subplot(1,3,2), imshow(Fondo_mult_dif), title('Fondo x (1-\alpha)');
subplot(1,3,3), imshow(Composicion_dif), title('Composición final');