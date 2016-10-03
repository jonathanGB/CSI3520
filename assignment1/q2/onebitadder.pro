% CSI 3520 Devoir 1 Question 2
% Nom de l'élève : Jonathan Guillotte-Blouin
% Nombre d' étudiants : 7900293
% Courriel d’étudiant: jguil098@uottawa.ca

:- use_module(library(clpfd)).

%% Facts...

signal(_, 0).
signal(_, 1).


%% Rules...

% 1. Si les deux bornes sont reliées , elles ont le même signal
connected(T1, T2) :- terminal(T1), terminal(T2), signal(T1, X), signal(T2, X).

% 2. Le signal à chaque terminal est 1 ou 0
terminal(T) :- signal(T, _).

% 3. Connected est commutative
% ... already handled by 1.

% 4. Il existe quatre types de portes
gate(G) :- gate_type(G, _).
% ... handled by 5-8.

% 5. La sortie d'une porte AND est 0 si et seulement si (ssi) l'une de ses entrées est 0
gate_type(G, and) :- signal(in(_, G), 0), signal(out(1, G), 0), !.
gate_type(G, and) :- signal(out(1, G), 1).

% 6. La production d'une porte OR est 1 si et seulement si l'une de ses entrées est 1
gate_type(G, or)  :- signal(in(_, G), 1), signal(out(1, G), 1), !.
gate_type(G, or)  :- signal(out(1, G), 0).

% 7. La production d'une porte XOR est égal à 1 si et seulement si les entrées sont différentes
gate_type(G, xor) :- signal(in(1, G), X), signal(in(2, G), Y), X \= Y, signal(out(1, G), 1), !.
gate_type(G, xor) :- signal(out(1, G), 0).

% 8. La sortie d’une porte NOT est différente de son entrée
gate_type(G, not) :- signal(in(1, G), X), signal(_, Y), X \= Y, signal(out(1, G), Y).

% 9. Les portes (sauf pour NOT) possèdent deux entrées et une sortie
arity(G, In, Out) :- gate_type(G, not), In = 1, Out = 1.
arity(G, In, Out) :- gate_type(G, Type), Type \= not, In = 2, Out = 1.

% 10. Un circuit a des bornes, jusqu'à ‘arité de ces entrée et sortie, et rien au-delà de son arité.
circuit(C) :- arity(C, _, _).
arity(C, I, J) :- terminal(in(Ni, C)), Ni =< I, !, terminal(out(Nj, C)), Nj =< J, !.
arity(C, I, J) :- terminal(Nothing).

% 11. Portes , terminaux, les signaux , les types de portes et rien sont tous distincts.
distinct(gate(G), terminal(T)) :-  all_distinct([G, T, 1, 0, and, or, xor, not, Nothing]).

% 12. Portes sont des circuits.
circuit(G) :- gate(G).




%% Predicates

circuit(c1).
arity(c1, 3, 2).

gate(x1).
gate_type(x1, xor).

gate(x2).
gate_type(x2, xor).

gate(a1).
gate_type(a1, and).

gate(a2).
gate_type(a2, and).

gate(o1).
gate_type(o1, or).

connected(out(1, x1), in(1, x2)).
connected(out(1, x1), in(2, a2)).
connected(out(1, a2), in(1, o1)).
connected(out(1, a1), in(2, o1)).
connected(out(1, x2), out(1, c1)).
connected(out(1, o1), out(2, c1)).
connected(in(1, c1), in(1, x1)).
connected(in(1, c1), in(1, a1)).
connected(in(2, c1), in(2, x1)).
connected(in(2, c1), in(2, a1)).
connected(in(3, c1), in(2, x2)).
connected(in(3, c1), in(1, a2)).
