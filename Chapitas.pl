adopto(martin, pepa, 2014).
adopto(martin, frida, 2015).
adopto(martin, kali, 2016).
adopto(martin, olivia, 2014).
adopto(constanza, mambo, 2015).
adopto(hector, abril, 2015).
adopto(hector, buenaventura, 1971).
adopto(hector, severino, 2007).
adopto(hector, simón, 2016).

leRegalaronA(constanza, abril, 2006).
leRegalaronA(silvio, quinchin, 1990).

compró(martin, piru, 2010).
compró(hector, abril, 2006).

mascota(pepa, perro(mediano)).
mascota(frida, perro(grande)).
mascota(piru, gato(macho,15)).
mascota(kali, gato(macho,3)).
mascota(olivia, gato(hembra,16)).
mascota(mambo, gato(macho,2)).
mascota(abril, gato(hembra,4)).
mascota(buenaventura, tortuga(agresiva)).
mascota(severino, tortuga(agresiva)).
mascota(simon, tortuga(tranquila)).
mascota(quinchin, gato(macho,0)).

dueño(Persona,adopto,Mascota,Año):-adopto(Persona,Mascota,Año).
dueño(Persona,regalo,Mascota,Año):-leRegalaronA(Persona,Mascota,Año).
dueño(Persona,compro,Mascota,Año):-compró(Persona,Mascota,Año).

% Al consultar si Constanza adoptó a mambo en el 2008 debe dar falso.
% Justificar conceptualmente lo que fue necesario hacer para conseguirlo.
% Por principio de universo cerrado, es falso ya que no esta en la base
% de conocimiento.
%
% comprometidos/2 se cumple para dos personas cuando adoptaron el mismo
% año a la misma mascota.
% Por ejemplo, Hector y Constanza están comprometidos porque adoptaron a
% mambo el mismo año.

comprometidos(Persona, OtraPersona) :- adopto(Persona, Mascota, Año), adopto(OtraPersona, Mascota, Año), Persona \= OtraPersona.

% locoDeLosGatos/1 se cumple para una persona cuando tiene sólo gatos,
% pero más de uno. Por ejemplo, Constanza es loco de los gatos.

locoDeLosGatos(Persona) :- persona(Persona,_),
                           tieneMascota(Persona),
                           forall(persona(Persona,Mascota),mascota(Mascota,gato(_,_))).

persona(Persona, Mascota) :- adopto(Persona, Mascota, _).
persona(Persona, Mascota) :- compró(Persona, Mascota, _).
persona(Persona, Mascota) :- leRegalaronA(Persona, Mascota , _).

tieneMascota(Persona):-
    persona(Persona,Mascota),
    persona(Persona,OtraMascota),
    Mascota \= OtraMascota.

% puedeDormir/1 Se cumple para una persona si no tiene mascotas que estén
% chapita (los perros chicos y las tortugas están chapita, y los gatos
% machos que fueron acariciados menos de 10 veces están chapita).
% Debe ser inversible.
% En los ejemplos todos tienen mascotas chapita.... Así que nadie puede
% dormir.

chapita(perro(chico)).
chapita(tortuga(_)).
chapita(gato(macho,Caricias)):- Caricias < 10.


puedeDormir(Persona) :-
    persona(Persona, _),
    %tieneMascota(Persona),
    not((persona(Persona,Mascota),estaChapita(Mascota))).

estaChapita(Mascota):-
   mascota(Mascota,Especie),
   chapita(Especie).

% A veces las personas siguen llevando mascotas a sus casas a pesar de
% tener mascotas chapitas. En algunos casos esto genera crisis
% nerviosas... crisisNerviosa/2 es cierto para una persona y un año
% cuando, el año anterior obtuvo una mascota que está chapita y ya antes
% tenía otra mascota que está chapita. Por ejemplo, en el 2008 Hector
% tuvo una crisis nerviosa (ya tenía a buenaventura, que es chapita, y
% en el 2007 adoptó a severino... Resultado: en el 2008 tuvo una crisis
% nerviosa). Decir si es inversible (si se pueden hacer preguntas
% existenciales) y por qué.

crisisNerviosa(Persona,Año):-
    AñoAnterior is Año -1,
    dueño(Persona,_,Mascota,AñoAnterior),
    estaChapita(Mascota),
    dueño(Persona,_,OtraMascota,OtroAño),
    estaChapita(OtraMascota),
    OtroAño < AñoAnterior.

% mascotaAlfa/2 Relaciona una persona con el nombre de una mascota,
% cuando esa mascota domina al resto de las mascotas de esa persona. Se
% sabe que un gato siempre domina a un perro, que un perro grande domina
% a uno chico, que un gato chapita domina a gatos no chapita, y que una
% tortuga agresiva domina cualquier cosa.
% Por ejemplo, kali es mascota alfa de Martín.

mascotaAlfa(Persona,Mascota):- dueño(Persona, _, Mascota, _),
                               forall((dueño(Persona,_,OtraMascota,_), OtraMascota \= Mascota), dominaA(Mascota, OtraMascota)).

dominaA(Mascota, OtraMascota) :-
    mascota(Mascota, EspecieAlfa),
    mascota(OtraMascota, EspecieDominada),
    domina(EspecieAlfa, EspecieDominada).


domina(gato(_,_), perro(_)).
domina(perro(grande), perro(chico)).
domina(tortuga(agresiva),_).
domina(gato(Cat1,Cariñoso1), gato(Cat2,Cariñoso2)):- estaChapita(gato(Cat1,Cariñoso1)), not(estaChapita(gato(Cat2,Cariñoso2))).

% materialista/1 se cumple para una persona cuando no tiene mascotas o
% compró más de las que adoptó. Hacer que sea inversible.
% Por ejemplo, si Constanza comprara 3 mascotas sería materialista
% (porque ya tiene 1 adoptada).

materialista(Persona) :-
    dueño(Persona, _,_,_),
    cantidad(Persona,adopto,CantidadAdoptados),
    cantidad(Persona,compró,CantidadComprados),
    CantidadAdoptados > CantidadComprados.

cantidad(Persona,Tipo,Cantidad):-
    findall(Mascota,dueño(Persona,Tipo,Mascota,_),Mascotas),
    length(Mascotas,Cantidad).
