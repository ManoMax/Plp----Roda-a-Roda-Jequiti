:- initialization(main).

:- use_module(menus).

:- dynamic(tema/1).
:- dynamic(rodadas/1).
:- dynamic(qtdJogadores/1).

limpaTela() :-
	shell("clear").

caso1 :-
    limpaTela,
    menus:telaDeOpcoes,
    lerString(Op) -> ( 
        Op == "2", limpaTela, menus:regras;
        Op == "1", caso2;
        Op \= "1", Op \= "2", limpaTela, menus: opcaoInvalida, caso1;
        caso1
        ).
    
caso2 :-
    limpaTela,
    menus:escolherTema,
    lerString(Tema)->(
        Tema \= "1", Tema \= "2", Tema \= "3", menus:opcaoInvalida, caso2;
        assert(tema(Tema)), caso3 
        ).
    
caso3() :-
    limpaTela,
    menus:escolherQtdRodadas,
    lerString(Qtd),
    atom_number(Qtd, X)->(
        X >= 1, X =< 10, assert(rodadas(Qtd)), caso4;
        menus:opcaoInvalida, caso3()
        ).
    
caso4():-
    limpaTela,
    menus: comecar,
    lerString(QtdJogadores),
    atom_number(QtdJogadores, Y)->(
        Y >= 1, Y =< 3, assert(qtdJogadores(QtdJogadores));
        menus:opcaoInvalida, caso4()
        ),
    comecar.
    
comecar():-
    retract(tema(Tema)),
    writeln(Tema).


main :-
    limpaTela,
    menus:telaInicial,
    caso1,
    halt(0).
    
    
lerString(X) :-
    read_line_to_string(user_input, X).