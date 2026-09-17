#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"

#DEFINE DMPAPER_A4 9

/*/{Protheus.doc} PEDVENDA
Relatorio customizado para impressao de Pedido de Venda.
Substitui o modelo padrao descontinuado com layout limpo e direto.
@type  Function
@author Eduardo
@since 03/09/2026
/*/
User Function PEDVENDA(cPedDe, cPedAte, lPerg)

    Local oReport
    Local cPerg    := "PEDVENDA"
    Local nFormato := 1 // 1=PDF, 2=Excel

    Default cPedDe  := ""
    Default cPedAte := ""
    Default lPerg   := .T.

    // Selecao de formato de impressao (PDF ou Excel)
    nFormato := Aviso("Formato de Impressao", "Como deseja gerar o Pedido de Venda?", {"PDF", "Excel", "Cancelar"}, 2)

    If nFormato == 3 .Or. nFormato == 0
        Return Nil
    EndIf

    // Se nao passou parametros mas a SC5 ja esta posicionada no browse/tela
    If Empty(cPedDe) .And. Select("SC5") > 0 .And. !Empty(SC5->C5_NUM)
        cPedDe  := SC5->C5_NUM
        cPedAte := SC5->C5_NUM
        lPerg   := .F.
    EndIf

    // Se chamado pelo menu geral de relatorios, abre tela de perguntas (De/Ate)
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
            oReport := FWMSPrinter():New("PedidoVenda.rel", IMP_PDF, .F., "", .T., , , , , , .F.)
            oReport:SetResolution(72)
            oReport:SetPortrait()
            oReport:SetMargin(30, 30, 30, 30)

            Processa({|lEnd| ImpPedido(@oReport, cPedDe, cPedAte)}, "Gerando Impressao do Pedido...")

            oReport:Preview()
        ElseIf nFormato == 2
            // Formato Excel (Planilha Tabular com Totalizadores)
            Processa({|lEnd| ExpPedVenda(cPedDe, cPedAte)}, "Gerando Planilha Excel...")
        EndIf
    EndIf

Return Nil

/*/{Protheus.doc} M410IMPR
Ponto de Entrada padrao da TOTVS acionado ao clicar no botao Imprimir 
da tela de Pedidos de Venda (MATA410).
Substitui o relatorio padrao (MATR680) pela impressao customizada PEDVENDA.
@type  Function
@author Usuario
@since 03/09/2026
/*/
User Function M410IMPR()
    Local cPed := ""

    // Captura o numero do pedido selecionado atualmente no browse do MATA410
    If Select("SC5") > 0 .And. !Empty(SC5->C5_NUM)
        cPed := SC5->C5_NUM
    EndIf

    // Executa a impressao direta do pedido posicionado sem abrir perguntas
    U_PEDVENDA(cPed, cPed, .F.)

Return Nil

/*-------------------------------------------------------------------
  Rotina principal de busca de dados e desenho das páginas
-------------------------------------------------------------------*/
Static Function ImpPedido(oReport, cPedDe, cPedAte)

    Local oFontTit  := TFont():New("Arial", , -14, .T.)
    Local oFontNorm := TFont():New("Arial", , -09, .F.)
    Local oFontBold := TFont():New("Arial", , -09, .T.)
    
    Local nLinha    := 0
    Local nTotGeral := 0
    Local cDescCond := ""
    Local cQuery    := ""
    Local cAliasSC5 := GetNextAlias()
    Local cAliasSC6 := ""

    // Busca os pedidos de venda no intervalo
    cQuery := " SELECT C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_CONDPAG, "
    cQuery += "        A1_NOME, A1_CGC, A1_MUN, A1_EST "
    cQuery += " FROM " + RetSqlName("SC5") + " SC5 "
    cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
    cQuery += "   ON A1_FILIAL = '" + xFilial("SA1") + "' "
    cQuery += "  AND A1_COD = C5_CLIENTE "
    cQuery += "  AND A1_LOJA = C5_LOJACLI "
    cQuery += "  AND SA1.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
    cQuery += "   AND C5_NUM BETWEEN '" + cPedDe + "' AND '" + cPedAte + "' "
    cQuery += "   AND SC5.D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY C5_NUM "

    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), cAliasSC5, .F., .T.)

    While !(cAliasSC5)->(EoF())

        oReport:StartPage()
        nLinha := 40
        nTotGeral := 0

        // 1. Cabecalho da Empresa e Titulo
        oReport:Box(nLinha, 30, nLinha + 60, 565)
        oReport:Say(nLinha + 18, 40, AllTrim(SM0->M0_NOMECOM), oFontTit)
        oReport:Say(nLinha + 32, 40, "CNPJ: " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99"), oFontNorm)
        oReport:Say(nLinha + 22, 400, "PEDIDO DE VENDA", oFontTit)
        oReport:Say(nLinha + 40, 400, "No.: " + (cAliasSC5)->C5_NUM, oFontTit)
        nLinha += 70

        // 2. Dados do Cliente
        oReport:Box(nLinha, 30, nLinha + 50, 565)
        oReport:Say(nLinha + 15, 40, "Cliente: " + (cAliasSC5)->C5_CLIENTE + "/" + (cAliasSC5)->C5_LOJACLI + " - " + AllTrim((cAliasSC5)->A1_NOME), oFontBold)
        oReport:Say(nLinha + 30, 40, "CNPJ/CPF: " + (cAliasSC5)->A1_CGC, oFontNorm)
        oReport:Say(nLinha + 30, 260, "Cidade/UF: " + AllTrim((cAliasSC5)->A1_MUN) + "/" + (cAliasSC5)->A1_EST, oFontNorm)
        // Busca descricao da condicao de pagamento
        cDescCond := AllTrim(Posicione("SE4", 1, xFilial("SE4") + (cAliasSC5)->C5_CONDPAG, "E4_DESCRI"))
        If Empty(cDescCond)
            cDescCond := (cAliasSC5)->C5_CONDPAG
        EndIf

        oReport:Say(nLinha + 42, 40, "Emissao: " + DtoC(StoD((cAliasSC5)->C5_EMISSAO)), oFontNorm)
        oReport:Say(nLinha + 42, 260, "Condicao Pagto: " + cDescCond, oFontNorm)
        nLinha += 60

        // 3. Cabecalho da Tabela de Itens
        oReport:Line(nLinha, 30, nLinha, 565)
        oReport:Say(nLinha + 12, 35,  "ITEM", oFontBold)
        oReport:Say(nLinha + 12, 65,  "PRODUTO", oFontBold)
        oReport:Say(nLinha + 12, 130, "DESCRICAO", oFontBold)
        oReport:Say(nLinha + 12, 350, "QTD", oFontBold)
        oReport:Say(nLinha + 12, 395, "UM", oFontBold)
        oReport:Say(nLinha + 12, 430, "PRC UNIT", oFontBold)
        oReport:Say(nLinha + 12, 505, "TOTAL", oFontBold)
        nLinha += 18
        oReport:Line(nLinha, 30, nLinha, 565)
        nLinha += 8

        // 4. Busca Itens do Pedido (SC6)
        cAliasSC6 := GetNextAlias()
        cQuery := " SELECT C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_UM, C6_PRCVEN, C6_VALOR "
        cQuery += " FROM " + RetSqlName("SC6") + " SC6 "
        cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
        cQuery += "   AND C6_NUM = '" + (cAliasSC5)->C5_NUM + "' "
        cQuery += "   AND SC6.D_E_L_E_T_ = ' ' "
        cQuery += " ORDER BY C6_ITEM "

        cQuery := ChangeQuery(cQuery)
        dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), cAliasSC6, .F., .T.)

        While !(cAliasSC6)->(EoF())

            // Quebra de pagina se atingir o limite
            If nLinha > 740
                oReport:EndPage()
                oReport:StartPage()
                nLinha := 40
            EndIf

            oReport:Say(nLinha, 35,  (cAliasSC6)->C6_ITEM, oFontNorm)
            oReport:Say(nLinha, 65,  AllTrim((cAliasSC6)->C6_PRODUTO), oFontNorm)
            oReport:Say(nLinha, 130, SubStr((cAliasSC6)->C6_DESCRI, 1, 38), oFontNorm)
            oReport:Say(nLinha, 345, Transform((cAliasSC6)->C6_QTDVEN, "@E 99,999.99"), oFontNorm)
            oReport:Say(nLinha, 400, (cAliasSC6)->C6_UM, oFontNorm)
            oReport:Say(nLinha, 430, Transform((cAliasSC6)->C6_PRCVEN, "@E 999,999.99"), oFontNorm)
            oReport:Say(nLinha, 495, Transform((cAliasSC6)->C6_VALOR,  "@E 9,999,999.99"), oFontNorm)

            nTotGeral += (cAliasSC6)->C6_VALOR
            nLinha += 14

            (cAliasSC6)->(dbSkip())
        EndDo
        (cAliasSC6)->(dbCloseArea())

        // 5. Totalizador / Rodape
        nLinha += 10
        oReport:Line(nLinha, 30, nLinha, 565)
        nLinha += 15
        oReport:Say(nLinha, 400, "TOTAL DO PEDIDO:", oFontBold)
        oReport:Say(nLinha, 490, Transform(nTotGeral, "@E 9,999,999.99"), oFontBold)

        oReport:EndPage()
        (cAliasSC5)->(dbSkip())
    EndDo

    (cAliasSC5)->(dbCloseArea())

Return

/*-------------------------------------------------------------------
  Rotina de exportacao para Excel via FWMsExcel (Pedido de Venda)
-------------------------------------------------------------------*/
Static Function ExpPedVenda(cPedDe, cPedAte)

    Local oExcel     := FWMsExcel():New()
    Local cQuery     := ""
    Local cAliasSC   := GetNextAlias()
    Local cNomeArq   := "PedidoVenda_" + AllTrim(cPedDe) + "_" + DtoS(Date()) + "_" + StrTran(Time(), ":", "") + ".xml"
    Local cDescCond  := ""
    Local cDirSrv    := "\spool\"
    Local cArqSrv    := cDirSrv + cNomeArq
    Local cDirCli    := GetTempPath()
    Local cArqCli    := cDirCli + cNomeArq

    If !ExistDir(cDirSrv)
        MakeDir(cDirSrv)
    EndIf

    // Consulta unificada de Cabecalho (SC5) + Itens (SC6) + Cliente (SA1)
    cQuery := " SELECT C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_CONDPAG, "
    cQuery += "        A1_NOME, A1_CGC, A1_MUN, A1_EST, "
    cQuery += "        C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_UM, C6_PRCVEN, C6_VALOR "
    cQuery += " FROM " + RetSqlName("SC5") + " SC5 "
    cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 "
    cQuery += "   ON C6_FILIAL = '" + xFilial("SC6") + "' "
    cQuery += "  AND C6_NUM = C5_NUM "
    cQuery += "  AND SC6.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
    cQuery += "   ON A1_FILIAL = '" + xFilial("SA1") + "' "
    cQuery += "  AND A1_COD = C5_CLIENTE "
    cQuery += "  AND A1_LOJA = C5_LOJACLI "
    cQuery += "  AND SA1.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
    cQuery += "   AND C5_NUM BETWEEN '" + cPedDe + "' AND '" + cPedAte + "' "
    cQuery += "   AND SC5.D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY C5_NUM, C6_ITEM "

    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), cAliasSC, .F., .T.)

    If (cAliasSC)->(EoF())
        (cAliasSC)->(dbCloseArea())
        FWAlertWarn("Nenhum registro encontrado para o intervalo selecionado.", "Atencao")
        Return Nil
    EndIf

    // 1. Cria a aba da planilha
    oExcel:AddworkSheet("Pedidos de Venda")
    oExcel:AddTable("Pedidos de Venda", "Itens do Pedido")

    // 2. Colunas: AddColumn(cSheet, cTable, cTitulo, nAlign, nFormat, lTotal)
    // nAlign: 1=Esquerda, 2=Centro, 3=Direita
    // nFormat: 1=Geral, 2=Numero, 3=Monetario, 4=Data
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Pedido",         2, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Emissao",        2, 4, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Cod Cliente",    2, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Loja",           2, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Nome Cliente",   1, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "CNPJ/CPF",       2, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Cidade",         1, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "UF",             2, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Cond Pagto",     2, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Item",           2, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Produto",        1, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Descricao",      1, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Quantidade",     3, 2, .T.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "UM",             2, 1, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Preco Unit",     3, 3, .F.)
    oExcel:AddColumn("Pedidos de Venda", "Itens do Pedido", "Total Item",     3, 3, .T.)

    // 3. Adiciona as linhas
    While !(cAliasSC)->(EoF())

        cDescCond := AllTrim(Posicione("SE4", 1, xFilial("SE4") + (cAliasSC)->C5_CONDPAG, "E4_DESCRI"))
        If Empty(cDescCond)
            cDescCond := (cAliasSC)->C5_CONDPAG
        EndIf

        oExcel:AddRow("Pedidos de Venda", "Itens do Pedido", { ;
            (cAliasSC)->C5_NUM, ;
            StoD((cAliasSC)->C5_EMISSAO), ;
            (cAliasSC)->C5_CLIENTE, ;
            (cAliasSC)->C5_LOJACLI, ;
            AllTrim((cAliasSC)->A1_NOME), ;
            (cAliasSC)->A1_CGC, ;
            AllTrim((cAliasSC)->A1_MUN), ;
            (cAliasSC)->A1_EST, ;
            cDescCond, ;
            (cAliasSC)->C6_ITEM, ;
            AllTrim((cAliasSC)->C6_PRODUTO), ;
            AllTrim((cAliasSC)->C6_DESCRI), ;
            (cAliasSC)->C6_QTDVEN, ;
            (cAliasSC)->C6_UM, ;
            (cAliasSC)->C6_PRCVEN, ;
            (cAliasSC)->C6_VALOR ;
        })

        (cAliasSC)->(dbSkip())
    EndDo

    (cAliasSC)->(dbCloseArea())

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
  Criação automatica das perguntas SX1 se nao existirem
-------------------------------------------------------------------*/
Static Function AjustaSX1(cPerg)
    PutSx1(cPerg, "01", "Do Pedido?",   "", "", "mv_ch1", "C", TamSX3("C5_NUM")[1], 0, 0, "G", "", "SC5", "", "", "mv_par01")
    PutSx1(cPerg, "02", "Ate o Pedido?", "", "", "mv_ch2", "C", TamSX3("C5_NUM")[1], 0, 0, "G", "", "SC5", "", "", "mv_par02")
Return
