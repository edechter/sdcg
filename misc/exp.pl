%%%  PRISM directives  %%%
target(failure,0).
target(success,0).
failure :-
        not(success).
success :-
        sdcg(_, []).
data(user).

%%%  MSW declarations  %%%
values(s(0), [s_0_2,s_0_1]).
values(a(1), [a_1_2,a_1_1]).

%%%  Start symbol  %%%
sdcg(A, B) :-
        s(A, B, 0).

%%%  Selector rules:  %%%
a(A, B, C, D) :-
        incr_depth(D, E),
        msw(a(1), F),
        sdcg_rule(F, A, B, C, E).
s(A, B, C) :-
        incr_depth(C, D),
        msw(s(0), E),
        sdcg_rule(E, A, B, D).

%%%  Implementation rules:  %%%
sdcg_rule(a_1_2, b, A, B, _) :-
	A = [b|B].
%	consume([b],B,A).
%	ap([b],B,A).
sdcg_rule(a_1_1, a, A, B, _) :-
	A = [a|B].
%	consume([a],B,A).
%	ap([a],B,A).
sdcg_rule(s_0_2, A, B, C) :-
        s(A, B, C).
sdcg_rule(s_0_1, A, B, C) :-
        a(D, A, E, C),
        a(D, E, B, C).

%%%  Utilities:  %%%
consume([A|B], A, B).
incr_depth(A, B) :-
        integer(A),
        B is A+1,
        B<10.
/*
consume([a],B,[a|B]).
consume([b],B,[a|B]).

fo_sort(ap(list,list,list)).
ap([],Y,Y). 
ap([H|X],Y,[H|Z]):- ap(X,Y,Z).
*/

%%%  User defined  %%%
sdcg_user_option(debug, yes).
