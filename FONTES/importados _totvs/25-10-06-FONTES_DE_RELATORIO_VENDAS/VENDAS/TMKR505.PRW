#INCLUDE "TMKR505.CH"
#INCLUDE "REPORT.CH" 
#INCLUDE "PROTHEUS.CH"

Static dUltIter := dDataBase       //Indica a data da ultima interação com cliente
Static dDtAbert	:= dDataBase		//Indica a data de abertura ou que foi transferido
Static lTransf	:= .F.			//Indica se um chamado foi transferido

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMKR505  ³ Autor ³ Vendas CRM            ³ Data ³ 20/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Prazo de vida dos chamados                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMKR505(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function TMKR505()

Local oReport	//Objeto relatorio TReport (Release 4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("TMKR505",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ Mv_Par01           // De                                     ³
	//³ Mv_Par02           // Ate                                    ³
	//³ Mv_Par03           // Do Produto    		                 ³
	//³ Mv_Par04           // Até o Produto                          ³			
	//³ Mv_Par05           // Do Grupo                               ³		
	//³ Mv_Par06           // Ate o Grupo                            ³	
	//³ Mv_Par07           // Do Analista                            ³		
	//³ Mv_Par08           // Ate o Analista                         ³	
	//³ Mv_Par09           // Tipo de Relatorio                      ³		
	//³ MV_PAR10		   // Do Cliente     						 |	
	//³ MV_PAR11		   // Da Loja	     						 |	
	//³ MV_PAR12		   // Ate o Cliente   						 |	
	//³ MV_PAR13		   // Ate a Loja     						 | 
	//³ Mv_Par14           // Indicador para Transferencia           ³
	//³ MV_PAR15		   // Exibe sub-equipes ?       			 |						
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
±±³Fun‡…o    ³TKR502RptDef ³ Autor ³Vendas CRM          ³ Data ³20/07/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina que define os itens que serao apresentados no relato-³±±
±±³          ³rio.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tkr501RptDef()                                             ³±±
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
Local oSection3				//Objeto secao 3 do relatorio (Totalizador)
Local cAlias1 := "ADE"     //Alias da consulta Embedded SQL
Local oBreak
Local cTransfSQL := ""		// SQL para localizar chamados que foram transferidos

cAlias1	:= GetNextAlias()						// Pega o proximo Alias Disponivel

// "Prazo de Vida dos chamados" # // "Este relatório exibe a média do prazo decorrido dos chamados atendidos " #
// "no mês desde a sua abertura até a última interação."
DEFINE REPORT oReport NAME "TMKR505" TITLE STR0001 PARAMETER "TMKR505" ACTION {|oReport| Tkr505PrtRpt( oReport, cAlias1, @cTransfSQL )} DESCRIPTION STR0002 + STR0003

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, informando que o arquivo principal ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport 	TITLE STR0004 TABLES "ADE"		   		// "Equipes"
DEFINE SECTION oSection2 OF oSection1 	TITLE STR0005 TABLES "ADE" LINE BREAK	// "Chamados"
DEFINE SECTION oSection3 OF oReport 	TITLE STR0006 TABLES ""    				// "Totalizado Sintético"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "ADE_GRUPO"	OF oSection1 ALIAS "ADE" 
DEFINE CELL NAME "ADE_DESCGP"	OF oSection1 ALIAS "ADE" BLOCK {||POSICIONE('SU0',1,xFilial('SU0')+(cAlias1)->ADE_GRUPO,'U0_NOME')} SIZE 40

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
DEFINE CELL NAME "ADE_CODIGO"	OF oSection2 ALIAS "ADE" SIZE 10	
DEFINE CELL NAME "ADE_CHAVE"	OF oSection2 ALIAS "ADE" TITLE STR0007 
DEFINE CELL NAME "ADE_DESCCH"	OF oSection2 ALIAS "ADE" TITLE STR0008 BLOCK {||FATPDObfuscate(TKENTIDADE((cAlias1)->ADE_ENTIDA,(cAlias1)->ADE_CHAVE,1),"ADE_DESCCH",,.T.)} SIZE 40 // "Descrição"
DEFINE CELL NAME "ADE_NMPROD" 	OF oSection2 ALIAS "ADE" BLOCK {||POSICIONE('SB1',1,XFILIAL('SB1') +(cAlias1)->ADE_CODSB1, 'B1_DESC')}	 SIZE 30      
DEFINE CELL NAME "ADE_DATA" 	OF oSection2 ALIAS "ADE"	      
DEFINE CELL NAME "ADE_HORA" 	OF oSection2 ALIAS "ADE"
DEFINE CELL NAME "TKEQTRANSF"	OF oSection2 ALIAS "" 	 TITLE STR0009 	BLOCK {||TkUltIter(3, (cAlias1)->ADE_CODIGO, cTransfSQL, (cAlias1)->ADE_DATA)}  SIZE 50 // "Equipe que transferiu"
DEFINE CELL NAME "TKDTTRANSF"	OF oSection2 ALIAS "" 	 TITLE STR0010	BLOCK {||TkUltIter(4, (cAlias1)->ADE_CODIGO, cTransfSQL)}  SIZE 20 // "Dt transferência"
DEFINE CELL NAME "TKULTITER"	OF oSection2 ALIAS ""	 TITLE STR0011	BLOCK {||TkUltIter(1, (cAlias1)->ADE_CODIGO)}  SIZE 20 // "Dt ult interação"
DEFINE CELL NAME "TKPRZITER"	OF oSection2 ALIAS ""	 TITLE STR0012 	BLOCK {||TkUltIter(2, (cAlias1)->ADE_CODIGO)} 	SIZE 20 // "Prazo médio"
DEFINE CELL NAME "ADE_DTEXPI" 	OF oSection2 ALIAS "ADE" 
DEFINE CELL NAME "ADE_HREXPI" 	OF oSection2 ALIAS "ADE"
DEFINE CELL NAME "ADE_STATUS" 	OF oSection2 ALIAS "ADE" SIZE 20	      
DEFINE CELL NAME "ADE_FNC" 		OF oSection2 ALIAS "ADE" TITLE STR0013 // "Cod FNC"	      
DEFINE CELL NAME "ADE_OPERAD"	OF oSection2 ALIAS "ADE" TITLE STR0014	BLOCK{||TRIM((cAlias1)->ADE_OPERAD + " - " + FATPDObfuscate(POSICIONE('SU7',1,XFILIAL('SU7') + (cAlias1)-> ADE_OPERAD, 'U7_NOME'),"U7_NOME",,.T.))} SIZE 50	 // "Analista"
	
DEFINE CELL NAME "TKENTRESP" 	OF oSection2 ALIAS "" SIZE 40 Title STR0024 BLOCK {||TkEntidade((cAlias1)->ADE_ENTREP,(cAlias1)->ADE_CHVREP,1)} //"Entidade Resp."
DEFINE CELL NAME "TKCNTRESP" 	OF oSection2 ALIAS "" SIZE 30 Title STR0025 BLOCK {||FATPDObfuscate(Posicione("SU5",1,xFilial("SU5")+(cAlias1)->ADE_CODREP,"U5_CONTAT"),"U5_CONTAT",,.T.)} //"Contato Resp."
DEFINE CELL NAME "ADE_DDDREP" 	OF oSection2 ALIAS "ADE" 
DEFINE CELL NAME "ADE_TELREP" 	OF oSection2 ALIAS "ADE" 

DEFINE BREAK oBreak OF oSection1 WHEN oSection2:Cell("ADE_CODIGO")
oBreak:SetTotalInLine(.T.)		// Imprime total em linha ou coluna (default .T. - linha )
oReport:SetLandscape()

DEFINE FUNCTION FROM oSection2:Cell("ADE_CODIGO") FUNCTION COUNT BREAK oBreak NO END SECTION NO END REPORT TITLE "Total de Chamados "

DEFINE CELL NAME "TKTOTAREA" 	OF oSection3 ALIAS "" TITLE STR0015 SIZE 10	      	// "Equipe"
DEFINE CELL NAME "TKDESCSU0" 	OF oSection3 ALIAS "" TITLE STR0016 SIZE 30	      	// "Nome"
DEFINE CELL NAME "TKTOTAL" 		OF oSection3 ALIAS "" TITLE STR0017	SIZE 40			// "Qtde total de chamados"
DEFINE CELL NAME "TKSOLUCAO" 	OF oSection3 ALIAS "" TITLE STR0018	SIZE 40			// "Chamados solucionados(%)"
DEFINE CELL NAME "TKSOL24" 		OF oSection3 ALIAS "" TITLE STR0019	SIZE 50	      	// "Ch solucionados em ate 24h(%)"
DEFINE CELL NAME "TKSOL48" 		OF oSection3 ALIAS "" TITLE STR0020 SIZE 50			// "Ch solucionados em ate 48h(%)"
DEFINE CELL NAME "TKSOL72" 		OF oSection3 ALIAS "" TITLE STR0021 SIZE 50			// "Ch solucionados em ate 72h(%)"
DEFINE CELL NAME "TKSOLSUP"		OF oSection3 ALIAS "" TITLE STR0022	SIZE 50			// "Ch solucionados com mais de 72h(%)"

Return(oReport)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Tkr502PrtRpt ³ Autor ³Vendas CRM          ³ Data ³20/07/2008³±±
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
Static Function Tkr505PrtRpt(oReport, cAlias1, cTransfSQL)
Local oSection1 := oReport:Section(1)		//Objeto secao 1 do relatorio (Cabecalho, campos das tabelas SU2 e SB1)
Local oSection2 := oSection1:Section(1)		//Objeto secao 2 do relatorio (Itens, campos da tabela SU2)
Local oSection3 := oReport:Section(2)		//Objeto secao 1 do relatorio (Totalizador)
Local cFiltro	:= ""                      //String contendo o filtro de busca a ser utilizado com DBF
Local cAliasAux := GetNextAlias()			//Alias auxiliar para recuperar os itens do indicador 
Local aSintetic	:= {}     
Local cWhere	:= ""
Local cWhereSQL := ""						//Armazena a query SQL Ansi
Local nPos		:= 0
Local cQuery 	:= ""  
Local dDataAbertura := dDataBase
Local dDataUltIter	:= dDataBase
Local nI			:= 0
Local aSintetic2 	:= {}
Local nDiff			:= 0 
Local cListSU0  := FormatIn( Tkr501SelGp(Mv_Par05, Mv_Par06), ",")
Local cListSU0E := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros do tipo Range em expressao SQL para ser utilizada na query ³
//³Exemplo Word, nao intervalos pre definidos (mais utilizado pelo RH - Ferias)     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr("TMKR505")      
														
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a lista de Ocorrências x Acoes listadas no indicador                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
cQuery := "SELECT 	UU_CODSU9,	UU_CODSUQ,	UU_CODSUT,	UU_FILIAL		" 
cQuery += "FROM "+RetSqlName("SUU")+" SUU  WHERE "
cQuery += "SUU.UU_FILIAL = '" + xFilial("SUU") + "' AND "
cQuery += "SUU.UU_CODSUT = '" + MV_PAR14 + "' AND "
cQuery += "SUU.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY SUU.UU_CODSUT "	    

cQuery	:= ChangeQuery(cQuery)
// MemoWrite("TMKR001.SQL", cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)	

cTransfSQL := ""

While (cAliasAux)->(!EOF()) .AND.;
	(cAliasAux)->UU_FILIAL == xFilial("SUU") .AND.;
	(cAliasAux)->UU_CODSUT	== MV_PAR14
	
	If !Empty(cTransfSQL)
		cTransfSQL += " OR ("		
	Else	                       
		cTransfSQL += " ("
	EndIf        
															
	If !Empty((cAliasAux)->UU_CODSU9)
		cTransfSQL += " ADF.ADF_CODSU9 = '" + (cAliasAux)->UU_CODSU9 + "' "
	EndIf
	If !Empty((cAliasAux)->UU_CODSU9) .AND. !Empty((cAliasAux)->UU_CODSUQ)
		cTransfSQL += " AND ADF.ADF_CODSUQ = '" + (cAliasAux)->UU_CODSUQ + "') "
	ElseIf !Empty((cAliasAux)->UU_CODSUQ)
		cTransfSQL += " ADF.ADF_CODSUQ = '" + (cAliasAux)->UU_CODSUQ + "') "
	Else          
		cTransfSQL += ")"	   	
	EndIf	   		   	
	(cAliasAux)->(dbSkip())
End         	                                       
(cAliasAux)->(dbCloseArea())
If !Empty(cTransfSQL)
	cTransfSQL := "(" + cTransfSQL + ")"	
Else
	cTransfSQL := ""	
EndIf 


cWhere := ""

If !Empty(MV_PAR10) .OR. (!Empty(MV_PAR12) .AND. MV_PAR12 <> "ZZZZZZ")
	cWhere += "ADE_CHAVE BETWEEN '" + MV_PAR10+MV_PAR11 + "' AND '" + MV_PAR12+MV_PAR13 + "' AND "
	cWhere += "ADE_ENTIDA 	= 'SA1' AND "                    	     			
EndIf	                                                
cWhereSQL := cWhere
cWhere	:= "%" + cWhere + "%"	

If Type("Mv_Par15") == "N" .AND. Mv_Par15 == 1
	cListSU0E += "% ADE_GRUPO	IN " + cListSU0 + " AND %"
Else
	cListSU0E += "% ADE_GRUPO	BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND		%"
EndIf		

BEGIN REPORT QUERY oSection1
BeginSQL alias cAlias1                         
	SELECT *//ADE_CODIGO, ADE_DTEXPI, ADE_REGSLA, K5_DTEXPIR, K5_HREXPIR, K5_CHAVE
	FROM %table:ADE% ADE
	WHERE ADE.ADE_FILIAL = %xFilial:ADE% AND 			
		ADE.%notDel%   					AND			
		%exp:cWhere%			                						
		ADE_DATA	BETWEEN %exp:DtoS(Mv_Par01)% AND %exp:DtoS(Mv_Par02)% AND
		ADE_CODSB1	BETWEEN %exp:Mv_Par03% AND %exp:Mv_Par04% AND		
		%exp:cListSU0E%
		ADE_OPERAD	BETWEEN %exp:Mv_Par07% AND %exp:Mv_Par08% 									
	ORDER BY ADE_GRUPO, ADE_STATUS 				

EndSql    
END REPORT QUERY oSection1 

oSection2:SetParentQuery() 
oSection2:SetParentFilter({|cParam|cParam == (cAlias1)->ADE_GRUPO},{|| (cAlias1)->ADE_GRUPO})    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quebra a linha, caso existam muitas colunas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR09 == 1     
	//oSection1:SetLineBreak()
	oSection1:Print()       
EndIf

cQuery := ""
cQuery += "SELECT AUX.ADE_GRUPO, AUX.ADE_STATUS, AUX.ADE_DATA, MAX(AUX.DT_ULTIT) DT_ULTIT, COUNT(*) TOTAL FROM ("
cQuery += "SELECT	ADE_GRUPO, ADE_STATUS, ADE_DATA, MAX(ADF_DATA) DT_ULTIT "
cQuery += "FROM 	"+ RetSqlName("ADE") + " ADE, " + RetSQLName("ADF") + " ADF "		
cQuery += "WHERE 	ADE_FILIAL	=	'" + xFilial("ADE") + "'	AND "	
cQuery += "ADF_FILIAL	=	'" + xFilial("ADF") + "'	AND				"
cQuery += "ADE.ADE_CODIGO = ADF.ADF_CODIGO AND "	
cQuery += "ADE_DATA	BETWEEN '" + DtoS(Mv_Par01) + "' AND '" + DtoS(Mv_Par02) + "' AND "
cQuery += "ADE_CODSB1	BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND	"

If Type("Mv_Par15") == "N" .AND. Mv_Par15 == 1
	cQuery += " ADE_GRUPO	IN " + cListSU0 + " AND "
Else
	cQuery += " ADE_GRUPO	BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' AND		"
EndIf		

cQuery += "ADE_OPERAD	BETWEEN '" + Mv_Par07 + "' AND '" + Mv_Par08 + "' AND " 										
cQuery += cWhereSQL 	          
cQuery += "ADF.D_E_L_E_T_ = ' ' AND "	
cQuery += "ADE.D_E_L_E_T_ = ' '   "
cQuery += " GROUP BY ADE_GRUPO, ADE_STATUS, ADE_DATA, ADE_CODIGO"	
cQuery += ") AUX GROUP BY AUX.ADE_GRUPO, AUX.ADE_STATUS, AUX.ADE_DATA,AUX.DT_ULTIT"
		
cQuery	:= ChangeQuery(cQuery) 
// MemoWrite("TMKR001.SQL", cQuery)
cAliasAux := GetNextAlias()
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)		
If (cAliasAux)->(!EOF())
	While (cAliasAux)->(!EOF())
		nPos := aScan(aSintetic, {|x|	x[1]==(cAliasAux)->ADE_GRUPO  .AND.;
										x[2]==(cAliasAux)->ADE_STATUS .AND.; 
										x[3]==(cAliasAux)->ADE_DATA   .AND.; 											
										x[5]==(cAliasAux)->DT_ULTIT})
		If nPos <= 0
			aAdd(aSintetic, {	(cAliasAux)->ADE_GRUPO,;	//Cod. Grupo 				1
								(cAliasAux)->ADE_STATUS,;	//Status                    2
								(cAliasAux)->ADE_DATA,;		//DATA DE ABERTURA	        3
								0,;							//TOTAL DE CHAMADOS         4
								(cAliasAux)->DT_ULTIT})		//DATA DA ULTIMA ITERACAO   5

			nPos := Len(aSintetic)
		EndIf                    
		aSintetic[nPos,4] += (cAliasAux)->TOTAL
		DbSkip()
	End
EndIf  
(cAliasAux)->(dbCloseArea())  
		
For nI := 1 To Len(aSintetic)		                                               
	nPos := aScan(aSintetic2, {|x|	x[1]==aSintetic[nI,1]})
	If nPos <= 0
		aAdd(aSintetic2, {	aSintetic[nI,1],;	//Cod. Grupo    1
							0,;	//Total                         2
							0,;	//TOTAL SOLUCIONADOS            3
							0,;	//TOTAL SOLUCIONADOS 24HS       4 
							0,;	//TOTAL SOLUCIONADOS 48HS	    5							
							0,;	//TOTAL SOLUCIONADOS 72HS	    6															
							0})	//TOTAL SOLUCIONADOS MAIS 72HS  7
							
		nPos := Len(aSintetic2)

	EndIf                    
	aSintetic2[nPos, 2] += aSintetic[nI,4]		
	If aSintetic[nI,2] == "3"
		aSintetic2[nPos, 3] +=	aSintetic[nI,4]
		dDataAbertura 	:= CtoD(SubStr(aSintetic[nI,3],7,2) + "/" + SubStr(aSintetic[nI,3],5,2) + "/" + SubStr(aSintetic[nI,3],1,4))
		dDataUltIter	:= CtoD(SubStr(aSintetic[nI,5],7,2) + "/" + SubStr(aSintetic[nI,5],5,2) + "/" + SubStr(aSintetic[nI,5],1,4))
		nDiff			:= dDataUltIter - dDataAbertura 
		
		If nDiff <= 1
			aSintetic2[nPos, 4] +=	aSintetic[nI,4]
		ElseIf nDiff <= 2
			aSintetic2[nPos, 5] +=	aSintetic[nI,4]
		ElseIf nDiff <= 3
			aSintetic2[nPos, 6] +=	aSintetic[nI,4]
		Else
			aSintetic2[nPos, 7] +=	aSintetic[nI,4]
		EndIf			
	EndIf	
Next nI



oReport:SkipLine()                
oReport:FatLine()                 
oReport:PrintText(" ")	
oReport:PrintText(" ")		
oReport:PrintText(STR0023)	 // "Resultados por equipes"
oReport:ThinLine()                 
oSection3:Init()
For nPos := 1 To Len(aSintetic2)
	oSection3:Cell("TKTOTAREA"):SetValue(AllTrim(aSintetic2[nPos,1]))
	oSection3:Cell("TKDESCSU0"):SetValue(POSICIONE('SU0',1,xFilial('SU0')+aSintetic2[nPos,1],'U0_NOME'))		
	oSection3:Cell("TKTOTAL"):SetValue(AllTrim(Str(aSintetic2[nPos,2])))
	oSection3:Cell("TKSOLUCAO"):SetValue(AllTrim(Str(aSintetic2[nPos,3])))		
	oSection3:Cell("TKSOL24"):SetValue(AllTrim(Str(Int(aSintetic2[nPos,4]/aSintetic2[nPos,3]*100))))		                                        		
	oSection3:Cell("TKSOL48"):SetValue(AllTrim(Str(Int(aSintetic2[nPos,5]/aSintetic2[nPos,3]*100))))		                                        				
	oSection3:Cell("TKSOL72"):SetValue(AllTrim(Str(Int(aSintetic2[nPos,6]/aSintetic2[nPos,3]*100))))		                                        		
	oSection3:Cell("TKSOLSUP"):SetValue(AllTrim(Str(Int(aSintetic2[nPos,7]/aSintetic2[nPos,3]*100))))		                                        								
	oSection3:PrintLine()	
Next nPos     
oSection3:Finish()    	

Return(.T.)
           
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TkUltIter    ³ Autor ³Vendas CRM          ³ Data ³20/07/2008³±±
±±³          ³             ³       ³                    ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna informacoes para o relatorio.                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tkr501PrtRept(ExpO1,ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Tipo (1-Ultima Iteracao;2-Tempo sem it. em dias)   ³±±
±±³          ³ ExpC2 = Codigo do atenidmento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TkUltIter(nTipo, cCodigo, cTransfSQL, dDataAbertura)
Local cQuery := ""
Local cAliasAux	:= ""
Local cStr	:= ""        
Local nDiff   

Default cTransfSQL := ""
 

	If nTipo == 1
		dUltIter := dDataBase
		
		cQuery := "SELECT	MAX(ADF_DATA) ULT_ITER "
		cQuery += "FROM 	"+ RetSqlName("ADF") + " ADF "		
		cQuery += "WHERE    ADF_FILIAL	=	'" + xFilial("ADF") + "'	AND " 
		cQuery += "ADF_CODIGO	=	'" + cCodigo + "' AND "	
		cQuery += "ADF.D_E_L_E_T_ = ' '   "
		       
		cQuery	:= ChangeQuery(cQuery) 
		// MemoWrite("TMKR001.SQL", cQuery)
		cAliasAux := GetNextAlias()
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)		
		TCSetField(cAliasAux, "ULT_ITER"	, "D")
		If (cAliasAux)->(!Eof())
			dUltIter := (cAliasAux)->ULT_ITER			
			cStr := DtoC(dUltIter)//SubStr(dUltIter,7,2) + "/" + SubStr(dUltIter,5,2) + "/" + SubStr(dUltIter,1,4)//Transform(dUltIter, PESQPICT("ADE", "ADE_DATA"))
		EndIf                                          
		(cAliasAux)->(DbCloseArea())
	ElseIf nTipo == 2                	   	
		nDiff := dDataBase-dDtAbert
	    cStr := AllTrim(Str(nDiff))
	ElseIf nTipo == 3
		dDtAbert	:= dDataAbertura
		lTransf		:= .F.
		
		// Resgata a equipe que realizou a transferencia para a equipe atual
		If !Empty(cTransfSQL)
			cQuery := "SELECT	ADF_CODSU0, ADF_DATA "
			cQuery += "FROM 	"+ RetSqlName("ADF") + " ADF "		
			cQuery += "WHERE    ADF_FILIAL	=	'" + xFilial("ADF") + "'	AND " 
			cQuery += "ADF_CODIGO	=	'" + cCodigo + "' AND "	
			cQuery += cTransfSQL + " AND "
			cQuery += "ADF.D_E_L_E_T_ = ' '   "
			cQuery += " ORDER BY ADF_ITEM DESC"
			       
			cQuery	:= ChangeQuery(cQuery) 
			// MemoWrite("TMKR001.SQL", cQuery)
			cAliasAux := GetNextAlias()
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAux, .F., .T.)		
			If (cAliasAux)->(!Eof())
				cStr := (cAliasAux)->ADF_CODSU0
				cStr += " - " + POSICIONE('SU0',1,xFilial('SU0')+cStr,'U0_NOME')  
				dDtAbert 	:= CtoD(SubStr((cAliasAux)->ADF_DATA,7,2) + "/" + SubStr((cAliasAux)->ADF_DATA,5,2) + "/" + SubStr((cAliasAux)->ADF_DATA,1,4))
				lTransf		:= .T.
			EndIf                    
			(cAliasAux)->(DbCloseArea())
		EndIf
	ElseIf nTipo == 4
		If lTransf
	    	cStr := DtoC(dDtAbert)				
	 	Else
	 		cStr := " / / "				
	 	EndIf
	ElseIf nTipo == 5
		nDiff := dDataBase-dUltIter
	    cStr := AllTrim(Str(nDiff))	
	EndIf
Return cStr

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