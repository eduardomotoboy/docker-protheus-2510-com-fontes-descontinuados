#INCLUDE "TMKR036.CH"
#INCLUDE "PROTHEUS.CH"      
#INCLUDE "REPORT.CH"

/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ aScripts[X][1] - Codigo do Script                    ³
  ³ aScripts[X][2] - Array com as perguntas deste Scripts³
  ³ aScripts[X][3] - Array com as respostas deste Scripts³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³APERGUNTA                                                                ³
  ³1- UP_CODCAMP	-	Codigo do Script                                    ³
  ³2- UP_CARGO	    -	Codigo do Item                                      ³
  ³3- UP_IDTREE	    -	Cargo Pai deste Item. (em que ele esta amarrado)    ³
  ³4- UP_DESC		-   Descricao da resposta.                              ³
  ³5- UP_CODOBS	    -   Codigo da Observacao da pergunta                    ³
  ³6- UP_SCORE	    -   Pontuacao da resposta no cadastro de Scripts        ³
  ³7- UP_TIPOOBJ	-   Tipo da Resposta ('1','2' ou '3')                   ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ARESPOSTA                                                                ³
  ³1- UP_CODCAMP	-	Codigo do Script                                    ³
  ³2- UP_CARGO	    -	Codigo do Item                                      ³
  ³3- UP_IDTREE	    -	Cargo Pai deste Item. (em que ele esta amarrado)    ³
  ³4- UP_DESC		-   Descricao da resposta.                              ³
  ³5- UP_CODOBS	    -   Codigo da Observacao da resposta                    ³
  ³6- UP_SCORE	    -   Pontuacao da resposta no cadastro de Scripts        ³
  ³7- UP_TIPOOBJ	-   Tipo da Resposta ('1','2' ou '3')                   ³
  ³8- 0             -  	Pontuacao de cada resposta.                         ³
  ³9- Array         -  	Array com os textos referentes a resposta.          ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMKR036  ³ Autor ³ Rafael M. Quadrotti   ³ Data ³ 16/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Resultado de Scripts Dinâmicos.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Call Center - Gerencia de Campanhas                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo K.³75670   ³7.10  ³Correcao do SELECT para INFORMIX 	          ³±±
±±³Michel W. ³99206   ³8.11  ³Atualizacao relatorios release 4.	          ³±±
±±³Michel W. ³21/08/06³8.11  ³Revisao do fonte.                           ³±±
±±³Conrado Q.³22/02/07³9.12  ³-Bops 119542: Retirado função de ajuste de  ³±±
±±³          ³        ³      ³dicionário.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/  
Function TMKR036()
Local oReport	//Objeto relatorio TReport (Release 4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("TMK036",.F.)

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis utilizadas para parametros                          ³
	³ Mv_Par01           // Campanha                                ³
	³ Mv_Par02           // Do Script                               ³
	³ Mv_Par03           // Ate Script                              ³
	³ Mv_Par04           // Da data                                 ³
	³ Mv_Par05           // Ate a Data                              ³
/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()
oReport:PrintDialog() 

Return Nil            



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKR036VlScºAutor  ³Rafael M. Quadrotti º Data ³  06/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao dos scripts informados com relacao a campanha     º±±
±±º          ³definida no MV_PAR01                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TKR036VlSc(nScripts,aScripts,cScripts)
Local lRet 		:= .F.			//	Retorno da Funcao
Local aSArea	:= GetArea()	//	Grava o alias anterior

DbSelectArea("SUW")
DbSetOrder(1)
If MsSeek(xFilial("SUW")+AllTrim(Mv_Par01))
	While	(!Eof())							.AND.;
			(xFilial("SUW")==SUW->UW_FILIAL)	.AND.;
			(SUW->UW_CODCAMP ==	 Mv_Par01   )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Armazena todos os Scripts relacionados a campanha.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// aScripts[X][1] - Codigo do Script
		// aScripts[X][2] - Array com as perguntas deste Scripts
		// aScripts[X][3] - Array com as respostas deste Scripts
		Aadd(aScripts,{SUW->UW_CODSCRI,{},{}})
		SUW->(DbSkip())
	End
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Armazena os Scripts selecionados nos parametos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nScripts := 1 To Len(aScripts)
	If (aScripts[nScripts][1] >= MV_PAR02) .AND. (aScripts[nScripts][1] <= MV_PAR03)
		cScripts+= "'" + aScripts[nScripts][1]+ "',"
	Endif
Next nScripts

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para retirada da ', ' para a clausula IN do SQL.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cScripts := SubStr(cScripts,1, Len(cScripts)-1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se esta variavel estiver vazia os scripts definidos nos parametros        ³
//³estao incorretos. O sistema so permitira a impressao dos relatorios se os ³
//³scripts informados estiverem corretos.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cScripts)
	lRet := .F.
Else
	lRet := .T.	
EndIf

RestArea(aSArea)
Return (lRet)
                                   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ReportDef ³ Autor ³Michel W. Mosca     ³ Data ³01/08/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina que define os itens que serao apresentados no relato-³±±
±±³          ³rio de Resultado de Scripts Dinâmicos no release 4.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(ExpN1, ExpA2, ExpC3)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Numero de scripts da campanha selecionada           ³±±
±±³          ³ExpN2 = Array contendo dados dos scripts                    ³±±
±±³          ³ExpC3 = codigos dos scripts para consulta ao DB.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                       
Static Function ReportDef()
Local oReport			//Objeto relatorio TReport (Release 4)
Local oSection1 		//Objeto secao 1 do relatorio (Dados do script da campanha)
Local oSection2 		//Objeto secao 2 do relatorio (Perguntas associadas ao script)
Local oSection3 		//Objeto secao 3 do relatorio (Repostas as perguntas)
Local cACI := GetNextAlias() 	// Gerencia o alias entre top e dbf
Local cSUK := cACI 	// Gerencia o alias entre top e dbf
Local nScripts	:= 0	// Contador do For.
Local aScripts	:= {}	// Array com os scripts que estao definidos no item da Campanha selecionada.
Local cScripts	:= ""	// String com os codigos dos Scripts selecionados.


// "Resultado de Scripts Dinamicos" # // "Este programa ira emitir uma relacao dos Scripts dinamicos"
// "totalizando todas das respostas dadas de acordo com o" # // "periodo e Campanhas definidas. "
DEFINE REPORT oReport NAME "TMKR036" TITLE STR0001 PARAMETER "TMK036" ACTION {|oReport| Tkr036PrtRpt( oReport, @nScripts,@aScripts,@cScripts, cACI, cSUK)} DESCRIPTION STR0002 + STR0003 + STR0004


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, informando que o arquivo principal ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport TITLE STR0032  		//"Dados do script da campanha"
DEFINE SECTION oSection2 OF oSection1 TITLE STR0033 	//"Perguntas associadas ao script"
DEFINE SECTION oSection3 OF oSection2 TITLE STR0034 	//"Repostas as perguntas"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "S1_SCRIPT"	OF oSection1 TITLE STR0010 SIZE 70

DEFINE CELL NAME "S2_PERGUNT"	OF oSection2 TITLE STR0013 SIZE 70 LINE BREAK

DEFINE CELL NAME "S3_RESP"		OF oSection3 TITLE STR0014 SIZE 70 LINE BREAK
DEFINE CELL NAME "S3_SCORE"		OF oSection3 TITLE STR0011 SIZE 10
DEFINE CELL NAME "S3_TOT"		OF oSection3 TITLE STR0012 SIZE 10
DEFINE CELL NAME "S3_OBS"		OF oSection3 TITLE STR0031 SIZE 70 LINE BREAK 

Return(oReport)   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Tkr036PrtRpt ³ Autor ³Michel W. Mosca     ³ Data ³01/08/2007³±±
±±³          ³             ³       ³                    ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel pela impressao do relatorio de Resultados³±±
±±³          ³de Scripts Dinamicos  no release 4.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tkr036PrtRept(ExpO1,ExpN1,ExpN2,ExpC3,ExpC4,ExpC5)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = objeto relatorio                                   ³±±
±±³          ³ ExpN1 = Numero de scripts da campanha selecionada          ³±±
±±³          ³ ExpN2 = Array contendo dados dos scripts                   ³±±
±±³          ³ ExpC3 = codigos dos scripts para consulta ao DB.           ³±±
±±³          ³ ExpC4 = alias da query atual ACI                           ³±±
±±³          ³ ExpC5 = alias da query atual SUK                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tkr036PrtRpt(oReport, nScripts, aScripts, cScripts, cACI, cSUK)
Local oSection1 := oReport:Section(1) 		//Objeto secao 1 do relatorio (Dados do script da campanha)
Local oSection2 := oSection1:Section(1)		//Objeto secao 2 do relatorio (Perguntas associadas ao script)
Local oSection3 := oSection2:Section(1)    //Objeto secao 3 do relatorio (Repostas as perguntas)


Local cFiltro	:= ""   					//String contendo o filtro de busca a ser utilizado com DBF   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis especificas para este relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nI		   := 0			// Contador
Local aLinhas	   := {}		// Recebe as linhas do memo
Local dDatIniCamp  :=CtoD("//")	// Data Inicial da vigencia da Campanha
Local dDatFimCamp  :=CtoD("//")	// Data Final de vigencia da Campanha
Local aPergunta    := {}		// Array auxiliar para as perguntas
Local aResposta    := {}		// Array auxiliar para as Respostas
Local nPosResp	   := 0			// Retorno de AsCan
Local nPosScript   := 0			// Retorno do AsCan
Local aRespTemp    := {}		// Array temporario de respostas para utilizacao do contador.
Local lDado        := .F.		// Flag para identificar se existem dados para impressao.
Local cCodPerg     := ""		// Codigo da pergunta relacionada a resposta
Local nPosPerg     := 0			// Posicao da pergunta.
Local nW           := 0			// Controle de for para impressao de Memo.
Local nLenAux	   := 0 		// Contador auxilar para o FOR
Local cAuxObs					//Armazena o conteudo da resposta informada pelo usuário
Local cStringAux    := ""		//Var auxiliar para tirar aspas simples da string


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Laco para verificacao dos parametros digitados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !TKR036VlSc(@nScripts,@aScripts,@cScripts)
		Aviso(STR0029,STR0030,{"OK"}) //"Pergunte"###"Os Parâmetros de Scripts nao pertencem a campanha definida."
		oReport:PrintText(STR0035+STR0029+" "+STR0030+" "+STR0036) //"Falha: "    /"Verifique os parâmetros para a impressão do relatório."
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a Campanha foi preenchida para pesquisa dos Scripts que estao no itens. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !Empty(Mv_Par01)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Armazena as datas de vigencia da campanha para validacao do periodo para impressao.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SUO")
		DbSetOrder(1)
		If MsSeek(xFilial("SUO")+AllTrim(Mv_Par01))
			dDatIniCamp:= SUO-> UO_DTINI
			dDatFimCamp:= SUO-> UO_DTFIM
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validacao da data inical para selecao dos resultados.          ³
	//³As datas de inicio e fim devem respeitar as datas definidas na ³
	//³campanha.                                                      ³
	//³Se Data Inicial da Campanha  > que data do Parametro Dt Inicial³
	//³     Data Inicial valida = Data Inicial da Campanha            ³
	//³Senao                                                          ³
	//³     Data Inicial valida = Data do Parametro Dt Inicial        ³
	//³FimSe                                                          ³
	//³                                                               ³
	//³Se Data Final da Campanha  < que data do Parametro Dt Final    ³
	//³     Data Final valida = Data Final da Campanha                ³
	//³Senao                                                          ³
	//³     Data Final valida = Data do Parametro Dt Final            ³
	//³FimSe                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If (dDatIniCamp < MV_PAR04) .OR. Empty(dDatIniCamp)
		dDatIniCamp := MV_PAR04
	Endif
	
	If (dDatFimCamp > MV_PAR05)	.OR. Empty(dDatFimCamp)
		dDatFimCamp := MV_PAR05
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para cada Script serao armazenadas as Perguntas e Respostas³
	//³onde serao tambem totalizadas as respostas.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega as perguntas e repostas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SUP")
	DbSetOrder(1)               
	nLenAux := Len(aScripts)
	For nScripts := 1 To nLenAux
		
		If MsSeek(xFilial("SUP") + aScripts[nScripts][1])
			
			While (!Eof()) 							 		.AND.;
				 (xFilial("SUP") == SUP->UP_FILIAL) 		.AND.; 
				 (aScripts[nScripts,1] == SUP->UP_CODCAMP)
				
				If !Empty(SUP->UP_TIPOOBJ)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³APERGUNTA                                                                ³
					//³1- UP_CODCAMP	-	Codigo do Script                                    ³
					//³2- UP_CARGO	    -	Codigo do Item                                      ³
					//³3- UP_IDTREE	    -	Cargo Pai deste Item. (em que ele esta amarrado)    ³
					//³4- UP_DESC		-   Descricao da resposta.                              ³
					//³5- UP_CODOBS	    -   Codigo da Observacao da pergunta                    ³
					//³6- UP_SCORE	    -   Pontuacao da resposta no cadastro de Scripts        ³
					//³7- UP_TIPOOBJ	-   Tipo da Resposta ('1','2' ou '3')                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					Aadd(aPergunta,{UP_CODCAMP	,;	//	 Codigo do Script
									UP_CARGO	,;	//	 Cargo do Item.
									UP_IDTREE	,;	//	 Cargo Pai deste item. (em quem ele esta amarrado)
									UP_DESC		,;
									UP_CODOBS	,;
									UP_SCORE	,;
									UP_TIPOOBJ})      
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se o tipo de resposta for dissertativa nao ha uma referencia ³
					//³na base de dados para a resposta pois a informacao fica      ³
					//³armazenada na pergunta. Neste caso crio uma posicao          ³
					//³para resposta dissetativa para armazenamento das informacoes ³
					//³digitadas.                                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SUP->UP_TIPOOBJ == "3" 
						Aadd(aResposta,{	UP_CODCAMP	,; //	Codigo do Script
											"00000000"	,; //	Codigo do Item
											UP_CARGO	,; //	Cargo Pai deste Item. (em que ele esta amarrado) - utilizado o cargo da pergunta
											""			,;
											""			,;
											0			,; //	Score
											""			,;
											0			,; //	Pontuacao de cada resposta.
											{}			})
					Endif								
					
				Else
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ARESPOSTA                                                                ³
					//³1- UP_CODCAMP	-	Codigo do Script                                    ³
					//³2- UP_CARGO	    -	Codigo do Item                                      ³
					//³3- UP_IDTREE	    -	Cargo Pai deste Item. (em que ele esta amarrado)    ³
					//³4- UP_DESC		-   Descricao da resposta.                              ³
					//³5- UP_CODOBS	    -   Codigo da Observacao da resposta                    ³
					//³6- UP_SCORE	    -   Pontuacao da resposta no cadastro de Scripts        ³
					//³7- UP_TIPOOBJ	-   Tipo da Resposta ('1','2' ou '3')                   ³
					//³8- 0             -  	Pontuacao de cada resposta.                         ³
					//³9- Array         -  	Array com os textos referentes a resposta.          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					Aadd(aResposta,{	UP_CODCAMP	,; //	Codigo do Script
										UP_CARGO	,; //	Codigo do Item
										UP_IDTREE	,; //	Cargo Pai deste Item. (em que ele esta amarrado)
										UP_DESC		,;
										UP_CODOBS	,;
										UP_SCORE	,;
										UP_TIPOOBJ	,;
										0			,; //	Pontuacao de cada resposta.
										{}			})
				Endif
				
				DbSkip()
			End
			
		Endif
	
		aScripts[nScripts][2] := aPergunta
		aScripts[nScripts][3] := aResposta
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Limpa as informacoes para o proximo script.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aPergunta := {}
		aResposta := {}
		
	Next nScripts
		
	MakeSqlExpr("TMKR006")      
	
	cScriptsAux :=SubStr(cScripts,2, Len(cScripts)-2)

	BEGIN REPORT QUERY oSection1
	BeginSQL alias cACI                          	
			SELECT ACI_FILIAL,		ACI_CODCAM,		ACI_CODSCR,		ACI_CODSCR,
					ACI_DATA,			ACI_CODIGO,		UK_FILIAL,		UK_CODIGO,
					UK_CODPERG,		UK_CODRESP,		UK_CODMEMO		           
			FROM %table:ACI% ACI,	%table:SUK% SUK 

			WHERE	ACI.ACI_FILIAL = %xFilial:ACI% 		AND
					ACI.ACI_CODCAM = %exp:Mv_Par01%    	AND
					ACI.ACI_CODSCR IN(%exp:cScriptsAux%) 	AND
					ACI.ACI_DATA BETWEEN %exp:DtoS(dDatIniCamp)%	AND %exp:DtoS(dDatFimCamp)%		AND
					ACI.%notDel%						 AND
					SUK.UK_FILIAL = %xFilial:SUK% 		 AND
					SUK.UK_CODIGO = ACI.ACI_CODIGO 		 AND
					SUK.%notDel%				
			ORDER BY %order:ACI%
	EndSql    
	END REPORT QUERY oSection1      
	
	While	(!Eof())								.AND.;
			(cACI)->ACI_FILIAL == xFilial("ACI")	.AND.;
			(cACI)->ACI_CODCAM == Mv_Par01			.AND.;
			(cACI)->ACI_CODSCR >= Mv_PAR02			.AND.;
			(cACI)->ACI_CODSCR <= Mv_PAR03
		
	    oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifico a posico do Script que esta sendo trabalhado no ³
		//³array de Scripts que serao emitidos.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPosScript := Ascan(aScripts,{|aVal| aVal[1] = (cACI)->ACI_CODSCR})
		
		aRespTemp := aScripts[nPosScript][3]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa em todo o array de respostas (aResposta) a resposta gravada no SUK		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ARESPOSTA                                                                ³
		//³1- UP_CODCAMP	-	Codigo do Script                                    ³
		//³2- UP_CARGO	    -	Codigo do Item                                      ³
		//³3- UP_IDTREE	    -	Cargo Pai deste Item. (em que ele esta amarrado)    ³
		//³4- UP_DESC		-   Descricao da resposta.                              ³
		//³5- UP_CODOBS	    -   Codigo da Observacao da resposta                    ³
		//³6- UP_SCORE	    -   Pontuacao da resposta no cadastro de Scripts        ³
		//³7- UP_TIPOOBJ	-   Tipo da Resposta ('1','2' ou '3')                   ³
		//³8- 0             -  	Pontuacao de cada resposta.                         ³
		//³9- Array         -  	Array com os textos referentes a resposta.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCodPerg := (cSUK)->UK_CODPERG
		nPosResp := Ascan(aRespTemp,{|aVal| aVal[2] = (cSUK)->UK_CODRESP})
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso a resposta seja encontrada sera contabilizada.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPosResp > 0
			lDado := .T.
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o tipo de objeto da resposta eh memo.                       ³
			//³Para saber se esta resposta utiliza memo (respostas dissertativas)      ³
			//³sera verificada a pergunta a ela relacionada que contem esta informacao.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³APERGUNTA                                                                ³
			//³1- UP_CODCAMP	-	Codigo do Script                                    ³
			//³2- UP_CARGO	    -	Codigo do Item                                      ³
			//³3- UP_IDTREE	    -	Cargo Pai deste Item. (em que ele esta amarrado)    ³
			//³4- UP_DESC		-   Descricao da resposta.                              ³
			//³5- UP_CODOBS	    -   Codigo da Observacao da pergunta                    ³
			//³6- UP_SCORE	    -   Pontuacao da resposta no cadastro de Scripts        ³
			//³7- UP_TIPOOBJ	-   Tipo da Resposta ('1','2' ou '3')                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								
			nPosPerg := Ascan(aScripts[nPosScript][2],{|aVal| aVal[2] = cCodPerg})
			If aScripts[nPosScript][2][nPosPerg][7] <> '3' // Diferente de Memo 
				
				aScripts[nPosScript][3][nPosResp][8]+= 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Tratamento para impressao do memo de resposta aberta.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Alltrim(aScripts[nPosScript][3][nPosResp][4]) == STR0008 //"RESPOSTA ABERTA"
					Aadd(aScripts[nPosScript][3][nPosResp][9],(cSUK)->UK_CODMEMO)
				Endif
			
			Else
				nPosResp := Ascan(aRespTemp,{|aVal| aVal[3] = cCodPerg})
				If nPosResp > 0
					If (aScripts[nPosScript][3][nPosResp][3] = cCodPerg)
						Aadd(aScripts[nPosScript][3][nPosResp][9],(cSUK)->UK_CODMEMO)
					Endif	
				Endif	
			Endif
		
		Endif
		
		// Limpa variaveis auxiliares
		nPosResp := 0
		aRespTemp:= {}
	
		DbSelectArea(cACI)
		DbSkip()
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra a linha, caso existam muitas colunas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:SetLineBreak()
	oSection2:SetLineBreak()
		
	
	If lDado
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Impressao dos dados da campanha³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:FatLine()
		oReport:PrintText(STR0009 + MV_PAR01+ "-"+ Posicione("SUO",1,xFilial("SUO") + MV_PAR01,"UO_DESC"))		
		oReport:FatLine()		
		
		For nScripts := 1 To Len(aScripts)
					
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifico se o script faz parte dos scripts selecionados  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !( aScripts[nScripts][1] $ cScripts)
				Loop
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do Titulo do Script Dinamico                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//S1_SCRIPT	
			oSection1:Init()
			oSection1:Cell("S1_SCRIPT"):SetValue(aScripts[nScripts][1]+ "-"+ Posicione("SUZ",1,xFilial("SUZ") + aScripts[nScripts][1],"UZ_DESC"))
			oSection1:PrintLine()	
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Laco para impressao das perguntas.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// aScripts[x][1] - Codigo do Script
			// aScripts[x][2] - Array com as perguntas deste Scripts
			// aScripts[x][3] - Array com as respostas deste Scripts
		                                       
		
			For nPosPerg := 1 To Len(aScripts[nScripts][2]) // Perguntas
		
		//S2_PERGUNT
				oSection2:Init()
				oSection2:Cell("S2_PERGUNT"):SetValue(aScripts[nScripts][2][nPosPerg][4])
				oSection2:PrintLine()
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicio da impressao das respostas.                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Laco para impressao das respostas.                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSection3:Init()                
				For nPosResp:= 1 To Len(aScripts[nScripts][3])
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se a resposta for relacionada com a pergunta             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			 		
					If aScripts[nScripts][3][nPosResp][3] == aScripts[nScripts][2][nPosPerg][2]
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Se o tipo de dados for diferente de Memo                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If aScripts[nScripts][2][nPosPerg][7] <> '3' // Memo        
							
							oSection3:Cell("S3_RESP" ):Enable()
							oSection3:Cell("S3_SCORE"):Enable()
							oSection3:Cell("S3_TOT"  ):Enable()
							oSection3:Cell("S3_OBS"  ):Disable()
								
							oSection3:Cell("S3_RESP" ):SetValue(aScripts[nScripts][3][nPosResp][4])
							oSection3:Cell("S3_SCORE"):SetValue(Transform(aScripts[nScripts][3][nPosResp][6],"99999"))
							oSection3:Cell("S3_TOT"  ):SetValue(Transform(aScripts[nScripts][3][nPosResp][8],"99999"))							
							
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Se existirem dados para serem impressos sera executado um laco	 ³
							//³ para todos estes dados e a funcao TkMemo que retorna esta		 ³ 
							//³ informacao.												 		 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Len(aScripts[nScripts][3][nPosResp][9]) > 0								

								oSection3:Cell("S3_RESP" ):Disable()
								oSection3:Cell("S3_SCORE"):Disable()
								oSection3:Cell("S3_TOT"  ):Disable()					
								oSection3:Cell("S3_OBS"  ):Enable()
								
								cAuxObs := ""
								For nW := 1 To Len(aScripts[nScripts][3][nPosResp][9])
									aLinhas := TkMemo(aScripts[nScripts][3][nPosResp][9][nW],999)
									For nI := 1 to Len(aLinhas)
										cAuxObs += aLinhas[nI] + " " + CRLF
									Next nI
								Next nW

								oSection3:Cell("S3_OBS"):SetValue(cAuxObs)															

							EndIf
						Endif
						oSection3:PrintLine()	
					Endif
					
				Next nPosResp
				oSection3:Finish()					
				oSection2:Finish()		
			Next nPosPerg
			
			oSection1:Finish()		
		Next nScripts
	Else
		oReport:PrintText(STR0015)	//"Nao Existem dados a serem impressos para este relatorio com os parametros informados"
	EndIf	
EndIf

Return(.T.)