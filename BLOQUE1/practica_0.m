% 1 : Crear los vectores
v1 = [1,2,3];
v2 = [3,2,1];
v3 = [5,7,-1];

% 2 : Asignar valores a M1,2 y3
M1 = size(v1);
M2 = size(v2);
M3 = size(v3);

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
mayor_elemento_A = max(mayor_elemento_A)
D(:,8) = mayor_elemento_A

%10: Dada la matriz E
E = [3 2 1 5 6; 2 3 4 2 3;7 8 9 10 11;3 2 2 1 2;2 0 2 2 2]
% Encontrar la posición del elemento menor.
vector_menor_elemento_E = min(E)
menor_elemento_E = min(vector_menor_elemento_E)
% he conseguido coger el menor elemento pero no su posición

% 11 : A partir de la matriz E, crear una máscara binaria con el valor ‘1’ en la posición de los
% doses y de los treses y con el valor ‘0’ en el resto de posiciones utilizando para ello
% operadores relacionales. MB = Mascara Binaria
MB = (E == 2 | E == 3)

% 12 : A partir de la máscara anterior, obtener otra matriz F donde sólo aparezcan los ‘2’ y ‘3’
% de la matriz E y cero (‘0’) en el resto de posiciones.
%F = E(MB)

