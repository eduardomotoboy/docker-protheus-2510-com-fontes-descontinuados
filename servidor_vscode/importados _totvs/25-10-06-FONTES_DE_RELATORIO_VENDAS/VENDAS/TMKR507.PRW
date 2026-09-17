#INCLUDE "REPORT.CH" 
#INCLUDE "TMKR507.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMKR507  ³ Autor ³ Vendas CRM            ³ Data ³ 30/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consolidação de chamados                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMKR507(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function TMKR507()
Local oReport	//Objeto relatorio TReport (Release 4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("TMKR507",.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros	³
	//³ Mv_PAR01	// De						³
	//³ Mv_PAR02	// Ate						³
	//³ Mv_PAR03	// Da Equipe				³
	//³ Mv_PAR04	// Até a Equipe				³
	//³ Mv_PAR05	// Do Cliente				³
	//³ Mv_PAR06	// Da Loja   				³	
	//³ Mv_PAR07	// Até o Cliente			³	
	//³ Mv_PAR08	// Até a Loja   			³		
	//³ Mv_PAR09	// Do Produto				³
	//³ Mv_PAR10	// Até o Produto			³		
	//³ Mv_PAR11	// Quebra    				³	
	//³ Mv_PAR12	// Tipo de Relatorio		³
	//³ MV_PAR13    // Exibe sub-equipes ? 	    |	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog() 

Return(.T.)
                     
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TKR507RptDef ³ Autor ³Vendas CRM          ³ Data ³30/08/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina que define os itens que serao apresentados no relato-³±±
±±³          ³rio.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tkr507RptDef()                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              
Static Function ReportDef()
Local oReport	:= Nil		// Objeto relatorio TReport
Local oSection1	:= Nil		// Objeto seção 1 do relatorio
Local oSection2	:= Nil		// Objeto seção 2 do relatorio
Local oSection3	:= Nil		// Objeto seção 3.1 do relatório (analítico)
Local cAlias 	:= "ADE"	// Alias da consulta Embedded SQL
Local oBreak1	:= Nil		// Break para a seção 1
Local oBreak2	:= Nil		// Break para a seção 2
Local oFunction1:= Nil		// Totalizador para a seção 1
Local oFunction2:= Nil		// Totalizador para a seção 2
Local oFunction3:= Nil		// Totalizador para a seção 1 dos chamados em aberto/pendente
Local oFunction4:= Nil		// Totalizador para a seção 1 dos chamados encerrados
Local oFunction5:= Nil		// Totalizador para a seção 2 dos chamados em aberto/pendente
Local oFunction6:= Nil		// Totalizador para a seção 2 dos chamados encerrados
Local oFunction7:= Nil		// Totalizador para a seção 2 dos chamados encerrados
Local oFunction8:= Nil		// Totalizador para a seção 2 dos chamados encerrados
Local oFunction9:= Nil		// Totalizador para a seção 2 dos chamados encerrados

DEFINE REPORT oReport NAME "TMKR507" TITLE STR0001 PARAMETER "TMKR507" ACTION {|oReport| Tkr507PrtRpt( oReport, cAlias, oBreak1, oBreak2, oFunction1, oFunction2, oFunction3, oFunction4, oFunction5, oFunction6, oFunction7, oFunction8, oFunction9 )} DESCRIPTION STR0002	// "Consolidação de chamados" "Possibilitar diversas formas de consolidação de quantidade de chamados"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, informando que o arquivo principal ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport		TITLE STR0003 TABLES "ADE"	// "Quebra 1"
DEFINE SECTION oSection2 OF oSection1	TITLE STR0004 TABLES "ADE"	// "Quebra 2"
DEFINE SECTION oSection3 OF oSection2	TITLE STR0005 TABLES "ADE"	// "Chamados"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na seção 1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "ADE_CHAVE"	OF oSection1 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_CHAVE) + " - " + AllTrim(FATPDObfuscate(Posicione("SA1", 1, xFilial("SA1") + (cAlias)->ADE_CHAVE,"A1_NOME"),"A1_NOME",,.T.)) }	SIZE 30
DEFINE CELL NAME "ADE_GRUPO"	OF oSection1 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_GRUPO) + " - " + AllTrim(Posicione("SU0", 1, xFilial('SU0') + (cAlias)->ADE_GRUPO,"U0_NOME")) }	SIZE 30

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na seção 2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "ADE_CHAVE"	OF oSection2 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_CHAVE) + " - " + AllTrim(FATPDObfuscate(Posicione("SA1", 1, xFilial("SA1") + (cAlias)->ADE_CHAVE,"A1_NOME"),"A1_NOME",,.T.)) }	SIZE 30
DEFINE CELL NAME "ADE_GRUPO"	OF oSection2 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_GRUPO) + " - " + AllTrim(Posicione("SU0", 1, xFilial("SU0") + (cAlias)->ADE_GRUPO,"U0_NOME")) }	SIZE 30
DEFINE CELL NAME "ADE_CODSB1"	OF oSection2 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_CODSB1) + " - " + AllTrim(Posicione("SB1", 1, xFilial("SB1") + (cAlias)->ADE_CODSB1, "B1_DESC")) }	SIZE 30

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na seção 3.1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "ADE_TIPO"		OF oSection3 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_TIPO) + " - " + AllTrim(Posicione("SUL", 1, xFilial("SUL") + (cAlias)->ADE_TIPO, "UL_DESC")) } SIZE 20
DEFINE CELL NAME "ADE_CODIGO"	OF oSection3 ALIAS "ADE"	SIZE 10
DEFINE CELL NAME "ADE_DATA"		OF oSection3 ALIAS "ADE"
DEFINE CELL NAME "ADE_CODSB1"	OF oSection3 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_CODSB1) + " - " + AllTrim(Posicione("SB1", 1, xFilial("SB1") + (cAlias)->ADE_CODSB1, "B1_DESC")) }	SIZE 20
DEFINE CELL NAME "ADE_OPERAD"	OF oSection3 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_OPERAD) + " - " + AllTrim(FATPDObfuscate(Posicione("SU7", 1, xFilial("SU7") + (cAlias)->ADE_OPERAD, "U7_NOME"),"U7_NOME",,.T.)) }	SIZE 20
DEFINE CELL NAME "ADE_STATUS"	OF oSection3 ALIAS "ADE"
DEFINE CELL NAME "ADE_ASSUNT"	OF oSection3 ALIAS "ADE"	BLOCK	{||AllTrim((cAlias)->ADE_ASSUNT) + " - " + AllTrim(Posicione("SX5", 1, xFilial("SX5")+"T1"+(cAlias)->ADE_ASSUNT,'X5DESCRI()')) }	SIZE 20
DEFINE CELL NAME "ADE_FNC"		OF oSection3 ALIAS "ADE"
DEFINE CELL NAME "TKTAM"		OF oSection3 ALIAS ""	 	TITLE STR0021	BLOCK{||TK510TAME((cAlias)->ADE_CODIGO)} 	SIZE 11	//"Tempo Total"
DEFINE CELL NAME "TKTMA"		OF oSection3 ALIAS ""	 	TITLE STR0022	BLOCK{||TK510TMA((cAlias)->ADE_CODIGO)}	SIZE 7	//"TMA"
DEFINE CELL NAME "ADE_DTEXPI"	OF oSection3 ALIAS "ADE"  

DbSelectArea("ADE")
DEFINE CELL NAME "ADE_HREXPI"	OF oSection3 ALIAS "ADE" 

DEFINE CELL NAME "TKPERCSLA"	OF oSection3 ALIAS ""		TITLE STR0023	BLOCK {||nPerc:=0,RetSlaStatus((cAlias)->ADE_REGSLA,,@nPerc),nPerc} SIZE 8 PICTURE "@E 99999.99" //"% SLA"


	
DEFINE CELL NAME "TKDPSE1S"	OF oSection3 ALIAS ""	 	TITLE STR0015   BLOCK {||(cAlias)->ADE_DPSE1S} 	//BLOCK {||(cAlias)->ADE_DPSE1S}	//"Dt 1º Pausa SLA"
DEFINE CELL NAME "TKHPSE1S"	OF oSection3 ALIAS ""	 	TITLE STR0016   BLOCK {||(cAlias)->ADE_HPSE1S}		//"Hr 1º Pausa SLA"
DEFINE CELL NAME "TKDPSEUL"	OF oSection3 ALIAS ""	 	TITLE STR0017  BLOCK {||(cAlias)->ADE_DPSEUL}	//"Dt. Pausa SLA"
DEFINE CELL NAME "TKHPSEUL"	OF oSection3 ALIAS ""	 	TITLE STR0018  BLOCK {||(cAlias)->ADE_HPSEUL}	//"Hr. Pausa SLA"         
DEFINE CELL NAME "TKDENCSL"	OF oSection3 ALIAS ""	 	TITLE STR0019   BLOCK {||(cAlias)->ADE_DENCSL}			//"Dt.Enc SLA"
DEFINE CELL NAME "TKHENCSL"	OF oSection3 ALIAS ""	 	TITLE STR0020   BLOCK {||(cAlias)->ADE_HENCSL}			//"Hr.Enc SLA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Total da seção 1.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE BREAK oBreak1 OF oSection1 WHEN oSection3:Cell("ADE_CODIGO")	TITLE STR0003		// "Quebra 1"
oBreak1:SetTotalInLine(.T.)		// Imprime total em linha ou coluna (default .T. - linha )
oSection3:SetLineBreak()
DEFINE FUNCTION oFunction1 FROM oSection3:Cell("ADE_CODIGO") FUNCTION SUM	BREAK oBreak1 NO END SECTION NO END REPORT FORMULA {|| TKR507Status( cAlias , 1) }	PICTURE "999999" TITLE STR0006	// "Abertos/pendentes"
DEFINE FUNCTION oFunction2 FROM oSection3:Cell("ADE_CODIGO") FUNCTION SUM	BREAK oBreak1 NO END SECTION NO END REPORT FORMULA {|| TKR507Status( cAlias , 2) }	PICTURE "999999" TITLE STR0007	// "Encerrados"
DEFINE FUNCTION oFunction3 FROM oSection3:Cell("ADE_CODIGO") FUNCTION COUNT	BREAK oBreak1 NO END SECTION NO END REPORT											PICTURE "999999" TITLE STR0008	// "Total"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Total da seção 2.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE BREAK oBreak2 OF oSection2 WHEN oSection3:Cell("ADE_CODIGO")	TITLE STR0004		// "Quebra 2"
oBreak2:SetTotalInLine(.T.)		// Imprime total em linha ou coluna (default .T. - linha )
DEFINE FUNCTION oFunction4 FROM oSection3:Cell("ADE_CODIGO") FUNCTION SUM	BREAK oBreak2 NO END SECTION NO END REPORT FORMULA {|| TKR507Status( cAlias , 1) }	PICTURE "999999" TITLE STR0006	// "Abertos/pendentes"
DEFINE FUNCTION oFunction5 FROM oSection3:Cell("ADE_CODIGO") FUNCTION SUM	BREAK oBreak2 NO END SECTION NO END REPORT FORMULA {|| TKR507Status( cAlias , 2) }	PICTURE "999999" TITLE STR0007	// "Encerrados"
DEFINE FUNCTION oFunction6 FROM oSection3:Cell("ADE_CODIGO") FUNCTION COUNT	BREAK oBreak2 NO END SECTION NO END REPORT											PICTURE "999999" TITLE STR0008	// "Total"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Total geral.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FUNCTION oFunction7 FROM oSection3:Cell("ADE_CODIGO") FUNCTION SUM	NO END SECTION FORMULA {|| TKR507Status( cAlias , 1) }	PICTURE "999999" TITLE STR0006	// "Abertos/pendentes"
DEFINE FUNCTION oFunction8 FROM oSection3:Cell("ADE_CODIGO") FUNCTION SUM	NO END SECTION FORMULA {|| TKR507Status( cAlias , 2) }	PICTURE "999999" TITLE STR0007	// "Encerrados"
DEFINE FUNCTION oFunction9 FROM oSection3:Cell("ADE_CODIGO") FUNCTION COUNT	NO END SECTION											PICTURE "999999" TITLE STR0008	// "Total"


Return(oReport)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Tkr507PrtRpt ³ Autor ³ Vendas CRM         ³ Data ³30/08/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel pela impressao do relatorio              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tkr507PrtRept(ExpO1,ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = objeto relatorio                                   ³±±
±±³          ³ ExpC1 = alias da query atual                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tkr507PrtRpt(	oReport		, cAlias	, oBreak1		, oBreak2	,;
								oFunction1	, oFunction2, oFunction3	, oFunction4,;
								oFunction5	, oFunction6, oFunction7	, oFunction8,;
								oFunction9)

Local oSection1 	:= oReport:Section(1)				// Objeto secao 1 do relatorio
Local oSection2 	:= oSection1:Section(1)				// Objeto secao 2 do relatorio
Local oSection3 	:= oSection2:Section(1)				// Objeto secao 3 do relatorio
Local lSintetico	:= IF(MV_PAR12==1,.T., .F.)		// Se o relatório é do tipo sintético ou não
Local cOrderBy		:= ""
Local cWhereADE		:= ""
Local cSqlCampos 	:= ""
Local lSubEquipe	:= .F.
Local cQuery		:= ""

If Type("Mv_Par13") == "N" .AND. Mv_Par13 == 1
	lSubEquipe := .T.
EndIf	

#IFDEF TOP
	MakeSqlExpr("TMKR507")		
	
	If lSintetico
		oSection3:Hide()
	EndIf
	
	If MV_PAR11 == 1	// Quebra por Cliente/Area
		cOrderBy	:= " ADE_CHAVE, ADE_GRUPO "
	ElseIf MV_PAR11 == 2	// Quebra por Area/Cliente
		cOrderBy	:= " ADE_GRUPO, ADE_CHAVE "
	ElseIf MV_PAR11 == 3	// Quebra por Cliente/Produto
		cOrderBy	:= " ADE_CHAVE, ADE_CODSB1 "
	EndIf

	cSqlCampos += " U0_CODIGO, ADE_CHAVE, ADE_GRUPO, ADE_CODSB1, ADE_TIPO,"
	cSqlCampos += " ADE_CODIGO, ADE_DATA, ADE_OPERAD,"
	cSqlCampos += " ADE_STATUS, ADE_ENTIDA, ADE_ASSUNT, ADE_FNC,"
	cSqlCampos += " ADE_DTEXPI"
			
	cSqlCampos += ", ADE_DPSE1S, ADE_HPSE1S, ADE_DPSEUL, ADE_HPSEUL,"
	cSqlCampos += "ADE_DENCSL, ADE_HENCSL, ADE_DENCCH, ADE_HENCCH"
    
	cSqlCampos += ", ADE_HREXPI"

	cSqlCampos += ", ADE_REGSLA"

	
	cWhereADE += " ADE_FILIAL ='" + xFilial("ADE") + "'"
	
	If !(Empty(MV_PAR01) .AND. Empty(MV_PAR02))
  		cWhereADE += " AND ADE_DATA >= '" + DToS(MV_PAR01) + "' AND ADE_DATA <= '" + DToS(MV_PAR02) + "'"
	 EndIf
	
	If !lSubEquipe
		If !(Empty(Mv_Par03) .AND. Upper(Mv_Par04) == "ZZ")
	   		cWhereADE += " AND ADE_GRUPO BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "'"
		EndIf
	EndIf	
	
	cWhereADE += " AND ADE_ENTIDA = 'SA1'"
	
	If !(Empty(MV_PAR05 + MV_PAR06) .AND. Left(Upper(MV_PAR07),6) == "ZZZZZZ")
		cWhereADE += " AND ADE_CHAVE >= '" + MV_PAR05 + MV_PAR06 + "' AND ADE_CHAVE <= '" + MV_PAR07 + MV_PAR08 + "'"
	EndIf
	
	If !(Empty(MV_PAR09) .AND. Left(Upper(MV_PAR10),6) == "ZZZZZZ")
		cWhereADE += " AND ADE_CODSB1 >= '" + MV_PAR09 + "' AND ADE_CODSB1 <= '" + MV_PAR10 + "'"
	EndIf
	         
	cWhereADE += " AND N1.U0_FILIAL = '"+xFilial("SU0")+"' AND N1.U0_CODIGO BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+ "'"
		
	If lSubEquipe
		cWhereADE += " AND EXISTS (SELECT * FROM " +RetSqlName("SU0")+" N2" 
		cWhereADE += " WHERE N2.U0_GRPSUP = N1.U0_CODIGO AND N2.U0_CODIGO = ADE.ADE_GRUPO ) "
	EndIf
                  	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query principal.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery	+= "SELECT " + cSqlCampos
	cQuery	+= " FROM " + RetSqlName("ADE") + " ADE ,"+RetSqlName("SU0")+" N1"
	cQuery	+= " WHERE " + cWhereADE + " AND ADE.D_E_L_E_T_ = ' ' AND N1.D_E_L_E_T_ = ' '"
	cQuery	+= " ORDER BY " + cOrderBy
		
	oSection1:SetQuery(cAlias,cQuery,.F.)
	
	If MV_PAR11 == 1	// Quebra por Cliente/Area
		oSection2:SetParentQuery()			
		oSection2:SetParentFilter({|cParam| (cAlias)->ADE_CHAVE == cParam},{|| (cAlias)->ADE_CHAVE })
		oSection3:SetParentQuery()
		oSection3:SetParentFilter({|cParam| (cAlias)->ADE_CHAVE + (cAlias)->ADE_GRUPO == cParam},{|| (cAlias)->ADE_CHAVE + (cAlias)->ADE_GRUPO })		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esconde as celulas que não serão exibidas pois não são da quebra selecionada.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    oSection1:Cell("ADE_CHAVE"):SetTitle(STR0009)	// "Cliente"
		oSection1:Cell("ADE_GRUPO"):Disable()
		oSection2:Cell("ADE_CHAVE"):Disable()
		oSection2:Cell("ADE_CODSB1"):Disable()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Corrige o título das functions.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oBreak1:SetTitle(STR0010)			// "Total do Cliente"
		oBreak2:SetTitle(STR0011)			// "Total do Grupo"
	ElseIf MV_PAR11 == 2	// Quebra por Area/Cliente
		oSection2:SetParentQuery()	
		oSection2:SetParentFilter({|cParam| (cAlias)->ADE_GRUPO == cParam},{|| (cAlias)->ADE_GRUPO })		
		oSection3:SetParentQuery()	                                       
		oSection3:SetParentFilter({|cParam| (cAlias)->ADE_GRUPO + (cAlias)->ADE_CHAVE == cParam},{|| (cAlias)->ADE_GRUPO + (cAlias)->ADE_CHAVE })	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esconde as celulas que não serão exibidas pois não são da quebra selecionada.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		oSection1:Cell("ADE_CHAVE"):Disable()
		oSection2:Cell("ADE_CHAVE"):SetTitle(STR0009)	// "Cliente"
		oSection2:Cell("ADE_GRUPO"):Disable()
		oSection2:Cell("ADE_CODSB1"):Disable()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Corrige o título das functions.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		oBreak1:SetTitle(STR0011)			// "Total do Grupo"
		oBreak2:SetTitle(STR0010)			// "Total do Cliente"
	ElseIf MV_PAR11 == 3	// Quebra por Produto/Area
		oSection2:SetParentQuery()	
		oSection2:SetParentFilter({|cParam| (cAlias)->ADE_CHAVE == cParam},{|| (cAlias)->ADE_CHAVE })		
		oSection3:SetParentQuery()	
		oSection3:SetParentFilter({|cParam| (cAlias)->ADE_CHAVE + (cAlias)->ADE_CODSB1  == cParam},{|| (cAlias)->ADE_CHAVE + (cAlias)->ADE_CODSB1 })	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esconde as celulas que não serão exibidas pois não são da quebra selecionada.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		oSection1:Cell("ADE_CHAVE"):SetTitle(STR0009)	// "Cliente"
		oSection1:Cell("ADE_GRUPO"):Disable()
		oSection2:Cell("ADE_GRUPO"):Disable()
		oSection2:Cell("ADE_CHAVE"):Disable()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Corrige o título das functions.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		oBreak1:SetTitle(STR0010)			// "Total do Cliente"
		oBreak2:SetTitle(STR0012)			// "Total do Produto"
	EndIf		
	
	oSection1:Print()
#ENDIF

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TKR507Statust³ Autor ³ Vendas CRM         ³ Data ³20/07/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel pela contagem dos chamados em aberto e   ³±±
±±³          ³pendente                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TKR507Statust(ExpC1,ExpN2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do relatório principal                       ³±±
±±³          ³ ExpN2 = Qual function (totalizador) está sendo solicitando ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TKR507Status( cAlias, nFunction )
Local nRet := 0		// Retorno

If nFunction == 1	// Contagem dos em aberto e pendentes da quebra 1 e da quebra 2
	If (cAlias)->ADE_STATUS $ "12"
		nRet := 1
	EndIf
ElseIf nFunction == 2	// Contagem dos encerrados da quebra 1 e da quebra 2
	If (cAlias)->ADE_STATUS == "3"
		nRet := 1
	EndIf
EndIf

Return nRet

//-----------------------------------------------------------------------------
/*/{Protheus.doc} FATPDObfuscate
    @description
    Realiza ofuscamento de uma variavel ou de um campo protegido.
	Remover essa função quando não houver releases menor que 12.1.27

    @type  Function
    @sample FATPDObfuscate("999999999","U5_CEL")
    @author Squad CRM & Faturamento
    @since 04/12/2019
    @version P12
    @param xValue, (caracter,numerico,data), Valor que sera ofuscado.
    @param cField, caracter , Campo que sera verificado.
    @param cSource, Caractere, Nome do recurso que buscar dados protegidos.
    @param lLoad, Logico, Efetua a carga automatica do campo informado

    @return xValue, retorna o valor ofuscado.
/*/
//-----------------------------------------------------------------------------
Static Function FATPDObfuscate(xValue, cField, cSource, lLoad)
    
    If FATPDActive()
		xValue := FTPDObfuscate(xValue, cField, cSource, lLoad)
    EndIf

Return xValue   

//-----------------------------------------------------------------------------
/*/{Protheus.doc} FATPDActive
    @description
    Função que verifica se a melhoria de Dados Protegidos existe.

    @type  Function
    @sample FATPDActive()
    @author Squad CRM & Faturamento
    @since 17/12/2019
    @version P12    
    @return lRet, Logico, Indica se o sistema trabalha com Dados Protegidos
/*/
//-----------------------------------------------------------------------------
Static Function FATPDActive()

    Static _lFTPDActive := Nil
  
    If _lFTPDActive == Nil
        _lFTPDActive := ( GetRpoRelease() >= "12.1.027" .Or. !Empty(GetApoInfo("FATCRMPD.PRW")) )  
    Endif

Return _lFTPDActive