% Punto 1
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% Variante con un idenficador para cada suenio,
% Evita repetir info cuando varias personas tienen el mismo suenio
% Permite que los seuños tenga diferente aridad

sueniaCon(gabriel,loteria59).
sueniaCon(gabriel,jugarEnArsenal).
sueniaCon(juan,cantarPara100000).
sueniaCon(macarena,cantarPara100000).

ganarLoteria(loteria59,[5, 9]).
serFutbolista(jugarEnArsenal,arsenal).
serCantante(cantarPara100000,100000).

enfermo(conejoDePascua).

amigo(reyesMagos, campanita).
amigo(conejoDePascua, campanita).
amigo(cavenaghi, conejoDePascua).

esEquipoGrande(arsenal).

% Punto 2
valorDeSuenios(Persona, Valor):-
  cree(Persona, _),
  findall(Valor, (sueniaCon(Persona,Suenio),valorDeSuenio(Suenio, Valor)), ListaDeValores),
  sum_list(ListaDeValores, Valor).


ambiciosa(Persona) :-
  valorDeSuenios(Persona, Valor),
  Valor > 20.


quiereVenderMucho(Numeros) :-
  Numeros > 500000.

valorDeSuenio(Suenio, Valor) :-
  ganarLoteria(Suenio, Numeros),
  length(Numeros, Length),
  Valor is Length*10.
valorDeSuenio(Suenio, 3) :-
  serFutbolista(Suenio, Club),
  esEquipoGrande(Club).
valorDeSuenio(Suenio, 6) :-
  serFutbolista(Suenio,Club),
  not(esEquipoGrande(Club)).
valorDeSuenio(Suenio, 6) :-
  serCantante(Suenio,Numeros),
  quiereVenderMucho(Numeros).
valorDeSuenio(Suenio, 4) :-
  serCantante(Suenio,Numeros),
  not(quiereVenderMucho(Numeros)).

% Punto 3

tieneQuimica(Personaje, Persona) :-
  cree(Persona, Personaje),
  cumpleCondicionDeQuimica(Personaje, Persona).

cumpleCondicionDeQuimica(campanita, Persona) :-
  sueniaCon(Persona,Suenio),
  valorDeSuenio(Suenio, Numero),
  Numero > 5.

cumpleCondicionDeQuimica(Personaje, Persona) :-
  Personaje \= campanita,
  forall(sueniaCon(Persona, Suenio), esPuro(Suenio)),
  not(ambiciosa(Persona)).

esPuro(Suenio):-
  serFutbolista(Suenio,_).
esPuro(Suenio):-
  serCantante(Suenio,Numero),
  Numero < 200000.


% Punto 4

puedeAlegrar(Persona, Personaje) :-
  sueniaCon(Persona, _),
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
