% Punto 1
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% Variantes con predicado suenia y con un termino para indicar el tipo de suenio
% Se puede hacer porque todos los suenios tienen la misma aridad
% Se vuelve a hacer suenio puro en vez de impuro

suenia(ganarLoteria,gabriel,[5, 9]).
suenia(serFutbolista,gabriel,arsenal).
suenia(serCantante,juan,100000).
suenia(serCantante,macarena, 10000).

enfermo(conejoDePascua).

amigo(reyesMagos, campanita).
amigo(conejoDePascua, campanita).
amigo(cavenaghi, conejoDePascua).

esEquipoGrande(arsenal).

% Punto 2
valorDeSuenios(Persona, Valor):-
  cree(Persona, _),
  findall(Valor, valorDeSuenio(Persona, Valor), ListaDeValores),
  sum_list(ListaDeValores, Valor).


ambiciosa(Persona) :-
  valorDeSuenios(Persona, Valor),
  Valor > 20.


quiereVenderMucho(Numeros) :-
  Numeros > 500000.

valorDeSuenio(Persona, Valor) :-
  suenia(ganarLoteria,Persona, Numeros),
  length(Numeros, Length),
  Valor is Length*10.
valorDeSuenio(Persona, 3) :-
  suenia(serFutbolista,Persona, Club),
  esEquipoGrande(Club).
valorDeSuenio(Persona, 6) :-
  suenia(serFutbolista,Persona,Club),
  not(esEquipoGrande(Club)).
valorDeSuenio(Persona, 6) :-
  suenia(serCantante,Persona,Numeros),
  quiereVenderMucho(Numeros).
valorDeSuenio(Persona, 4) :-
  suenia(serCantante,Persona,Numeros),
  not(quiereVenderMucho(Numeros)).

% Punto 3

tieneQuimica(Personaje, Persona) :-
  cree(Persona, Personaje),
  cumpleCondicionDeQuimica(Personaje, Persona).

cumpleCondicionDeQuimica(campanita, Persona) :-
  valorDeSuenio(Persona, Numero),
  Numero > 5.

cumpleCondicionDeQuimica(Personaje, Persona) :-
  Personaje \= campanita,
  forall(suenia(Suenio, Persona, Valor), esPuro(Suenio,Valor)),
  not(ambiciosa(Persona)).

esPuro(serFutbolista,_).
esPuro(serCantante, Numero):-
  Numero < 200000.


% Punto 4

puedeAlegrar(Persona, Personaje) :-
  valorDeSuenio(Persona, _),
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
