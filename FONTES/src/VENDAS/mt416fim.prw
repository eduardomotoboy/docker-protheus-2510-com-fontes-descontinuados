#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT416FIM
Ponto de Entrada padrao da TOTVS executado ao finalizar a efetivacao
de Orcamento de Vendas em Pedido de Venda (MATA416).
Garante que todos os dados cadastrais do cliente (Natureza Financeira,
Tipo de Cliente, Transportadora, Vendedores, etc.) sejam preenchidos no Pedido (SC5).

@type  Function
@author Eduardo
@since 08/09/2026
/*/
User Function MT416FIM()

    Local aAreaSC5 := SC5->(GetArea())
    Local aAreaSA1 := SA1->(GetArea())
    Local cCliente := ""
    Local cLoja    := ""

    If Select("SC5") > 0 .And. !Empty(SC5->C5_NUM)
        cCliente := SC5->C5_CLIENTE
        cLoja    := SC5->C5_LOJACLI

        dbSelectArea("SA1")
        SA1->(dbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA

        If SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))
            RecLock("SC5", .F.)

            // 1. Natureza Financeira da operacao (A1_NATUREZ -> C5_NATUREZ)
            If Empty(SC5->C5_NATUREZ) .And. !Empty(SA1->A1_NATUREZ)
                SC5->C5_NATUREZ := SA1->A1_NATUREZ
            EndIf

            // 2. Tipo do Cliente (A1_TIPO -> C5_TIPOCLI)
            If Empty(SC5->C5_TIPOCLI) .And. !Empty(SA1->A1_TIPO)
                SC5->C5_TIPOCLI := SA1->A1_TIPO
            EndIf

            // 3. Transportadora padrao (A1_TRANSP -> C5_TRANSP)
            If SC5->(FieldPos("C5_TRANSP")) > 0 .And. Empty(SC5->C5_TRANSP) .And. !Empty(SA1->A1_TRANSP)
                SC5->C5_TRANSP := SA1->A1_TRANSP
            EndIf

            // 4. Redespacho (A1_REDESP -> C5_REDESP)
            If SC5->(FieldPos("C5_REDESP")) > 0 .And. Empty(SC5->C5_REDESP) .And. SA1->(FieldPos("A1_REDESP")) > 0 .And. !Empty(SA1->A1_REDESP)
                SC5->C5_REDESP := SA1->A1_REDESP
            EndIf

            // 5. Vendedor 1 (A1_VEND -> C5_VEND1)
            If Empty(SC5->C5_VEND1) .And. !Empty(SA1->A1_VEND)
                SC5->C5_VEND1 := SA1->A1_VEND
            EndIf

            // 6. Vendedor 2 (A1_VEND2 -> C5_VEND2)
            If SC5->(FieldPos("C5_VEND2")) > 0 .And. Empty(SC5->C5_VEND2) .And. SA1->(FieldPos("A1_VEND2")) > 0 .And. !Empty(SA1->A1_VEND2)
                SC5->C5_VEND2 := SA1->A1_VEND2
            EndIf

            // 7. Mensagem da Nota (A1_MENNOTA -> C5_MENNOTA)
            If SC5->(FieldPos("C5_MENNOTA")) > 0 .And. Empty(SC5->C5_MENNOTA) .And. SA1->(FieldPos("A1_MENNOTA")) > 0 .And. !Empty(SA1->A1_MENNOTA)
                SC5->C5_MENNOTA := SA1->A1_MENNOTA
            EndIf

            SC5->(MsUnlock())
        EndIf

        RestArea(aAreaSA1)
        RestArea(aAreaSC5)
    EndIf

Return Nil

/*/{Protheus.doc} MTA416PV
Ponto de Entrada padrao da TOTVS executado durante a montagem
do Pedido de Venda na efetivacao do orcamento (MATA416).
Inicializa variaveis de memoria do cabecalho (M->C5_NATUREZ, M->C5_TIPOCLI, etc).

@type  Function
@author Eduardo
@since 08/09/2026
/*/
User Function MTA416PV()

    Local aAreaSA1 := SA1->(GetArea())
    Local cCliente := ""
    Local cLoja    := ""

    // Captura cliente do pedido em memoria ou do orcamento posicionado
    If Type("M->C5_CLIENTE") != "U" .And. !Empty(M->C5_CLIENTE)
        cCliente := M->C5_CLIENTE
        cLoja    := IIf(Type("M->C5_LOJACLI") != "U", M->C5_LOJACLI, "")
    ElseIf Select("SCJ") > 0 .And. !Empty(SCJ->CJ_CLIENTE)
        cCliente := SCJ->CJ_CLIENTE
        cLoja    := SCJ->CJ_LOJA
    EndIf

    If !Empty(cCliente)
        dbSelectArea("SA1")
        SA1->(dbSetOrder(1))

        If SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))

            // 1. Natureza Financeira na memoria
            If Type("M->C5_NATUREZ") != "U" .And. Empty(M->C5_NATUREZ) .And. !Empty(SA1->A1_NATUREZ)
                M->C5_NATUREZ := SA1->A1_NATUREZ
            EndIf

            // 2. Tipo do Cliente na memoria
            If Type("M->C5_TIPOCLI") != "U" .And. Empty(M->C5_TIPOCLI) .And. !Empty(SA1->A1_TIPO)
                M->C5_TIPOCLI := SA1->A1_TIPO
            EndIf

            // 3. Transportadora padrao na memoria
            If Type("M->C5_TRANSP") != "U" .And. Empty(M->C5_TRANSP) .And. !Empty(SA1->A1_TRANSP)
                M->C5_TRANSP := SA1->A1_TRANSP
            EndIf

            // 4. Vendedor 1 padrao na memoria (se vazio)
            If Type("M->C5_VEND1") != "U" .And. Empty(M->C5_VEND1) .And. !Empty(SA1->A1_VEND)
                M->C5_VEND1 := SA1->A1_VEND
            EndIf

        EndIf

        RestArea(aAreaSA1)
    EndIf

Return Nil

