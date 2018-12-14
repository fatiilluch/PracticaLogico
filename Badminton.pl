%Nos interesa saber c�mo le fue a un equipo en cierto set de cierto partido. Para esto, queremos registrar la fecha del partido,
%el set, el equipo, y qu� puntaje obtuvo el equipo ah�. Sabemos que se juega solo un partido por fecha.
%Mostrar qu� har�a para modelar el partido del 25/5/2018, entre Brasil y Uruguay:

%En esa fecha, en el set 1, Brasil qued� con 15 (gan� por tener 15 puntos en ese set).
%En esa misma fecha, en ese mismo set, Uruguay qued� con 10 puntos.
%En el set 2 Brasil volvi� a ganar con 15 puntos.
%Uruguay lo perdi� con 9.
%Brasil ya gan� 2 sets seguidos as� que no jug� un tercer set.

%partido(set, EquipoA, EquipoB, puntosA, puntosB, fecha()).
partido(1, brasil, uruguay, 15, 10, fecha(25,5,2018)).
partido(2, brasil, uruguay, 15, 9, fecha(25,5,2018)).

% Que el equipo A gane 2 sets seguidos. SI es as�, termina el partido.
% Que el equipo A gane uno y luego gane el equipo B, en cuyo caso se
% juega un tercer set para desempatar.

% A partir de contar con lo anterior en nuestra base de conocimientos,
% mostrar c�mo consultar�a (como si fuese en la consola) lo siguiente, y
% aclarar qu� pasar�a en cada caso:
% Brasil obtuvo 15 puntos en alg�n set de alguna fecha.
% ? - partido(_, brasil, _, 15, _, _).
% True
%
% Brasil jug� en la fecha en la que tambi�n jugaba Uruguay.
% ? - partido(_,brasil, uruguay,_ ,_ ,_)).
% True
%
% Qu� sets hubo en la fecha 25/5/2018 (las soluciones deber�an ser el
% primer set y el segundo set nada m�s, ya que no hubo tercero).
% ? - partido(Set, _, _, _, _, fecha(25,5,2018)).
% Set = 1;
% Set = 2;
% False
%
% No se jug� un tercer set en el partido del 25/5/2018.
% ? - partido(3, _, _, _, _, fecha(25,5,2018)).
% False
%
% Existe alg�n equipo que haya jugado el 10/6/2018.
% ? - partido(_, A, B, _, _, fecha(10,6,2018)).
% False
%
% Qui�n es el ganador. Alguien gana en una fecha si es que tiene 2 sets
% en los cuales obtuvo 15 puntos.

ganoPartido(EquipoA, Fecha) :- partido(Set1, EquipoA, _, 15, _, Fecha),
                               partido(Set2, EquipoA, _, 15, _, Fecha),
                               Set1 \= Set2.

% Qui�n es el perdedor. Un equipo perdi� si no fue el ganador (habiendo
% jugado en dicha fecha, obvio).

perdedor(EquipoB, Fecha) :- partido(_, _, EquipoB, _, _, Fecha), not(ganoPartido(EquipoB, Fecha)).

% Saber si cierta fecha estuvo peleada. Esto sucede si el perdedor tuvo
% un buen puntaje (entre 10 y 14) en ambos sets jugados, o bien, tuvieron
% que jugar el tercer set (porque gan� primero un equipo, luego el otro,
% y despu�s vino el desempate).

estuvoPeleada(Fecha) :- partido(Set1, _, _, _, PuntosBSet1, Fecha), partido(Set2, _, _, _, PuntosBSet2, Fecha),
                        Set1 \= Set2, buenPuntaje(PuntosBSet1), buenPuntaje(PuntosBSet2).

estuvoPeleada(Fecha) :- partido(3, _, _, _, _, Fecha).

buenPuntaje(Puntos) :- 10 < Puntos , Puntos < 14.

% Determinar si un equipo es campe�n: Ocurre si gan� todos los partidos
% en los que particip�.

esCampeon(Equipo) :- partido(_, Equipo, _, _, _, _),
                     forall(partido(_, Equipo, _, _, _, Fecha), ganoPartido(Equipo, Fecha)).

% Casi casi: Sucede si el equipo perdi� la final (es decir, la �ltima
% fecha que se conozca).
% Ayuda: Asumir que existe un predicado �laPrimeraEsM�sReciente/2�, que
% dadas dos fechas, indica que la primera es m�s reciente.

casiCasi(Equipo) :- perdedor(Equipo, UltimaFecha),
                    forall(partido(_, _, _, _, _, Fecha), laPrimeraEsM�sReciente(UltimaFecha, Fecha)).

laPrimeraEsM�sReciente(fecha(_, _, A�oMayor), fecha(_, _, A�oMenor)) :- A�oMayor > A�oMenor.
laPrimeraEsM�sReciente(fecha(_, MesMayor, A�o), fecha(_, MesMenor, A�o)) :- MesMayor > MesMenor.
laPrimeraEsM�sReciente(fecha(D�aMayor, Mes, A�o), fecha(D�aMenor, Mes, A�o)) :- D�aMayor >= D�aMenor.

% Existe el rumor de que Alemania nos puede superar en cualquier deporte.
% Por lo tanto, debemos poder determinar si un equipo es mejor que otro
% para poder comprobar o refutar este tipo de afirmaciones. Un equipo es
% mejor si gan� m�s partidos.

esMejor(EquipoA, EquipoB) :- partido(_, EquipoA, EquipoB, _, _, _),
                             partidosGanados(EquipoA, CantidadA),
                             partidosGanados(EquipoB, CantidadB), CantidadA > CantidadB.

partidosGanados(Equipo, Cantidad) :- findall(Fecha, ganoPartido(Equipo, Fecha), FechasGanadas),
                                     length(FechasGanadas, Cantidad).

% Mostrar c�mo consultar�a (sin crear predicados adicionales) cu�l equipo
% es el peor de todos. Esto ocurre si no es mejor que nadie.
% Como no conocemos la base completa, asumir alg�n equipo de su desagrado
% como el peor.
%
% ? - partido(_, _, Equipo, _, _, _),forall(partido(_, EquipoA, _, _, _, _),
% not(esMejor(Equipo,EquipoA))).
%

% Cebollita: Un equipo es cebollita si no es campe�n, y todos sus
% partidos estuvieron peleados. Tambi�n es cebollita aqu�l que haya
% perdido contra un equipo cebollita.

esCebollita(Equipo) :- partido(_, _, Equipo, _, _, _), not(esCampeon(Equipo)),
                       forall(partido(_, _, Equipo, _, _, Fecha), estuvoPeleada(Fecha)).

esCebollita(Equipo) :- partido(_, Equipo2, Equipo, _, _, Fecha), esCebollita(Equipo2), perdedor(Equipo, Fecha).

% Por �ltimo, conocemos a algunos hinchas. De ellos, sabemos que hay
% famosos (de los cuales nos interesa su nombre y profesi�n), y comunes
% (de los cuales solo sabemos su nombre). De todos se sabe, obviamente,
% por cu�l equipo hinchan.
% Por ejemplo, Marian es com�n e hincha por Argentina, y Mick es un
% cantante que hincha por Inglaterra. Se requiere modelar estos 2 casos
% de la forma m�s conveniente.
% Determinar si un hincha es mufa: Los famosos son mufas si es que su
% profesi�n es mufa (periodistas o cantantes). Los comunes son mufas solo
% si se llaman Carlos.
% Asumiendo que se crean muchos hinchas de muchos equipos, se requiere
% verificar si para cierto equipo, la suerte est� de su lado. Esto sucede
% si ninguno de sus hinchas es mufa.

%hinchas(famosos(nombre, profesion), Equipo).
%hinchas(comunes(nombre), Equipo).

hincha(comunes(marian), argentina).
hincha(famoso(mick, cantante), inglaterra).

esMufa(comunes(carlos)).
esMufa(famoso(_, cantante)).
esMufa(famoso(_, periodista)).

laSuerteEstaDeSuLado(Equipo) :-  partido(_, _, Equipo, _, _, _),
                                 forall(hincha(Hincha,Equipo), not(esMufa(Hincha))).
