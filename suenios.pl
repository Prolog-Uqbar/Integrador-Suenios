% Punto 1
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).
% Variante con listas
% Se complica un poco, no vale la pena
%cree(gabriel, [campanita,gabriel, magoDeOz]).

suenia(gabriel, ganarLoteria([5, 9])).
suenia(gabriel, serFutbolista(arsenal)).
suenia(juan, serCantante(100000)).
suenia(macarena, serCantante(100000)).

enfermo(conejoDePascua).

amigo(reyesMagos, campanita).
amigo(conejoDePascua, campanita).
amigo(cavenaghi, conejoDePascua).

esEquipoGrande(arsenal).

% Punto 2
valorDeSuenios(Persona, Valor):-
  cree(Persona, _),
  findall(Valor, (suenia(Persona, Suenio), valorDeSuenio(Suenio, Valor)), ListaDeValores),
%  findall(Valor, valorDeSuenio(Persona, Valor), ListaDeValores),
  sum_list(ListaDeValores, Valor).


ambiciosa(Persona) :-
  valorDeSuenios(Persona, Valor),
  Valor > 20.


quiereVenderMucho(Numeros) :-
  Numeros > 500000.

%valorDeSuenio(Persona, Valor) :-
%  suenia(Persona, ganarLoteria(Numeros))
%  length(Numeros, Largo),
%  Valor is Largo*10.
% habria que agregar suenia() en cada regla valorDeSuenio

valorDeSuenio(ganarLoteria(Numeros), Valor) :-
  length(Numeros, Largo),
  Valor is Largo*10.
valorDeSuenio(serFutbolista(Club), 3) :-
  esEquipoGrande(Club).
valorDeSuenio(serFutbolista(Club), 6) :-
  not(esEquipoGrande(Club)).
valorDeSuenio(serCantante(Numeros), 6) :-
  quiereVenderMucho(Numeros).
valorDeSuenio(serCantante(Numeros), 4) :-
  not(quiereVenderMucho(Numeros)).

% Punto 3

tieneQuimica(Personaje, Persona) :-
  cree(Persona, Personaje),
% En el caso de usar listas
%  cree(Persona, Personajes),
%  member(Personaje, Personajes),
  cumpleCondicionDeQuimica(Personaje, Persona).

cumpleCondicionDeQuimica(campanita, Persona) :-
  suenia(Persona, Suenio),
  valorDeSuenio(Suenio, Numero),
  Numero > 5.

cumpleCondicionDeQuimica(Personaje, Persona) :-
  Personaje \= campanita,
  forall(suenia(Persona, Suenio), esPuro(Suenio)),
  not(ambiciosa(Persona)).

  esPuro(serFutbolista(_)).
  esPuro(serCantante(Numero)) :-
    Numero < 200000.


% Punto 4

puedeAlegrar(Persona, Personaje) :-
  suenia(Persona, _),
  tieneQuimica(Personaje, Persona),
  not(personajeOBackupEnfermo(Personaje)).


personajeOBackupEnfermo(Personaje) :-
  enfermo(Personaje).

personajeOBackupEnfermo(Personaje) :-
  amigoRecursivo(Personaje, OtroPersonaje),
  enfermo(OtroPersonaje).

amigoRecursivo(Personaje, OtroPersonaje) :-
  amigo(Personaje, OtroPersonaje).

amigoRecursivo(Personaje, OtroPersonaje) :-
  amigo(Personaje, PersonajeIntermedio),
  amigoRecursivo(PersonajeIntermedio, OtroPersonaje).
