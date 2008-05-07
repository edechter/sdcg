%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Various general purpose utilities
% Author: Christian Theil Have <cth@itu.dk>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dot :- write('.').

% Tell me if X is a list (note, doesn't work with empty lists )
is_list(X) :-
	nonvar(X),
	functor(X,'.',_).

% Test if X is inclosed in curly brackets
is_code_block(X) :-
	nonvar(X),
	functor(X, {}, _).

% Test if clause has multiple constituents
is_composed(X) :-
	functor(X, ',', _).

% Create a list of unground vars, which can subsequently be used
% to unify with something.
unifiable_list(0,[]).
unifiable_list(Len,[_A|L]) :-
	NewLen is Len - 1,
	unifiable_list(NewLen,L), !.

compose_list((E1,E2), [E1|Rest]) :- compose_list(E2, Rest).
compose_list(E, [E]).

compact_list([],[]).
compact_list([L],[L]).
compact_list([L1,L2|Rest], CL) :-
	is_list(L1), 
	is_list(L2),
	append(L1,L2,L3),
	compact_list([L3|Rest],CL).
compact_list([L1,L2|Rest],CL) :-
	compact_list([L2|Rest],CL1),
	append([L1],CL1,CL).

% assert_once always succeds
assert_once(C) :-
	(not(clause(C,_)) -> assert(C) ; true).
	replacement_name(Name, Arity, Number, NewName) :-
	hyphenate(Name, Arity, N1),
	hyphenate(N1,Number,NewName).

% Stitch together the first tree arguments
% as the fourth: eg. 
% hyphenate(noun, 3, 2, noun_3_2) => true
hyphenate(First, Second, Hyphenated) :-
	ground(First),
	ground(Second),
	Hyphen = "_",
	name(First, FirstList),
	name(Second, SecondList),
	append(FirstList, Hyphen, L1),
	append(L1, SecondList, L2),
	name(Hyphenated, L2).

% Hyphenate also works in the opposite direction
% Eg. hyphenate(O,A,N,noun_3_2)	 => O=noun, A=3, N=2
hyphenate(First,Second,Hyphenated) :-
	ground(Hyphenated),
	peel_rightmost(Hyphenated, FirstList, SecondList),
	name(First,FirstList),
	name(Second,SecondList).

% Peels of the rightmost hyphen and arg
% eg. peel("test_1_2", "test_1", "2") => true
peel_rightmost(Input, Rest, Arg) :-
	"_" = [ Hyphen ],
	(is_list(Input) -> InputCodes = Input ; atom_codes(Input, InputCodes)),
	reverse(InputCodes,Reversed),
	append(A,B,Reversed),
	B = [ Hyphen | _], 
	reverse(A,Arg),
	append(Rest,[ Hyphen | Arg],InputCodes), !.
	
remove_ground([],[]).
remove_ground([V|R],NotGround) :-
	remove_ground(R,NotGroundRest),
	(ground(V) ->
		NotGround = NotGroundRest
	;
		append([V],NotGroundRest,NotGround)
	).

% Removes empty list elements from a list
remove_empty([],[]).
remove_empty([[]|R],NonEmpty) :- remove_empty(R,NonEmpty).
remove_empty([E|R],[E|NonEmpty]) :- remove_empty(R,NonEmpty).

% Flatten a list at depth one. 
flatten_once([],[]).
flatten_once([[]|R],FlatRest) :- flatten_once(R,FlatRest).
flatten_once([[E|ER]|R],[E|FlatRest]) :-
	flatten_once(R,FlatR),
	append(ER,FlatR,FlatRest).

% Converts a list of rules to a clause
list_to_clause([E],(E)).
list_to_clause([E|L],(E,ClauseRest)) :-
	list_to_clause(L,ClauseRest).

% Converts a clause to a list of rules
clause_to_list(A,[A]).
clause_to_list((A,B),L) :-
	(functor(B,',',2) ->
		clause_to_list(B,C),
		L = [A|C]
	;
		L = [A,B]
	).

% Outputs each element of a list on a separate line
write_list([]).
write_list([E|Rest]) :-
	write(E),nl,
	write_list(Rest).