#include "PROTHEUS.Ch"
#include "ctbr542C.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³CTBR542   ºAutor  ³ Totvs              º Data ³  27/09/10   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Construcao Release 4                                       º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function U_Ctbr542C()

	//Valida��o de aviso/bloqueio do relat�rio em Release 12.1.2510 e superiores
	If TRepInUse()
		U_Ctbr541C()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³CTBR542R4 ºAutor  ³ Totvs              º Data ³  27/09/10   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Construcao Release 4                                       º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function U_Ctbr541C()
Local aArea := GetArea()
Local cPergunte := "CTR542"

Private NomeProg := FunName()

// Acesso somente pelo SIGACTB
If !AMIIn( 34 )
	Return
EndIf



If !Pergunte( cPergunte , .T. )
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  		³
//³ MV_PAR01				// Data referencia                		³
//³ MV_PAR02				// Configuracao de livros			    ³
//³ MV_PAR03				// Moeda?          			     	    ³
//³ MV_PAR04				// Usa Data referencia ou periodo De Ate*
//³ MV_PAR05				// Periodo De            				³
//³ MV_PAR06				// Periodo Ate     			     	    ³ 
//³ MV_PAR07				// Folha Inicial    			     	³
//³ MV_PAR08				// Imprime Arq. Termo Auxiliar?			³
//³ MV_PAR09				// Arq.Termo Auxiliar ?					³ 
//³ MV_PAR10				// Consid. % em relacao ao 1o nivel?    ³ 
//³ MV_PAR11				// Tipo de Saldo?                       ³ 
//³ MV_PAR12				// Titulo como nome da Visao?           ³ 
//³ MV_PAR13				// Mov. do Periodo?                     ³ 
//³ MV_PAR14				// Seleciona Filiais ?					³ 
//³ MV_PAR15				// Considera movimento ?         		³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// faz a validação do livro
If !VdSetOfBook( MV_PAR02 , .T. )
   Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()

If ValType( oReport ) == 'O'
	If !Empty( oReport:uParam )
		Pergunte( oReport:uParam , .F. )
	EndIf	
	
	oReport:PrintDialog()
EndIf

oReport := Nil

RestArea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³CTBR542R4 ºAutor  ³ Totvs              º Data ³  27/09/10   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Construcao Release 4                                       º±±
±±º          ³ Definicao das colunas do relatorio                         º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local cPerg			:= "CTR542"
Local cReport		:= "CTBR542"
Local cTitulo		:= STR0002				// "Analise Vertical e Horizontal"
Local cDesc			:= STR0016 + STR0017	// "Este programa ira imprimir o Demonstrativo de Resultado,"                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                            // "de acordo com os parâmetros informados pelo usuário. "
Local oReport
Local oDemRenda
Local oCabecSup
Local aOrdem 		:= {}
Local aTamVal		:= TamSX3( "CT2_VALOR" )
Local cDescMoeda    := ""
Local nLineSize     := 0 

Local aSetOfBook	:= CTBSetOf( MV_PAR02 )

cTitulo		:= If( !Empty( aSetOfBook[10] ), aSetOfBook[10], cTitulo )		// Titulo definido SetOfBook
If ValType( MV_PAR12 ) == "N" .And. MV_PAR12 == 1
	cTitulo := CTBNomeVis( aSetOfBook[5] )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New( 	cReport, cTitulo, cPerg,;
							{ |oReport| Pergunte( cPerg, .F. ), If( !Ct040Valid( MV_PAR02 ), oReport:CancelPrint(), ReportPrint( oReport ) ) },;
							cDesc )

oReport:SetLandScape( .F. )
oReport:ParamReadOnly()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                    


nLineSize := 75 + (aTamVal[1]*IIF(MV_PAR13 ==1,3,2)) //Tamanho da Linha do cabeçalho superior(Descrição da Conta + Valor Período 1 + Valor Período 2

//adiciona ordens do relatorio   

//Cabeçalho
oCabecSup  := TRSection():New( oReport, "CABECSUP", {"cArqTmp"},, .F., .F. )										// Seção do Cabecalho
TRCell():New( oCabecSup, "CBCS_TIT1","",Space(nLineSize),,nLineSize,,,,,,,,,,, )   								// Espaços			
TRCell():New( oCabecSup, "CBCS_TIT2" , "", STR0003,, 35,,,"CENTER",,"CENTER",,,,,,.T.)				            // "Análise Vertical"
TRCell():New( oCabecSup, "CBCS_TIT3" ,"",STR0004,,aTamVal[1]+11,,,"CENTER",,"CENTER",,,,,,.T.)	                // "Análise Horizontal" 
TRCell():New( oCabecSup, "CBCS_ESPACO", "",Space(100),,100,,,"RIGHT",,"RIGHT")									// Espaços para completar Linha

//Detalhes
oDemRenda  := TRSection():New( oReport, "DETALHES", {"cArqTmp"},, .F., .F. )        						// Seção de Detalhes
TRCell():New( oDemRenda, "CLN_CONTA"	,""," "	,,60,,)														// Descrição da Conta
TRCell():New( oDemRenda, "CLN_MOVPERIODO"	,"",,,aTamVal[1]+20,,,"RIGHT",,"RIGHT")							// Mov. no Período
TRCell():New( oDemRenda, "CLN_SALDOATU"	,"",,,aTamVal[1]+20,,,"RIGHT",,"RIGHT")								// Saldo Atual
TRCell():New( oDemRenda, "CLN_SALDOANT"	,"",,,aTamVal[1]+20,,,"RIGHT",,"RIGHT")								// Saldo Anterior
TRCell():New( oDemRenda, "CLN_ESPACO"	,"",Space(3),,5,,,"RIGHT",,"RIGHT")								// Espaços de Separação
TRCell():New( oDemRenda, "CLN_VERTATU" ,"","",,aTamVal[1]+20,,,"RIGHT",,"RIGHT")								// A. Vertical Período Atual 
TRCell():New( oDemRenda, "CLN_VERTANT" ,"","",,aTamVal[1]+20,,,"RIGHT",,"RIGHT")										// A. Vertical Período Anterior 
TRCell():New( oDemRenda, "CLN_HORIZABS","",STR0005,,aTamVal[1]+20,,,"RIGHT",,"RIGHT")						// A. Horizontal Absoluto
TRCell():New( oDemRenda, "CLN_HORIZREL", "",STR0007,,aTamVal[1]+20,,,"RIGHT",,"RIGHT")								// A. Horizontal Relativos 
TRCell():New( oDemRenda, "CLN_ESPACO2", "",Space(80),,80,,,"RIGHT",,"RIGHT")							// Espaços para completar Linha


oDemRenda:SetTotalInLine(.F.) 
oCabecSup:SetHeaderPage()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ReportPrint ºAutor ³ TOtvs             º Data ³  27/09/10   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Construcao Release 4                                       º±±
±±º          ³ Funcao de impressao do relatorio acionado pela execucao    º±±
±±º          ³ do botao <OK> da PrintDialog()                             º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDemRenda		:= oReport:Section( 2 ) 
Local aSetOfBook	:= CTBSetOf( MV_PAR02 )
Local aCtbMoeda		:= {}
Local cArqTmp
Local cPicture
Local aTotal 		:= {}
Local nTotal		:= 0
Local nTotMes		:= 0
Local nTotalSint	:= 0
Local nTotAtu		:= 0
Local nTotVisA		:= 0
Local nTotVisM		:= 0
Local aColunas		:= {}
Local nColuna
Local cTpValor		:= GetMV( "MV_TPVALOR" )
Local lImpTrmAux	:= MV_PAR08 == 1
Local cArqTrm		:= ""
Local cProcesso     := STR0002
Local aTamVal		:= TamSX3( "CT2_VALOR" )
Local cTitAux
Local aSelFil		:= {}
Local cMoedaDesc	:= mv_par03 
Local lCharSinal	:= .F.


Private dInicio
Private dFinal
Private dPeriodo0
Private cTitulo

If mv_par14 == 1 .And. Len( aSelFil ) <= 0  .And. !IsBlind()
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		Return .F.
	EndIf 
EndIf

If MV_PAR04 == 2 
	dInicio  	:= MV_PAR05
	dFinal		:= MV_PAR06
	dPeriodo0	:= CtbPeriodos( MV_PAR03, dInicio, dFinal, .F., .F. )[1][2]
	cTitAux		:= STR0012 + " " + DtoC( dInicio ) + " " + STR0011 + " " + DtoC( dFinal )
Else
	dInicio  	:= CtoD( "01/" + Subs( DtoC( MV_PAR01 ), 4 ) )
	dFinal		:= MV_PAR01
	dPeriodo0 	:= CtoD( Str( Day( LastDay( MV_PAR01 ) ), 2 ) + "/" + Subs( DtoC( MV_PAR01 ), 4 ) )
	cTitAux 	:= ""
EndIf	

aCtbMoeda := CtbMoeda( MV_PAR03, aSetOfBook[9] )
If Empty( aCtbMoeda[1] )
	Help( " ", 1, "NOMOEDA" )
	oReport:CancelPrint()
    Return .F.
EndIf

nDecimais 	:= DecimalCTB( aSetOfBook, MV_PAR03 )
cPicture 	:= aSetOfBook[4]
If !Empty( cPicture ) .And. Len( Trans( 0, cPicture ) ) > 15
	cPicture := ""
EndIf

oReport:SetTitle( oReport:Title() + "  " + cTitAux )
oReport:SetPageNumber(mv_par07) //mv_par07 - Pagina Inicial
 

oDemRenda:Cell("CLN_VERTATU" ):SetTitle(Dtoc(dFinal))
oDemRenda:Cell("CLN_VERTANT" ):SetTitle(Dtoc(dInicio))
oDemRenda:Cell("CLN_SALDOATU" ):SetTitle(Dtoc(dFinal))
oDemRenda:Cell("CLN_SALDOANT" ):SetTitle(Dtoc(dInicio))  
oDemRenda:Cell( "CLN_MOVPERIODO" ):Disable()

oDemRenda:Cell("CLN_CONTA"):SetBlock( { || Iif(cArqTmp->COLUNA<2,Iif(cArqTmp->TIPOCONTA="2",cArqTmp->DESCCTA,cArqTmp->DESCCTA),"") } )		


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter( {|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan( oMeter, oText, oDlg, @lEnd, @cArqTmp,;
				dInicio, dFinal, "", "", "", Repl( "Z", Len( CT1->CT1_CONTA ) ),;
				"", Repl( "Z", Len( CTT->CTT_CUSTO ) ), "", Repl( "Z", Len( CTD->CTD_ITEM ) ),;
				"", Repl( "Z", Len( CTH->CTH_CLVL ) ), MV_PAR03,;
				MV_PAR11, aSetOfBook, Space(2), Space(20), Repl( "Z", 20 ), Space(30),;
		  		,,,,.T.,Iif(mv_par04=2,mv_par05,mv_par01),,,,,,,,,,,,,,,,,"",,;
		   		"","",,,,,,,"",,aSelFil)},;
				STR0006, cProcesso ) //"Criando Arquivo Temporario..."

dbSelectArea( "cArqTmp" )
dbGoTop()

While cArqTmp->( !Eof() )
	Aadd( aColunas, RecNo() )

	If MV_PAR10 <= 2 .AND. cArqTmp->TIPOCONTA == "1"
		nTotal := aScan( aTotal, { |x| x[1] = cArqTmp->CONTA } )
		If nTotal = 0
			Aadd( aTotal, { cArqTmp->CONTA, 0, 0 } )
			nTotal := Len( aTotal )
		EndIf

		aTotal[nTotal][2]	+= cArqTmp->SALDOANT
		aTotal[nTotal][3]	+= cArqTmp->SALDOATU
	EndIf

	If cArqTmp->TOTVIS == "1"
		nTotVisM := cArqTmp->SALDOANT
		nTotVisA := cArqTmp->SALDOATU
	EndIf
	
	cArqTmp->( DbSkip() )
End

If Len( aTotal ) == 0
	aTotal := { { "", 0, 0 } }
EndIf


If MV_PAR13 == 1 
	oDemRenda:Cell( "CLN_MOVPERIODO" ):Enable()
	oDemRenda:Cell( "CLN_MOVPERIODO" ):SetTitle(STR0024)  // "Mov. no Período"
	oDemRenda:Cell( "CLN_MOVPERIODO" ):SetBlock( { || ValorCTB(cArqTmp->MOVIMENTO,,,aTamVal[1],nDecimais,.T.,cPicture, cArqTmp->NORMAL,cArqTmp->CONTA,,,cTpValor,,,.F.,,lCharSinal) } )
EndIf 

// Apresenta as colunas de saldo anterior e movimento do periodo
oDemRenda:Cell( "CLN_SALDOATU" ):SetBlock( { || ValorCTB(cArqTmp->SALDOATU,,,aTamVal[1],nDecimais,.T.,cPicture, cArqTmp->NORMAL,cArqTmp->CONTA,,,cTpValor,,,.F.,,lCharSinal) } )
oDemRenda:Cell( "CLN_SALDOANT" ):SetBlock( { || ValorCTB(cArqTmp->SALDOANT,,,aTamVal[1],nDecimais,.T.,cPicture, cArqTmp->NORMAL,cArqTmp->CONTA,,,cTpValor,,,.F.,,lCharSinal) } )

If MV_PAR10 < 3
	oDemRenda:Cell( "CLN_VERTATU" ):SetBlock( { || Transform((cArqTmp->(SALDOATU)  / nTotAtu) * 100, "@E 9999.99")  + " %" })
	oDemRenda:Cell( "CLN_VERTANT" ):SetBlock( { || Transform((cArqTmp->(SALDOANT) / nTotMes) * 100, "@E 9999.99") + " %" })
Else
	oDemRenda:Cell( "CLN_VERTATU" ):SetBlock( { || Transform((cArqTmp->(SALDOATU) / nTotVisA) * 100 , "@E 9999.99")  + " %" })
	oDemRenda:Cell( "CLN_VERTANT" ):SetBlock( { || Transform((cArqTmp->(SALDOANT) / nTotVisM) * 100  , "@E 9999.99") + " %"})
EndIf                                                                                                               

oDemRenda:Cell( "CLN_HORIZABS" ):SetBlock( { || ValorCTB(cArqTmp->(MOVIMENTO),,,aTamVal[1],nDecimais,.T.,cPicture, cArqTmp->NORMAL,cArqTmp->CONTA,,,cTpValor,,,.F.,,lCharSinal) } )
oDemRenda:Cell( "CLN_HORIZREL" ):SetBlock( { || Transform(cArqTmp->( MOVIMENTO / SALDOATU * 100 ), "@E 9999.99")  + " %"})

oDemRenda:Init()

For nColuna := 1 To Len( aColunas )
	cArqTmp->( MsGoto( aColunas[nColuna] ) )

	If cArqTmp->DESCCTA = "-"
		oReport:ThinLine()   	// horizontal
	Else
		nTotal := aScan( aTotal, { |x| x[1] = cArqTmp->SUPERIOR } )
		If MV_PAR10 == 1		//Se considerar o % na sintetica local                     
			If (nTotMes == 0 .AND. nTotAtu == 0) .AND. (Empty( cArqTmp->SUPERIOR ) .OR. cArqTmp->TIPOCONTA == "1") 
				nTotMes := cArqTmp->SALDOANT
				nTotAtu := cArqTmp->SALDOATU
			EndIf
		ElseIf MV_PAR10 == 2	//Se considerar o % do total em relacao a conta de nivel 1
			If nTotal > 0 
				If cArqTmp->TIPOCONTA == "2" 
					nTotMes := aTotal[nTotal][2]
					nTotAtu := aTotal[nTotal][3]
				Else 
					nTotMes := cArqTmp->SALDOANT
					nTotAtu := cArqTmp->SALDOATU				
				EndIf    	
					
			Else				
				nTotMes := cArqTmp->SALDOANT
				nTotAtu := cArqTmp->SALDOATU				
			EndIf					

		EndIf
		
		oDemRenda:PrintLine()	
	EndIf
Next


oDemRenda:Finish()
oReport:ThinLine()

If lImpTrmAux
	cArqTRM 	:= MV_PAR09
	aVariaveis	:= {}

    // Buscando os parâmetros do relatorio (a partir do SX1) para serem impressaos do Termo (arquivos *.TRM)
	SX1->( DbSeek( PadR( "CTR500" , Len( X1_GRUPO ) , ' ' ) + "01" ) )

	While SX1->X1_GRUPO == PadR( "CTR500" , Len( SX1->X1_GRUPO ) , ' ' )
		AADD( aVariaveis,{ Rtrim( Upper( SX1->X1_VAR01 ) ), &( SX1->X1_VAR01 ) } )
		SX1->( dbSkip() )
	End
	
	If !File( cArqTRM )
		aSavSet := __SetSets()
		cArqTRM := CFGX024( cArqTRM, STR0015 ) // "Responsáveis..."
		__SetSets( aSavSet )
		Set( 24, Set( 24 ), .T. )
	EndIf

	If cArqTRM # NIL
		ImpTerm2( cArqTRM, aVariaveis,,,, oReport )
	EndIf	 
EndIf


DbSelectArea( "cArqTmp" )
Set Filter To
dbCloseArea() 
If Select( "cArqTmp" ) == 0
	FErase( cArqTmp + GetDBExtension() )
	FErase( cArqTmp + OrdBagExt() )
EndIf	

dbselectArea( "CT2" )

Return
