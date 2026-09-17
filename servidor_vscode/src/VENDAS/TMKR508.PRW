#INCLUDE "REPORT.CH" 
#INCLUDE "TMKR508.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMKR508  ³ Autor ³ Vendas CRM            ³ Data ³ 30/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atendimentos por analista e equipe                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMKR501(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function TMKR508()

Local oReport	//Objeto relatorio TReport (Release 4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("TMKR508",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros	³
//³ Mv_PAR01	// De						³
//³ Mv_PAR02	// Ate						³
//³ Mv_PAR03	// Da Equipe				³
//³ Mv_PAR04	// Até a Equipe				³
//³ Mv_PAR05	// Do analista				³
//³ Mv_PAR06	// Até o analista			³
//³ Mv_PAR07	// Indicador        		³				
//³ Mv_PAR08	// Tipo de Relatorio		³  
//³ MV_PAR09	// Exibe sub-equipes ?   	|		
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
±±³Fun‡…o    ³ReportDef ³    Autor ³Vendas CRM          ³ Data ³30/08/2008³±±
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
Local oReport 				// Objeto relatorio TReport (Release 4)
Local oSection1             // Objeto secao 1 do relatorio (Cabecalho, campos das tabelas SU2 e SB1)
Local oSection2             // Objeto secao 2 do relatorio (Itens, campos da tabela SU2)
Local oSection4             // Objeto secao 4 do relatorio 
Local cAlias := "ADE"		// Alias da consulta Embedded SQL
Local oBreak				// Break para a seção 3

cAlias	:= GetNextAlias()						// Pega o proximo Alias Disponivel

DEFINE REPORT oReport NAME "TMKR508" TITLE STR0001 PARAMETER "TMKR508" ACTION {|oReport| Tkr508PrtRpt( oReport, cAlias )} DESCRIPTION STR0002 // "Atendimentos por analista e equipe" "Possibilitar a consulta e extração de relatório de produtividade analista/equipe por período"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, informando que o arquivo principal ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport TITLE STR0003 TABLES "ADE"		// "Chamados da área"
DEFINE SECTION oSection2 OF oSection1 TITLE STR0004 TABLES "ADE"	// "Chamados do analista"
DEFINE SECTION oSection3 OF oSection2 TITLE STR0005 TABLES "ADE"	// "Chamados por tipo de comunicação"
DEFINE SECTION oSection4 OF oSection2 TITLE STR0005 TABLES "ADE"	// "Atendimentos avulsos"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "ADE_GRUPO"	OF oSection1 ALIAS "ADE" BLOCK {||TRIM((cAlias)->ADE_GRUPO + " - " + POSICIONE('SU0',1,xFilial('SU0')+(cAlias)->ADE_GRUPO,'U0_NOME'))} SIZE 40

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "ADE_OPERAD"		OF oSection2 ALIAS "ADE"	TITLE STR0006	BLOCK {||TRIM((cAlias)->ADE_OPERAD + " - " + FATPDObfuscate(POSICIONE('SU7',1,XFILIAL('SU7') + (cAlias)->ADE_OPERAD, 'U7_NOME'),"U7_NOME",,.T.))} SIZE 30	// "Analista"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao3³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "TIPO"				OF oSection3 ALIAS ""		TITLE STR0007	SIZE 40		// "Tipo de comunicação"
DEFINE CELL NAME "ABERTO_PENDENTE"	OF oSection3 ALIAS "" 		TITLE STR0008	ALIGN RIGHT	// "Aberto/Pendente"
DEFINE CELL NAME "APRELATIVO"		OF oSection3 ALIAS "" 		TITLE STR0021	ALIGN RIGHT	// "Aberto/Pendente relativo ao total"
DEFINE CELL NAME "ENCERRADO"		OF oSection3 ALIAS ""		TITLE STR0009	ALIGN RIGHT	// "Encerrado"
DEFINE CELL NAME "ERELATIVO"		OF oSection3 ALIAS ""		TITLE STR0022	ALIGN RIGHT	// "Encerrado relativo ao total"
DEFINE CELL NAME "SUB_TOTAL"		OF oSection3 ALIAS ""		TITLE STR0010	ALIGN RIGHT	// "Sub-Total"
DEFINE CELL NAME "STRELATIVO"		OF oSection3 ALIAS ""		TITLE STR0020	ALIGN RIGHT	// "Relativo ao total"

DEFINE BREAK oBreak OF oSection3 WHEN oSection2:Cell("ADE_OPERAD")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sub totalizadores.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FUNCTION FROM oSection3:Cell("ABERTO_PENDENTE") FUNCTION SUM BREAK oBreak NO END REPORT NO END SECTION
DEFINE FUNCTION FROM oSection3:Cell("ENCERRADO") FUNCTION SUM BREAK oBreak NO END REPORT NO END SECTION
DEFINE FUNCTION FROM oSection3:Cell("SUB_TOTAL") FUNCTION SUM BREAK oBreak NO END REPORT NO END SECTION

Return(oReport)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Tkr508PrtRpt ³ Autor ³Vendas CRM          ³ Data ³30/08/2008³±±
±±³          ³             ³       ³                    ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel pela impressao do relatorio              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tkr508PrtRept(ExpO1,ExpC2)                                 ³±±
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
Static Function Tkr508PrtRpt(oReport, cAlias)
Local oSection1 	:= oReport:Section(1)				// Objeto secao 1 do relatorio
Local oSection2 	:= oSection1:Section(1)				// Objeto secao 2 do relatorio
Local oSection3 	:= oSection2:Section(1)				// Objeto secao 2 do relatorio
Local oSection4 	:= oSection1:Section(1)				// Objeto secao 4 do relatorio
Local cAliasAux1	:= GetNextAlias()					// Alias auxiliar para a contagem de dias úteis
Local cAliasAux2	:= GetNextAlias()					// Alias auxiliar para a contagem de feedbacks
Local cAliasAux3	:= GetNextAlias()					// Alias auxiliar para a contagem de feedbacks
Local cAliasAux4	:= GetNextAlias()					// Alias auxiliar para a contagem de feedbacks
Local lSintetico	:= IF(MV_PAR08 == 1, .T. , .F.)	// Se o relatório é analítico ou sintético
Local cSelect		:= ""                              	// Campos que serão selecionados por padrão
Local cGroupBy		:= ""								// Agrupamento dos campos
Local cWhereADE		:= ""								// Condições da tabela ADE
Local cWhereADF 	:= ""								// Condições da tabela ADF
Local cWhereP		:= ""								// Condições da tabela principal		
Local cWhereI1		:= ""								// Where para pegar os dados do indicador 1
Local aDiasUteis	:= {}								// Array com os dias úteis trabalhados por operador sendo, [n,1] = Código do operador e [n,2] = Dias trabalhados
Local aFeedbacks	:= {}								// Quantidade de atendimentos realizados por operador sendo, [n,1] = Código do operador e [n,2] = Quantidade de atendimentos
Local aChamComI		:= {}								// Chamados com o indicador selecionado
Local aChamados		:= {}								// Buffer de chamados para pegar o totalizador e imprimir
Local cGrupo		:= ""								// Grupo de análise
Local cOperador 	:= ""                               // Operador em análise
Local cTipoComu		:= ""								// Tipo de comunicação em análise
Local nNaoEncerrado	:= 0								// Quantidade de chamados em aberto/encerrado do operador
Local nEncerrado	:= 0								// Quantidade de chamados encerrados do operador
Local nFeedbacks	:= 0								// Quantidade de feedback do operador
Local nDiasUteis	:= 0								// Quantidade de dias úteis do operador
Local nTotAP		:= 0								// Total de chamados em aberto/encerrado do grupo
Local nTotE			:= 0								// Total de chamados encerrados do grupo
Local nTotAPGeral	:= 0								// Total de chamados em aberto/encerrado no total
Local nTotEGeral	:= 0								// Total de chamados encerrados no total
Local nPos			:= 0								// Variável temporária
Local nChamComI		:= 0								// Variável temporária com a quantidade de chamados com o indicador selecionado
Local nConta		:= 0								// Variável temporária
Local cListSU0  := FormatIn( Tkr501SelGp(Mv_Par03, Mv_Par04), ",")
Local cListSU0E := ""
Local Ix        := 0

MakeSqlExpr("TMKR508")	

If lSintetico
	cSelect		:= "% ADE_GRUPO, ADE_TIPO, ADE_STATUS %"
	cGroupBy	:= "% ADE_GRUPO, ADE_TIPO, ADE_STATUS %"
Else
	cSelect		:= "% ADE_GRUPO, ADE_OPERAD, ADE_TIPO, ADE_STATUS %"
	cGroupBy	:= "% ADE_GRUPO, ADE_OPERAD, ADE_TIPO, ADE_STATUS %"
EndIf
																			
cWhereADE += " ADE_FILIAL ='" + xFilial("ADE") + "' AND "
cWhereADE += " ADE_DATA >= '" + DToS(MV_PAR01) + "' AND ADE_DATA <= '" + DToS(MV_PAR02) + "' AND "

If Type("Mv_Par09") == "N" .AND. Mv_Par09 == 1
	cWhereADE += "ADE_GRUPO	IN " + cListSU0 + " AND "
Else
	cWhereADE += "ADE_GRUPO	BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND								"
EndIf	
	
cWhereADE += " ADE_OPERAD >= '" + MV_PAR05 + "' AND ADE_OPERAD <= '" + MV_PAR06 + "' AND "
cWhereADE += " ADE.D_E_L_E_T_ = ' ' "

cWhereADF += " ADF_FILIAL ='" + xFilial("ADF") + "' AND "	
cWhereADF += " ADF_DATA >= '" + DToS(MV_PAR01) + "' AND ADF_DATA <= '" + DToS(MV_PAR02) + "' AND "

If Type("Mv_Par09") == "N" .AND. Mv_Par09 == 1
	cWhereADF += "ADF_CODSU0	IN " + cListSU0 + " AND "
Else
	cWhereADF += "ADF_CODSU0	BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND								"
EndIf		

cWhereADF += " ADF_CODSU7 >= '" + MV_PAR05 + "' AND ADF_CODSU7 <= '" + MV_PAR06 + "' AND "
cWhereADF += " ADF.D_E_L_E_T_=' ' "	
				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query principal.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cWhereP := "% " + cWhereADE + " %"
BEGIN REPORT QUERY oSection1 
	BeginSQL alias cAlias
			SELECT	%exp:cSelect%, 
					COUNT(*) as NCOUNT        	           			      			
			FROM     %table:ADE% ADE
			WHERE  	%exp:cWhereP% AND
					ADE.%notDel% 	           							 			           
			GROUP BY %exp:cGroupBy%				
	EndSql    
END REPORT QUERY oSection1	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query da contagem de dias úteis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT ADF_DATA,ADF_CODSU7 FROM " + RetSqlName("ADF") + " ADF WHERE " + cWhereADF + " GROUP BY ADF_DATA, ADF_CODSU7 ORDER BY ADF_CODSU7"	

cQuery := ChangeQuery(cQuery)    	
//MemoWrite("TMKR508.SQL", cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux1, .F., .T.)		
aDiasUteis := {}
While (cAliasAux1)->(!EOF())
	cOperador := (cAliasAux1)->ADF_CODSU7
	aAdd( aDiasUteis, { (cAliasAux1)->ADF_CODSU7, 0 } )		
	Do While (cAliasAux1)->(!EOF()) .AND. (cAliasAux1)->ADF_CODSU7 == cOperador
		aDiasUteis[Len(aDiasUteis),2]++
		(cAliasAux1)->(DbSkip())
	End 				
End
(cAliasAux1)->(DbCloseArea())  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query da contagem de feedbacks.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT ADF_CODSU7, COUNT(*) AS FEEDBACKS FROM " + RetSqlName("ADF") + " ADF WHERE " + cWhereADF + " GROUP BY ADF_CODSU7"	

cQuery := ChangeQuery(cQuery)    	
//MemoWrite("TMKR508.SQL", cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux2, .F., .T.)		
aFeedbacks := {}
While (cAliasAux2)->(!EOF())
	aAdd( aFeedbacks, { (cAliasAux2)->ADF_CODSU7, (cAliasAux2)->FEEDBACKS, "N" } )		
	(cAliasAux2)->(DbSkip())
End
(cAliasAux2)->(DbCloseArea())	

If lSintetico
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a lista de Ocorrências x Acoes listadas no indicador 1	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	cQuery := ""
	cQuery := "SELECT 	UU_CODSU9,	UU_CODSUQ,	UU_CODSUT,	UU_FILIAL		" 
	cQuery += "FROM "+RetSqlName("SUU")+" SUU  WHERE "
	cQuery += "SUU.UU_FILIAL = '" + xFilial("SUU") + "' AND "
	cQuery += "SUU.UU_CODSUT = '" + MV_PAR07 + "' AND "
	cQuery += "SUU.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SUU.UU_CODSUT "	    
	
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TMKR001.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux3, .F., .T.)	
	
	While	(cAliasAux3)->(!EOF()) .AND.;     
			(cAliasAux3)->UU_FILIAL == xFilial("SUU") .AND.;
			(cAliasAux3)->UU_CODSUT	== MV_PAR07
		
		If !Empty(cWhereI1)
			cWhereI1 += " OR ("		
		Else	                       
			cWhereI1 += " ("
		EndIf        
																
		If !Empty((cAliasAux3)->UU_CODSU9)
			cWhereI1 += " ADF.ADF_CODSU9 = '" + (cAliasAux3)->UU_CODSU9 + "' "
		EndIf
		If !Empty((cAliasAux3)->UU_CODSU9) .AND. !Empty((cAliasAux3)->UU_CODSUQ)
			cWhereI1 += " AND ADF.ADF_CODSUQ = '" + (cAliasAux3)->UU_CODSUQ + "') "
		ElseIf !Empty((cAliasAux3)->UU_CODSUQ)
			cWhereI1 += " ADF.ADF_CODSUQ = '" + (cAliasAux3)->UU_CODSUQ + "') "
		Else          
			cWhereI1 += ")"	   	
		EndIf	   		   	
		(cAliasAux3)->(DbSkip())
	End         	                                       
	(cAliasAux3)->(DbCloseArea())
	
	If !Empty(cWhereI1)
		cWhereI1 := "(" + cWhereI1 + ")"	
	Else
		cWhereI1 := "(1=1)"	
	EndIf     	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query da contagem de chamados com o indicador ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "" 	                        
	cQuery += "SELECT	ADE_CODIGO, ADF_CODSU0 "
	cQuery += "FROM 	" + RetSqlName("ADE") + " ADE, " + RetSQLName("ADF") + " ADF "		
	cQuery += "WHERE 	ADE_FILIAL	=	'" + xFilial("ADE") + "'	AND "
	cQuery += "			ADF_FILIAL	=	'" + xFilial("ADF") + "'	AND				"
	cQuery += "			ADE_CODIGO	=	ADF_CODIGO		AND "
	cQuery += "			ADE_DATA	BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' AND "
	
	If Type("Mv_Par09") == "N" .AND. Mv_Par09 == 1
		cQuery += "ADF_CODSU0	IN " + cListSU0 + " AND "
	Else
		cQuery += "ADF_CODSU0	BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND								"
	EndIf	
	
	cQuery += "			ADF_CODSU7	BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND								"
	cQuery += "			ADE.D_E_L_E_T_ = ' '   					AND "
	cQuery += "			ADF.D_E_L_E_T_ = ' '					AND "
	cQuery += cWhereI1                                
	cQuery += " GROUP BY ADF_CODSU0, ADE.ADE_CODIGO "       
	//cQuery := "SELECT COUNT(*) COUNT FROM (" + cQuery + ") AUX "
	
	cQuery	:= ChangeQuery(cQuery)    	
	// MemoWrite("TMKR001.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux4, .F., .T.)		
	aChamComI := {}
	While (cAliasAux4)->(!EOF())
		If (nPos:=aScan(aChamComI, { |aChamado| aChamado[1] == (cAliasAux4)->ADF_CODSU0 })) == 0
			aAdd( aChamComI, { (cAliasAux4)->ADF_CODSU0, 1 } )
		Else
			aChamComI[nPos,2]++
		EndIf
		(cAliasAux4)->(DbSkip())
	End	
	(cAliasAux4)->(DbCloseArea())

EndIf

oSection2:SetParentQuery()	
oSection2:SetParentFilter({|cParam| (cAlias)->ADE_GRUPO == cParam},{|| (cAlias)->ADE_GRUPO })		
oSection3:SetParentQuery()	
oSection3:SetParentFilter({|cParam| (cAlias)->ADE_GRUPO + (cAlias)->ADE_OPERAD == cParam},{|| (cAlias)->ADE_GRUPO + (cAlias)->ADE_OPERAD })			

If lSintetico
	oSection2:Hide()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop geral.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
While (cAlias)->(!EOF())  
	
	If oReport:Cancel()
		Exit
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime cabeçalho do grupo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:Init()
	oSection1:PrintLine()
	oSection1:Finish()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Zero os contadores.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cGrupo		:= (cAlias)->ADE_GRUPO
	nTotAP		:= 0
	nTotE		:= 0		
	nChamComI	:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for sintético já inicia a seção 3.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSintetico
		oSection3:init()
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Loop por grupo e herda condições.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While	(cAlias)->(ADE_GRUPO) == cGrupo .And.;
			(cAlias)->(!EOF()) 
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se for sintético não faz o loop por analista, vai direto por comunicação.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSintetico		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inicia as variáveis que contam de status.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nNaoEncerrado	:= 0
			nEncerrado		:= 0
			cTipoComu		:= (cAlias)->ADE_TIPO
					
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Loop por comunicação e herda condições.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While	(cAlias)->(ADE_TIPO) == cTipoComu 		.And.;					
					(cAlias)->(ADE_GRUPO) == cGrupo		.And.;
					(cAlias)->(!EOF())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Faz contagem de status.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (cAlias)->ADE_STATUS == "1" .Or. (cAlias)->ADE_STATUS == "2"
					nNaoEncerrado+=(cAlias)->NCOUNT
				ElseIf (cAlias)->ADE_STATUS == "3"
					nEncerrado+=(cAlias)->NCOUNT
				EndIf
				(cAlias)->(DbSkip())
			End 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime comuncação e totalizadores.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
			aAdd( aChamados, {	IF(AllTrim(cTipoComu) == "", STR0011, AllTrim(cTipoComu + " - " + POSICIONE('SUL',1,XFILIAL('SUL') + cTipoComu, 'UL_DESC'))),; // "Sem comunicação"
								nNaoEncerrado,;
								nEncerrado } )									     
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa contadores de área.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotAP	+= nNaoEncerrado
			nTotE	+= nEncerrado				

		Else 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime cabeçalho do operador.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection2:Init()
			oSection2:PrintLine()
			oSection2:Finish()
			oSection3:Init()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Zera contadores por operador.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cOperador	:= (cAlias)->ADE_OPERAD
			nFeedbacks	:= 0
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Loop por operador e herda condições.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While	(cAlias)->(ADE_OPERAD) == cOperador	.And.;
					(cAlias)->(ADE_GRUPO) == cGrupo		.And.;
					(cAlias)->(!EOF()) 
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Inicia as variáveis que contam de status.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nNaoEncerrado	:= 0
				nEncerrado		:= 0
				cTipoComu		:= (cAlias)->ADE_TIPO
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Loop por comunicação e herda condições.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				While	(cAlias)->(ADE_TIPO) == cTipoComu 		.And.;
						(cAlias)->(ADE_OPERAD) == cOperador	.And.;
						(cAlias)->(ADE_GRUPO) == cGrupo		.And.;
						(cAlias)->(!EOF())
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Faz contagem de status.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAlias)->ADE_STATUS == "1" .Or. (cAlias)->ADE_STATUS == "2"
						nNaoEncerrado+=(cAlias)->NCOUNT
					ElseIf (cAlias)->ADE_STATUS == "3"
						nEncerrado+=(cAlias)->NCOUNT
					EndIf
					(cAlias)->(DbSkip())
				End      
						
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Imprime comuncação e totalizadores.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aAdd( aChamados, {	IF(AllTrim(cTipoComu) == "", STR0011, AllTrim(cTipoComu + " - " + POSICIONE('SUL',1,XFILIAL('SUL') + cTipoComu, 'UL_DESC'))),; // "Sem comunicação"
									nNaoEncerrado,;
									nEncerrado } )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Incrementa contadores de área.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nTotAP	+= nNaoEncerrado
				nTotE	+= nEncerrado
	
			End
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz a totalização de todos os tipos de comunicação.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotOAP := 0
			nTotOE	:= 0				
			For nConta := 1 To Len(aChamados)
				nTotOAP += aChamados[nConta, 2]
				nTotOE	+= aChamados[nConta, 3]
			Next
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime comunicação.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nConta := 1 To Len(aChamados)
				oSection3:Cell("TIPO"):SetValue(aChamados[nConta][1])
				oSection3:Cell("ABERTO_PENDENTE"):SetValue(Alltrim(Str(aChamados[nConta][2])))
				oSection3:Cell("APRELATIVO"):SetValue(Transform( (100 * aChamados[nConta][2]) / nTotOAP  , "@E 999.99%" ) )
				oSection3:Cell("ENCERRADO"):SetValue(Alltrim(Str(aChamados[nConta][3])))
				oSection3:Cell("ERELATIVO"):SetValue(Transform( (100 * aChamados[nConta][3]) / nTotOE , "@E 999.99%" ) )
				oSection3:Cell("SUB_TOTAL"):SetValue(Alltrim(Str(aChamados[nConta][2]+aChamados[nConta][3])))
				oSection3:Cell("STRELATIVO"):SetValue(Transform( (100* (aChamados[nConta][2] + aChamados[nConta][3]) ) / (nTotOAP+nTOtOE) , "@E 999.99%" ) )					
				oSection3:PrintLine()					
			Next				
			aChamados := {}				

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pega o total de feedbacks do operador.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (nPos := aScan( aFeedbacks, { |aOperador| aOperador[1] == cOperador })) > 0
				nFeedbacks := aFeedbacks[nPos,2]
				aFeedbacks[nPos,3] := "S"
			End
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pega o total de feedbacks do operador.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (nPos := aScan( aDiasUteis, { |aOperador| aOperador[1] == cOperador })) > 0
				nDiasUteis := aDiasUteis[nPos,2]
			End			

			oSection3:Finish()								
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime totalizador por operador.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oReport:PrintText(" ")
			oReport:PrintText(STR0012 + Alltrim(Str(nDiasUteis)))	// "Total de dias úteis do analista: "
			oReport:PrintText(STR0013 + Alltrim(Str(nFeedbacks)) ) // "Total de atendimentos do analista: "
			oReport:PrintText(STR0014 + Alltrim(Str(Round((nFeedbacks)/nDiasUteis,2))))	// "Média de atendimentos do analista: "
			oReport:PrintText(STR0023 + TK510TAME(	Nil, 		Mv_Par01, 			Mv_Par02, 	cGrupo,; 
																			cGrupo, 	cOperador, 			cOperador) ) //"Tempo total de atendimento:      "

			oReport:PrintText(STR0024 + TK510TMA(	Nil, 		Mv_Par01, 			Mv_Par02, 	cGrupo,; 
																				cGrupo, 	cOperador, 			cOperador) ) //"Tempo Médio de Atendimento(TMA): "

		EndIf  
	End  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma no totalizador geral.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotAPGeral += nTotAP
	nTotEGeral	+= nTotE		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for sintético termina a seção 3, se não imprime o total.   ³
	//³Faz essa validação porque o total que é exibido quando não é  ³
	//³sintético, já é exibido naturalmente quando é sintético, então³
	//³não há a necessidade de imprimir os totais.                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSintetico
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz a totalização de todos os tipos de comunicação.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotOAP := 0
		nTotOE	:= 0				
		For nConta := 1 To Len(aChamados)
			nTotOAP += aChamados[nConta, 2]
			nTotOE	+= aChamados[nConta, 3]
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime comunicação.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nConta := 1 To Len(aChamados)
			oSection3:Cell("TIPO"):SetValue(aChamados[nConta][1])
			oSection3:Cell("ABERTO_PENDENTE"):SetValue(Alltrim(Str(aChamados[nConta][2])))
			oSection3:Cell("APRELATIVO"):SetValue(Transform( (100 * aChamados[nConta][2]) / nTotOAP  , "@E 999.99%" ) )
			oSection3:Cell("ENCERRADO"):SetValue(Alltrim(Str(aChamados[nConta][3])))
			oSection3:Cell("ERELATIVO"):SetValue(Transform( (100 * aChamados[nConta][3]) / nTotOE , "@E 999.99%" ) )
			oSection3:Cell("SUB_TOTAL"):SetValue(Alltrim(Str(aChamados[nConta][2]+aChamados[nConta][3])))
			oSection3:Cell("STRELATIVO"):SetValue(Transform( (100* (aChamados[nConta][2] + aChamados[nConta][3]) ) / (nTotOAP+nTOtOE) , "@E 999.99%" ) )					
			oSection3:PrintLine()					
		Next				
		aChamados := {}				
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pega o total de feedbacks do operador.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan( aChamComI, { |aGrupo| aGrupo[1] == cGrupo })) > 0
			nChamComI := aChamComI[nPos,2]
		End			
	
		oSection3:Finish()			
		oReport:PrintText(" ")
		oReport:PrintText(STR0019 + " '" + Alltrim(Posicione("SUT", 1, xFilial("SUT") + MV_PAR07, "UT_NOME")) + "': "+ Transform( (100 * nChamComI) / (nTotAP+nTotE), "@E 999.99%" )  )
	Else
		oReport:PrintText(" ")
		oReport:PrintText(STR0015 + Alltrim(Str(nTotAP)))	// "Total de chamados da área em aberto/pendente: "
		oReport:PrintText(STR0016 + Alltrim(Str(nTotE)))	// "Total de chamados da área encerrados: "
	EndIf 
	
	oReport:IncMeter()
	
	oReport:PrintText(" ")
	oReport:PrintText(STR0017 + Alltrim(Str(nTotAPGeral)))	// "Total de chamados em aberto/pendente: "
	oReport:PrintText(STR0018 + Alltrim(Str(nTotEGeral)))	// "Total de chamados encerrados: "		
	
End                   
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se há Atendimento Avulsos a serem impressos  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  		  	
For Ix:=1 to len(aFeedbacks)
	
	IF aFeedbacks[Ix,3] == "N"
	
			If oReport:Cancel()
			Exit
			EndIf	          		
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Zero os contadores.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotAP		:= 0
			nTotE		:= 0				
		
			If lSintetico
			oSection4:init()
			End

			aChamados := {}				

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pega o total de feedbacks do operador.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (nPos := aScan( aFeedbacks, { |aOperador| aOperador[1] == aFeedbacks[Ix,1] })) > 0 .and. aFeedbacks[Ix,3] == "N"
				nFeedbacks := aFeedbacks[nPos,2]
			End				
			
			If (nPos := aScan( aDiasUteis, { |aOperador| aOperador[1] == aFeedbacks[Ix,1] })) > 0 .and. aFeedbacks[Ix,3] == "N"
			nDiasUteis := aDiasUteis[nPos,2]
			End			

			oSection4:Finish()								
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime totalizador por operador.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if !lSintetico
			oReport:PrintText(" ")                      
			oReport:PrintText("ATENDIMENTOS AVULSOS ")     
			oReport:PrintText(" ")     
			oReport:PrintText("ANALISTA  : "+aFeedbacks[Ix,1] + " - " + FATPDObfuscate(POSICIONE('SU7',1,XFILIAL('SU7') + aFeedbacks[Ix,1], 'U7_NOME'),"U7_NOME",,.T.))     	           
			oSection4:PrintLine()
			oReport:PrintText(" ")   
			oReport:PrintText(STR0012 + Alltrim(Str(nDiasUteis)))   	// "Total de dias úteis do analista: "
			oReport:PrintText(STR0013 + Alltrim(Str(nFeedbacks)) )    // "Total de atendimentos do analista: "
			oReport:PrintText(STR0014 + Alltrim(Str(Round((nFeedbacks)/nDiasUteis,2))))	// "Média de atendimentos do analista: "
			oReport:PrintText(STR0023 + TK510TAME(	Nil, 		Mv_Par01, 			Mv_Par02, 	cGrupo,; 
																			cGrupo, 	cOperador, 			cOperador) ) //"Tempo total de atendimento:      "
			oReport:PrintText(STR0024 + TK510TMA(	Nil, 		Mv_Par01, 			Mv_Par02, 	cGrupo,; 
																				cGrupo, 	cOperador, 			cOperador) ) //"Tempo Médio de Atendimento(TMA): "		
			Endif																		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Soma no totalizador geral.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotAPGeral += nTotAP
			nTotEGeral	+= nTotE		
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz a totalização de todos os tipos de comunicação.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotOAP := 0
			nTotOE	:= 0				
			For nConta := 1 To Len(aChamados)
			nTotOAP += aChamados[nConta, 2]
			nTotOE	+= aChamados[nConta, 3]
			Next					
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pega o total de feedbacks do operador.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (nPos := aScan( aChamComI, { |aGrupo| aGrupo[1] == cGrupo })) > 0
			nChamComI := aChamComI[nPos,2]
			End			
	
			oSection3:Finish()			
			oReport:PrintText(" ")
			oReport:IncMeter()
	Endif

Next		

Return(.T.)

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
