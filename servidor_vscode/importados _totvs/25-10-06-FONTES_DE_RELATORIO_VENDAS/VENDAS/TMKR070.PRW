#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"  
#INCLUDE "TMKR070.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKR070   ºAutor  ³Vendas CRM          º Data ³  10/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de atendimentos telemarketing com exibicao de cha-º±±
±±º          ³mados compartilhados                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TMKR070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMKR070()
	Local oReport	:= Nil				// Objeto Report
	Local aArea 	:= GetArea()		// Salva a area 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros    ³
	//³ Mv_Par01           // Do chamado ?		³
	//³ Mv_Par02           // Até o chamado ?	³
	//³ Mv_Par03           // Da data ?     	³
	//³ Mv_Par04           // Até a data ?  	³
	//³ Mv_Par05           // Operadores ?  	³
	//³ Mv_Par06           // Cliente inicial ? ³
	//³ Mv_Par07           // Loja inicial ?  	³
	//³ Mv_Par08           // Cliente final ?  	³
	//³ Mv_Par09           // Loja final ?  	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("TMKR070", .F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                       
	oReport := ReportDef()
	oReport:PrintDialog()
	
	RestArea( aArea ) 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef  ºAutor  ³Vendas CRM          º Data ³  10/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de atendimentos telemarketing com exibicao de cha-º±±
±±º          ³mados compartilhados                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ReportDef                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local oReport
Local oSUC
Local oSUD
Local oSUDit
          
Local cPerg := "TMKR070"
Local cAlias1 	:= GetNextAlias()
Local cAlias2 	:= GetNextAlias()
Local cAlias3 	:= GetNextAlias()

DbSelectArea("SUC")   

Pergunte(cPerg, .F.)

DEFINE REPORT oReport NAME "REL002" TITLE STR0001 PARAMETER cPerg ACTION {|oReport| PrintReport(oReport, cPerg, cAlias1, cAlias2, cAlias3)} //"Chamados relacionados"

	DEFINE SECTION oSUC OF oReport TITLE STR0002 TABLES "SUC" //"Telemarketing"

		DEFINE CELL NAME "UC_CODIGO"  OF oSUC ALIAS "SUC"
		DEFINE CELL NAME "UC_DATA" 	OF oSUC ALIAS "SUC"
		DEFINE CELL NAME "UC_CODCONT"	OF oSUC ALIAS "SUC"
		DEFINE CELL NAME "UC_DESCENT"	OF oSUC ALIAS "SUC" BLOCK {|| Posicione("SX2",1,(cAlias1)->UC_ENTIDAD,"X2NOME()") } SIZE 15
		DEFINE CELL NAME "UC_DESCCHA"	OF oSUC ALIAS "SUC" BLOCK {|| TkEntidade((cAlias1)->UC_ENTIDAD,(cAlias1)->UC_CHAVE,1, , .T.) }
		DEFINE CELL NAME "UC_OPERADO"	OF oSUC ALIAS "SUC"
		DEFINE CELL NAME "UC_DESCOPE"	OF oSUC ALIAS "SUC" BLOCK {||Posicione("SU7",1,xFilial("SU7") + (cAlias1)->UC_OPERADO, "U7_NOME")}
		DEFINE CELL NAME "UC_MIDIA"	OF oSUC ALIAS "SUC"
		DEFINE CELL NAME "UC_DESCMID"	OF oSUC ALIAS "SUC" BLOCK {||Posicione("SUH",1,xFilial("SUH") + (cAlias1)->UC_MIDIA, "UH_DESC")}
		DEFINE CELL NAME "UC_OPERACA"	OF oSUC ALIAS "SUC"
		DEFINE CELL NAME "UC_STATUS"	OF oSUC ALIAS "SUC" BLOCK {||X3Combo("UC_STATUS",(cAlias1)->UC_STATUS)}
		DEFINE CELL NAME "UC_PENDENT"	OF oSUC ALIAS "SUC"
		DEFINE CELL NAME "UC_HRPEND"	OF oSUC ALIAS "SUC"
		DEFINE CELL NAME "UC_DTENCER"	OF oSUC ALIAS "SUC"

	DEFINE SECTION oSUD OF oSUC TITLE STR0003 TABLE "SUD" LEFT MARGIN 3	//"Itens - Atendimento" 

		DEFINE CELL NAME "UD_ITEM" 	OF oSUD ALIAS "SUD"
		DEFINE CELL NAME "UD_ASSUNTO"	OF oSUD ALIAS "SUD"
		DEFINE CELL NAME "UD_DESCASS"	OF oSUD ALIAS "SUD" BLOCK {||Posicione("SX5",1,xFilial("SX5")+"T1"+(cAlias2)->UD_ASSUNTO,"X5DESCRI()")}
		DEFINE CELL NAME "UD_PRODUTO"	OF oSUD ALIAS "SUD"
		DEFINE CELL NAME "UD_DESCPRO"	OF oSUD ALIAS "SUD"	BLOCK {||Posicione("SB1",1,xFilial("SB1")+(cAlias2)->UD_PRODUTO,"B1_DESC")}
		DEFINE CELL NAME "UD_OCORREN"	OF oSUD ALIAS "SUD"
		DEFINE CELL NAME "UD_DESCOCO"	OF oSUD ALIAS "SUD" BLOCK {||Posicione("SU9",1,xFilial("SU9")+(cAlias2)->UD_OCORREN,"U9_DESC")}
		DEFINE CELL NAME "UD_SOLUCAO"	OF oSUD ALIAS "SUD"
		DEFINE CELL NAME "UD_DESCSOL"	OF oSUD ALIAS "SUD" BLOCK {||Posicione("SUQ",1,xFilial("SUQ")+(cAlias2)->UD_SOLUCAO,"UQ_DESC")}
		DEFINE CELL NAME "UD_OPERADO"	OF oSUD ALIAS "SUD"
		DEFINE CELL NAME "UD_DATA"		OF oSUD ALIAS "SUD"
		DEFINE CELL NAME "UD_STATUS"	OF oSUD ALIAS "SUD" 
		DEFINE CELL NAME "UD_DTEXEC"	OF oSUD ALIAS "SUD" 

	DEFINE SECTION oSUDit OF oSUD TITLE STR0004 TABLE "SUD" LEFT MARGIN 6 //"Itens compartilhados"

		DEFINE CELL NAME "UD_ITEM" 	OF oSUDIt ALIAS "SUD"
		DEFINE CELL NAME "UD_ASSUNTO"	OF oSUDIt ALIAS "SUD"
		DEFINE CELL NAME "UD_DESCASS"	OF oSUDIt ALIAS "SUD" BLOCK {||Posicione("SX5",1,xFilial("SX5")+"T1"+(cAlias3)->UD_ASSUNTO,"X5DESCRI()")}
		DEFINE CELL NAME "UD_PRODUTO"	OF oSUDIt ALIAS "SUD"
		DEFINE CELL NAME "UD_DESCPRO"	OF oSUDIt ALIAS "SUD"	BLOCK {||Posicione("SB1",1,xFilial("SB1")+(cAlias3)->UD_PRODUTO,"B1_DESC")}
		DEFINE CELL NAME "UD_OCORREN"	OF oSUDIt ALIAS "SUD"
		DEFINE CELL NAME "UD_DESCOCO"	OF oSUDIt ALIAS "SUD" BLOCK {||Posicione("SU9",1,xFilial("SU9")+(cAlias3)->UD_OCORREN,"U9_DESC")}
		DEFINE CELL NAME "UD_SOLUCAO"	OF oSUDIt ALIAS "SUD"
		DEFINE CELL NAME "UD_DESCSOL"	OF oSUDIt ALIAS "SUD" BLOCK {||Posicione("SUQ",1,xFilial("SUQ")+(cAlias3)->UD_SOLUCAO,"UQ_DESC")}
		DEFINE CELL NAME "UD_OPERADO"	OF oSUDIt ALIAS "SUD"
		DEFINE CELL NAME "UD_DATA"		OF oSUDIt ALIAS "SUD"
		DEFINE CELL NAME "UD_STATUS"	OF oSUDIt ALIAS "SUD" 
		DEFINE CELL NAME "UD_DTEXEC"	OF oSUDIt ALIAS "SUD" 

oReport:SetLandscape()

Return( oReport )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintReportºAutor ³Vendas CRM          º Data ³  11/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Selecao dos dados e impressao do relatorio                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TMKR070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport(oReport, cPerg, cAlias1, cAlias2, cAlias3)

Local oSecCab	:= oReport:Section(1)					   		//Raiz do relatorio
Local oSecItem	:= oReport:Section(1):Section(1)		   		//Itens do atendimento
Local oSecSubIt	:= oReport:Section(1):Section(1):Section(1)	//SubItens do atendimento
Local cEntIni	:= "%'"+MV_PAR06+MV_PAR07+"'%"
Local cEntFim	:= "%'"+MV_PAR08+MV_PAR09+"'%"
Local lSubItem	:= .F.
Local bWhile	:= {||.T.} 
Local cVazio	:= "%''%"
Local cSQL 		:= "" 
Local cDataIni	:= DtoS(MV_PAR03)
Local cDataFim	:= DtoS(MV_PAR04)

MakeSqlExp(cPerg)

If !Empty(MV_PAR05)
	cSQL += " AND " + MV_PAR05
EndIf

cSQL := "%"+cSQL+"%"
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query principal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BEGIN REPORT QUERY oSecCab
	BeginSQL Alias cAlias1
		
		COLUMN UC_DTENCER	AS DATE	
		COLUMN UC_PENDENT	AS DATE	
		COLUMN UC_DATA		AS DATE	
		
		SELECT 	UC_FILIAL,UC_CODIGO,UC_DATA,UC_CODCONT,UC_OPERADO,UC_MIDIA,UC_OPERACA,
				UC_STATUS,UC_PENDENT,UC_HRPEND,UC_DTENCER,UC_TIPO,UC_CHAVE,UC_ENTIDAD
		FROM %Table:SUC% SUC
		WHERE UC_FILIAL = %xFilial:SUC% AND UC_CODIGO BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% 
			AND UC_DATA BETWEEN %exp:cDataIni% and %exp:cDataFim% AND UC_CHAVE BETWEEN %exp:cEntIni% and %exp:cEntFim% 
			AND UC_CHAORIG = %exp:cVazio% AND SUC.%NotDel%
			%Exp:cSQL%
		ORDER BY UC_FILIAL, UC_CODIGO
	EndSQL
END REPORT QUERY oSecCab

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query dos itens (1o. Nivel) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BEGIN REPORT QUERY oSecItem
	BeginSql alias cAlias2
		SELECT UD_FILIAL,UD_ITEM,UD_CODIGO,UD_ASSUNTO,UD_PRODUTO,UD_OCORREN,UD_SOLUCAO,UD_OPERADO,UD_DATA,UD_STATUS,UD_DTEXEC
		FROM %table:SUD% SUD 
		WHERE UD_FILIAL = %xfilial:SUD% AND SUD.UD_CODIGO = %report_param: (cAlias1)->UC_CODIGO% AND SUD.%notDel%
		ORDER BY UD_FILIAL,UD_CODIGO,UD_ITEM
	EndSql
END REPORT QUERY oSecItem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query dos itens (2o. Nivel) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BEGIN REPORT QUERY oSecSubIt
	BeginSql alias cAlias3
		SELECT UD_FILIAL,UD_ITEM,UD_CODIGO,UD_ASSUNTO,UD_PRODUTO,UD_OCORREN,UD_SOLUCAO,UD_OPERADO,UD_DATA,UD_STATUS,UD_DTEXEC
		FROM %table:SUD% SUD 
		INNER JOIN %table:SUC% SUC on UC_FILIAL = %xfilial:SUC% AND UC_CODIGO = UD_CODIGO AND
			UC_CHAORIG = %report_param: (cAlias2)->UD_CODIGO% AND 
			UC_ITCHAOR = %report_param: (cAlias2)->UD_ITEM% AND SUC.%NotDel%	
		WHERE UD_FILIAL = %xfilial:SUD% AND SUD.%notDel%
		ORDER BY UD_FILIAL,UD_CODIGO,UD_ITEM
	EndSql
END REPORT QUERY oSecSubIt
	


While !oReport:Cancel() .AND. (cAlias1)->(!Eof()) .AND.;
	(cAlias1)->UC_FILIAL == xFilial("SUC")			.AND.;
	(cAlias1)->UC_CODIGO <= MV_PAR02
	
	oSecCab:Init()
	oSecCab:PrintLine()
	oSecItem:ExecSql() 	

	While !oReport:Cancel() .And. !(cAlias2)->(Eof()) .AND.;
		(cAlias2)->UD_FILIAL == xFilial("SUD")			.AND.;
		(cAlias2)->UD_CODIGO == (cAlias1)->UC_CODIGO
		
		oSecItem:Init() 
		oSecItem:PrintLine()
		
		oSecSubIt:ExecSql()
		lSubItem := !(cAlias3)->(Eof()) 
		

        If lSubItem
	        oSecSubIt:Init()  
			While !oReport:Cancel() .AND. !(cAlias3)->(Eof()) .AND. Eval(bWhile)  
				oSecSubIt:PrintLine()
				(cAlias3)->(DbSkip())
			End  
			oSecSubIt:Finish()
			oSecItem:Finish()
		EndIf
		
		oReport:IncMeter() 
			  		
		(cAlias2)->(DbSkip()) 
		
	End 
	oSecItem:Finish()
	(cAlias1)->(DbSkip())	
	oSecCab:Finish()
EndDo  

Return Nil