#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MA415MNU
Ponto de Entrada padrao TOTVS no menu de Orcamentos de Venda (MATA415).
Adiciona o botao "Importar Cotacao (Excel)" no menu Outras Acoes.
@type  Function
@author Eduardo
@since 04/09/2026
/*/
User Function MA415MNU()

    // aRotina e a variavel publica nativa do MATA415 com os botoes da tela
    aAdd(aRotina, {"Importar Cotacao (Excel)", "U_IMPCOT()", 0, 3, 0, .F.})
    aAdd(aRotina, {"Efetivar em Pedido", "MATA416()", 0, 4, 0, .F.})

Return Nil

