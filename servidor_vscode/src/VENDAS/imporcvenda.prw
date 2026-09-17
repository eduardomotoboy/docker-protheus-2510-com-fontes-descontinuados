#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} IMPCOT
Rotina para Importacao de Cotacao de Venda via Planilha Excel (MATA415).
Permite:
  1. Baixar modelo padrao de planilha (.xml) com layout oficial e exemplo.
  2. Ler planilha preenchida, validar clientes, produtos, condicoes e 1 ou 2 vendedores.
  3. Gravar Orcamento de Venda oficial via ExecAuto (MATA415 - SCJ/SCK).
  4. Permitir que o comercial revise e converta em Pedido de Venda (MATA410).

@type  Function
@author Eduardo
@since 04/09/2026
/*/
User Function IMPCOT()

    Local nOpcao    := 0
    Local cMascara  := "Planilhas Excel / XML (*.xml;*.xlsx;*.csv)|*.xml;*.xlsx;*.csv|" + ;
                       "Planilhas XML (*.xml)|*.xml|" + ;
                       "Planilhas Excel (*.xlsx)|*.xlsx|" + ;
                       "Arquivos CSV (*.csv)|*.csv|" + ;
                       "Todos os Arquivos (*.*)|*.*"
    Local cTitulo   := "Selecione a Planilha de Cotacao"
    Local cArqSel   := ""
    Local nOrigem   := 0

    nOpcao := Aviso("Cotacao de Venda (Excel)", ;
                    "Escolha a acao que deseja realizar:" + CRLF + CRLF + ;
                    "1 - Baixar Modelo de Planilha (Excel formatado)" + CRLF + ;
                    "2 - Importar Cotacao Preenchida (Gerar Orcamento)", ;
                    {"1-Modelo", "2-Importar", "Cancelar"}, 3)

    If nOpcao == 1
        TelaModelo()
    ElseIf nOpcao == 2
        // Permite escolher entre navegar no Servidor TOTVS (arvore [SERVIDOR]) ou Maquina Local (WebAgent)
        nOrigem := Aviso("Origem da Planilha", ;
                         "De onde deseja selecionar o arquivo de cotacao?" + CRLF + CRLF + ;
                         "1 - Do Servidor TOTVS (Mostra [SERVIDOR] como antes)" + CRLF + ;
                         "2 - Da Minha Maquina (Computador local C:\ via Agente)", ;
                         {"1-Servidor", "2-Minha Maquina", "Cancelar"}, 3)

        If nOrigem == 1
            // Servidor TOTVS: arvore do servidor ([SERVIDOR])
            cArqSel := cGetFile(cMascara, cTitulo, 1, "", .F., 0, .T., .T.)
        ElseIf nOrigem == 2
            // Maquina Local: direciona para o C:\ local via WebAgent / SmartClient
            cArqSel := cGetFile(cMascara, cTitulo, 1, "C:\", .F., 7, .F., .T.)
        Else
            Return Nil
        EndIf

        If Empty(cArqSel)
            Return Nil
        EndIf

        If Right(cArqSel, 1) == "\" .Or. Right(cArqSel, 1) == "/" .Or. ExistDir(cArqSel)
            FWAlertWarn("Nenhum arquivo foi selecionado." + CRLF + CRLF + ;
                        "Por favor, clique sobre o arquivo da cotacao (.xml ou .xlsx) para seleciona-lo antes de confirmar.", "Atencao")
            Return Nil
        EndIf

        Processa({|lEnd| ImportaCot(cArqSel)}, "Processando importacao da cotacao...")
    EndIf

Return Nil

/*-------------------------------------------------------------------
  Solicita parametros para a geracao da planilha modelo (Cliente, Loja, Qtd)
-------------------------------------------------------------------*/
Static Function TelaModelo()

    Local aParamBox := {}
    Local aRet      := {}
    Local nTamCli   := 6
    Local nTamLoj   := 2
    Local aTamCli   := TamSX3("A1_COD")
    Local aTamLoj   := TamSX3("A1_LOJA")
    Local cCodCli   := ""
    Local cLojCli   := ""
    Local nQtdLin   := 10
    Local cCond     := ""
    Local cTab      := ""
    Local cVend1    := ""
    Local cVend2    := ""
    Local cNomeCli  := ""

    If !Empty(aTamCli) .And. Len(aTamCli) >= 1
        nTamCli := aTamCli[1]
    EndIf
    If !Empty(aTamLoj) .And. Len(aTamLoj) >= 1
        nTamLoj := aTamLoj[1]
    EndIf

    cCodCli := Space(nTamCli)
    cLojCli := PadR("01", nTamLoj)

    // ParamBox: {1, cDescricao, cInicializador, cPicture, cValidacao, cF3, cWhen, nTamanho, lObrigatorio}
    aAdd(aParamBox, {1, "Cliente (Vazio = Modelo Exemplo)", cCodCli, "@!", ".T.", "SA1", ".T.", 60, .F.})
    aAdd(aParamBox, {1, "Loja",                            cLojCli, "@!", ".T.", "",    ".T.", 30, .F.})
    aAdd(aParamBox, {1, "Qtd Linhas a Gerar",              nQtdLin, "@E 999", "MV_PAR03 > 0 .And. MV_PAR03 <= 500", "", ".T.", 30, .T.})

    If ParamBox(aParamBox, "Dados para Modelo de Cotacao", @aRet)
        cCodCli := AllTrim(MV_PAR01)
        cLojCli := AllTrim(MV_PAR02)
        nQtdLin := MV_PAR03

        If !Empty(cCodCli)
            dbSelectArea("SA1")
            SA1->(dbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
            cCodCli := PadR(cCodCli, nTamCli)
            If Empty(cLojCli)
                cLojCli := "01"
            EndIf
            cLojCli := PadR(cLojCli, nTamLoj)

            If !SA1->(dbSeek(xFilial("SA1") + cCodCli + cLojCli))
                If !SA1->(dbSeek(xFilial("SA1") + cCodCli))
                    Aviso("Atencao", "Cliente " + AllTrim(cCodCli) + "/" + AllTrim(cLojCli) + " nao encontrado no cadastro (SA1)!" + CRLF + "Sera gerado modelo generico com exemplos.", {"OK"}, 2)
                    cCodCli := ""
                    cLojCli := ""
                Else
                    cLojCli := SA1->A1_LOJA
                EndIf
            EndIf

            If !Empty(cCodCli)
                cCond    := SA1->A1_COND
                cTab     := SA1->A1_TABELA
                cVend1   := SA1->A1_VEND
                cVend2   := ""
                If SA1->(FieldPos("A1_VEND2")) > 0 .And. !Empty(SA1->A1_VEND2)
                    cVend2 := SA1->A1_VEND2
                EndIf
                cNomeCli := AllTrim(SA1->A1_NOME)
            EndIf
        EndIf

        Processa({|lEnd| GeraModelo(cCodCli, cLojCli, cCond, cTab, cVend1, cVend2, cNomeCli, nQtdLin)}, "Gerando modelo de planilha Excel...")
    EndIf

Return Nil

/*-------------------------------------------------------------------
  Gera a planilha modelo Excel oficial formatada para o usuario
-------------------------------------------------------------------*/
Static Function GeraModelo(cCliente, cLoja, cCond, cTab, cVend1, cVend2, cNomeCli, nQtdLin)

    Local oExcel     := FWMsExcel():New()
    Local oExcelApp  := Nil
    Local cNomeArq   := "Modelo_Cotacao_Venda.xml"
    Local cDirSrv    := "\spool\"
    Local cArqSrv    := ""
    Local cDirCli    := GetTempPath()
    Local cArqCli    := ""
    Local nI         := 0
    Local lPreenche  := .F.
    Local cMsgSuc    := ""

    Default cCliente := ""
    Default cLoja    := ""
    Default cCond    := ""
    Default cTab     := ""
    Default cVend1   := ""
    Default cVend2   := ""
    Default cNomeCli := ""
    Default nQtdLin  := 10

    lPreenche := !Empty(cCliente)

    If lPreenche
        cNomeArq := "Modelo_Cotacao_" + AllTrim(cCliente) + "_" + AllTrim(cLoja) + ".xml"
    EndIf

    cArqSrv := cDirSrv + cNomeArq
    cArqCli := cDirCli + cNomeArq

    If !ExistDir(cDirSrv)
        MakeDir(cDirSrv)
    EndIf

    oExcel:AddworkSheet("Cotacao")
    oExcel:AddTable("Cotacao", "Itens da Cotacao")

    // Colunas do modelo
    // AddColumn(cSheet, cTable, cTitulo, nAlign, nFormat, lTotal)
    // nAlign: 1=Esquerda, 2=Centro, 3=Direita
    // nFormat: 1=Geral, 2=Numero, 3=Monetario, 4=Data
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Cliente",        2, 1, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Loja",           2, 1, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Cond Pagto",     2, 1, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Tabela Preco",   2, 1, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Vendedor 1",     2, 1, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Vendedor 2",     2, 1, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Cod Produto",    1, 1, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Quantidade",     3, 2, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Preco Unit",     3, 3, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "TES",            2, 1, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "Dt Entrega",     2, 4, .F.)
    oExcel:AddColumn("Cotacao", "Itens da Cotacao", "pedido cliente", 1, 1, .F.)

    If lPreenche
        // Linhas pre-preenchidas com os dados cadastrais do cliente informado
        For nI := 1 To nQtdLin
            oExcel:AddRow("Cotacao", "Itens da Cotacao", { ;
                AllTrim(cCliente), ;
                AllTrim(cLoja), ;
                AllTrim(cCond), ;
                AllTrim(cTab), ;
                AllTrim(cVend1), ;
                AllTrim(cVend2), ;
                "", ;               // Cod Produto (em branco para digitacao dos itens)
                1, ;                // Quantidade (padrao 1 em vez de 0)
                0.00, ;             // Preco Unitario
                "", ;               // TES (opcional)
                dDataBase + 5, ;    // Dt Entrega prevista
                "" ;                // Observacoes
            })
        Next nI
    Else
        // Linha de Exemplo 1: Cliente com 1 vendedor
        oExcel:AddRow("Cotacao", "Itens da Cotacao", { ;
            "000001", ;
            "01", ;
            "001", ;
            "", ;
            "000001", ;
            "", ;
            "PA0001", ;
            10, ;
            150.00, ;
            "", ;
            dDataBase, ;
            "Cotacao de teste - 1 Vendedor" ;
        })

        // Linha de Exemplo 2: Cliente com 2 vendedores
        oExcel:AddRow("Cotacao", "Itens da Cotacao", { ;
            "000001", ;
            "01", ;
            "001", ;
            "", ;
            "000001", ;
            "000002", ;
            "PA0002", ;
            5, ;
            220.50, ;
            "", ;
            dDataBase + 5, ;
            "Cotacao de teste - 2 Vendedores" ;
        })
    EndIf

    oExcel:Activate()
    oExcel:GetXMLFile(cArqSrv)

    // Copia para a estacao e abre
    CpyS2T(cArqSrv, cDirCli, .F.)

    If lPreenche
        cMsgSuc := "Modelo gerado para o cliente: " + AllTrim(cCliente) + "/" + AllTrim(cLoja) + " - " + cNomeCli + CRLF + CRLF + ;
                   "Foram criadas " + cValToChar(nQtdLin) + " linhas com os dados cadastrais preenchidos." + CRLF + ;
                   "Basta informar o Cod Produto, Quantidade e Preco nas linhas desejadas."
    Else
        cMsgSuc := "Modelo de planilha gerado com sucesso com dados de exemplo!" + CRLF + CRLF + ;
                   "Preencha as linhas mantendo os cabecalhos e importe pela opcao 2."
    EndIf

    // Se for SmartClient Desktop Windows (GetRemoteType == 0), pode tentar OLE.
    // Em SmartClient HTML / WebApp (GetRemoteType != 0), o OLE nao existe e o arquivo e aberto/baixado via ShellExecute.
    If GetRemoteType() == 0
        If ApOleClient("MsExcel")
            oExcelApp := MsExcel():New()
            oExcelApp:WorkBooks:Open(cArqCli)
            oExcelApp:SetVisible(.T.)
            oExcelApp:Destroy()
        Else
            ShellExecute("Open", cArqCli, "", "", 1)
        EndIf
        FWAlertSuccess(cMsgSuc + CRLF + CRLF + "Arquivo salvo em: " + cArqCli, "Modelo Gerado")
    Else
        ShellExecute("Open", cArqCli, "", "", 1)
        FWAlertSuccess(cMsgSuc + CRLF + CRLF + "O arquivo foi disponibilizado para download no seu navegador (Downloads).", "Modelo Gerado")
    EndIf

Return Nil

/*-------------------------------------------------------------------
  Executa a importacao da planilha, valida dados e chama MATA415
-------------------------------------------------------------------*/
Static Function ImportaCot(cArqParam)

    Local cMascara   := "Planilhas Excel / XML (*.xml;*.xlsx;*.csv)|*.xml;*.xlsx;*.csv|" + ;
                        "Planilhas XML (*.xml)|*.xml|" + ;
                        "Planilhas Excel (*.xlsx)|*.xlsx|" + ;
                        "Arquivos CSV (*.csv)|*.csv|" + ;
                        "Todos os Arquivos (*.*)|*.*"
    Local cTitulo    := "Selecione a Planilha de Cotacao"
    Local cArqSel    := ""
    Local aLinhas    := {}
    Local aErros     := {}
    Local aCabec     := {}
    Local aItens     := {}
    Local aItensVal  := {}
    Local aItemLin   := {}
    Local nI         := 0
    Local cExt       := ""
    Local cCliente   := ""
    Local cLoja      := ""
    Local cCond      := ""
    Local cTab       := ""
    Local cVend1     := ""
    Local cVend2     := ""
    Local cProduto   := ""
    Local nQtd       := 0
    Local nPreco     := 0
    Local cTes       := ""
    Local dEntrega   := CtoD("")
    Local cObs       := ""
    Local cNumOrc    := ""
    Local cLogErro   := ""
    Local cNomeArq   := ""
    Local cArqSrv    := ""
    Local cArqProc   := ""

    PRIVATE lMsErroAuto    := .F.
    PRIVATE lMsHelpAuto    := .T.
    PRIVATE lAutoErrNoFile := .T.

    Default cArqParam := ""
    cArqSel := cArqParam

    // 1. Se nao foi selecionado previamente, abre a janela de selecao padrao no Servidor
    If Empty(cArqSel)
        cArqSel := cGetFile(cMascara, cTitulo, 1, "", .F., 0, .T., .T.)

        If Empty(cArqSel)
            Return Nil
        EndIf

        If Right(cArqSel, 1) == "\" .Or. Right(cArqSel, 1) == "/" .Or. ExistDir(cArqSel)
            FWAlertWarn("Nenhum arquivo foi selecionado." + CRLF + CRLF + ;
                        "Por favor, clique sobre o arquivo da cotacao (.xml ou .xlsx) para seleciona-lo antes de confirmar.", "Atencao")
            Return Nil
        EndIf
    EndIf

    // Garante que o arquivo esteja acessivel no servidor para leitura
    If ":" $ cArqSel
        // Caminho da estacao local com letra de unidade (ex: C:\...)
        cNomeArq := SubStr(cArqSel, Max(RAt("\", cArqSel), RAt("/", cArqSel)) + 1)
        cArqSrv  := "\spool\" + cNomeArq

        If !ExistDir("\spool\")
            MakeDir("\spool\")
        EndIf

        If !CpyT2S(cArqSel, "\spool\", .F.)
            FWAlertError("Nao foi possivel transferir o arquivo da sua maquina para o servidor Protheus:" + CRLF + ;
                         cArqSel + CRLF + CRLF + ;
                         "Dica: No SmartClient WebApp (Navegador), certifique-se de que o WebAgent (Agente Local) esteja ativo.", "Erro na Transferencia")
            Return Nil
        EndIf
        cArqProc := cArqSrv
    Else
        // Caminho no servidor (SmartClient HTML ou caminho relativo, ex: SERVIDOR\..., \spool\..., etc.)
        If Upper(Left(cArqSel, 9)) == "SERVIDOR\" .Or. Upper(Left(cArqSel, 9)) == "SERVIDOR/"
            cArqProc := "\" + SubStr(cArqSel, 10)
        ElseIf Left(cArqSel, 1) == "\" .Or. Left(cArqSel, 1) == "/"
            cArqProc := cArqSel
        Else
            cArqProc := "\" + cArqSel
        EndIf
    EndIf

    If !File(cArqProc)
        FWAlertError("O arquivo nao foi encontrado no servidor para leitura:" + CRLF + cArqProc + CRLF + CRLF + ;
                     "Verifique se o arquivo foi selecionado corretamente.", "Arquivo Nao Encontrado")
        Return Nil
    EndIf

    cExt := Upper(SubStr(cArqProc, RAt(".", cArqProc) + 1))

    // 2. Leitura dos dados conforme extensao
    If cExt == "XML"
        aLinhas := LeXMLSpreadsheet(cArqProc)
    ElseIf cExt == "XLSX"
        aLinhas := LeXLSX(cArqProc)
    ElseIf cExt == "CSV"
        aLinhas := LeCSV(cArqProc)
    Else
        aLinhas := LeXMLSpreadsheet(cArqProc)
    EndIf

    If Len(aLinhas) < 2
        FWAlertWarn("A planilha selecionada esta vazia ou possui apenas o cabecalho.", "Atencao")
        Return Nil
    EndIf

    // 3. Processa e valida cada linha a partir da 2a (pula cabecalho)
    dbSelectArea("SA1")
    SA1->(dbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA

    dbSelectArea("SE4")
    SE4->(dbSetOrder(1)) // E4_FILIAL + E4_CODIGO

    dbSelectArea("SA3")
    SA3->(dbSetOrder(1)) // A3_FILIAL + A3_COD

    dbSelectArea("SB1")
    SB1->(dbSetOrder(1)) // B1_FILIAL + B1_COD

    For nI := 1 To Len(aLinhas)
        aItemLin := aLinhas[nI]

        If Len(aItemLin) < 7
            Loop
        EndIf

        // Pula linhas de cabecalho ou titulos da planilha
        If "CLIENTE" $ Upper(AllTrim(cValToChar(aItemLin[1]))) .Or. ;
           "ITENS" $ Upper(AllTrim(cValToChar(aItemLin[1]))) .Or. ;
           "COTACAO" $ Upper(AllTrim(cValToChar(aItemLin[1]))) .Or. ;
           "PRODUTO" $ Upper(AllTrim(cValToChar(aItemLin[7])))
            Loop
        EndIf

        cCliente := AllTrim(cValToChar(aItemLin[1]))
        cLoja    := AllTrim(cValToChar(aItemLin[2]))
        cCond    := AllTrim(cValToChar(aItemLin[3]))
        cTab     := AllTrim(cValToChar(aItemLin[4]))
        cVend1   := AllTrim(cValToChar(aItemLin[5]))
        cVend2   := IIf(Len(aItemLin) >= 6, AllTrim(cValToChar(aItemLin[6])), "")
        cProduto := IIf(Len(aItemLin) >= 7, AllTrim(cValToChar(aItemLin[7])), "")
        nQtd     := IIf(Len(aItemLin) >= 8, Val(StrTran(cValToChar(aItemLin[8]), ",", ".")), 0)
        nPreco   := IIf(Len(aItemLin) >= 9, Val(StrTran(cValToChar(aItemLin[9]), ",", ".")), 0)
        cTes     := IIf(Len(aItemLin) >= 10, AllTrim(cValToChar(aItemLin[10])), "")
        dEntrega := IIf(Len(aItemLin) >= 11, ConverteData(aItemLin[11]), dDataBase)
        cObs     := IIf(Len(aItemLin) >= 12, AllTrim(cValToChar(aItemLin[12])), "")

        // Aplica o tamanho correto do dicionario Protheus sem nunca truncar o conteudo digitado
        cCliente := PadR(cCliente, Max(Len(cCliente), SafeTam("A1_COD", SafeTam("CJ_CLIENTE", 8))))
        cLoja    := PadR(cLoja, Max(Len(cLoja), SafeTam("A1_LOJA", SafeTam("CJ_LOJA", 4))))
        cCond    := PadR(cCond, Max(Len(cCond), SafeTam("E4_CODIGO", SafeTam("CJ_CONDPAG", 3))))
        cTab     := PadR(cTab, Max(Len(cTab), SafeTam("DA0_CODTAB", SafeTam("CJ_TABELA", 3))))
        cVend1   := PadR(cVend1, Max(Len(cVend1), SafeTam("A3_COD", SafeTam("CJ_VEND1", 6))))
        cVend2   := IIf(!Empty(cVend2), PadR(cVend2, Max(Len(cVend2), SafeTam("A3_COD", SafeTam("CJ_VEND2", 6)))), "")
        cProduto := PadR(cProduto, Max(Len(cProduto), SafeTam("B1_COD", SafeTam("CK_PRODUTO", 15))))
        cTes     := IIf(!Empty(cTes), PadR(cTes, Max(Len(cTes), SafeTam("F4_CODIGO", SafeTam("CK_TES", 3)))), "")

        // Se linha sem codigo de produto, ignora (linha modelo nao utilizada)
        If Empty(cProduto)
            Loop
        EndIf

        // Se informou o produto mas a quantidade ficou zerada ou com traco '-' (padrao do modelo), assume 1 por padrao
        If nQtd <= 0
            nQtd := 1
        EndIf

        // Valida Cliente e Loja
        If Empty(cCliente) .Or. Empty(cLoja)
            aAdd(aErros, "Linha " + cValToChar(nI) + ": Cliente e Loja sao obrigatorios.")
        ElseIf !SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))
            aAdd(aErros, "Linha " + cValToChar(nI) + ": Cliente " + cCliente + "/" + cLoja + " nao encontrado no cadastro (SA1).")
        Else
            // Se Vendedor 1 nao foi informado na planilha, busca padrao do cliente (A1_VEND)
            If Empty(cVend1) .And. !Empty(SA1->A1_VEND)
                cVend1 := SA1->A1_VEND
            EndIf
            // Se Vendedor 2 nao foi informado na planilha e cliente tem segundo vendedor cadastrado
            If Empty(cVend2) .And. SA1->(FieldPos("A1_VEND2")) > 0 .And. !Empty(SA1->A1_VEND2)
                cVend2 := SA1->A1_VEND2
            EndIf
        EndIf

        // Valida Condicao de Pagamento
        If !Empty(cCond) .And. !SE4->(dbSeek(xFilial("SE4") + cCond))
            aAdd(aErros, "Linha " + cValToChar(nI) + ": Condicao de pagamento " + cCond + " nao existe (SE4).")
        EndIf

        // Valida Vendedor 1 (se informado)
        If !Empty(cVend1) .And. !SA3->(dbSeek(xFilial("SA3") + cVend1))
            aAdd(aErros, "Linha " + cValToChar(nI) + ": Vendedor 1 (" + cVend1 + ") nao cadastrado (SA3).")
        EndIf

        // Valida Vendedor 2 (se informado - suporta clientes com 1 ou 2 vendedores)
        If !Empty(cVend2) .And. !SA3->(dbSeek(xFilial("SA3") + cVend2))
            aAdd(aErros, "Linha " + cValToChar(nI) + ": Vendedor 2 (" + cVend2 + ") nao cadastrado (SA3).")
        EndIf

        // Valida Produto
        If !SB1->(dbSeek(xFilial("SB1") + cProduto))
            aAdd(aErros, "Linha " + cValToChar(nI) + ": Produto " + cProduto + " nao encontrado no cadastro (SB1).")
        ElseIf SB1->B1_MSBLQL == "1"
            aAdd(aErros, "Linha " + cValToChar(nI) + ": Produto " + cProduto + " esta bloqueado para venda.")
        EndIf

        // Valida Preco
        If nPreco <= 0
            aAdd(aErros, "Linha " + cValToChar(nI) + ": Preco unitario deve ser maior que zero.")
        EndIf

        // Se nao tem erro, guarda item valido
        aAdd(aItensVal, {cProduto, nQtd, nPreco, cTes, dEntrega, cObs})

    Next nI

    // 4. Se houveram inconsistencias, aborta e exibe lista de erros
    If Len(aErros) > 0
        cLogErro := "Foram encontradas inconsistencias na planilha:" + CRLF + CRLF
        For nI := 1 To Min(Len(aErros), 15)
            cLogErro += "- " + aErros[nI] + CRLF
        Next nI
        If Len(aErros) > 15
            cLogErro += "... e mais " + cValToChar(Len(aErros) - 15) + " erro(s)." + CRLF
        EndIf
        cLogErro += CRLF + "Corrija os dados da planilha e tente novamente."
        FWAlertError(cLogErro, "Erros na Validacao")
        Return Nil
    EndIf

    If Len(aItensVal) == 0
        FWAlertWarn("Nenhum item valido para gerar a cotacao.", "Atencao")
        Return Nil
    EndIf

    // 5. Monta estruturas aCabec e aItens para o ExecAuto MATA415
    aCabec := {}
    aAdd(aCabec, {"CJ_CLIENTE", cCliente, Nil})
    aAdd(aCabec, {"CJ_LOJA",    cLoja,    Nil})
    aAdd(aCabec, {"CJ_CONDPAG", cCond,    Nil})

    If !Empty(cTab)
        aAdd(aCabec, {"CJ_TABELA",  cTab,   Nil})
    EndIf

    // Natureza Financeira do cliente (se o campo existir no orcamento SCJ)
    If SCJ->(FieldPos("CJ_NATUREZ")) > 0 .And. !Empty(SA1->A1_NATUREZ)
        aAdd(aCabec, {"CJ_NATUREZ", SA1->A1_NATUREZ, Nil})
    EndIf

    // Tipo de Cliente (se existir no orcamento SCJ)
    If SCJ->(FieldPos("CJ_TIPOCLI")) > 0 .And. !Empty(SA1->A1_TIPO)
        aAdd(aCabec, {"CJ_TIPOCLI", SA1->A1_TIPO, Nil})
    EndIf

    // Vendedor 1 (obrigatorio ou padrao do cliente)
    If !Empty(cVend1)
        If SCJ->(FieldPos("CJ_VEND1")) > 0
            aAdd(aCabec, {"CJ_VEND1", cVend1, Nil})
        ElseIf SCJ->(FieldPos("CJ_VEND")) > 0
            aAdd(aCabec, {"CJ_VEND",  cVend1, Nil})
        EndIf
    EndIf

    // Vendedor 2 (suporta clientes com 2 vendedores; fica vazio se tiver apenas 1)
    If !Empty(cVend2)
        If SCJ->(FieldPos("CJ_VEND2")) > 0
            aAdd(aCabec, {"CJ_VEND2", cVend2, Nil})
        EndIf
    EndIf

    If !Empty(cObs)
        aAdd(aCabec, {"CJ_OBS",     cObs,   Nil})
    EndIf

    aItens := {}
    For nI := 1 To Len(aItensVal)
        aItemLin := {}
        aAdd(aItemLin, {"CK_ITEM",    StrZero(nI, SafeTam("CK_ITEM", 2)), Nil})
        aAdd(aItemLin, {"CK_PRODUTO", aItensVal[nI][1],                  Nil})
        aAdd(aItemLin, {"CK_QTDVEN",  aItensVal[nI][2],                  Nil})
        aAdd(aItemLin, {"CK_PRCVEN",  aItensVal[nI][3],                  Nil})
        aAdd(aItemLin, {"CK_VALOR",   aItensVal[nI][2] * aItensVal[nI][3], Nil})

        If !Empty(aItensVal[nI][4])
            aAdd(aItemLin, {"CK_TES", aItensVal[nI][4],                  Nil})
        EndIf

        If !Empty(aItensVal[nI][5])
            aAdd(aItemLin, {"CK_ENTREG", aItensVal[nI][5],               Nil})
        EndIf

        If !Empty(aItensVal[nI][6])
            If SCK->(FieldPos("CK_PEDCLI")) > 0
                aAdd(aItemLin, {"CK_PEDCLI", aItensVal[nI][6],           Nil})
            ElseIf SCK->(FieldPos("CK_OBS")) > 0
                aAdd(aItemLin, {"CK_OBS",    aItensVal[nI][6],           Nil})
            ElseIf SCK->(FieldPos("CK_NUMPCOM")) > 0
                aAdd(aItemLin, {"CK_NUMPCOM", aItensVal[nI][6],          Nil})
            EndIf
        EndIf

        aAdd(aItens, aItemLin)
    Next nI

    // 6. Executa a gravacao via ExecAuto oficial MATA415 (Inclusao = 3)
    MSExecAuto({|x,y,z| MATA415(x,y,z)}, aCabec, aItens, 3)

    If lMsErroAuto
        MostraErro()
    Else
        cNumOrc := SCJ->CJ_NUM
        FWAlertSuccess("Orcamento de Venda [" + cNumOrc + "] gerado com sucesso!" + CRLF + CRLF + ;
                       "Cliente: " + cCliente + " / Loja: " + cLoja + CRLF + ;
                       "Vendedor 1: " + cVend1 + IIf(!Empty(cVend2), " | Vendedor 2: " + cVend2, " (Apenas 1 Vendedor)") + CRLF + ;
                       "Total de Itens: " + cValToChar(Len(aItens)) + CRLF + CRLF + ;
                       "Apos conferencia e aprovacao, acesse a rotina de Orcamentos (MATA415) e clique em 'Gerar Pedido' para converter em Pedido de Venda.", ;
                       "Cotacao Importada com Sucesso")
    EndIf

Return Nil

/*-------------------------------------------------------------------
  Leitura de arquivo XLSX utilizando FWReadExcel
  Possui fallback para leitura de XML Spreadsheet caso necessario
-------------------------------------------------------------------*/
Static Function LeXLSX(cArquivo)

    Local oExcel      := FWReadExcel():New()
    Local aWorkSheets := {}
    Local aLinhas     := {}

    If oExcel:Open(cArquivo)
        If oExcel:Activate()
            aWorkSheets := oExcel:GetWorkSheets()
            If Len(aWorkSheets) > 0
                aLinhas := oExcel:GetRows(aWorkSheets[1])
            EndIf
            oExcel:DeActivate()
        EndIf
    EndIf

    // Se nao obteve linhas via OpenXML (ex: gerado por FWMsExcel com extensao .xlsx),
    // interpreta o conteudo em formato XML
    If Len(aLinhas) == 0
        aLinhas := LeXMLSpreadsheet(cArquivo)
    EndIf

Return aLinhas

/*-------------------------------------------------------------------
  Interpreta linhas de planilha XML Spreadsheet (compativel com FWMsExcel)
-------------------------------------------------------------------*/
Static Function LeXMLSpreadsheet(cArquivo)

    Local aLinhas  := {}
    Local cBuffer  := ""
    Local nPosRow1 := 0
    Local nPosRow2 := 0
    Local cRow     := ""
    Local nPosD1   := 0
    Local nClose   := 0
    Local nPosD2   := 0
    Local cVal     := ""
    Local aCols    := {}

    cBuffer := MemoRead(cArquivo)
    If Empty(cBuffer)
        Return aLinhas
    EndIf

    While (nPosRow1 := At("<Row", cBuffer)) > 0
        cBuffer := SubStr(cBuffer, nPosRow1)
        nPosRow2 := At("</Row>", cBuffer)
        If nPosRow2 == 0
            Exit
        EndIf

        cRow    := SubStr(cBuffer, 1, nPosRow2)
        cBuffer := SubStr(cBuffer, nPosRow2 + 6)
        aCols   := {}

        While (nPosD1 := At("<Data", cRow)) > 0
            cRow := SubStr(cRow, nPosD1)
            nClose := At(">", cRow)
            If nClose == 0
                Exit
            EndIf
            cRow := SubStr(cRow, nClose + 1)

            nPosD2 := At("</Data>", cRow)
            If nPosD2 == 0
                Exit
            EndIf

            cVal := SubStr(cRow, 1, nPosD2 - 1)
            cRow := SubStr(cRow, nPosD2 + 7)
            aAdd(aCols, cVal)
        EndDo

        If Len(aCols) > 0
            aAdd(aLinhas, aCols)
        EndIf
    EndDo

Return aLinhas

/*-------------------------------------------------------------------
  Leitura de arquivo CSV separado por ponto-e-virgula ou virgula
-------------------------------------------------------------------*/
Static Function LeCSV(cArquivo)

    Local nHandle  := FT_FUse(cArquivo)
    Local aLinhas  := {}
    Local cLinha   := ""
    Local aCols    := {}
    Local cDelim   := ";"

    If nHandle < 0
        Return aLinhas
    EndIf

    FT_FGoTop()

    While !FT_FEOF()
        cLinha := FT_FReadLN()

        If !Empty(cLinha)
            // Detecta delimitador (, ou ;)
            If At(";", cLinha) == 0 .And. At(",", cLinha) > 0
                cDelim := ","
            Else
                cDelim := ";"
            EndIf

            aCols := StrTokArr2(cLinha, cDelim, .T.)
            aAdd(aLinhas, aCols)
        EndIf

        FT_FSKIP()
    EndDo

    FT_FUse()

Return aLinhas

/*-------------------------------------------------------------------
  Converte string de data para objeto Date do ADVPL
-------------------------------------------------------------------*/
Static Function ConverteData(xData)

    Local dRet := dDataBase
    Local cTxt := ""

    If ValType(xData) == "D"
        Return xData
    EndIf

    cTxt := AllTrim(cValToChar(xData))

    If Len(cTxt) == 10 // DD/MM/AAAA ou AAAA-MM-DD
        If SubStr(cTxt, 3, 1) == "/"
            dRet := CtoD(cTxt)
        ElseIf SubStr(cTxt, 5, 1) == "-"
            dRet := StoD(StrTran(cTxt, "-", ""))
        EndIf
    ElseIf Len(cTxt) == 8 // AAAAMMDD
        dRet := StoD(cTxt)
    EndIf

Return dRet

/*-------------------------------------------------------------------
  Retorna o tamanho do campo no SX3 com valor padrao defensivo
-------------------------------------------------------------------*/
Static Function SafeTam(cCampo, nPadrao)

    Local aTam := TamSX3(cCampo)

    If !Empty(aTam) .And. ValType(aTam) == "A" .And. Len(aTam) >= 1 .And. aTam[1] > 0
        Return aTam[1]
    EndIf

Return nPadrao

