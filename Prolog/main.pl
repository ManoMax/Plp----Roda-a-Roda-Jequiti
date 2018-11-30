:- initialization(main).
:- use_module(menus).
:- dynamic tema/1, qtdRodadas/1, qtdJogadores/1, nome01/1, pontos1/1, nome02/1, pontos2/1, nome03/1, pontos3/1, pontosT01/1, pontosT02/1, pontosT03/1, letras/1.

arquivo(Lines) :-
    open('Palavras.txt', read, Str),
    read_file(Str,Lines),
    close(Str).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).
 
palavraDica(Palavra, Dica) :-
    tema(T) -> ( 
        T == "Geografia", I is 0, F is 20;
        T == "Marcas", I is 20, F is 40;
        I is 40, F is 60
        ),
    arquivo(L),
    random(I, F, R),
    K is (R + 60),
    itemPorIndice(0, R, L, Palavra),
    itemPorIndice(0, K, L, Dica).

itemPorIndice(I, N, [H|T], E) :-
    K is (I + 1) -> (
        I =:= N, E = H;
        itemPorIndice(K, N, T, E)).

lista(X) :- X = [50,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,"Perdeu tudo","Perdeu tudo","Passou a vez","Passou a vez","Passou a vez"].

letras_bot(Y) :- Y["A","E","I","O","U"].

roleta(Y):-
    lista(X),
    random_member(Y, X).

caso1 :-
    menus: limpaTela,
    menus:telaDeOpcoes,
    lerString(Op) -> ( 
        Op == "2", menus: limpaTela, menus: regras;
        Op == "1", caso2;
        Op \= "1", Op \= "2", menus: limpaTela, menus: opcaoInvalida, caso1;
        caso1
        ).
    
caso2 :-
    menus: limpaTela,
    menus:escolherTema,
    lerString(Tema)->(
        Tema \= "1", Tema \= "2", Tema \= "3", menus: limpaTela, menus: opcaoInvalida, caso2;
        true -> (Tema == "1", T = "Geografia"; Tema == "2", T = "Marcas"; Tema == "3", T = "Filmes"),
        assert(tema(T)), caso3
        ).
    
caso3() :-
    menus: limpaTela,
    menus:escolherQtdRodadas,
    lerString(Entrada),
    atom_number(Entrada, QtdRodadas)->(
        QtdRodadas >= 1, QtdRodadas =< 10, assert(qtdRodadas(QtdRodadas)), caso4;
        menus: limpaTela, menus:opcaoInvalida, caso3()
        ).
    
caso4():-
    menus: limpaTela,
    menus: comecar,
    lerString(Jogadores),
    cadastraJogadores(Jogadores).

cadastraJogadores("1") :-
    menus: limpaTela,
    writeln("Digite seu nome: "),
    lerString(Nome),
    assert(nome01(Nome)),
    assert(pontos1(0)),
    assert(nome02("Bot 01")),
    assert(pontos2(0)), 
    assert(nome03("Bot 02")),
    assert(pontos3(0)),
    rodadas(1).
    
cadastraJogadores("2"):-
    menus: limpaTela,
    writeln("Jogador 01, digite seu nome: "),
    lerString(Nome01),
    menus: limpaTela,
    writeln("Jogador 02, digite seu nome: "),
    lerString(Nome02),
    assert(nome01(Nome01)),
    assert(pontos1(0)), 
    assert(nome02(Nome02)),
    assert(pontos2(0)), 
    assert(nome03("Bot 02")),
    assert(pontos3(0)),
    rodadas(1).
    
cadastraJogadores("3"):-
    menus: limpaTela,
    writeln("Jogador 01, digite seu nome: "),
    lerString(Nome01),
    menus: limpaTela,
    writeln("Jogador 02, digite seu nome: "),
    lerString(Nome02),
    menus: limpaTela,
    writeln("Jogador 03, digite seu nome: "),
    lerString(Nome03),
    assert(nome01(Nome01)),
    assert(pontos1(0)), 
    assert(nome02(Nome02)),
    assert(pontos2(0)), 
    assert(nome03(Nome03)),
    assert(pontos3(0)),
    rodadas(1).

cadastraJogadores(_) :-
    menus: limpaTela,
    menus:opcaoInvalida,
    caso4.

rodadas(NumeroRodada) :-
    qtdRodadas(X) ->
        (NumeroRodada > X, rodadaFinal;
        NumeroRodada < (X + 1),
        palavraDica(Palavra, Dica),
        string_chars(Palavra, Chars),
        assert(pontosT01(0)), assert(pontosT02(0)), assert(pontosT03(0)),
        cobrirPalavra(Chars, Res),
        atomic_list_concat(Res, PalavraCoberta),
        assert(letras("")),
        jogadas(1, NumeroRodada, PalavraCoberta, Palavra, Dica),
        write(">> Rodada N°: "), writeln(NumeroRodada),
        menus: pontuacaoGeral,
        retract(pontosT01(_)), retract(pontosT02(_)), retract(pontosT03(_)),
        retract(letras(_)),
        nome01(Nome01), nome02(Nome02), nome03(Nome03),
        pontos1(P1), pontos2(P2), pontos3(P3),
        write("Pontuação do jogador(a) "), write(Nome01), write(": "), writeln(P1),
        write("Pontuação do jogador(a) "), write(Nome02), write(": "), writeln(P2),
        write("Pontuação do jogador(a) "), write(Nome03), write(": "), writeln(P3), 
        sleep(5),
        Aux is (NumeroRodada + 1),
        rodadas(Aux)).

jogadas(Vez, NumeroRodada, PalavraCoberta, Palavra, Dica) :-
    tema(Tem), letras(Letras),
    menus: limpaTela,
    alteraVez(Vez, Nvez),
    nome01(Nome01), nome02(Nome02), nome03(Nome03),
    pontosT01(PT1), pontosT02(PT2), pontosT03(PT3),
    write(">> Rodada N°: "), writeln(NumeroRodada),
    writeln("*************************** Pontuação *********************************"),
    write(Nome01), write(": "), write(PT1), write(" pontos    ||    "),
    write(Nome02), write(": "), write(PT2), write(" pontos    ||    "),
    write(Nome03), write(": "), write(PT3), writeln(" pontos"),
    writeln("***********************************************************************"),
    write("Tema: "), writeln(Tem),
    write("Dica: "), writeln(Dica),
    write("Palavra: "), write(Palavra), write(" // "), writeln(PalavraCoberta),
    write("Letra(s) já escolhida(s): "), writeln(Letras),
    writeln("Girando a roleta..."),
    string_chars(PalavraCoberta, PCChar),
    qntCoberta(PCChar, C),
    sleep(2),
    roleta(R),
    nomeDaVez(Vez, Nome) -> (
        R = "Perdeu tudo",
        writeln("Perdeu tudo..."),
        zeraPontuacao(Vez), 
        sleep(2), 
        jogadas(Nvez, NumeroRodada, PalavraCoberta, Palavra, Dica);
        R = "Passou a vez",
        writeln("Passou a vez..."),
        sleep(2),
        jogadas(Nvez,NumeroRodada, PalavraCoberta, Palavra, Dica);
        R \= "Perdeu tudo", 
        R \= "Passou a vez" -> (
            C < 4,
            write("Valendo "), write(R), write(" pontos por letra restante, "), write(Nome), 
            writeln(" digite a palavra corretamente:"),
            lerString(PalavraT),
            string_upper(PalavraT, UPalavraT) -> (
                UPalavraT = Palavra,
                Pon is (R * C),
                write("Parabens, você acertou a palavra e ganhou "), write(Pon), writeln(" pontos"),
                sleep(2),
                alterarPontuacao(Vez, Pon),
                alterarPontuacaoPermanente(Vez),
                writeln("CHECKJ"),
                sleep(2);
                UPalavraT \= Palavra,
                writeln("Que pena... Você nãoaaa acertou a palavra."),
                sleep(2),
                jogadas(Nvez, NumeroRodada, PalavraCoberta, Palavra, Dica)
            );
            C > 3, write(">> Valendo "), write(R), write(" pontos por letra, "), write(Nome), writeln(" digite uma letra:"),
            lerString(Tentativa),
            string_upper(Tentativa, UTentativa),
            string_chars(UTentativa, [HChar|_]),
            string_chars(Letras, LChar),
            contarLetras(HChar, LChar, NO) -> (
                NO \= 0, writeln("Letra já escolhida anteriormente."),
                sleep(2),
                jogadas(Nvez, NumeroRodada, PalavraCoberta, Palavra, Dica);
                NO =:= 0, string_chars(Palavra, PChar),
                atualizarLetras(Letras, HChar),
                contarLetras(HChar, PChar, NL) -> (
                    NL =:= 0, writeln("Que pena, você não acertou nenhuma letra..."),
                    sleep(2),
                    jogadas(Nvez, NumeroRodada, PalavraCoberta, Palavra, Dica);
                    NL \= 0, descobrirPalavra(HChar, PChar, PCChar, Res),
                    atomic_list_concat(Res, NPalavraCoberta),
                    NP is (R * NL),
                    alterarPontuacao(Vez, NP),
                    write("Parabens "), write(Nome), write(", você acertou "), write(NL),
                    write(" letras e ganhou "), write(NP), writeln(" pontos."),
                    sleep(2),
                    jogadas(Vez, NumeroRodada, NPalavraCoberta, Palavra, Dica)
                    )
                ))).

alterarPontuacaoPermanente(V) :-
    V =:= 1, retract(pontos1(_)), assert(pontos1(10)),
    V =:= 2, retract(pontos2(_)), assert(pontos2(20)),
    V =:= 3, retract(pontos3(_)), assert(pontos3(30)).

atualizarLetras(Letras, L) :-
    string_concat(Letras, L, N0), string_concat(N0, " ", N1),
    retract(letras(_)),
    assert(letras(N1)). 

contarLetras(_, [], 0).
contarLetras(L, [PH|PT], K) :-
    contarLetras(L, PT, N) -> (
        L == PH, K is (N + 1);
        L \= PH, K is N).

descobrirPalavra(_, [], [], []).
descobrirPalavra(L, [PH|PT], [PCH|PCT], [H|T]) :-
   descobrirPalavra(L, PT, PCT, T) -> (
       L == PH, H = PH;
       L \= PH, H = PCH).

lerString(X) :-
    read_line_to_string(user_input, X).

cobre(' ', " ").
cobre(_, "#").

cobrirPalavra([], []).
cobrirPalavra([H|T], [R|T2]):-
    cobre(H, R), cobrirPalavra(T, T2).

qntCoberta([], 0).
qntCoberta([H|T], K):-
    qntCoberta(T, Q) -> (
        H == '#', K is (Q + 1);
        H \= '#', K is Q).

alteraVez(Vez, R) :-
    Vez =:= 1, R is 2;
    Vez =:= 2, R is 3;
    Vez =:= 3, R is 1.

nomeDaVez(Vez, R) :- 
    Vez =:= 1, nome01(R);
    Vez =:= 2, nome02(R);
    Vez =:= 3, nome03(R).

zeraPontuacao(Vez) :-
    Vez =:= 1, retract(pontosT01(_)), assert(pontosT01(0));
    Vez =:= 2, retract(pontosT02(_)), assert(pontosT02(0));
    Vez =:= 3, retract(pontosT03(_)), assert(pontosT03(0)).

alterarPontuacao(Vez, N) :-
    Vez =:= 1, retract(pontosT01(P1)), K1 is (P1 + N), assert(pontosT01(K1));
    Vez =:= 2, retract(pontosT02(P2)), K2 is (P2 + N), assert(pontosT02(K2));
    Vez =:= 3, retract(pontosT03(P3)), K3 is (P3 + N), assert(pontosT03(K3)).

rodadaFinal :-
    writeln("H89SH89ASHAS").

main :-
    menus: limpaTela,
    menus:telaInicial,
    caso1,
    halt(0).
