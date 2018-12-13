lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).


tieneItem(Jugador, Item):- jugador(Jugador, Items, _), member(Item, Items).

sePreocupaPorSuSalud(Jugador):-  tieneItem(Jugador, Item), tieneItem(Jugador, Item2), Item \= Item2, comestible(Item), comestible(Item2).

cantidadDeItem(Jugador, Item, Cantidad):- jugador(Jugador,_ , _), tieneItem(_, Item),
                                          findall(Cosa, (tieneItem(Jugador,Cosa), Cosa == Item), ListaDeCosas),
                                          length(ListaDeCosas, Cantidad).

tieneMasDe(Jugador, Item) :-  jugador(Jugador, _, _), tieneItem(_, Item), cantidadDeItem(Jugador, Item, Cantidad),
                              forall(jugador(Jugadores, _, _), laMenorCantidad(Jugadores, Item, Cantidad)).

laMenorCantidad(Jugadores, Item, Cantidad) :- cantidadDeItem(Jugadores, Item, Cantidad2), Cantidad2 =< Cantidad.

hayMonstruos(Lugar) :- lugar(Lugar, _, Oscuridad), Oscuridad >= 6.

correPeligro(Jugador) :- estaEn(Jugador, Lugar), hayMonstruos(Lugar).
correPeligro(Jugador) :- estaHambriento(Jugador), not(tieneItemsComestibles(Jugador)).

estaEn(Jugador, Lugar) :- lugar(Lugar, Jugadores, _), member(Jugador, Jugadores).

estaHambriento(Jugador) :-  jugador(Jugador,_,Hambre), Hambre < 4.

tieneItemsComestibles(Jugador) :- tieneItem(Jugador, Item), comestible(Item).

nivelPeligrosidad(Lugar, Nivel) :- lugar(Lugar, _, _), not(hayMonstruos(Lugar)),
                                   porcentajeDeHambrientos(Lugar,Valor), Nivel is Valor.
nivelPeligrosidad(Lugar, 100)   :- hayMonstruos(Lugar).
nivelPeligrosidad(Lugar, Nivel) :- lugar(Lugar, _, Oscuridad), not(estaEn(_, Lugar)), Nivel is (10 * Oscuridad) .

cantidadJugadores(Lugar,Cantidad):- lugar(Lugar,Jugadores,_),length(Jugadores,Cantidad).


porcentajeDeHambrientos(Lugar, Porcentaje) :-  lugar(Lugar, _, _),
                                   findall(Hambriento,(estaHambriento(Hambriento), estaEn(Hambriento, Lugar)), JugadoresHambrientos),
                                   length(JugadoresHambrientos, Valor),
                                   cantidadJugadores(Lugar,Valor2),
                                   Porcentaje is ((Valor/ Valor2)*100), estaEntre(0,100,Porcentaje).

estaEntre(Min, Max, Valor) :- Min < Valor, Max > Valor.

%%puedeConstruir(Jugador, Item):-jugador(Jugador,Materiales,_),
 %%                              item(Item, [ tipoDeItem(Material, Cantidad) ],
   %%                            findall().


puedeConstruir(Jugador, Item) :- jugador(Jugador, _, _),
                                 item(Item, [tipoDeItem(Elemento,CantidadX)]),
                                 findall(Elemento, (jugador(Jugador,_,_), tieneItem(Jugador, Elemento)), Elementos),
                                 length(Elementos, Cantidad),
                                 CantidadX =< Cantidad.

tipoDeItem(Material, Cantidad) :- itemSimple(Material, Cantidad).
tipoDeItem(Material, _) :- itemCompuesto(Material).

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).


jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).


%Puede requerir una cierta cantidad de un ítem simple,
%    que es aquel que el jugador tiene o puede recolectar. Por ejemplo,
%    8 unidades de piedra.
% Puede requerir un ítem compuesto, que se debe construir a partir de
% otros (una única unidad).
