% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.


esRaro(deAccion(stacyMalibu, 1, [sombrero])).

esColeccionista(sam).

% %1. a. tematica/2: relaciona a un juguete con su temática. La temática
% de los cara de papa es caraDePapa.

tematica(Juguete, Tematica):- juguete(Juguete, deTrapo(Tematica)).
tematica(Juguete, Tematica):- juguete(Juguete, deAccion(Tematica, _)).
tematica(Juguete, Tematica):- juguete(Juguete, miniFiguras(Tematica, _)).
tematica(Juguete, Tematica):- juguete(Juguete, figuras(Tematica, _)).

% 1. b. esDePlastico/1: Nos dice si el juguete es de plástico, lo cual es
% verdadero sólo para las
%miniFiguras y los caraDePapa

esDePlastico(Juguete) :- tematica(Juguete, miniFiguras(_,_)).
esDePlastico(Juguete) :- tematica(Juguete, caraDePapa(_)).
% 1. c. esDeColeccion/1:Tanto lo muñecos de acción como los cara de papa
% son de colección si son raros, los de trapo siempre lo son, y las mini
% figuras, nunca.

esDeColeccion(Juguete) :- esRaro(Juguete).
esDeColeccion(Juguete) :- tematica(Juguete, deTrapo(_)).

% 2. amigoFiel/2: Relaciona a un dueño con el nombre del juguete que no
% sea de plástico que tiene hace más tiempo. Debe ser completamente
% inversible.
amigoFiel(Dueño, NombreDelJuguete) :- dueño(Dueño, NombreDelJuguete, _), juguete(NombreDelJuguete, _),
                                      not(esDePlastico(NombreDelJuguete)).

dueño(andy, woody, 8).
dueño(andy, señorCaraDePapa,10).
dueño(andy, soldados, 7).
dueño(andy, soldadoPioola,1).
dueño(andy, monitosEnBarril, 2).
dueño(sam, jessie, 3).

% 3. superValioso/1: Genera los nombres de juguetes de colección que
% tengan todas sus piezas originales, y que no estén en posesión de un
% coleccionista.

superValioso(Juguete) :- juguete(Juguete, _), esDeColeccion(Juguete),
                    forall(esDeColeccion(Juguete), (tienePiezasOriginales(Juguete), not(estaEnPosesionDeColeccionista(Juguete)))).

tienePiezasOriginales(woody).
estaEnPosesionDeColeccionista(Juguete):- juguete(Juguete,_),dueño(Dueño,Juguete,_),esColeccionista(Dueño).

% 4. dúoDinámico/3: Relaciona un dueño y a dos nombres de juguetes que le
% pertenezcan que hagan buena pareja. Dos juguetes distintos hacen buena
% pareja si son de la misma temática. Además woody y buzz hacen buena
% pareja. Debe ser complemenente inversible.

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(soldadoPioola, figuras(soldado, 180)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(señorCaraDePapa,caraDePapa([ original(pieIzquierdo),original(pieDerecho),repuesto(nariz) ])).

duoDinamico(Dueño, NombreDeJuguete1, NombreDeJuguete2) :- juguete(NombreDeJuguete1, _), juguete(NombreDeJuguete2, _),
                                                          dueño(Dueño, NombreDeJuguete1, _), dueño(Dueño, NombreDeJuguete2, _),
                                                          hacenBuenaPareja(NombreDeJuguete1,NombreDeJuguete2),
                                                          NombreDeJuguete1 \= NombreDeJuguete2.
duoDinamico(_, woody, buzz).

hacenBuenaPareja(NombreDeJuguete1,NombreDeJuguete2):- tematica(NombreDeJuguete1,Tematica), tematica(NombreDeJuguete2, Tematica),
                                                      NombreDeJuguete1 \= NombreDeJuguete2.

% 5. felicidad/2:Relaciona un dueño con la cantidad de felicidad que le
% otorgan todos sus juguetes:
% ● las minifiguras le dan a cualquier dueño 20 * la cantidad de figurasdel conjunto
% ● los cara de papas dan tanta felicidad según que piezas tenga: las
% originales dan 5, las de repuesto,8.
% ● los de trapo, dan 100
% ● Los de accion, dan 120 si son de coleccion y el dueño es
% coleccionista. Si no dan lo mismo que los de trapo. Debe ser
% completamente inversible.

felicidad(Dueño, Felicidad):- dueño(Dueño,Juguete,_),juguete(Juguete, miniFiguras(_,Cantidad)), Felicidad is 20* Cantidad.
felicidad(Dueño, Felicidad):- dueño(Dueño, Juguete,_), juguete(Juguete, caraDePapa(Partes)),
                              findall(Puntos,juguete(Juguete,caraDePapa.

suma([],0).
suma([X1,X2 : Xs] , S1):- puntos(X1,P), puntos(X2,R), S1 is P + R, suma(Xs,S1).

puntos(original(_),5).
puntos(repuesto(_),8).
