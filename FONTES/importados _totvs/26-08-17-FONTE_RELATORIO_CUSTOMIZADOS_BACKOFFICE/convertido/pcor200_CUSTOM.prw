#INCLUDE "PCOR200C.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

STATIC lFWCodFil	:= FindFunction("FWCodFil")
Static nQtdEntid	:= Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCOR200   ºAutor  ³Jair Ribeiro        º Data ³  11/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de simulacao                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAPCO                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                           
Function U_PCOR200C()
	Local olReport	:= Nil
	Local cPerg		:= "PCOR200"

	//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
	Pergunte(cPerg,.F.)
	olReport:= ReportDef(cPerg)
	olReport:PrintDialog()

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Microsiga           º Data ³  11/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef(cPerg)
	Local olReport		:= Nil
	Local olSection1	:= Nil
	Local olSection2	:= Nil 
	Local oBreak		:= Nil
	Local oBreak2		:= Nil 
	Local clDesc		:= OEMTOANSI(STR0001) //"Relatório da Simulação" //"Relatório da Simulação"
	Local clAx1			:= ""
	Local clAx2			:= ""
	Local cMoeda		:= ""
	Local nCount		:= 0	
			
	olReport	:= TReport():New(cPerg,clDesc,cPerg,{|olReport| FProcessaR(olReport)},clDesc,.F., /*Orientacao do Relatorio - '.T.' para paisagem*/)
	olReport:lFooterVisible		:= .F.	// Não imprime rodapé do protheus
	olReport:lParamPage			:= .F.	// Não imprime pagina de parametros
	olReport:oPage:nPaperSize	:= 9	// Ajuste para papel A4
	
	olSection1	:= TRSection():New(olReport,STR0039,"QRYPCOR200")
	olSection2	:= TRSection():New(olSection1,STR0040) 
	olSection3	:= TRSection():New(olSection2,STR0041) 

	olSection2:SetLeftMargin(5)
	olSection3:SetLeftMargin(10)
	
	TRCell():New(olSection1,"AKR_ORCAME") //Planilha Orçamentária
	TRCell():New(olSection1,"AK1_DESCRI",,STR0007) //"Descrição"
	TRCell():New(olSection1,"AKR_DESCRI",,STR0002) //"Relatório de visualização da Simulação Orçamentária."
	
	TRCell():New(olSection2,"AK3_CO",,STR0004) //"Conta Orçamentária"
	TRCell():New(olSection2,"AK3_DESCRI",,STR0007) //"Descrição"
	
	TRCell():New(olSection3,"AK2_CC") //"Centro de Custo"
	TRCell():New(olSection3,"AK2_ITCTB") //"Item Contab."
	TRCell():New(olSection3,"AK2_CLVLR") //"Classe Valor"
	TRCell():New(olSection3,"AK2_CLASSE") //"Classe Orçamentária"
	TRCell():New(olSection3,"AK2_UNIORC") //"Unid. Orçamentária"

	If nQtdEntid == NIL
		If cPaisLoc == "RUS"
			nQtdEntid := PCOQtdEntd() //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor.
		Else
			nQtdEntid := CtbQtdEntd() //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
		EndIf		
	EndIf

	If nQtdEntid > 4

		dbSelectArea("CT0")
		CT0->(dbSetOrder(1))
		CT0->(dbSeek(xFilial("CT0")))
		CT0->(dbSkip(4))

		For nCount := 5 To nQtdEntid
			TRCell():New(olSection3,"AK2_ENT0" + CValToChar(nCount),,AllTrim(CT0->CT0_DESC))
			CT0->(DbSkip())
		Next nCount

	EndIf

	TRCell():New(olSection3,"AK6_DESCRI",,,,30,,,,.T.)
	TRCell():New(olSection3,"",,STR0020,,,,{|| &("MV_MOEDA"+ALLTRIM(STR(AK2_MOEDA)))}) //"Desc.Moeda 1"
	TRCell():New(olSection3,"AK2_DATAI",,STR0012) //"Inic.Períodos"
	TRCell():New(olSection3,"AK2_DATAF",,STR0013) //"Fin.Períodos"
	TRCell():New(olSection3,"AK2_VALOR")

	olSection1:SetLineCondtion({|| IIF(QRYPCOR200->AKR_ORCAME == clAx1,.F.,clAx1:=QRYPCOR200->AKR_ORCAME)})
	oBreak := TRBreak():New(olSection1,olSection1:Cell("AKR_ORCAME"),STR0044,.F.) //"Total Simulacao"
	TRFunction():New(olSection3:Cell("AK2_VALOR"),NIL,"SUM",oBreak,,,,.F.,.F.)	

	olSection2:SetParentFilter({|| QRYPCOR200->AKR_ORCAME == clAx1})
	olSection2:SetParentQuery()	
	olSection2:SetLineCondtion({|| IIF(QRYPCOR200->AK3_CO == clAx2,.F.,clAx2:=QRYPCOR200->AK3_CO)})	
	
   	olSection3:SetParentFilter({|| QRYPCOR200->AK3_CO == clAx2})
	oBreak2 := TRBreak():New(olSection3,olSection2:Cell("AK3_CO"),STR0008,.F.) //"TOTAL C.O"
	TRFunction():New(olSection3:Cell("AK2_VALOR"),NIL,"SUM",oBreak2,,,,.F.,.T.)	
	olSection3:SetParentQuery()	
	
	olReport:SetLandScape()
	olReport:DisableOrientation()
	
Return olReport 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FProcessaRºAutor  ³Microsiga           º Data ³  11/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FProcessaR(olReport)   
	Local olSection1	:= olReport:Section(1) 
	Local cQry			:= ""
	Local cAddSelect	:= ""
	Local nX			:= 0
	Local cIdEntAd		:= ""
	Local nNumPerg		:= 0	

	olSection1:BeginQuery()
	
	If X3Usado("AK2_UNIORC")
		cAddSelect += ", AK2.AK2_UNIORC "
		cQry += " AND AK2.AK2_UNIORC >= '" + MV_PAR19 + "' " //"Unidade Orçamentária de?"
		cQry += " AND AK2.AK2_UNIORC <= '" + MV_PAR20 + "' " //"Unidade Orçamentária ate?"
	EndIf

	If nQtdEntid == NIL
		If cPaisLoc == "RUS"
			nQtdEntid := PCOQtdEntd() //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
		Else
			nQtdEntid := CtbQtdEntd() //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
		EndIf		
	EndIf

	nNumPerg := 20
	For nX := 5 To nQtdEntid
		cIdEntAd := StrZero(nX,2)
		cAddSelect += ", AK2.AK2_ENT" + cIdEntAd + " "
		cQry += " AND AK2.AK2_ENT" + cIdEntAd + " >= '" + &("MV_PAR"+StrZero(++nNumPerg,2)) + "' "
		cQry += " AND AK2.AK2_ENT" + cIdEntAd + " <= '" + &("MV_PAR"+StrZero(++nNumPerg,2)) + "' "
	Next nX	

	cAddSelect	:= "% " + cAddSelect + " %"
	cQry		:= "% " + cQry + " %"
	
	BeginSql Alias "QRYPCOR200"
	
		SELECT AKR.AKR_ORCAME
				, AKR.AKR_DESCRI
				, AK1.AK1_DESCRI
				, AK3.AK3_CO
				, AK3.AK3_DESCRI 
				, AK2.AK2_CC
				, AK2.AK2_ITCTB
   				, AK2.AK2_CLVLR
				, AK2.AK2_CLASSE 
				, AK6.AK6_DESCRI
				, AK2.AK2_MOEDA 
				, AK2.AK2_DATAI
				, AK2.AK2_DATAF 
				, AK2.AK2_VALOR
				%exp:cAddSelect%
			FROM %table:AKR% AKR
		
			INNER JOIN %table:AK1% AK1
			ON(
				AK1.AK1_CODIGO = AKR.AKR_ORCAME
				AND AK1.AK1_FILIAL = AKR.AKR_FILIAL
				AND AK1.%NotDel% 
				)
		
			INNER JOIN %table:AK3% AK3
			ON(
				AK3.AK3_ORCAME = AKR.AKR_ORCAME
				AND AK3.AK3_FILIAL = AKR.AKR_FILIAL
		   		AND AK3.AK3_VERSAO = AKR.AKR_REVISA
		  		AND AK3_CO	>= %exp:MV_PAR09%	   	 		//"Conta de?"
		   		AND AK3_CO	<= %exp:MV_PAR10%	   			//"Conta ate?"
		   		AND AK3.AK3_CO <> AKR.AKR_ORCAME 
		   		AND AK3.%NotDel%
		   		)
	
			INNER JOIN %table:AK2% AK2
			ON(
				AK2.AK2_ORCAME 		= AK3.AK3_ORCAME
				AND AK2.AK2_CO 		= AK3.AK3_CO
				AND AK2.AK2_FILIAL 	= AKR.AKR_FILIAL
				AND AK2.AK2_VERSAO	= AKR.AKR_REVISA
				AND AK2.AK2_DATAI	>= %exp:MV_PAR03%		//"Periodo de?"
				AND AK2.AK2_DATAF	<= %exp:MV_PAR04%		//"Periodo ate?"
				AND AK2.AK2_CC		>= %exp:MV_PAR11%		//"Centro de Custo de?"
				AND AK2.AK2_CC		<= %exp:MV_PAR12%		//"Centro de Custo ate?"
				AND AK2.AK2_ITCTB	>= %exp:MV_PAR13%		//"Item Contábil de?"		
				AND AK2.AK2_ITCTB	<= %exp:MV_PAR14%		//"Item Contábil ate?"
				AND AK2.AK2_CLVLR	>= %exp:MV_PAR15%		//"Classe de Valor de?"
				AND AK2.AK2_CLVLR	<= %exp:MV_PAR16%		//"Classe de Valor ate?"
				AND AK2.AK2_CLASSE	>= %exp:MV_PAR17%		//"Classe Orçamentária de?"
				AND AK2.AK2_CLASSE	<= %exp:MV_PAR18%		//"Classe Orçamentária ate?"
				AND AK2.%NotDel%
				%exp:cQry%
				)
			
			INNER JOIN %table:AK6% AK6
			ON(
				AK6.AK6_CODIGO		= AK2.AK2_CLASSE
				AND AK6.AK6_FILIAL 	= AKR.AKR_FILIAL
				AND AK6.%NotDel%
				)
			
			WHERE AKR.AKR_FILIAL 	>= %exp:MV_PAR01%		//"Filial de?"
				AND AKR.AKR_FILIAL 	<= %exp:MV_PAR02%		//"Filial ate?"
				AND AKR.AKR_ORCAME	>= %exp:MV_PAR05%		//"Simulação de?"
				AND AKR.AKR_ORCAME	<= %exp:MV_PAR06%		//"Simulação ate?"
				AND AKR.AKR_REVISA	>= %exp:MV_PAR07%		//"Versao de?"
				AND AKR.AKR_REVISA	<= %exp:MV_PAR08%		//"Versao ate?"
				AND AKR.%NotDel%
		
			ORDER BY AKR.AKR_ORCAME, AK3.AK3_NIVEL ASC
	EndSql

	olSection1:EndQuery()
	olSection1:Print()

Return Nil


