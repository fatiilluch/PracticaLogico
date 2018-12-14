adopto(martin, pepa, 2014).
adopto(martin, frida, 2015).
adopto(martin, kali, 2016).
adopto(martin, olivia, 2014).
adopto(constanza, mambo, 2015).
adopto(hector, abril, 2015).
adopto(hector, buenaventura, 1971).
adopto(hector, severino, 2007).
adopto(hector, sim�n, 2016).

leRegalaronA(constanza, abril, 2006).
leRegalaronA(silvio, quinchin, 1990).

compr�(martin, piru, 2010).
compr�(hector, abril, 2006).

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

due�o(Persona,adopto,Mascota,A�o):-adopto(Persona,Mascota,A�o).
due�o(Persona,regalo,Mascota,A�o):-leRegalaronA(Persona,Mascota,A�o).
due�o(Persona,compro,Mascota,A�o):-compr�(Persona,Mascota,A�o).

% Al consultar si Constanza adopt� a mambo en el 2008 debe dar falso.
% Justificar conceptualmente lo que fue necesario hacer para conseguirlo.
% Por principio de universo cerrado, es falso ya que no esta en la base
% de conocimiento.
%
% comprometidos/2 se cumple para dos personas cuando adoptaron el mismo
% a�o a la misma mascota.
% Por ejemplo, Hector y Constanza est�n comprometidos porque adoptaron a
% mambo el mismo a�o.

comprometidos(Persona, OtraPersona) :- adopto(Persona, Mascota, A�o), adopto(OtraPersona, Mascota, A�o), Persona \= OtraPersona.

% locoDeLosGatos/1 se cumple para una persona cuando tiene s�lo gatos,
% pero m�s de uno. Por ejemplo, Constanza es loco de los gatos.

locoDeLosGatos(Persona) :- persona(Persona,_),
                           tieneMascota(Persona),
                           forall(persona(Persona,Mascota),mascota(Mascota,gato(_,_))).

persona(Persona, Mascota) :- adopto(Persona, Mascota, _).
persona(Persona, Mascota) :- compr�(Persona, Mascota, _).
persona(Persona, Mascota) :- leRegalaronA(Persona, Mascota , _).

tieneMascota(Persona):-
    persona(Persona,Mascota),
    persona(Persona,OtraMascota),
    Mascota \= OtraMascota.

% puedeDormir/1 Se cumple para una persona si no tiene mascotas que est�n
% chapita (los perros chicos y las tortugas est�n chapita, y los gatos
% machos que fueron acariciados menos de 10 veces est�n chapita).
% Debe ser inversible.
% En los ejemplos todos tienen mascotas chapita.... As� que nadie puede
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
% nerviosas... crisisNerviosa/2 es cierto para una persona y un a�o
% cuando, el a�o anterior obtuvo una mascota que est� chapita y ya antes
% ten�a otra mascota que est� chapita. Por ejemplo, en el 2008 Hector
% tuvo una crisis nerviosa (ya ten�a a buenaventura, que es chapita, y
% en el 2007 adopt� a severino... Resultado: en el 2008 tuvo una crisis
% nerviosa). Decir si es inversible (si se pueden hacer preguntas
% existenciales) y por qu�.

crisisNerviosa(Persona,A�o):-
    A�oAnterior is A�o -1,
    due�o(Persona,_,Mascota,A�oAnterior),
    estaChapita(Mascota),
    due�o(Persona,_,OtraMascota,OtroA�o),
    estaChapita(OtraMascota),
    OtroA�o < A�oAnterior.

% mascotaAlfa/2 Relaciona una persona con el nombre de una mascota,
% cuando esa mascota domina al resto de las mascotas de esa persona. Se
% sabe que un gato siempre domina a un perro, que un perro grande domina
% a uno chico, que un gato chapita domina a gatos no chapita, y que una
% tortuga agresiva domina cualquier cosa.
% Por ejemplo, kali es mascota alfa de Mart�n.

mascotaAlfa(Persona,Mascota):- due�o(Persona, _, Mascota, _),
                               forall((due�o(Persona,_,OtraMascota,_), OtraMascota \= Mascota), dominaA(Mascota, OtraMascota)).

dominaA(Mascota, OtraMascota) :-
    mascota(Mascota, EspecieAlfa),
    mascota(OtraMascota, EspecieDominada),
    domina(EspecieAlfa, EspecieDominada).


domina(gato(_,_), perro(_)).
domina(perro(grande), perro(chico)).
domina(tortuga(agresiva),_).
domina(gato(Cat1,Cari�oso1), gato(Cat2,Cari�oso2)):- estaChapita(gato(Cat1,Cari�oso1)), not(estaChapita(gato(Cat2,Cari�oso2))).

% materialista/1 se cumple para una persona cuando no tiene mascotas o
% compr� m�s de las que adopt�. Hacer que sea inversible.
% Por ejemplo, si Constanza comprara 3 mascotas ser�a materialista
% (porque ya tiene 1 adoptada).

materialista(Persona) :-
    due�o(Persona, _,_,_),
    cantidad(Persona,adopto,CantidadAdoptados),
    cantidad(Persona,compr�,CantidadComprados),
    CantidadAdoptados > CantidadComprados.

cantidad(Persona,Tipo,Cantidad):-
    findall(Mascota,due�o(Persona,Tipo,Mascota,_),Mascotas),
    length(Mascotas,Cantidad).
