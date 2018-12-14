amigo(juan, alberto).
amigo(juan, pedro).
amigo(pedro,mirta).
amigo(alberto, tomas).
amigo(tomas,mirta).
sonAmigos(Persona,OtraPersona):- amigo(OtraPersona,Persona).
sonAmigos(Persona,OtraPersona):- amigo(Persona,OtraPersona).


enemigo(mirta,ana).
enemigo(juan,nestor).
enemigo(juan,mirta).
sonEnemigos(Persona,OtraPersona):- enemigo(OtraPersona,Persona).
sonEnemigos(Persona,OtraPersona):- enemigo(Persona,OtraPersona).

mesaArmada(navidad2010,mesa(2,[mirta,nestor])).

mesaArmada(navidad2010,mesa(1,[juan,mirta,ana,nestor])).
mesaArmada(navidad2010,mesa(5,[andres,german,ludmila,elias])).
mesaArmada(navidad2010,mesa(8,[nestor,pedro])).

%estaSentadaEn/2 que relaciona a cada persona que esta sentada en una mesa.
%Este predicado debe de ser inversible

estaSentadaEn(Persona,mesa(Numero,Personas)):-
         mesaArmada(_,mesa(Numero,Personas)),
	 member(Persona,Personas).

% sePuedeSentar/2 que relaciona a una persona y una mesa si la persona
% puede sentarse en esa mesa. Una persona se sienta en una mesa si hay
% por lo menos un amigo y no hay enemigos. ?-
% sePuedeSentar(pedro,mesa(1,[juan,mirta,ana,nestor])). true .

mismaMesa(Persona,Otra):-
         mesaArmada(_,mesa(_,Personas)),
         member(Persona,Personas),
         member(Otra,Personas),
         Persona\=Otra.

sePuedeSentar(Persona,Mesa):-
         estaSentadaEn(Amigo,Mesa),
         %mismaMesa(Persona,Amigo),
         amigo(Amigo,Persona),
         forall(estaSentadaEn(Enemigo,Mesa),not(enemigo(Persona,Enemigo))).

%mesaDeCumpleañero/2 donde se crea una mesa ideal para una persona (el
% cumpleañero). La mesa ideal para alguien el día de su cumpleaños es la
% mesa
%número 1 donde está él y todos sus amigos.
%?- mesaDeCumpleañero(juan,M).
%M = mesa(1, [juan, alberto, pedro]).
%Nota: Recuerde que existe el predicado append(Lista1,Lista2,Lista12).
%
%
mesaDeCumpleañero(Persona,mesa(1,NuevosAmigos)):-
        amigo(Persona,_),
        findall(Amigo,amigo(Persona,Amigo),Amigos),
        append([Persona],Amigos,NuevosAmigos).


%incompatible/2 relacione a dos personas por ser incompatibles, esto pasa cuando
% tienen una persona en común pero para uno es amigo y para el otro es
% enemigo.
%?- incompatible(X,Y).
%X = pedro,
%Y = juan ;
incompatible(Persona,Incompatible):-
         amigo(Persona,OtraPersona),
         enemigo(Incompatible,OtraPersona).


% laPeorOpcion/2 relaciona a una persona y una mesa posible si todos los
% que están sentados en ella son sus enemigos.

%laPeorOpcion(Persona,MesaPosible):-
 %       enemigo(Persona,_),
  %      mesaArmada(_,MesaPosible),
   %     forall(estaSentadaEn(Enemigo, MesaPosible), enemigo(Persona, Enemigo)).

laPeorOpcion(Persona, mesa(Num, Gente)) :-
	mesaArmada(_, mesa(Num, Gente)),
	enemigo(Persona,_),
	forall(member(Enemigo, Gente), enemigo(Persona, Enemigo)).

% mesasPlanificadas/2: relaciona a una fiesta con todas las mesas que
% fueron
%planificadas para ella. Este predicado debe de ser inversible.
%?- mesasPlanificadas(F,Mesas).
%F = navidad2010,
%Mesas = [mesa(1, [juan, mirta, ana, nestor]), mesa(5, [andres, german,
%ludmila, elias]), mesa(8, [nestor, pedro])]


mesasPlanificadas(Fiesta,Mesas):-
         mesaArmada(Fiesta,_),
         findall(Mesa,mesaArmada(Fiesta,Mesa),Mesas).

%esViable/1: se verifica para una lista de mesas si:
%o Los números de mesa son correctos, es decir, si hay 5 mesas están
%numeradas del 1 al 5 (pueden no estar en orden).
%o Hay 4 personas en cada mesa (si exactamente 4 ni mas ni menos).
%o En ninguna mesa hay dos personas que sean enemigas entre sí.

cantidadPersonas(mesa(_,Personas)):-
         length(Personas,4).

crearMesa(Mesas, Mesas).

crearMesa(Mesas, Lista) :-
         cantidadPersonas(Mesa),
         append([Mesa], Mesas, NuevasMesas),
         crearMesa(NuevasMesas, Lista).

esViable(Mesas) :-
         mesaArmada(_, mesa(_,Personas)),
         forall(mesaArmada(_,mesa(_,Personas)), cantidadPersonas(Mesa1, 4)).
