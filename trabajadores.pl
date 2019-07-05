%% quedaEn(lugar, lugar)
quedaEn(venezuela, america).
quedaEn(argentina, america).
quedaEn(patagonia, argentina).
quedaEn(aula522, utn). % Sí, un aula es un lugar!
quedaEn(utn, buenosAires).
quedaEn(buenosAires, argentina).

% Functores Tareas:
%tomarExamen(tema,lugar)
%hacerDiscurso(lugar,cantPublico)
%meterGol(torneo)

% predicado tarea
% tarea(persona,functor,fecha(dia,mes,anio))
tarea(dani,tomarExamen(paradigmaLogico,aula522),fecha(10,8,2017)).
tarea(alf,hacerDiscurso(utn,0),fecha(10,8,2017)).
tarea(dani,meterGol(primeraDivision),fecha(10,8,2017)).

% predicado nacioEn
nacioEn(dani,buenosAires).
nacioEn(nico,buenosAires).
nacioEn(alf,buenosAires).


%%%%%%% 1)
nuncaSalioDeCasa(Trabajador):-
	nacioEn(Trabajador,Nacimiento),
	forall(tarea(Trabajador,Tarea,_),lugar(Tarea,Nacimiento)).

lugar(hacerDiscurso(Lugar,_),Lugar).
lugar(tomarExamen(_,Lugar),Lugar).
lugar(meterGol(Torneo), Lugar):-
	seJuegaEn(Torneo,Lugar).

seJuegaEn(primeraDivision,argentina). % Este es de la info que piden agregar.

%%%%%%% 2)

estresante(Tarea):- 
    lugar(Tarea,Lugar),
    quedaEnArgentina(Lugar),
    esTareaEstresante(Tarea).

esTareaEstresante(tomarExamen(Tema,_)):- complejo(Tema).
esTareaEstresante(meterGol(_)).
esTareaEstresante(hacerDiscurso(_,CantPublico)):- hayMuchaGente(CantPublico).

complejo(paradigmaFuncional).  % Este es de la info que piden agregar.

hayMuchaGente(CantPublico):- 
    CantPublico > 30000.
quedaEnArgentina(Lugar):- 
    estaDentroDe(Lugar,argentina).

estaDentroDe(LugarHijo, LugarPadre):- 
    quedaEn(LugarHijo,LugarPadre).
estaDentroDe(LugarHijo, LugarPadre):-
    quedaEn(LugarHijo,OtroLugar),
    estaDentroDe(OtroLugar, LugarPadre).

% Variante, que repite logica y no aprovecha bien el 
% polimorfismo

/*
estresante(meterGol(Torneo)):-
	seJuegaEn(Torneo,Lugar),
	quedaEnArgentina(Lugar).

estresante(hacerDiscurso(Lugar,CantPublico)):-
	quedaEnArgentina(Lugar),
	hayMuchaGente(CantPublico).

hayMuchaGente(CantPublico):- CantPublico > 30000.

estresante(tomarExamen(Tema,Lugar)):-
	complejo(Tema),
	quedaEnArgentina(Lugar).
*/


%%%%%%% 3)

% Versión no inversible 
calificacion(Trabajador,zen):-
	not(hizoTareaEstresante(Trabajador,_)).

% Versión inversible 
calificacion(Trabajador,zen):-
	trabajador(Trabajador), %Generamos al trabajador
    not(hizoTareaEstresante(Trabajador,_)).

calificacion(Trabajador,loco):-
	trabajador(Trabajador), %Generamos para que sea inversible
	forall(tarea(Trabajador,Tarea,fecha(_,_2017)),estresante(Tarea)).

calificacion(Trabajador,sabio):-
	hizoTareaEstresante(Trabajador,Tarea), % Es inversible
	not((hizoTareaEstresante(Trabador,Tarea2),Tarea\=Tarea2)).

hizoTareaEstresante(Trabajador,Tarea):-
    tarea(Trabajador,Tarea,_),
    estresante(Tarea).

%%%%%%% 4)
% Version con not, nadie lo supera
estresDeTodosLosTiempos(Quien):-
	cantidadTareasEstresantes(Quien,CantMax),
	not((cantidadTareasEstresantes(_,Cant),Cant > CantMax)).

% Version con forall, supera a todos
estresDeTodosLosTiempos(Quien):-
	cantidadTareasEstresantes(Quien,CantMax),
	forall(cantidadTareasEstresantes(_,Cant),CantMax >= Cant).

cantidadTareasEstresantes(Quien,Cant):-
	nacioEn(Quien,_),
	findall(Tarea,hizoTareaEstresante(Quien,Tarea),Estresantes),
	length(Estresantes,Cant).
