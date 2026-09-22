#Include "Protheus.ch"
#Include "FWMVCDef.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} AJFINA01
Rotina para consulta e exclusao de ocorrencias presas com erro no Novo Gestor Financeiro (Techfin / Boleto Hibrido).
Permite apagar os registros da tabela SEA (Titulos Enviados ao Banco) e, opcionalmente,
liberar os titulos correspondentes no Contas a Receber (SE1) retornando-os para Carteira.

@type function
@version 2.0
@author Eduardo Jose Da Silva
@since 22/09/2026
@return logical, .T.
/*/
User Function AJFINA01()
	Local lRet       := .T.
	Local aPergs     := {}
	Local cBordero   := Space(6)
	Local nTipoFilt  := 1
	Local nLiberaSE1 := 1
	Local nModoOp    := 1
	Local cAliasTRB  := "TRBSEA"
	Local oTempTable := Nil
	Local nTotalReg  := 0
	Local cMsgAviso  := ""

	cMsgAviso := "Esta rotina e utilizada para consultar e apagar registros de ocorrencias que ficam presas " + ;
	             "no NOVO GESTOR FINANCEIRO (cards 'Retorno com erro' e 'Falha no envio do email')." + CRLF + CRLF + ;
	             "Ao excluir a ocorrencia na tabela SEA, a notificacao e removida da grade do monitor " + ;
	             "e o titulo pode ser liberado no Contas a Receber (SE1) para nova cobranca."

	Aviso("Gestor Financeiro - Exclusao de Ocorrencias", cMsgAviso, {"Continuar", "Cancelar"}, 03)

	// Montagem do ParamBox
	aAdd(aPergs, {1, "Numero do Bordero", cBordero, "@!", ".T.", "", ".T.", 60, .F.})
	aAdd(aPergs, {2, "Tipo de Ocorrencia", nTipoFilt, {"1=Retorno com Erro / Rejeicoes", "2=Falha Envio E-mail (EA_APIMAIL=2)", "3=Todos os Registros do Bordero"}, 140, ".T.", .F.})
	aAdd(aPergs, {2, "Liberar em Contas a Receber (SE1)?", nLiberaSE1, {"1=Sim (Limpa Bordero e volta para Carteira)", "2=Nao (Apenas exclui ocorrencia na SEA)"}, 140, ".T.", .F.})
	aAdd(aPergs, {2, "Modo de Operacao", nModoOp, {"1=Visualizar Lista para Selecao (Recomendado)", "2=Excluir Direto com Confirmacao"}, 140, ".T.", .F.})

	If ParamBox(aPergs, "Parametros - Limpeza Gestor Financeiro")
		cBordero   := AllTrim(MV_PAR01)
		nTipoFilt  := MV_PAR02
		nLiberaSE1 := MV_PAR03
		nModoOp    := MV_PAR04

		// 1. Carrega dados da query em tabela temporaria
		oTempTable := CarregaSEA(cBordero, nTipoFilt, @cAliasTRB, @nTotalReg)

		If nTotalReg == 0
			MsgInfo("Nenhuma ocorrencia encontrada com os filtros informados!" + CRLF + CRLF + ;
			        "• Bordero: " + If(Empty(cBordero), "[Todos]", cBordero) + CRLF + ;
			        "• Tipo Filtro: " + Str(nTipoFilt, 1), "Gestor Financeiro")
			If oTempTable != Nil
				oTempTable:Delete()
			EndIf
			Return .F.
		EndIf

		// 2. Direciona conforme modo de operacao
		If nModoOp == 1
			ShowMarkBrw(cAliasTRB, oTempTable, (nLiberaSE1 == 1))
		Else
			ExecDireto(cAliasTRB, oTempTable, (nLiberaSE1 == 1), nTotalReg, cBordero)
		EndIf
	Else
		MsgAlert("Operacao cancelada pelo usuario.", "Atencao")
	EndIf

Return(lRet)

/*/{Protheus.doc} CarregaSEA
Executa query SQL na tabela SEA e preenche tabela temporaria com os registros encontrados
@type function
@version 2.0
@author Eduardo Jose Da Silva
@since 22/09/2026
/*/
Static Function CarregaSEA(cBordero, nTipoFilt, cAliasTRB, nTotalReg)
	Local cQuery     := ""
	Local cAliasQry  := GetNextAlias()
	Local oTempTable := Nil
	Local aCampos    := {}
	Local cWhere     := ""
	Local cWhereBord := ""
	Local cWhereTipo := ""
	Local cMarca     := GetMark()

	cAliasTRB := "TRBSEA"
	nTotalReg := 0
	cBordero  := AllTrim(cBordero)

	// Filtro de Bordero
	If !Empty(cBordero)
		cWhereBord := " SEA.EA_NUMBOR = '" + cBordero + "' "
	Else
		cWhereBord := " 1=1 "
	EndIf

	// Filtro por tipo de ocorrencia / situacao
	Do Case
		Case nTipoFilt == 1 // Retorno com Erro / Rejeicoes
			cWhereTipo := " (SEA.EA_APIMAIL = '2' OR SEA.EA_SITUAC IN ('2','E','R') OR (SEA.EA_OCORR NOT IN ('','01','02') AND SEA.EA_OCORR IS NOT NULL)) "
		Case nTipoFilt == 2 // Falha Envio E-mail
			cWhereTipo := " SEA.EA_APIMAIL = '2' "
		Case nTipoFilt == 3 // Todos do Bordero
			cWhereTipo := " 1=1 "
	EndCase

	cWhere := cWhereBord + " AND " + cWhereTipo

	// Cria estrutura da tabela temporaria
	oTempTable := FWTemporaryTable():New(cAliasTRB)
	aCampos := {}
	AAdd(aCampos, {"OK",         "C", 2,  0})
	AAdd(aCampos, {"EA_FILIAL",  "C", 4,  0})
	AAdd(aCampos, {"EA_NUMBOR",  "C", 6,  0})
	AAdd(aCampos, {"EA_PORTADO", "C", 3,  0})
	AAdd(aCampos, {"EA_AGEDEP",  "C", 5,  0})
	AAdd(aCampos, {"EA_NUMCON",  "C", 10, 0})
	AAdd(aCampos, {"EA_PREFIXO", "C", 3,  0})
	AAdd(aCampos, {"EA_NUM",     "C", 9,  0})
	AAdd(aCampos, {"EA_PARCELA", "C", 3,  0})
	AAdd(aCampos, {"EA_TIPO",    "C", 3,  0})
	AAdd(aCampos, {"EA_FORNECE", "C", 6,  0})
	AAdd(aCampos, {"EA_LOJA",    "C", 2,  0})
	AAdd(aCampos, {"A1_NOME",    "C", 40, 0})
	AAdd(aCampos, {"EA_VALOR",   "N", 14, 2})
	AAdd(aCampos, {"EA_APIMAIL", "C", 1,  0})
	AAdd(aCampos, {"EA_OCORR",   "C", 2,  0})
	AAdd(aCampos, {"REC_SEA",    "N", 12, 0})

	oTempTable:SetFields(aCampos)
	oTempTable:AddIndex("1", {"EA_NUMBOR", "EA_NUM", "EA_PARCELA"})
	oTempTable:Create()

	// Montagem da query SQL
	cQuery := " SELECT "
	cQuery += "   SEA.R_E_C_N_O_ AS REC_SEA, "
	cQuery += "   SEA.EA_FILIAL, "
	cQuery += "   SEA.EA_NUMBOR, "
	cQuery += "   SEA.EA_PORTADO, "
	cQuery += "   SEA.EA_AGEDEP, "
	cQuery += "   SEA.EA_NUMCON, "
	cQuery += "   SEA.EA_PREFIXO, "
	cQuery += "   SEA.EA_NUM, "
	cQuery += "   SEA.EA_PARCELA, "
	cQuery += "   SEA.EA_TIPO, "
	cQuery += "   SEA.EA_FORNECE, "
	cQuery += "   SEA.EA_LOJA, "
	cQuery += "   SEA.EA_VALOR, "
	cQuery += "   SEA.EA_APIMAIL, "
	cQuery += "   SEA.EA_OCORR, "
	cQuery += "   SEA.EA_SITUAC, "
	cQuery += "   ISNULL(SA1.A1_NOME, '') AS A1_NOME "
	cQuery += " FROM " + RetSQLName("SEA") + " SEA "
	cQuery += " LEFT JOIN " + RetSQLName("SA1") + " SA1 "
	cQuery += "   ON SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cQuery += "  AND SA1.A1_COD    = SEA.EA_FORNECE "
	cQuery += "  AND SA1.A1_LOJA   = SEA.EA_LOJA "
	cQuery += "  AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SEA.D_E_L_E_T_ = ' ' "
	If !Empty(xFilial("SEA"))
		cQuery += "   AND SEA.EA_FILIAL = '" + xFilial("SEA") + "' "
	EndIf
	cQuery += "   AND " + cWhere
	cQuery += " ORDER BY SEA.EA_NUMBOR, SEA.EA_NUM, SEA.EA_PARCELA "

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasQry) > 0
		(cAliasQry)->(dbCloseArea())
	EndIf

	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .T., .T.)

	While !(cAliasQry)->(EoF())
		nTotalReg++
		RecLock(cAliasTRB, .T.)
		(cAliasTRB)->OK         := cMarca
		(cAliasTRB)->EA_FILIAL  := (cAliasQry)->EA_FILIAL
		(cAliasTRB)->EA_NUMBOR  := (cAliasQry)->EA_NUMBOR
		(cAliasTRB)->EA_PORTADO := (cAliasQry)->EA_PORTADO
		(cAliasTRB)->EA_AGEDEP  := (cAliasQry)->EA_AGEDEP
		(cAliasTRB)->EA_NUMCON  := (cAliasQry)->EA_NUMCON
		(cAliasTRB)->EA_PREFIXO := (cAliasQry)->EA_PREFIXO
		(cAliasTRB)->EA_NUM     := (cAliasQry)->EA_NUM
		(cAliasTRB)->EA_PARCELA := (cAliasQry)->EA_PARCELA
		(cAliasTRB)->EA_TIPO    := (cAliasQry)->EA_TIPO
		(cAliasTRB)->EA_FORNECE := (cAliasQry)->EA_FORNECE
		(cAliasTRB)->EA_LOJA    := (cAliasQry)->EA_LOJA
		(cAliasTRB)->A1_NOME    := (cAliasQry)->A1_NOME
		(cAliasTRB)->EA_VALOR   := (cAliasQry)->EA_VALOR
		(cAliasTRB)->EA_APIMAIL := (cAliasQry)->EA_APIMAIL
		(cAliasTRB)->EA_OCORR   := (cAliasQry)->EA_OCORR
		(cAliasTRB)->REC_SEA    := (cAliasQry)->REC_SEA
		(cAliasTRB)->(MsUnlock())
		(cAliasTRB)->(dbSkip())
	EndDo

	(cAliasQry)->(dbCloseArea())

Return oTempTable

/*/{Protheus.doc} ShowMarkBrw
Apresenta grade de marcacao com os titulos encontrados para o usuario selecionar
@type function
@version 2.0
@author AJE
@since 22/09/2026
/*/
Static Function ShowMarkBrw(cAliasTRB, oTempTable, lLiberaSE1)
	Local oMark
	Local cMarca := GetMark()

	(cAliasTRB)->(dbGoTop())

	oMark := FWMarkBrowse():New()
	oMark:SetAlias(cAliasTRB)
	oMark:SetDescription("Exclusao de Ocorrencias - Gestor Financeiro Techfin")
	oMark:SetFieldMark("OK")
	oMark:SetMark(cMarca, cAliasTRB, "OK")

	// Colunas identicas a grade do Gestor Financeiro
	oMark:AddColumn({"Filial",        {|| (cAliasTRB)->EA_FILIAL},  "C", "@!"})
	oMark:AddColumn({"Bordero",       {|| (cAliasTRB)->EA_NUMBOR},  "C", "@!"})
	oMark:AddColumn({"Banco",         {|| (cAliasTRB)->EA_PORTADO}, "C", "@!"})
	oMark:AddColumn({"Agencia",       {|| (cAliasTRB)->EA_AGEDEP},  "C", "@!"})
	oMark:AddColumn({"Conta",         {|| (cAliasTRB)->EA_NUMCON},  "C", "@!"})
	oMark:AddColumn({"Prefixo",       {|| (cAliasTRB)->EA_PREFIXO}, "C", "@!"})
	oMark:AddColumn({"No. Titulo",    {|| (cAliasTRB)->EA_NUM},     "C", "@!"})
	oMark:AddColumn({"Parcela",       {|| (cAliasTRB)->EA_PARCELA}, "C", "@!"})
	oMark:AddColumn({"Tipo",          {|| (cAliasTRB)->EA_TIPO},    "C", "@!"})
	oMark:AddColumn({"Nome Cliente",  {|| AllTrim((cAliasTRB)->EA_FORNECE) + "-" + (cAliasTRB)->EA_LOJA + " " + AllTrim((cAliasTRB)->A1_NOME)}, "C", "@!"})
	oMark:AddColumn({"Valor",         {|| Transform((cAliasTRB)->EA_VALOR, "@E 999,999,999.92")}, "C", "@!"})
	oMark:AddColumn({"Ocorrencia",    {|| (cAliasTRB)->EA_OCORR},   "C", "@!"})
	oMark:AddColumn({"Status E-mail", {|| If((cAliasTRB)->EA_APIMAIL=="2", "2-Falha", If((cAliasTRB)->EA_APIMAIL=="1", "1-Enviado", If((cAliasTRB)->EA_APIMAIL=="0", "0-Aguardando", "3-Nao Envia")))}, "C", "@!"})

	oMark:AddButton("Excluir Selecionados", {|| ExecExclusao(cAliasTRB, cMarca, lLiberaSE1, oMark)}, "Excluir ocorrencias marcadas", 4)
	oMark:AddButton("Marcar Todos",         {|| MarcaTodos(cAliasTRB, cMarca, .T., oMark)}, "Marcar todos os registros", 2)
	oMark:AddButton("Desmarcar Todos",      {|| MarcaTodos(cAliasTRB, cMarca, .F., oMark)}, "Desmarcar todos os registros", 2)
	oMark:AddButton("Fechar",               {|| oMark:End()}, "Fechar sem excluir", 2)

	oMark:Activate()

	If oTempTable != Nil
		oTempTable:Delete()
	EndIf
Return Nil

/*/{Protheus.doc} MarcaTodos
Marca ou desmarca todos os registros da grade
@type function
@version 2.0
@author AJE
@since 22/09/2026
/*/
Static Function MarcaTodos(cAliasTRB, cMarca, lMarca, oMark)
	Local nRecAtual := (cAliasTRB)->(Recno())

	(cAliasTRB)->(dbGoTop())
	While !(cAliasTRB)->(EoF())
		RecLock(cAliasTRB, .F.)
		(cAliasTRB)->OK := If(lMarca, cMarca, "  ")
		(cAliasTRB)->(MsUnlock())
		(cAliasTRB)->(dbSkip())
	EndDo
	(cAliasTRB)->(dbGoTo(nRecAtual))

	If oMark != Nil
		oMark:Refresh(.T.)
	EndIf
Return Nil

/*/{Protheus.doc} ExecDireto
Executa exclusao direta apos confirmacao do usuario
@type function
@version 2.0
@author AJE
@since 22/09/2026
/*/
Static Function ExecDireto(cAliasTRB, oTempTable, lLiberaSE1, nTotalReg, cBordero)
	Local cMarca := GetMark()
	Local cMsg   := ""

	cMsg := "Foram encontradas " + AllTrim(Str(nTotalReg)) + " ocorrencia(s)." + CRLF + CRLF
	cMsg += "• Bordero: " + If(Empty(cBordero), "[Todos]", AllTrim(cBordero)) + CRLF
	If lLiberaSE1
		cMsg += "• Titulos em SE1: Serao liberados para CARTEIRA (bordero limpo)." + CRLF
	Else
		cMsg += "• Titulos em SE1: Nao serao alterados." + CRLF
	EndIf
	cMsg += CRLF + "Deseja realmente EXCLUIR todas essas ocorrencias da tabela SEA?"

	If MsgYesNo(cMsg, "Confirmacao de Exclusao Direta")
		ExecExclusao(cAliasTRB, cMarca, lLiberaSE1, Nil)
	Else
		MsgAlert("Operacao cancelada pelo usuario.", "Atencao")
	EndIf

	If oTempTable != Nil
		oTempTable:Delete()
	EndIf
Return Nil

/*/{Protheus.doc} ExecExclusao
Processa a exclusao dos registros selecionados na SEA e atualizacao do SE1
@type function
@version 2.0
@author AJE
@since 22/09/2026
/*/
Static Function ExecExclusao(cAliasTRB, cMarca, lLiberaSE1, oMark)
	Local nQtdMarc   := 0
	Local nRecAtual  := (cAliasTRB)->(Recno())
	Local aExcluir   := {}
	Local nI         := 0
	Local nExcluidos := 0
	Local nSE1Ajust  := 0
	Local cMsg       := ""

	// Contabiliza registros marcados
	(cAliasTRB)->(dbGoTop())
	While !(cAliasTRB)->(EoF())
		If (cAliasTRB)->OK == cMarca
			nQtdMarc++
			AAdd(aExcluir, { ;
				(cAliasTRB)->REC_SEA,    ; // [1] Recno SEA
				(cAliasTRB)->EA_FILIAL,  ; // [2] Filial
				(cAliasTRB)->EA_PREFIXO, ; // [3] Prefixo
				(cAliasTRB)->EA_NUM,     ; // [4] Numero
				(cAliasTRB)->EA_PARCELA, ; // [5] Parcela
				(cAliasTRB)->EA_TIPO,    ; // [6] Tipo
				(cAliasTRB)->EA_NUMBOR   ; // [7] Bordero
			})
		EndIf
		(cAliasTRB)->(dbSkip())
	EndDo
	(cAliasTRB)->(dbGoTo(nRecAtual))

	If nQtdMarc == 0
		MsgAlert("Nenhum registro selecionado para exclusao!", "Atencao")
		Return Nil
	EndIf

	cMsg := "Confirma a exclusao de " + AllTrim(Str(nQtdMarc)) + " ocorrencia(s) selecionada(s)?" + CRLF + CRLF
	cMsg += "• Os registros serao apagados da tabela SEA (Gestor Financeiro)." + CRLF
	If lLiberaSE1
		cMsg += "• Os titulos no Contas a Receber (SE1) serao retornados para CARTEIRA (bordero limpo)." + CRLF
	Else
		cMsg += "• Os titulos no Contas a Receber (SE1) NAO serao alterados." + CRLF
	EndIf

	If !MsgYesNo(cMsg, "Confirmacao de Exclusao")
		Return Nil
	EndIf

	// Processamento transacional
	Processa({|| ;
		Begin Transaction
			dbSelectArea("SEA")
			dbSelectArea("SE1")
			SE1->(dbSetOrder(1)) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO

			For nI := 1 To Len(aExcluir)
				ProcRegua(Len(aExcluir))
				IncProc("Excluindo ocorrencia " + AllTrim(Str(nI)) + " de " + AllTrim(Str(Len(aExcluir))) + "...")

				// 1. Exclui registro da tabela SEA
				SEA->(dbGoTo(aExcluir[nI][1]))
				If !SEA->(EoF()) .And. !SEA->(Deleted())
					RecLock("SEA", .F.)
					SEA->(dbDelete())
					SEA->(MsUnlock())
					nExcluidos++
				EndIf

				// 2. Libera o titulo em SE1 se solicitado
				If lLiberaSE1
					If SE1->(dbSeek(xFilial("SE1") + aExcluir[nI][3] + aExcluir[nI][4] + aExcluir[nI][5] + aExcluir[nI][6]))
						If AllTrim(SE1->E1_NUMBOR) == AllTrim(aExcluir[nI][7])
							RecLock("SE1", .F.)
							SE1->E1_NUMBOR  := Space(Len(SE1->E1_NUMBOR))
							SE1->E1_SITUACA := "0" // Carteira
							SE1->(MsUnlock())
							nSE1Ajust++
						EndIf
					EndIf
				EndIf
			Next nI
		End Transaction
	}, "Processando...", "Excluindo ocorrencias do Gestor Financeiro...", .F.)

	cMsg := "Processo concluido com sucesso!" + CRLF + CRLF
	cMsg += "• Ocorrencias excluidas da SEA: " + AllTrim(Str(nExcluidos)) + CRLF
	If lLiberaSE1
		cMsg += "• Titulos liberados em SE1 (Carteira): " + AllTrim(Str(nSE1Ajust)) + CRLF
	EndIf
	cMsg += CRLF + "As notificacoes foram removidas do banco de dados." + CRLF + ;
	        "Ao atualizar a tela do Novo Gestor Financeiro, as pendencias nao serao mais exibidas."

	MsgInfo(cMsg, "Gestor Financeiro - Concluido")

	If oMark != Nil
		oMark:End()
	EndIf
Return Nil
