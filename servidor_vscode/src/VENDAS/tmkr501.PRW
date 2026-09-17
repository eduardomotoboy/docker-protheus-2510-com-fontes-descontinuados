#INCLUDE "TMKR501.CH"
#INCLUDE "REPORT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMKR501  ³ Autor ³ Vendas CRM            ³ Data ³ 20/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Chamados Help Desk solcionados                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMKR501(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function TMKR501()

Local oReport	//Objeto relatorio TReport (Release 4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("TMKR501",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ Mv_Par01           // De                                     ³
	//³ Mv_Par02           // Ate                                    ³
	//³ Mv_Par03           // Indicador para Interacoes              ³	
	//³ Mv_Par04           // Do Grupo                               ³		
	//³ Mv_Par05           // Ate o Grupo                            ³	
	//³ Mv_Par06           // Do Analista                            ³		
	//³ Mv_Par07           // Ate o Analista                         ³	
	//³ Mv_Par08           // Tipo de Relatorio                      ³		
	//³ MV_PAR09		   // Agrupar por 							 |
	//³ MV_PAR10		   // Número máximo de interações 			 |	
	//³ MV_PAR11		   // Exibe sub-equipes ?       			 |		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
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
±±³Fun‡…o    ³ReportDef ³ Autor ³Vendas CRM          ³ Data ³20/07/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina que define os itens que serao apresentados no relato-³±±
±±³          ³rio.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef()                                                ³±±
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
Local oReport 				//Objeto relatorio TReport (Release 4)
Local oSection1             //Objeto secao 1 do relatorio (Cabecalho, campos das tabelas SU2 e SB1)
Local oSection2             //Objeto secao 2 do relatorio (Itens, campos da tabela SU2)
Local oSection3             //Objeto secao 2 do relatorio (Analitico)
Local cAlias1 := "ADE"     //Alias da consulta Embedded SQL
Local oBreak

#IFDEF TOP
	cAlias1	:= GetNextAlias()						// Pega o proximo Alias Disponivel
#ENDIF

// "Chamados x Interações" # 
// "Este programa irá emitir uma relação de chamados que não foram solucionados até o número máximo de interações com o cliente."
DEFINE REPORT oReport NAME "TMKR501" TITLE STR0001 PARAMETER "TMKR501" ACTION {|oReport| Tkr501PrtRpt( oReport, cAlias1 )} DESCRIPTION STR0002 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, informando que o arquivo principal ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport 	TITLE STR0003 TABLES "ADE"  // "Grupo"
DEFINE SECTION oSection2 OF oSection1 	TITLE STR0004 TABLES "ADE" 	// "Chamados"
DEFINE SECTION oSection3 OF oReport 	TITLE STR0005 				// "Analise Sintética"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "ADE_GRUPO"	OF oSection1 ALIAS "ADE" TITLE STR0006 BLOCK {||TRIM((cAlias1)->ADE_GRUPO + " - " + POSICIONE('SU0',1,xFilial('SU0')+(cAlias1)->ADE_GRUPO,'U0_NOME'))} SIZE 40 //	 "Equipe"	
DEFINE CELL NAME "ADE_OPERAD"	OF oSection1 ALIAS "ADE" TITLE STR0007 BLOCK{||TRIM((cAlias1)->ADE_OPERAD + " - " + FATPDObfuscate(POSICIONE('SU7',1,XFILIAL('SU7') + (cAlias1)-> ADE_OPERAD,'U7_NOME'),"U7_NOME",,.T.))} SIZE 30	// "Analista"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "ADE_CODIGO"	OF oSection2 ALIAS "ADE" SIZE 10	
DEFINE CELL NAME "ADE_CHAVE"	OF oSection2 ALIAS "ADE" TITLE STR0008 // "Cliente" 
DEFINE CELL NAME "ADE_DESCCH"	OF oSection2 ALIAS "ADE" TITLE STR0009 	BLOCK {||FATPDObfuscate(TKENTIDADE((cAlias1)->ADE_ENTIDA,(cAlias1)->ADE_CHAVE,1),"ADE_DESCCH",,.T.)} SIZE 40 // "Descrição"
DEFINE CELL NAME "ADE_CODSB1"	OF oSection2 ALIAS "ADE"	
DEFINE CELL NAME "ADE_NMPROD"	OF oSection2 ALIAS "ADE" TITLE STR0010 	BLOCK{||POSICIONE('SB1',1,XFILIAL('SB1')+(cAlias1)->ADE_CODSB1,'B1_DESC')}  SIZE 30 // "Produto"		
DEFINE CELL NAME "ADE_DATA" 	OF oSection2 ALIAS "ADE"	      
DEFINE CELL NAME "ADE_DTEXP" 	OF oSection2 ALIAS "ADE"	      
DEFINE CELL NAME "ADE_GRUPO"	OF oSection2 ALIAS "ADE" TITLE STR0006 	BLOCK {||TRIM((cAlias1)->ADE_GRUPO + " - " + POSICIONE('SU0',1,xFilial('SU0')+(cAlias1)->ADE_GRUPO,'U0_NOME'))} SIZE 40 // "Equipe"		
DEFINE CELL NAME "ADE_OPERAD"	OF oSection2 ALIAS "ADE" TITLE STR0011 	BLOCK {||TRIM((cAlias1)->ADE_OPERAD + " - " + FATPDObfuscate(POSICIONE('SU7',1,XFILIAL('SU7') + (cAlias1)-> ADE_OPERAD,'U7_NOME'),"U7_NOME",,.T.))} SIZE 30		// "Analista"
DEFINE CELL NAME "COUNT"		OF oSection2 ALIAS ""	 TITLE STR0012 BLOCK{||(cAlias1)->NCOUNT}	SIZE 25		      // "Qtde de interações"

DEFINE BREAK oBreak OF oSection1 WHEN oSection2:Cell("ADE_CODIGO")
oBreak:SetTotalInLine(.T.)		// Imprime total em linha ou coluna (default .T. - linha )
oSection1:SetLineBreak()

DEFINE FUNCTION FROM oSection2:Cell("ADE_CODIGO") FUNCTION COUNT BREAK oBreak NO END SECTION NO END REPORT TITLE STR0013

DEFINE CELL NAME "TKCODSU0"		OF oSection3 ALIAS "" SIZE 20 TITLE STR0014 // "Código"
DEFINE CELL NAME "TKDESCSU0"	OF oSection3 ALIAS "" SIZE 30 TITLE STR0009 // "Descrição" 
DEFINE CELL NAME "TKDESCI1"		OF oSection3 ALIAS "" SIZE 10 TITLE STR0015 // "Qtd total de chamados" 
DEFINE CELL NAME "TKDESCI3"		OF oSection3 ALIAS "" SIZE 40 TITLE STR0016 // "Qtd chamados com mais de X interações" 
DEFINE CELL NAME "TKPERCENT"	OF oSection3 ALIAS "" SIZE 40 TITLE STR0017 // "(%) de chamados com mais de X interações" 

Return(oReport)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Tkr501PrtRpt ³ Autor ³Vendas CRM          ³ Data ³20/07/2008³±±
±±³          ³             ³       ³                    ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel pela impressao do relatorio              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tkr501PrtRept(ExpO1,ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = objeto relatorio                                   ³±±
±±³          ³ ExpC1 = alias da query atual                               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tkr501PrtRpt(oReport, cAlias1)
Local oSection1 := oReport:Section(1)		//Objeto secao 1 do relatorio (Cabecalho, campos das tabelas SU2 e SB1)
Local oSection2 := oSection1:Section(1)		//Objeto secao 2 do relatorio (Itens, campos da tabela SU2)
Local oSection3 := oReport:Section(2)		//Objeto secao 3 do relatorio (Sintetico)	
Local cFiltro	:= ""                      //String contendo o filtro de busca a ser utilizado com DBF
Local cAliasAux := GetNextAlias()			//Alias auxiliar para recuperar os itens do indicador 
Local cWhere	:= ""						//Condicoes utilizadas na listagem do indicador  
Local aTot		:= {0,0,0,0,0}     
Local cHaving	:= ""
Local cOrderBy	:= ""
Local cWhereESql:= ""						//Predicados utilizados na query Embedded SQL     
Local cHavingESql:= ""						//Predicados utilizados na query Embedded SQL     
Local aSintetic	:= {}
Local nPos		:= 0						//Indica a posicao do array encontrado
Local cEndSQL	:= "" 
Local cListSU0  := FormatIn( Tkr501SelGp(Mv_Par04, Mv_Par05), ",")
Local cListSU0E := "%" + cListSU0 + "%"

#IFDEF TOP 


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros do tipo Range em expressao SQL para ser utilizada na query ³
	//³Exemplo Word, nao intervalos pre definidos (mais utilizado pelo RH - Ferias)     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr("TMKR501")      
	
	//Monta a lista de Ocorrências x Acoes listadas no indicador
	cQuery := "SELECT 	UU_CODSU9,	UU_CODSUQ,	UU_CODSUT,	UU_FILIAL		" 
	cQuery += "FROM "+RetSqlName("SUU")+" SUU  WHERE "
	cQuery += "SUU.UU_FILIAL = '" + xFilial("SUU") + "' AND "
	cQuery += "SUU.UU_CODSUT = '" + MV_PAR03 + "' AND "
	cQuery += "SUU.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SUU.UU_CODSUT "	    
	
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TMKR001.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)	
	
	While (cAliasAux)->(!EOF()) .AND.;
		(cAliasAux)->UU_FILIAL == xFilial("SUU") .AND.;
		(cAliasAux)->UU_CODSUT	== MV_PAR03
		
		If !Empty(cWhere)
			cWhere += " OR ("		
		Else	                       
		   	cWhere += " ("
		EndIf        
	   	                                                        
	   	If !Empty((cAliasAux)->UU_CODSU9)
	   		cWhere += " ADF.ADF_CODSU9 = '" + (cAliasAux)->UU_CODSU9 + "' "
	   	EndIf
	   	If !Empty((cAliasAux)->UU_CODSU9) .AND. !Empty((cAliasAux)->UU_CODSUQ)
	   		cWhere += " AND ADF.ADF_CODSUQ = '" + (cAliasAux)->UU_CODSUQ + "') "
	   	ElseIf !Empty((cAliasAux)->UU_CODSUQ)
	   		cWhere += " ADF.ADF_CODSUQ = '" + (cAliasAux)->UU_CODSUQ + "') "
	   	Else          
	   		cWhere += ")"	   	
	   	EndIf	   		   	
		(cAliasAux)->(dbSkip())
	End         	                                       
	(cAliasAux)->(dbCloseArea())
	If !Empty(cWhere)
    	cWhere := "(" + cWhere + ")"	
 	Else
 		cWhere := "(1=1)"	
	EndIf 

	cQuery := "SELECT	COUNT(*) NCOUNT FROM ( "
	cQuery += "SELECT	ADE_CODIGO "
	cQuery += "FROM 	"+ RetSqlName("ADE") + " ADE, " + RetSQLName("ADF") + " ADF "		
	cQuery += "WHERE 	ADE_FILIAL	=	'" + xFilial("ADE") + "'	AND "
	cQuery += "ADF_FILIAL	=	'" + xFilial("ADF") + "'	AND				"
	cQuery += "ADE_CODIGO	=	ADF_CODIGO		AND "
	cQuery += "ADE_DATA	BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' AND "
	If Type("Mv_Par11") == "N" .AND. Mv_Par11 == 1
		cQuery += "ADE_GRUPO	IN " + cListSU0 + " AND "
	Else
		cQuery += "ADE_GRUPO	BETWEEN '" + Mv_Par04 + "' AND '" + Mv_Par05 + "' AND								"
	EndIf
	cQuery += "ADE_OPERAD	BETWEEN '" + Mv_Par06 + "' AND '" + Mv_Par07 + "' AND								"
	cQuery += "ADE.D_E_L_E_T_ = ' '   					AND "
	cQuery += "ADF.D_E_L_E_T_ = ' '					AND "
	cQuery += cWhere
	cQuery += " GROUP BY ADE.ADE_CODIGO			"
	cQuery += ") AUX"
	
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TMKR001.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)		
	If (cAliasAux)->(!EOF())
		aTot[1] := (cAliasAux)->NCOUNT
	EndIf
	(cAliasAux)->(dbCloseArea())
	
	cQuery := "SELECT	COUNT(*) NCOUNT FROM "
	cQuery += "( SELECT	ADE_CODIGO "
	cQuery += "FROM 	"+ RetSqlName("ADE") + " ADE, " + RetSQLName("ADF") + " ADF "		
	cQuery += "WHERE 	ADE_FILIAL	=	'" + xFilial("ADE") + "'	AND "
	cQuery += "ADF_FILIAL	=	'" + xFilial("ADF") + "'	AND				"
	cQuery += "ADE_CODIGO	=	ADF_CODIGO		AND "
	cQuery += "	(ADE.ADE_STATUS = '2' OR ADE.ADE_STATUS = '3')		AND "	
	cQuery += "ADE_DATA	BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' AND "
	If Type("Mv_Par11") == "N" .AND. Mv_Par11 == 1
		cQuery += "ADE_GRUPO	IN " + cListSU0 + " AND "
	Else
		cQuery += "ADE_GRUPO	BETWEEN '" + Mv_Par04 + "' AND '" + Mv_Par05 + "' AND								"
	EndIf
	cQuery += "ADE_OPERAD	BETWEEN '" + Mv_Par06 + "' AND '" + Mv_Par07 + "' AND								"
	cQuery += "ADE.D_E_L_E_T_ = ' '   					AND "
	cQuery += "ADF.D_E_L_E_T_ = ' '					AND "
	cQuery += cWhere                                
	cQuery +=" GROUP BY ADE.ADE_CODIGO			"
		
	cHaving := " HAVING COUNT(*) > " + AllTrim(Str(MV_PAR10))
	cQuery += cHaving + ") AUX"
		
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TMKR001.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)		
	If (cAliasAux)->(!EOF())
		aTot[2] := (cAliasAux)->NCOUNT
	EndIf	                     
	(cAliasAux)->(dbCloseArea())	
	
	If aTot[1] > 0
		aTot[3] := Int(aTot[2]/aTot[1]*100)
		aTot[4] := aTot[1]-aTot[2]
		aTot[5] := Int(aTot[4]/aTot[1]*100)
	EndIf
	
   	cWhereESql := "%(" + cWhere + ")"	
   	
	If Type("Mv_Par11") == "N" .AND. Mv_Par11 == 1
		cWhereESql += " AND ADE1.ADE_GRUPO	IN " + cListSU0 + "  "
	Else
		cWhereESql += " AND ADE1.ADE_GRUPO	BETWEEN '" + Mv_Par04 + "' AND '" + Mv_Par05 + "' 	"
	EndIf	  
	cWhereESql += "%" 	
   	
   	cHavingESql := "%" + cHaving + "%"
   	
   	
	If MV_PAR09 == 4 .OR. MV_PAR09 == 3                          
		cOrderBy := " ORDER BY ADE.ADE_GRUPO, ADE.ADE_OPERAD "		
	ElseIf MV_PAR09 == 2                                                                                   
		cOrderBy := " ORDER BY ADE.ADE_OPERAD "		
	Else
		cOrderBy := " ORDER BY ADE.ADE_CODIGO "				
	EndIf 
	  
	cEndSQL := "% " + AllTrim(Str(MV_PAR10)) + cOrderBy + " %"
	
	BEGIN REPORT QUERY oSection1
 	BeginSQL alias cAlias1                         
 	
		SELECT 	ADE.ADE_GRUPO,	ADE.ADE_CODIGO,	ADE.ADE_CHAVE,	ADE.ADE_DATA, 
				ADE.ADE_OPERAD,	ADE.ADE_FILIAL, ADE.ADE_ENTIDA,	ADE.ADE_CODSB1,
				AUX.NCOUNT NCOUNT
		FROM 	%table:ADE% ADE, (
			SELECT 	ADE1.ADE_CODIGO CODIGO,	COUNT(*) NCOUNT
			FROM 	%table:ADE% ADE1, %table:ADF% ADF		
			WHERE 	ADE1.ADE_FILIAL	=	%xFilial:ADE%	AND
					ADF_FILIAL	=	%xFilial:ADF%	AND				
					ADE1.ADE_CODIGO	=	ADF_CODIGO		AND
					(ADE1.ADE_STATUS = '2' OR ADE1.ADE_STATUS = '3')	AND
					ADE1.ADE_DATA	BETWEEN %exp:DtoS(Mv_Par01)% AND %exp:DtoS(Mv_Par02)% AND
					ADE1.ADE_OPERAD	BETWEEN %exp:Mv_Par06% AND %exp:Mv_Par07% AND								
					ADE1.%notDel%   					AND
					ADF.%notDel%					AND
					%exp:cWhereESql%
			GROUP BY ADE1.ADE_CODIGO			
		) AUX
		WHERE	ADE.ADE_CODIGO	=	AUX.CODIGO		AND
				ADE.ADE_FILIAL	=	%xFilial:ADE%	AND			 
				AUX.NCOUNT > %exp:cEndSQL%

    EndSql    
	END REPORT QUERY oSection1 	
	
	oSection2:SetParentQuery() 
	If MV_PAR09 == 4
		oSection2:SetParentFilter({|cParam|cParam == (cAlias1)->ADE_GRUPO+(cAlias1)->ADE_OPERAD},{|| (cAlias1)->ADE_GRUPO+(cAlias1)->ADE_OPERAD})
	ElseIf MV_PAR09 == 3
		oSection2:SetParentFilter({|cParam|cParam == (cAlias1)->ADE_GRUPO},{|| (cAlias1)->ADE_GRUPO})    
	ElseIf MV_PAR09 == 2                                                                                   
		oSection2:SetParentFilter({|cParam|cParam == (cAlias1)->ADE_OPERAD},{|| (cAlias1)->ADE_OPERAD})    
	EndIf	
                                  

#ELSE 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr("TMK007")       

	DbSelectArea("SU2")
	DbSetOrder(1)
	
	cFiltro	:= "U2_FILIAL = '"+ xFilial("SU2") +"' .AND. "
	cFiltro += "U2_COD >= '" + MV_PAR01 + "' .AND. U2_COD <= '" + MV_PAR02 + "'"
	
	oSection1:SetFilter( cFiltro ) 
	TRPosition():New( oSection1,"SB1",1,"xFilial('SB1') + SU2->U2_COD" )
	oSection2:SetParentFilter({|cParam|cParam == SU2->U2_COD},{|| SU2->U2_COD})	
	


#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebra a linha, caso existam muitas colunas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:SetLineBreak()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a impressao dos dados, de acordo com o filtro ou query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR08 == 1     
	If MV_PAR09 == 3
		oSection1:Cell("ADE_OPERAD"):Hide()
	ElseIf MV_PAR09 == 2
		oSection1:Cell("ADE_GRUPO"):Hide() 
	ElseIf MV_PAR09 == 1                   
		oSection1:Hide() 		
	EndIf
	oSection1:Print()
EndIf
                    
oReport:FatLine()                 
oReport:PrintText(" ")
oReport:PrintText(PadR(STR0018, 80) + PadL(AllTrim(Str(aTot[1])),10)) // "Qtde de chamados no período: "
oReport:PrintText(PadR(STR0019 + AllTrim(Str(MV_PAR10)) + STR0020, 80) + PadL(AllTrim(Str(aTot[2])),10)) // "Qtde de chamados com mais de " # " interações: "
oReport:PrintText(PadR(STR0021 + AllTrim(Str(MV_PAR10)) + STR0020, 80) + PadL(AllTrim(Str(aTot[3]))+"%",10)) // "Percentual de chamados com mais de " # " interações:"

#IFDEF TOP 
                                                           
	cQuery := "SELECT AUX.ADE_GRUPO, COUNT(*) NCOUNT FROM ( "
	cQuery += "SELECT	ADE_GRUPO, ADE_CODIGO "
	cQuery += "FROM 	"+ RetSqlName("ADE") + " ADE, " + RetSQLName("ADF") + " ADF "		
	cQuery += "WHERE 	ADE_FILIAL	=	'" + xFilial("ADE") + "'	AND "
	cQuery += "ADF_FILIAL	=	'" + xFilial("ADF") + "'	AND				"
	cQuery += "ADE_CODIGO	=	ADF_CODIGO		AND "
	cQuery += "ADE_DATA	BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' AND "

	If Type("Mv_Par11") == "N" .AND. Mv_Par11 == 1
		cQuery += "ADE_GRUPO	IN " + cListSU0 + " AND "
	Else
		cQuery += "ADE_GRUPO	BETWEEN '" + Mv_Par04 + "' AND '" + Mv_Par05 + "' AND								"
	EndIf

	cQuery += "ADE_OPERAD	BETWEEN '" + Mv_Par06 + "' AND '" + Mv_Par07 + "' AND								"
	cQuery += "ADE.D_E_L_E_T_ = ' '   					AND "
	cQuery += "ADF.D_E_L_E_T_ = ' '					AND "
	cQuery += cWhere
	cQuery +=" GROUP BY ADE_GRUPO, ADE_CODIGO	"
	cQuery +=") AUX GROUP BY ADE_GRUPO "	
      
	cQuery	:= ChangeQuery(cQuery) 
	// MemoWrite("TMKR001.SQL", cQuery)
	cAliasAux := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)		
	While (cAliasAux)->(!EOF())
		aAdd(aSintetic, {	(cAliasAux)->ADE_GRUPO,;	//Cod. Grupo
							(cAliasAux)->NCOUNT,;		//Total
							0})							//Indicador 2

		DbSkip()
	End
	(cAliasAux)->(dbCloseArea())	

	cQuery := "SELECT AUX.ADE_GRUPO, COUNT(*) NCOUNT FROM ( "
	cQuery += "SELECT	ADE_GRUPO, ADE_CODIGO "
	cQuery += "FROM 	"+ RetSqlName("ADE") + " ADE, " + RetSQLName("ADF") + " ADF "		
	cQuery += "WHERE 	ADE_FILIAL	=	'" + xFilial("ADE") + "'	AND "
	cQuery += "ADF_FILIAL	=	'" + xFilial("ADF") + "'	AND				"
	cQuery += "ADE_CODIGO	=	ADF_CODIGO		AND "
	cQuery += "	(ADE.ADE_STATUS = '2' OR ADE.ADE_STATUS = '3')				AND "	
	cQuery += "ADE_DATA	BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' AND "

	If Type("Mv_Par11") == "N" .AND. Mv_Par11 == 1
		cQuery += "ADE_GRUPO	IN " + cListSU0 + " AND "
	Else
		cQuery += "ADE_GRUPO	BETWEEN '" + Mv_Par04 + "' AND '" + Mv_Par05 + "' AND								"
	EndIf

	cQuery += "ADE_OPERAD	BETWEEN '" + Mv_Par06 + "' AND '" + Mv_Par07 + "' AND								"
	cQuery += "ADE.D_E_L_E_T_ = ' '   					AND "
	cQuery += "ADF.D_E_L_E_T_ = ' '					AND "
	cQuery += cWhere                                
	cQuery +=" GROUP BY ADE_GRUPO,ADE.ADE_CODIGO			"
		
	cHaving := " HAVING COUNT(*) > " + AllTrim(Str(MV_PAR10))
	cQuery += cHaving + ") AUX"
	cQuery +=" GROUP BY ADE_GRUPO"		                       
	       
	cQuery	:= ChangeQuery(cQuery) 
	// MemoWrite("TMKR001.SQL", cQuery)
	cAliasAux := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)		
	While (cAliasAux)->(!EOF())
		nPos := aScan(aSintetic, {|x|x[1]==(cAliasAux)->ADE_GRUPO})
		If nPos <= 0
			aAdd(aSintetic, {	(cAliasAux)->ADE_GRUPO,;	//Cod. Grupo
								0,;							//Indicador 1
								(cAliasAux)->NCOUNT})		//Indicador 2
		Else
			aSintetic[nPos,3]	:= (cAliasAux)->NCOUNT      //Indicador 2
        EndIf
		DbSkip()
	End
	(cAliasAux)->(dbCloseArea())		       
	  
	oReport:SkipLine()                
	oReport:FatLine()                 
	oReport:PrintText(" ")	
	oReport:PrintText(" ")		
	oReport:PrintText(STR0022)	 // "Resultados por equipes"
	oReport:ThinLine()                 
	oSection3:Init()
	For nPos := 1 To Len(aSintetic)
		oSection3:Cell("TKCODSU0"):SetValue(AllTrim(aSintetic[nPos,1]))
		oSection3:Cell("TKDESCSU0"):SetValue(POSICIONE('SU0',1,xFilial('SU0')+aSintetic[nPos,1],'U0_NOME'))
		oSection3:Cell("TKDESCI1"):SetValue(AllTrim(Str(aSintetic[nPos,2])))
		//oSection3:Cell("TKDESCI2"):SetValue(AllTrim(Str(aSintetic[nPos,3])))		                                        
		oSection3:Cell("TKDESCI3"):SetValue(AllTrim(Str(aSintetic[nPos,3])))		                                        	
		
		If aSintetic[nPos,2]>0
			oSection3:Cell("TKPERCENT"):SetValue(AllTrim(Str(Int(aSintetic[nPos,3]/aSintetic[nPos,2]*100)))	)	
		Else		                                                                                        
			oSection3:Cell("TKPERCENT"):SetValue("0")
		EndIf
		oSection3:PrintLine()	
	Next nPos     
	oSection3:Finish()
	

#ENDIF


Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Tkr501SelGP  ³ Autor ³Vendas CRM          ³ Data ³12/03/2009³±±
±±³          ³             ³       ³                    ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Seleciona as equipes do Grupo Superior.                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tkr501SelGP(ExpC1,ExpC2)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Código da primeira equipe                          ³±±
±±³          ³ ExpC2 = Código da última equipe                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              
Function Tkr501SelGp(cCodSU0Ini, cCodSU0Fim)
Local aAreaSU0 	:= SU0->(GetArea()) 
Local cQuery 	:= ""   
Local cAliasAux := GetNextAlias()		// Alias auxiliar para recuperar os itens do indicador             
Local cList		:= ""					// Lista de Grupos de Atendimento
Local lExistSIX := .F.					// Indica se o indice foi criado na base

DbSelectArea("SIX")
DbSetOrder(1)
If DbSeek("SU03") .AND. "U0_GRPSUP" $ SIX->CHAVE
	lExistSIX := .T.
EndIf     

cQuery := "SELECT U0_CODIGO "
cQuery += "FROM 	"+ RetSqlName("SU0") + " SU0 "		
cQuery += "WHERE 	U0_FILIAL	=	'" + xFilial("SU0") + "'	AND "
cQuery += "U0_CODIGO BETWEEN '" + cCodSU0Ini + "' AND '" + cCodSU0Fim + "' "
cQuery += "ORDER BY U0_CODIGO"    

cQuery	:= ChangeQuery(cQuery) 
// MemoWrite("TMKR001.SQL", cQuery)
cAliasAux := GetNextAlias()
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)

While (cAliasAux)->(!EOF()) 
	
	cList += (cAliasAux)->U0_CODIGO + ","	
	If lExistSIX
		DbSelectArea("SU0")
		DbSetOrder(3) // U0_FILIAL+U0_GRPSUP
		If DbSeek( xFilial("SU0") + (cAliasAux)->U0_CODIGO)
			While SU0->(!EOF()) .AND.;
				SU0->U0_FILIAL == xFilial("SU0") .AND.;
				SU0->U0_GRPSUP == (cAliasAux)->U0_CODIGO
				
				cList += SU0->U0_CODIGO + ","
				SU0->(DbSkip())
			End
			
		EndIf             
	EndIf
	(cAliasAux)->(DbSkip())
End           

If !Empty(cList)
	cList := Left(cList, Len(cList)-1) // Tira a última virgula
Else
	cList := cCodSU0Ini + "," + cCodSU0Fim
EndIf

(cAliasAux)->(DbCloseArea())

RestArea(aAreaSU0)
Return cList

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