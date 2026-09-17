#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"

#DEFINE DMPAPER_A4 9

/*/{Protheus.doc} PEDCOMPRA
Relatorio customizado para impressao de Pedido de Compra (MATA120).
Substitui o modelo padrao (MATR110) com layout limpo e direto em PDF.
@type  Function
@author Eduardo
@since 03/09/2026
/*/
User Function PEDCOMPRA(cPedDe, cPedAte, lPerg)

    Local oReport
    Local cPerg      := "PEDCOMPRA"
    Local nFormato   := 1 // 1=PDF, 2=Excel
    Local nOrient    := 1 // 1=Retrato, 2=Paisagem
    Local lLandscape := .F.

    Default cPedDe  := ""
    Default cPedAte := ""
    Default lPerg   := .T.

    // 1. Selecao de formato de impressao (PDF ou Excel)
    nFormato := Aviso("Formato de Impressao", "Como deseja gerar o Pedido de Compra?", {"PDF", "Excel", "Cancelar"}, 2)

    If nFormato == 3 .Or. nFormato == 0
        Return Nil
    EndIf

    // 2. Se escolheu PDF, pergunta a orientacao da folha
    If nFormato == 1
        nOrient := Aviso("Orientacao da Folha", "Escolha a orientacao do PDF (Paisagem/Horizontal exibe a descricao completa):", {"Retrato (Vertical)", "Paisagem (Horizontal)", "Cancelar"}, 2)
        If nOrient == 3 .Or. nOrient == 0
            Return Nil
        EndIf
        lLandscape := (nOrient == 2)
    EndIf

    // Se a tabela SC7 ja estiver posicionada no browse/tela do MATA120
    If Empty(cPedDe) .And. Select("SC7") > 0 .And. !Empty(SC7->C7_NUM)
        cPedDe  := SC7->C7_NUM
        cPedAte := SC7->C7_NUM
        lPerg   := .F.
    EndIf

    // Se chamado pelo menu geral de relatorios, solicita o intervalo de pedidos
    If lPerg
        AjustaSX1(cPerg)
        If Pergunte(cPerg, .T.)
            cPedDe  := MV_PAR01
            cPedAte := MV_PAR02
        Else
            Return Nil
        EndIf
    Else
        If Empty(cPedAte)
            cPedAte := cPedDe
        EndIf
    EndIf

    If !Empty(cPedDe)
        If nFormato == 1
            // Formato PDF (Relatorio Grafico com Cabecalho e Caixas)
            oReport := FWMSPrinter():New("PedidoCompra.rel", IMP_PDF, .F., "", .T., , , , , , .F.)
            oReport:SetResolution(72)
            oReport:SetMargin(30, 30, 30, 30)

            If lLandscape
                oReport:SetLandscape()
            Else
                oReport:SetPortrait()
            EndIf

            Processa({|lEnd| ImpPedCompr(@oReport, cPedDe, cPedAte, lLandscape)}, "Gerando Impressao do Pedido de Compra...")

            oReport:Preview()
        ElseIf nFormato == 2
            // Formato Excel (Planilha Tabular com Totalizadores)
            Processa({|lEnd| ExpPedCompr(cPedDe, cPedAte)}, "Gerando Planilha Excel...")
        EndIf
    EndIf

Return Nil

/*-------------------------------------------------------------------
  Rotina principal de busca de dados e desenho das paginas
  Layout oficial idêntico ao modelo MATR110 solicitado
-------------------------------------------------------------------*/
Static Function ImpPedCompr(oReport, cPedDe, cPedAte, lLandscape)

    Local oFontTit1    := TFont():New("Arial", , -12, .T.)
    Local oFontTit2    := TFont():New("Arial", , -10, .T.)
    Local oFontSec     := TFont():New("Arial", , -09, .T.)
    Local oFontBold    := TFont():New("Arial", , -08, .T.)
    Local oFontNorm    := TFont():New("Arial", , -08, .F.)
    Local oFontItemBld := TFont():New("Arial", , -07, .T.)
    Local oFontItem    := TFont():New("Arial", , -07, .F.)

    Local nLinha       := 0
    Local cPedAtual    := ""
    Local cQuery       := ""
    Local cAliasSC7    := GetNextAlias()
    Local cAliasSCR    := ""
    Local cQrySCR      := ""

    Local cMoeda       := "1  REAL"
    Local cEmissao     := ""
    Local cDescCond    := ""
    Local cObs         := ""
    Local cStatus      := ""
    Local cComprador   := ""
    Local cAprov       := ""
    Local cNomeUsr     := ""

    Local cNomeEmp     := ""
    Local cCgcEmp      := ""
    Local cEndEmp      := ""
    Local cCepEmp      := ""
    Local cCidEmp      := ""
    Local cTelEmp      := ""
    Local cLocEnt      := ""
    Local cLocCob      := ""

    Local cNomeForn    := ""
    Local cCgcForn     := ""
    Local cEndForn     := ""
    Local cCepForn     := ""
    Local cCodForn     := ""

    Local nTotMerc     := 0
    Local nTotDesc     := 0
    Local nTotDesp     := 0
    Local nTotSeg      := 0
    Local nTotFre      := 0
    Local nTotIPI      := 0
    Local nTotICM      := 0
    Local nTotCImp     := 0

    Local aItens       := {}
    Local nI           := 0

    Local nMaxX        := 0
    Local nColDir      := 0
    Local nValDir      := 0
    Local nTitX        := 0
    Local nMoedaX      := 0
    Local nEmpSecX     := 0
    Local nFornSecX    := 0
    Local nBoxTitX     := 0
    Local nAprovTitX   := 0
    Local nLimPage     := 0

    Default lLandscape := .F.

    // Coordenadas dinamicas: Paisagem (largura 810) vs Retrato (largura 565)
    nMaxX        := IIf(lLandscape, 810, 565)
    nColDir      := IIf(lLandscape, 435, 305)
    nValDir      := IIf(lLandscape, 505, 370)
    nTitX        := IIf(lLandscape, 350, 230)
    nMoedaX      := IIf(lLandscape, 670, 420)
    nEmpSecX     := IIf(lLandscape, 170, 110)
    nFornSecX    := IIf(lLandscape, 570, 360)
    nBoxTitX     := IIf(lLandscape, 370, 250)
    nAprovTitX   := IIf(lLandscape, 385, 260)
    nLimPage     := IIf(lLandscape, 470, 710)

    // Informacoes da Empresa (SM0)
    cNomeEmp := AllTrim(SM0->M0_NOMECOM)
    cCgcEmp  := Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")
    cEndEmp  := AllTrim(SM0->M0_ENDENT)
    cCepEmp  := AllTrim(SM0->M0_CEPENT)
    cCidEmp  := AllTrim(SM0->M0_CIDENT)
    If Empty(cEndEmp); cEndEmp := AllTrim(SM0->M0_ENDCOB); EndIf
    If Empty(cCepEmp); cCepEmp := AllTrim(SM0->M0_CEPCOB); EndIf
    If Empty(cCidEmp); cCidEmp := AllTrim(SM0->M0_CIDCOB); EndIf
    cTelEmp  := AllTrim(SM0->M0_TEL)

    cLocEnt := cEndEmp
    If !Empty(cCidEmp); cLocEnt += " - " + cCidEmp; EndIf
    If !Empty(cCepEmp); cLocEnt += " - " + cCepEmp; EndIf
    cLocCob := AllTrim(SM0->M0_ENDCOB)
    If Empty(cLocCob); cLocCob := cEndEmp; EndIf

    // Consulta de Pedidos e Itens
    cQuery := " SELECT C7_NUM, C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_COND, C7_CONTATO, C7_FILENT, "
    cQuery += "        C7_MOEDA, C7_CONAPRO, C7_COMPRA, C7_USER, C7_OBS, C7_CC, "
    cQuery += "        C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_UM, C7_PRECO, C7_TOTAL, C7_DATPRF, "
    cQuery += "        C7_VLDESC, C7_DESPESA, C7_SEGURO, C7_VALFRE, C7_VALIPI, C7_VALICM, "
    cQuery += "        A2_NOME, A2_CGC, A2_END, A2_CEP, A2_MUN, A2_EST, A2_TEL, "
    cQuery += "        COALESCE(E4_DESCRI, ' ') AS E4_DESCRI "
    cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
    cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 "
    cQuery += "   ON A2_FILIAL = '" + xFilial("SA2") + "' "
    cQuery += "  AND A2_COD = C7_FORNECE "
    cQuery += "  AND A2_LOJA = C7_LOJA "
    cQuery += "  AND SA2.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN " + RetSqlName("SE4") + " SE4 "
    cQuery += "   ON E4_FILIAL = '" + xFilial("SE4") + "' "
    cQuery += "  AND E4_CODIGO = C7_COND "
    cQuery += "  AND SE4.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
    cQuery += "   AND C7_NUM BETWEEN '" + cPedDe + "' AND '" + cPedAte + "' "
    cQuery += "   AND SC7.D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY C7_NUM, C7_ITEM "

    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), cAliasSC7, .F., .T.)

    While !(cAliasSC7)->(EoF())

        cPedAtual := (cAliasSC7)->C7_NUM
        cEmissao  := (cAliasSC7)->C7_EMISSAO
        cObs      := AllTrim((cAliasSC7)->C7_OBS)
        cMoeda    := IIf((cAliasSC7)->C7_MOEDA <= 1, "1  REAL", AllTrim(Str((cAliasSC7)->C7_MOEDA)))
        cStatus   := IIf((cAliasSC7)->C7_CONAPRO == "B", "Bloqueado", "Liberado")

        // Descricao da Condicao de Pagamento
        cDescCond := AllTrim((cAliasSC7)->E4_DESCRI)
        If Empty(cDescCond)
            cDescCond := AllTrim(Posicione("SE4", 1, xFilial("SE4") + (cAliasSC7)->C7_COND, "E4_DESCRI"))
        EndIf
        If Empty(cDescCond); cDescCond := (cAliasSC7)->C7_COND; EndIf

        // Fornecedor
        cNomeForn := AllTrim((cAliasSC7)->A2_NOME)
        cCgcForn  := AllTrim((cAliasSC7)->A2_CGC)
        If Len(cCgcForn) == 14
            cCgcForn := Transform(cCgcForn, "@R 99.999.999/9999-99")
        ElseIf Len(cCgcForn) == 11
            cCgcForn := Transform(cCgcForn, "@R 999.999.999-99")
        EndIf
        cEndForn := AllTrim((cAliasSC7)->A2_END)
        cCepForn := AllTrim((cAliasSC7)->A2_CEP)
        cCodForn := AllTrim((cAliasSC7)->C7_FORNECE) + "    " + AllTrim((cAliasSC7)->C7_LOJA)

        // Comprador Responsavel (Nome Completo via UsrFullName)
        cComprador := Posicione("SY1", 1, xFilial("SY1") + (cAliasSC7)->C7_COMPRA, "Y1_NOME")
        If Empty(cComprador); cComprador := AllTrim(UsrFullName((cAliasSC7)->C7_USER)); EndIf
        If Empty(cComprador); cComprador := AllTrim(UsrRetName((cAliasSC7)->C7_USER)); EndIf
        If Empty(cComprador); cComprador := (cAliasSC7)->C7_COMPRA; EndIf

        // Aprovadores (SCR com Nome Completo via UsrFullName)
        cAprov    := ""
        cAliasSCR := GetNextAlias()
        cQrySCR   := " SELECT CR_USER, CR_STATUS FROM " + RetSqlName("SCR") + " SCR "
        cQrySCR   += " WHERE CR_FILIAL = '" + xFilial("SCR") + "' "
        cQrySCR   += "   AND CR_NUM = '" + cPedAtual + "' "
        cQrySCR   += "   AND CR_TIPO = 'PC' "
        cQrySCR   += "   AND SCR.D_E_L_E_T_ = ' ' "
        cQrySCR   += " ORDER BY CR_NIVEL "
        cQrySCR   := ChangeQuery(cQrySCR)
        dbUseArea(.T., "TOPCONN", TCGenQry(, , cQrySCR), cAliasSCR, .F., .T.)

        While !(cAliasSCR)->(EoF())
            cNomeUsr := AllTrim(UsrFullName((cAliasSCR)->CR_USER))
            If Empty(cNomeUsr)
                cNomeUsr := AllTrim(UsrRetName((cAliasSCR)->CR_USER))
            EndIf
            If Empty(cNomeUsr)
                cNomeUsr := AllTrim((cAliasSCR)->CR_USER)
            EndIf
            cAprov += cNomeUsr + " (Ok) - "
            (cAliasSCR)->(dbSkip())
        EndDo
        (cAliasSCR)->(dbCloseArea())

        If Empty(cAprov)
            If !Empty((cAliasSC7)->C7_USER)
                cNomeUsr := AllTrim(UsrFullName((cAliasSC7)->C7_USER))
                If Empty(cNomeUsr)
                    cNomeUsr := AllTrim(UsrRetName((cAliasSC7)->C7_USER))
                EndIf
                cAprov := cNomeUsr + " (Ok) -"
            EndIf
        EndIf

        // Zera totalizadores e lista de itens
        nTotMerc := 0
        nTotDesc := 0
        nTotDesp := 0
        nTotSeg  := 0
        nTotFre  := 0
        nTotIPI  := 0
        nTotICM  := 0
        aItens   := {}

        // Agrupa itens do mesmo pedido
        While !(cAliasSC7)->(EoF()) .And. (cAliasSC7)->C7_NUM == cPedAtual
            nTotMerc += (cAliasSC7)->C7_TOTAL
            nTotDesc += (cAliasSC7)->C7_VLDESC
            nTotDesp += (cAliasSC7)->C7_DESPESA
            nTotSeg  += (cAliasSC7)->C7_SEGURO
            nTotFre  += (cAliasSC7)->C7_VALFRE
            nTotICM  += (cAliasSC7)->C7_VALICM
            nTotIPI  += (cAliasSC7)->C7_VALIPI

            aAdd(aItens, { ;
                (cAliasSC7)->C7_ITEM, ;
                AllTrim((cAliasSC7)->C7_PRODUTO), ;
                AllTrim((cAliasSC7)->C7_DESCRI), ;
                (cAliasSC7)->C7_UM, ;
                (cAliasSC7)->C7_QUANT, ;
                (cAliasSC7)->C7_PRECO, ;
                (cAliasSC7)->C7_TOTAL, ;
                (cAliasSC7)->C7_DATPRF, ;
                AllTrim((cAliasSC7)->C7_CC) ;
            })

            (cAliasSC7)->(dbSkip())
        EndDo

        nTotCImp := nTotMerc + nTotIPI + nTotDesp + nTotSeg + nTotFre - nTotDesc

        // Desenha a pagina
        oReport:StartPage()

        // 1. Cabecalho Superior
        oReport:Say(20, 30,     "Data base:   " + DtoC(dDataBase), oFontNorm)
        oReport:Say(16, nTitX,  "Pedido de compra", oFontTit1)
        oReport:Say(28, nTitX,  "Numero:  " + cPedAtual, oFontTit2)
        oReport:Say(20, nMoedaX, "Moeda:", oFontBold)
        oReport:Say(20, nMoedaX + 60, cMoeda, oFontNorm)
        oReport:Say(31, nMoedaX, "Data Emissao:", oFontBold)
        oReport:Say(31, nMoedaX + 60, DtoC(StoD(cEmissao)), oFontNorm)
        oReport:Line(42, 30, 42, nMaxX)

        // 2. Informacoes da Empresa e Fornecedor
        oReport:Say(52, nEmpSecX,  "Informacoes da Empresa", oFontSec)
        oReport:Say(52, nFornSecX, "Informacoes do Fornecedor", oFontSec)
        oReport:Line(60, 30, 60, nMaxX)

        nLinha := 70
        oReport:Say(nLinha, 30,      "Razao Social:", oFontBold)
        oReport:Say(nLinha, 95,      SubStr(cNomeEmp, 1, IIf(lLandscape, 50, 38)), oFontNorm)
        oReport:Say(nLinha, nColDir, "Razao Social:", oFontBold)
        oReport:Say(nLinha, nValDir, SubStr(cNomeForn, 1, IIf(lLandscape, 50, 35)), oFontNorm)

        nLinha += 11
        oReport:Say(nLinha, 30,      "CNPJ/CPF:", oFontBold)
        oReport:Say(nLinha, 95,      cCgcEmp, oFontNorm)
        oReport:Say(nLinha, nColDir, "CNPJ/CPF:", oFontBold)
        oReport:Say(nLinha, nValDir, cCgcForn, oFontNorm)

        nLinha += 11
        oReport:Say(nLinha, 30,      "Endereco:", oFontBold)
        oReport:Say(nLinha, 95,      SubStr(cEndEmp, 1, IIf(lLandscape, 50, 38)), oFontNorm)
        oReport:Say(nLinha, nColDir, "Endereco:", oFontBold)
        oReport:Say(nLinha, nValDir, SubStr(cEndForn, 1, IIf(lLandscape, 50, 35)), oFontNorm)

        nLinha += 11
        oReport:Say(nLinha, 30,      "CEP:", oFontBold)
        oReport:Say(nLinha, 95,      cCepEmp, oFontNorm)
        oReport:Say(nLinha, nColDir, "CEP:", oFontBold)
        oReport:Say(nLinha, nValDir, cCepForn, oFontNorm)

        nLinha += 11
        oReport:Say(nLinha, 30,      "Cidade:", oFontBold)
        oReport:Say(nLinha, 95,      cCidEmp, oFontNorm)
        oReport:Say(nLinha, nColDir, "Codigo/Loja:", oFontBold)
        oReport:Say(nLinha, nValDir, cCodForn, oFontNorm)

        nLinha += 11
        oReport:Say(nLinha, 30,  "Telefone:", oFontBold)
        oReport:Say(nLinha, 95,  cTelEmp, oFontNorm)

        nLinha += 13
        oReport:Line(nLinha, 30, nLinha, nMaxX)

        // 3. Tabela de Itens (Colunas dimensionadas para Paisagem ou Retrato)
        nLinha += 11
        If lLandscape
            // Layout Paisagem: Espaco amplo para Descricao Completa (145 a 470 = 325 pt)
            oReport:Say(nLinha, 30,  "Item",        oFontItemBld)
            oReport:Say(nLinha, 65,  "Produto",     oFontItemBld)
            oReport:Say(nLinha, 145, "Descricao",   oFontItemBld)
            oReport:Say(nLinha, 475, "Unid.",       oFontItemBld)
            oReport:Say(nLinha, 505, "Qtde.",       oFontItemBld)
            oReport:Say(nLinha, 565, "Prc. Un.",    oFontItemBld)
            oReport:Say(nLinha, 630, "Vl. Total",   oFontItemBld)
            oReport:Say(nLinha, 705, "Dt. Entrega", oFontItemBld)
            oReport:Say(nLinha, 765, "C. Custo",    oFontItemBld)
        Else
            // Layout Retrato: Otimizado
            oReport:Say(nLinha, 30,  "Item",        oFontItemBld)
            oReport:Say(nLinha, 58,  "Produto",     oFontItemBld)
            oReport:Say(nLinha, 122, "Descricao",   oFontItemBld)
            oReport:Say(nLinha, 265, "Unid.",       oFontItemBld)
            oReport:Say(nLinha, 288, "Qtde.",       oFontItemBld)
            oReport:Say(nLinha, 340, "Prc. Un.",    oFontItemBld)
            oReport:Say(nLinha, 395, "Vl. Total",   oFontItemBld)
            oReport:Say(nLinha, 465, "Dt. Entrega", oFontItemBld)
            oReport:Say(nLinha, 522, "C. Custo",    oFontItemBld)
        EndIf

        For nI := 1 To Len(aItens)
            nLinha += 12
            If lLandscape
                oReport:Say(nLinha, 30,  aItens[nI][1], oFontItem)
                oReport:Say(nLinha, 65,  aItens[nI][2], oFontItem)
                oReport:Say(nLinha, 145, AllTrim(aItens[nI][3]), oFontItem) // Descricao Completa!
                oReport:Say(nLinha, 475, aItens[nI][4], oFontItem)
                oReport:Say(nLinha, 505, Transform(aItens[nI][5], "@E 999,999.99"), oFontItem)
                oReport:Say(nLinha, 565, Transform(aItens[nI][6], "@E 999,999.99"), oFontItem)
                oReport:Say(nLinha, 630, Transform(aItens[nI][7], "@E 999,999.99"), oFontItem)
                oReport:Say(nLinha, 705, DtoC(StoD(aItens[nI][8])), oFontItem)
                oReport:Say(nLinha, 765, aItens[nI][9], oFontItem)
            Else
                oReport:Say(nLinha, 30,  aItens[nI][1], oFontItem)
                oReport:Say(nLinha, 58,  aItens[nI][2], oFontItem)
                oReport:Say(nLinha, 122, SubStr(AllTrim(aItens[nI][3]), 1, 38), oFontItem)
                oReport:Say(nLinha, 265, aItens[nI][4], oFontItem)
                oReport:Say(nLinha, 288, Transform(aItens[nI][5], "@E 999,999.99"), oFontItem)
                oReport:Say(nLinha, 340, Transform(aItens[nI][6], "@E 999,999.99"), oFontItem)
                oReport:Say(nLinha, 395, Transform(aItens[nI][7], "@E 999,999.99"), oFontItem)
                oReport:Say(nLinha, 465, DtoC(StoD(aItens[nI][8])), oFontItem)
                oReport:Say(nLinha, 522, aItens[nI][9], oFontItem)
            EndIf
        Next nI

        nLinha += 14
        oReport:Line(nLinha, 30, nLinha, nMaxX)

        // 4. Secao: Demais Informacoes
        nLinha += 6
        oReport:Box(nLinha, 30, nLinha + 13, nMaxX)
        oReport:Say(nLinha + 9, nBoxTitX, "Demais Informacoes", oFontBold)
        nLinha += 21

        oReport:Say(nLinha, 30,  "Vlr. Total Descontos:", oFontBold)
        oReport:Say(nLinha, 135, Transform(nTotDesc, "@E 999,999.99"), oFontNorm)
        nLinha += 11

        oReport:Say(nLinha, 30,  "Cond. Pagamento:", oFontBold)
        oReport:Say(nLinha, 135, cDescCond, oFontNorm)
        nLinha += 11

        oReport:Say(nLinha, 30,  "Local de Entrega:", oFontBold)
        oReport:Say(nLinha, 135, SubStr(cLocEnt, 1, IIf(lLandscape, 110, 75)), oFontNorm)
        nLinha += 11

        oReport:Say(nLinha, 30,  "Local de Cobranca:", oFontBold)
        oReport:Say(nLinha, 135, SubStr(cLocCob, 1, IIf(lLandscape, 110, 75)), oFontNorm)
        nLinha += 11

        oReport:Say(nLinha, 30,  "Observacoes:", oFontBold)
        oReport:Say(nLinha, 135, SubStr(cObs, 1, IIf(lLandscape, 110, 75)), oFontNorm)

        nLinha += 14
        oReport:Line(nLinha, 30, nLinha, nMaxX)

        // 5. Secao: Valores e Impostos
        nLinha += 6
        oReport:Box(nLinha, 30, nLinha + 13, nMaxX)
        oReport:Say(nLinha + 9, nBoxTitX, "Valores e Impostos", oFontBold)
        nLinha += 21

        oReport:Say(nLinha, 30,      "Despesas:", oFontBold)
        oReport:Say(nLinha, 120,     Transform(nTotDesp, "@E 999,999.99"), oFontNorm)
        oReport:Say(nLinha, nColDir, "Vlr. IPI:", oFontBold)
        oReport:Say(nLinha, nColDir + 95, Transform(nTotIPI, "@E 999,999.99"), oFontNorm)
        nLinha += 11

        oReport:Say(nLinha, 30,      "Seguro:", oFontBold)
        oReport:Say(nLinha, 120,     Transform(nTotSeg, "@E 999,999.99"), oFontNorm)
        oReport:Say(nLinha, nColDir, "Vlr. ICMS:", oFontBold)
        oReport:Say(nLinha, nColDir + 95, Transform(nTotICM, "@E 999,999.99"), oFontNorm)
        nLinha += 11

        oReport:Say(nLinha, 30,  "Frete:", oFontBold)
        oReport:Say(nLinha, 120, Transform(nTotFre, "@E 999,999.99"), oFontNorm)
        nLinha += 11

        oReport:Say(nLinha, 30,      "Total Mercadoria:", oFontBold)
        oReport:Say(nLinha, 120,     Transform(nTotMerc, "@E 999,999.99"), oFontNorm)
        oReport:Say(nLinha, nColDir, "Total C/ Impostos:", oFontBold)
        oReport:Say(nLinha, nColDir + 95, Transform(nTotCImp, "@E 999,999.99"), oFontNorm)

        nLinha += 14
        oReport:Line(nLinha, 30, nLinha, nMaxX)

        // 6. Secao: Aprovacao
        nLinha += 6
        oReport:Box(nLinha, 30, nLinha + 13, nMaxX)
        oReport:Say(nLinha + 9, nAprovTitX, "Aprovacao", oFontBold)
        nLinha += 21

        oReport:Say(nLinha, 30,  "Comprador Responsavel:", oFontBold)
        oReport:Say(nLinha, 150, cComprador, oFontNorm)
        nLinha += 11

        oReport:Say(nLinha, 30,  "Comprador Alternativo:", oFontBold)
        nLinha += 11

        oReport:Say(nLinha, 30,  "Aprovadores:", oFontBold)
        oReport:Say(nLinha, 150, cAprov, oFontNorm)
        nLinha += 14

        oReport:Say(nLinha, 30,  "Status:", oFontBold)
        oReport:Say(nLinha, 150, cStatus, oFontNorm)

        oReport:EndPage()

    EndDo

    (cAliasSC7)->(dbCloseArea())

Return

/*-------------------------------------------------------------------
  Rotina de exportacao para Excel via FWMsExcel
-------------------------------------------------------------------*/
Static Function ExpPedCompr(cPedDe, cPedAte)

    Local oExcel     := FWMsExcel():New()
    Local oExcelApp  := Nil
    Local cQuery     := ""
    Local cAliasSC7  := GetNextAlias()
    Local cNomeArq   := "PedidoCompra_" + AllTrim(cPedDe) + "_" + DtoS(Date()) + "_" + StrTran(Time(), ":", "") + ".xml"
    Local cDescCond  := ""
    Local cDirSrv    := "\spool\"
    Local cArqSrv    := cDirSrv + cNomeArq
    Local cDirCli    := GetTempPath()
    Local cArqCli    := cDirCli + cNomeArq

    If !ExistDir(cDirSrv)
        MakeDir(cDirSrv)
    EndIf

    cQuery := " SELECT C7_NUM, C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_COND, C7_CONTATO, C7_FILENT, "
    cQuery += "        C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_UM, C7_PRECO, C7_TOTAL, C7_DATPRF, "
    cQuery += "        A2_NOME, A2_CGC, A2_MUN, A2_EST, A2_END, A2_TEL, "
    cQuery += "        COALESCE(E4_DESCRI, ' ') AS E4_DESCRI "
    cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
    cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 "
    cQuery += "   ON A2_FILIAL = '" + xFilial("SA2") + "' "
    cQuery += "  AND A2_COD = C7_FORNECE "
    cQuery += "  AND A2_LOJA = C7_LOJA "
    cQuery += "  AND SA2.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT JOIN " + RetSqlName("SE4") + " SE4 "
    cQuery += "   ON E4_FILIAL = '" + xFilial("SE4") + "' "
    cQuery += "  AND E4_CODIGO = C7_COND "
    cQuery += "  AND SE4.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
    cQuery += "   AND C7_NUM BETWEEN '" + cPedDe + "' AND '" + cPedAte + "' "
    cQuery += "   AND SC7.D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY C7_NUM, C7_ITEM "

    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), cAliasSC7, .F., .T.)

    If (cAliasSC7)->(EoF())
        (cAliasSC7)->(dbCloseArea())
        FWAlertWarn("Nenhum registro encontrado para o intervalo selecionado.", "Atencao")
        Return Nil
    EndIf

    // 1. Cria a aba da planilha
    oExcel:AddworkSheet("Pedidos de Compra")
    oExcel:AddTable("Pedidos de Compra", "Itens do Pedido")

    // 2. Colunas: AddColumn(cSheet, cTable, cTitulo, nAlign, nFormat, lTotal)
    // nAlign: 1=Esquerda, 2=Centro, 3=Direita
    // nFormat: 1=Geral, 2=Numero, 3=Monetario, 4=Data
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Pedido",         2, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Emissao",        2, 4, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Cod Fornecedor", 2, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Loja",           2, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Razao Social",   1, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "CNPJ/CPF",       2, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Cidade",         1, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "UF",             2, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Cond Pagto",     2, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Contato",        1, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Item",           2, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Produto",        1, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Descricao",      1, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Dt Entrega",     2, 4, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Quantidade",     3, 2, .T.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "UM",             2, 1, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Preco Unit",     3, 3, .F.)
    oExcel:AddColumn("Pedidos de Compra", "Itens do Pedido", "Total Item",     3, 3, .T.)

    // 3. Adiciona as linhas
    While !(cAliasSC7)->(EoF())

        cDescCond := AllTrim((cAliasSC7)->E4_DESCRI)
        If Empty(cDescCond)
            cDescCond := AllTrim(Posicione("SE4", 1, xFilial("SE4") + (cAliasSC7)->C7_COND, "E4_DESCRI"))
        EndIf
        If Empty(cDescCond)
            cDescCond := (cAliasSC7)->C7_COND
        EndIf

        oExcel:AddRow("Pedidos de Compra", "Itens do Pedido", { ;
            (cAliasSC7)->C7_NUM, ;
            StoD((cAliasSC7)->C7_EMISSAO), ;
            (cAliasSC7)->C7_FORNECE, ;
            (cAliasSC7)->C7_LOJA, ;
            AllTrim((cAliasSC7)->A2_NOME), ;
            (cAliasSC7)->A2_CGC, ;
            AllTrim((cAliasSC7)->A2_MUN), ;
            (cAliasSC7)->A2_EST, ;
            cDescCond, ;
            AllTrim((cAliasSC7)->C7_CONTATO), ;
            (cAliasSC7)->C7_ITEM, ;
            AllTrim((cAliasSC7)->C7_PRODUTO), ;
            AllTrim((cAliasSC7)->C7_DESCRI), ;
            StoD((cAliasSC7)->C7_DATPRF), ;
            (cAliasSC7)->C7_QUANT, ;
            (cAliasSC7)->C7_UM, ;
            (cAliasSC7)->C7_PRECO, ;
            (cAliasSC7)->C7_TOTAL ;
        })

        (cAliasSC7)->(dbSkip())
    EndDo

    (cAliasSC7)->(dbCloseArea())

    // 4. Grava o arquivo no servidor
    oExcel:Activate()
    oExcel:GetXMLFile(cArqSrv)

    // 5. Transfere para a estacao/navegador e abre no Excel
    CpyS2T(cArqSrv, cDirCli, .F.)

    If GetRemoteType() == 0
        If ApOleClient("MsExcel")
            oExcelApp := MsExcel():New()
            oExcelApp:WorkBooks:Open(cArqCli)
            oExcelApp:SetVisible(.T.)
            oExcelApp:Destroy()
        Else
            ShellExecute("Open", cArqCli, "", "", 1)
        EndIf
    Else
        ShellExecute("Open", cArqCli, "", "", 1)
    EndIf

Return Nil

/*-------------------------------------------------------------------
  Criacao automatica das perguntas SX1 se nao existirem
-------------------------------------------------------------------*/
Static Function AjustaSX1(cPerg)
    PutSx1(cPerg, "01", "Do Pedido?",   "", "", "mv_ch1", "C", TamSX3("C7_NUM")[1], 0, 0, "G", "", "SC7", "", "", "mv_par01")
    PutSx1(cPerg, "02", "Ate o Pedido?", "", "", "mv_ch2", "C", TamSX3("C7_NUM")[1], 0, 0, "G", "", "SC7", "", "", "mv_par02")
Return

/*/{Protheus.doc} MT120BRW
Ponto de entrada no browse de Pedidos de Compra (MATA120).
Adiciona o botao "Imprimir Pedido (PDF)" diretamente no menu Outras Acoes.
@type  Function
@author Eduardo
@since 03/09/2026
/*/
User Function MT120BRW()
    // aRotina e a variavel publica nativa do MATA120 contendo os botoes da tela
    aAdd(aRotina, {"Imprimir Pedido (PDF)", "U_PEDCOMPRA()", 0, 4, 0, .F.})
Return Nil

