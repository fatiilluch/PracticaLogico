cree(gabriel,campanita).
cree(gabriel,magoOz).
cree(gabriel,cavenaaghi).
cree(juan,conejoPascua).
cree(macarena,reyesMagos).
cree(macarena,magoCapria).
cree(macarena,campanita).

%%suenio(persona,suenio)
sueño(gabriel,ganarLoteria(5)).
sueño(gabriel,ganarLoteria(9)).
sueño(juan,cantar(solo,100000)).
sueño(macarena,cantar(erucaSativa,10000)).
sueño(gabriel,futbolista(arsenal)).

persona(gabriel).
persona(macarena).
persona(juan).

esPuro(futbolista(_)).
esPuro(cantar(_,Discos)) :- Discos < 200000.

esAmbiciosa(Persona):- sumaDeDificultadesDeCadaSueño(Persona, Numero),Numero > 20.

sumaDeDificultadesDeCadaSueño(Persona,Numero):-
    persona(Persona), findall(Dificultad,sueñoDeLaPersona(Dificultad,Persona),Dificultades),sum_list(Dificultades,Numero).

sueñoDeLaPersona(Dificultad, Persona):- sueño(Persona,Sueño),dificultadDeCadaSueño(Sueño,Dificultad).

dificultadDeCadaSueño(cantar(_,CantidadDeDiscosVendidos),6):- CantidadDeDiscosVendidos >= 500000.
dificultadDeCadaSueño(cantar(_,CantidadDeDiscosVendidos),4):- CantidadDeDiscosVendidos < 500000.
dificultadDeCadaSueño(ganarLoteria(NumerosApostados),Dificultad):- Dificultad is (10 * NumerosApostados).
dificultadDeCadaSueño(futbolista(arsenal),3).
dificultadDeCadaSueño(futbolista(aldosivi),3).
dificultadDeCadaSueño(futbolista(equipoGrande),16).

tieneQuimica(campanita, Persona) :- cree(Persona, campanita), alMenosUnSueñoMenorA5(Persona).
tieneQuimica(Personaje, Persona) :- sueño(Persona,Sueño), cree(Persona, Personaje), alMenosUnSueñoMenorA5(Persona), esPuro(Sueño).

alMenosUnSueñoMenorA5(Persona) :- sueño(Persona,Sueño), dificultadDeCadaSueño(Sueño, Dificultad), Dificultad < 5.

esAmiga(campanita, reyesMagos).
esAmiga(campanita, conejoDePascua).
esAmiga(conejoDePascua, cavenaghi).

puedeAlegrar(Personaje, Persona) :-  sueño(Persona, _), tieneQuimica(Personaje, Personaje), not(estaEnfermo(Personaje)).
puedeAlegrar(Personaje, Persona) :-  sueño(Persona, _), tieneQuimica(Personaje, Personaje),
                                     personajeDeBackUp(PersonajeDebackUp), not(estaEnfermo(PersonajeDeBackUp)),
                                     esAmigo(PersonajeDeBackup, Personaje).

