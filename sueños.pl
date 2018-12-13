cree(gabriel,campanita).
cree(gabriel,magoOz).
cree(gabriel,cavenaaghi).
cree(juan,conejoPascua).
cree(macarena,reyesMagos).
cree(macarena,magoCapria).
cree(macarena,campanita).

%%suenio(persona,suenio)
sue�o(gabriel,ganarLoteria(5)).
sue�o(gabriel,ganarLoteria(9)).
sue�o(juan,cantar(solo,100000)).
sue�o(macarena,cantar(erucaSativa,10000)).
sue�o(gabriel,futbolista(arsenal)).

persona(gabriel).
persona(macarena).
persona(juan).

esPuro(futbolista(_)).
esPuro(cantar(_,Discos)) :- Discos < 200000.

esAmbiciosa(Persona):- sumaDeDificultadesDeCadaSue�o(Persona, Numero),Numero > 20.

sumaDeDificultadesDeCadaSue�o(Persona,Numero):-
    persona(Persona), findall(Dificultad,sue�oDeLaPersona(Dificultad,Persona),Dificultades),sum_list(Dificultades,Numero).

sue�oDeLaPersona(Dificultad, Persona):- sue�o(Persona,Sue�o),dificultadDeCadaSue�o(Sue�o,Dificultad).

dificultadDeCadaSue�o(cantar(_,CantidadDeDiscosVendidos),6):- CantidadDeDiscosVendidos >= 500000.
dificultadDeCadaSue�o(cantar(_,CantidadDeDiscosVendidos),4):- CantidadDeDiscosVendidos < 500000.
dificultadDeCadaSue�o(ganarLoteria(NumerosApostados),Dificultad):- Dificultad is (10 * NumerosApostados).
dificultadDeCadaSue�o(futbolista(arsenal),3).
dificultadDeCadaSue�o(futbolista(aldosivi),3).
dificultadDeCadaSue�o(futbolista(equipoGrande),16).

tieneQuimica(campanita, Persona) :- cree(Persona, campanita), alMenosUnSue�oMenorA5(Persona).
tieneQuimica(Personaje, Persona) :- sue�o(Persona,Sue�o), cree(Persona, Personaje), alMenosUnSue�oMenorA5(Persona), esPuro(Sue�o).

alMenosUnSue�oMenorA5(Persona) :- sue�o(Persona,Sue�o), dificultadDeCadaSue�o(Sue�o, Dificultad), Dificultad < 5.

esAmiga(campanita, reyesMagos).
esAmiga(campanita, conejoDePascua).
esAmiga(conejoDePascua, cavenaghi).

puedeAlegrar(Personaje, Persona) :-  sue�o(Persona, _), tieneQuimica(Personaje, Personaje), not(estaEnfermo(Personaje)).
puedeAlegrar(Personaje, Persona) :-  sue�o(Persona, _), tieneQuimica(Personaje, Personaje),
                                     personajeDeBackUp(PersonajeDebackUp), not(estaEnfermo(PersonajeDeBackUp)),
                                     esAmigo(PersonajeDeBackup, Personaje).

