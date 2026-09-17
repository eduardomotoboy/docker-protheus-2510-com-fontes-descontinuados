#INCLUDE "finr014.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINR014   º Autor ³Paulo Augusto       º Data ³  20/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para imprimir os comprovantes de entrega do talao º±±
±±º          ³ de recibo para o Cobrador                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FINR014()

	Local oReport

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Paulo Augusto          ³ Data ³28/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
	
	Local oReport	:= Nil
	Local oSection1	:= Nil
	Local oSection2	:= Nil
	Local cReport	:= "FINR014"
	Local cTitulo	:= OemToAnsi(STR0003) //"Lista recibos pendientes por cobrador"
	Local cDescri	:= OemToAnsi(STR0001)+" "+OemToAnsi(STR0002) //"Este programa tiene como objet." - "imprimir la ctd. de recibos pend.   "

	Pergunte( "FIR014" , .F. )

	oReport  := TReport():New( cReport, cTitulo, "FIR014" , { |oReport| ReportPrint( oReport, "SAQ" ) }, cDescri )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a 1a. secao do relatorio Valores nas Moedas   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1 := TRSection():New( oReport,STR0012 , {"SAQ"} )//"Cobradores"

	TRCell():New( oSection1, "AQ_COD" ,"SAQ" ,/*X3Titulo*/  ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{code-block de impressao}*/)
	TRCell():New( oSection1, "AQ_NOME","SAQ" ,/*X3Titulo*/ ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{code-block de impressao}*/)

	oSection2 := TRSection():New( oSection1, STR0013 , {"SEY"} )//"Taloes"

	TRCell():New( oSection2, "TALAO" 	    ,   	, STR0010  ,/*Picture*/,3,/*lPixel*/,{|| 1}) //"CTD de Talon. "
	TRCell():New( oSection2, "EY_COBRAD" 	,"SEY"	, /*X3Titulo*/  ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||code-block de impressao}*/)
	TRCell():New( oSection2, "EY_TALAO" 	,"SEY"	, /*X3Titulo*/  ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao}*/)
	TRCell():New( oSection2, "EY_DATA"   	,"SEY"	, /*X3Titulo()*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{||code-block de impressao }*/)
	TRCell():New( oSection2, "TIPO"      	,		, /*X3Titulo()*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{||  If (EY_TIPOREC="1",STR0008,STR0009) }) //"OFICIAL" - "PROVISORIO"
	TRCell():New( oSection2, "EY_SERIE"		,"SEY" 	, /*X3Titulo()*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "EY_RECINI" 	,"SEY" 	, /*X3Titulo()*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "EY_RECFIN" 	,"SEY" 	, /*X3Titulo()*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New( oSection2, "EY_RECPEND" 	,"SEY" 	, /*X3Titulo()*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³Paulo Augusto       º Data ³  27/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query de impressao do relatorio                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )
	
	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oSection1:Section(1)
	Local cAlias	:= GetNextAlias()
	Local oBreak1	:= Nil

	MakeSqlExpr("FIR014")
	oSection1:BeginQuery()
	BeginSql alias cAlias
		SELECT EY_COBRAD,EY_STATUS,EY_RECPEND,EY_TALAO, EY_DATA ,EY_TIPOREC,EY_SERIE,EY_RECINI,EY_RECFIN,EY_RECPEND,AQ_COD,AQ_NOME 	FROM %table:SAQ% SAQ, %table:SEY% SEY
		WHERE	SAQ.AQ_FILIAL = %xfilial:SAQ%  AND
		SAQ.AQ_COD  >= %Exp:mv_par01% AND
		SAQ.AQ_COD <= %Exp:mv_par02% AND
		SAQ.AQ_FILIAL = %xfilial:SAQ%  AND
		SAQ.AQ_COD = SEY.EY_COBRAD  AND
		SAQ.%notDel% AND
		SEY.EY_STATUS <>'2' AND
		SEY.EY_RECPEND > 0 AND
		SEY.%notDel%
	
		ORDER BY AQ_COD,EY_DATA
	EndSql

	oSection2:SetParentQuery()
	oSection2:SetParentFilter({|cParam| (cAlias)->EY_COBRAD == cParam},{|| (cAlias)->AQ_COD})

	oSection1:EndQuery()

	oBreak1 := TRBreak():New( oSection1,oSection1:Cell("AQ_COD") ,STR0010) //"CTD de Talon. "

	TRFunction():New(oSection2:Cell("EY_RECPEND")	, , "SUM"  , oBreak1, , , , .F. ,  )
	TRFunction():New(oSection2:Cell("TALAO")	, , "COUNT", oBreak1, , , , .F. ,  )

	oSection1:Print()

Return Nil
