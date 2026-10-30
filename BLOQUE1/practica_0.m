% 1 : Crear los vectores
v1 = [1,2,3];
v2 = [3,2,1];
v3 = [5,7,-1];

% 2 : Concatenar v1, v2 y v3 en las dimensiones 1, 2 y 3
% Dimension 1 : apilamos los tres vectores en vertical
M1 = cat(1, v1, v2, v3);
% Dimension 2 : concatenamos en horizontal
M2 = cat(2, v1, v2, v3);
% Dimension 3 : matriz 3D, cada 'capa' es un vector en vertical
M3 = cat(3, v1, v2, v3);

% 3 : Mostrar los valores
disp(M1)
disp(M2)
disp(M3)

% 4 : Definir matriz A y B
A = [1,2,3;4,5,6;7,8,9];
B = [9,8,7;6,5,4;3,2,1];
disp(A)
disp(B)

% 5 : Multiplicar A y B componente a componente
C = A .* B;
disp("A x B :");
disp(C)

% 6 : Crear las submatrices A2 y B2
A2 = A(1:2,1:2)
B2 = B(2:3,2:3)

% 7 : Crear un cell array de tamaño 2x2 que contenga los vectores v1 y v2 en la primera fila y
% las matrices A y B en la segunda fila.
CA = {v1 v2;A B}
%luego acceder con CA{2,2} por ejemplo

% 8 :  Crear una matriz D de tamaño 10 x 15 formada toda ella por doses.
% Creamos una matriz lleno de unos y multiplicamos cada uno de los
% elementos por 2
D = ones(10,15) * 2

% 9: Sustituir la columna central de la matriz D por el mayor valor de A.
% La siguiente linea devuelve un vector con el mayor elemento de cada columna
vector_mayor_elemento_A = max(A)
% Ahora del vector anterior, obtenemos el mayor valor
mayor_elemento_A = max(vector_mayor_elemento_A)

% Columna central de una matriz de 15 columnas : la 8
D(:,8) = mayor_elemento_A

%10: Dada la matriz E
E = [3 2 1 5 6; 2 3 4 2 3;7 8 9 10 11;3 2 2 1 2;2 0 2 2 2]
% Encontrar la posición del elemento menor.
vector_menor_elemento_E = min(E)
menor_elemento_E = min(vector_menor_elemento_E)
% find localiza la posicion; devuelve el indice lineal y las coordenadas
[filas, cols] = find(E == menor_elemento_E)

% 11 : A partir de la matriz E, crear una máscara binaria con el valor ‘1’ en la posición de los
% doses y de los treses y con el valor ‘0’ en el resto de posiciones utilizando para ello
% operadores relacionales. MB = Mascara Binaria
MB = (E == 2 | E == 3)

% 12 : A partir de la máscara anterior, obtener otra matriz F donde sólo aparezcan los ‘2’ y ‘3’
% de la matriz E y cero (‘0’) en el resto de posiciones.

% Solucion facil : Como la mascara binaria ya tiene 1's en las posiciones
% donde la matriz E original tenia 2's y 3's, podemos obtener la matriz F
% simplemente 
F = MB .* E

% 13 : Generar una matriz G de tamaño 1000×1000 con números aleatorios comprendidos entre
% 0 y 10.
G = rand(1000,1000) .* 10

% 14 : Obtener una matriz H con los valores de G comprendidos entre 4 y 5 y cero en el resto.
% Representar gráficamente la fila 500 utilizando la función stem. Medir el tiempo de
% ejecución en milisegundos (ms). 

% Cronometramos todo el proceso con tic/toc (segundos) y lo pasamos a ms
tic
% Primero creamos una mascara binaria
MB = (G >= 4 & G <= 5);
% Ahora obtenemos H
H = MB .* G;
% Ahora representamos la fila 500
figure, stem(H(500,:))
tiempo_ms = toc * 1000;
disp(['Tiempo de ejecucion: ', num2str(tiempo_ms), ' ms'])


