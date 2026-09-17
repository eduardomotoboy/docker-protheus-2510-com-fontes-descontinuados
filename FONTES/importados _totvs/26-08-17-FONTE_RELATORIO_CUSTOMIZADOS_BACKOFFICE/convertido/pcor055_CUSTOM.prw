#INCLUDE "pcor055C.ch"
#INCLUDE "PROTHEUS.CH"

#DEFINE CELLTAMDATA 420
#DEFINE X_CLASSE 	aValorOrc[nX][2]
#DEFINE X_DESCLA 	aValorOrc[nX][3]
#DEFINE X_DESCRI 	aValorOrc[nX][4]
#DEFINE X_UM 		aValorOrc[nX][5]
#DEFINE X_OPER		aValorOrc[nX][6]
#DEFINE X_PICTURE 	aValorOrc[nX][7]
#DEFINE X_VALOR 	aValorOrc[nX][8]
#DEFINE TAM_VALOR 20


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCOR055  ºAutor  ³ Gustavo Henrique   º Data ³  26/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Chamada do relatorio de visao gerencial detalhada.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAPCO                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PCOR055C( lCallPrg, aPerg )

Local aArea		  := GetArea()
Local aAreaAKO    := {}
Local aAreaAK2TMP := {}
Local aAreaAK1TMP := {}
Local cPerg       := "PCRVIS"		// Nome do grupo de perguntas
Local lOk         := .T.
Local bPrintRel   := { || oReport := ReportDef( lCallPrg, cPerg ), oReport:PrintDialog() }

Default lCallPrg  := .F.          
Default aPerg	  := {}

	//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
	If lCallPrg

		aAreaAKO    := AKO->(    GetArea() )
		aAreaAK1TMP := TMPAK1->( GetArea() )
		aAreaAK2TMP := TMPAK2->( GetArea() )

		Eval( bPrintRel )

	Else	

		Pergunte( cPerg, .T. )
	
		dbSelectArea("AKN")
		dbSetOrder(1)
	
		lOk := !Empty(MV_PAR01) .And. dbSeek(xFilial("AKN")+MV_PAR01)
	
		If SuperGetMV("MV_PCO_AKN",.F.,"2")!="1"  		// 1-Verifica acesso por entidade
			lOk := .T.                        			// 2-Nao verifica o acesso por entidade
		Else
			lOk := ( PcoDirEnt_User("AKN", AKN->AKN_CODIGO, __cUserID, .F.) # 0 ) // 0=bloqueado
		    If ! lOk
				Aviso(STR0011,STR0012,{STR0013},2)//"Atenção"###"Usuario sem acesso a esta configuração de visao gerencial. "###"Fechar"
			EndIf
		EndIf    
	       
		If lOk   
		
			CursorWait()
			
			If Len(aPerg) == 0
				aEval(aPerg, {|x, y| &("MV_PAR"+StrZero(y,2)) := x})
			EndIf

			lPrintRel := .T.
			aPerVisao := { Str( MV_PAR02, 1 ), MV_PAR03, MV_PAR04 }
						
			PCO180EXE( "AKN", AKN->(Recno()), 2,,, aPerVisao, lPrintRel, bPrintRel )
			DelPCOA180()
		EndIf
	
	EndIf

RestArea( aArea )  

If lCallPrg
	RestArea( aAreaAKO    )
	RestArea( aAreaAK1TMP )
	RestArea( aAreaAK2TMP )
EndIf	

Return
             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Gustavo Henrique   º Data ³  26/05/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Indica se esta sendo chamado da rotina de consulta º±±
±±º          ³         da visao gerencial (PCOA180)                       º±±
±±º          ³ EXPC1 - Grupo de perguntas do relatorio                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orcamentario                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef( lCallPrg, cPerg )

Local cReport	:= "PCOR055" // Nome do relatorio
Local cTitulo	:= STR0001	 // Titulo do relatorio
Local cDescri	:= STR0014	 // Descricao do relatorio

Local oSection1        
Local oSection2
Local oSection3                              
 
Private oReport

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
oReport  := TReport():New( cReport, cTitulo, "PCR035", { |oReport| U_PCOR051C( oReport, lCallPrg ) }, cDescri ) // "Este relatorio apresentara todos os itens orcamentarios referente a execucao da visao gerencial."

Pergunte( "PCR035", .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio - Visao Orcamentaria Gerencial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New( oReport, STR0019 , {"TMPAK1"} )	// "Planilha"

TRCell():New( oSection1, "AK1_CODIGO", "TMPAK1", STR0002,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || TMPAK1->AK1_CODIGO } )	// Codigo
TRCell():New( oSection1, "AK1_DESCRI", "TMPAK1", STR0003,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || TMPAK1->AK1_DESCRI } )	// Descricao
TRCell():New( oSection1, "AK1_INIPER", "TMPAK1", STR0004,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || TMPAK1->AK1_INIPER } )	// Dt.Inicio
TRCell():New( oSection1, "AK1_FIMPER", "TMPAK1", STR0005,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || TMPAK1->AK1_FIMPER } )	// Dt.Fim

oSection1:SetHeaderPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 2a. secao do relatorio - Conta Orcamentaria Gerencial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New( oSection1, STR0020, {"AKO"} )	//  "Conta gerencial"
oSection2:SetNoFilter("AKO")

TRCell():New( oSection2, "AKO_CO"    , "AKO", STR0006,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// C.O.G.
TRCell():New( oSection2, "AKO_NIVEL" , "AKO", STR0007,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// Nivel
TRCell():New( oSection2, "AKO_DESCRI", "AKO", STR0003,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// Descricao
TRCell():New( oSection2, "AKO_CLASSE", "AKO", STR0008,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)	// Tipo
              
oSection2:SetHeaderSection(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 3a. secao do relatorio - Classe Orcamentaria referente a conta orcamentaria da planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New( oSection2, STR0021, {"TMPAK2","AK2"} )	// "Itens planilha"
oSection3:SetNoFilter("AK2")

TRCell():New( oSection3, "cClasse"  ,, STR0011,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// Classe
TRCell():New( oSection3, "cDesCla"  ,, STR0003,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/) 	// Descricao
TRCell():New( oSection3, "cDescri"  ,, STR0012,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)	// Identificador
TRCell():New( oSection3, "cUM"      ,, "UM"   ,/*Picture*/,15         ,/*lPixel*/,/*{|| code-block de impressao }*/)	// UM
TRCell():New( oSection3, "cOper"    ,, STR0013,/*Picture*/,15         ,/*lPixel*/,/*{|| code-block de impressao }*/)	// Operacao

oSection3:SetHeaderSection(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 4a. secao do relatorio - Valores por periodo do item da CO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4 := TRSection():New( oSection3, STR0022, {"TMPAK2"} )	// "Valores planilha"
//oSection4 := TRSection():New( oReport, STR0022, {"TMPAK2"} )	// "Valores planilha"

// Foram definidas 8 secoes pois eh o limite no formato do relatorio - landscape
TRCell():New( oSection4, "nValor1"  ,,STR0018+ " 1",/*Picture*/,TAM_VALOR/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")		// Valor
TRCell():New( oSection4, "nValor2"  ,,STR0018+ " 2",/*Picture*/,TAM_VALOR/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")		// Valor
TRCell():New( oSection4, "nValor3"  ,,STR0018+ " 3",/*Picture*/,TAM_VALOR/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")		// Valor
TRCell():New( oSection4, "nValor4"  ,,STR0018+ " 4",/*Picture*/,TAM_VALOR/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")		// Valor
TRCell():New( oSection4, "nValor5"  ,,STR0018+ " 5",/*Picture*/,TAM_VALOR/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")		// Valor
TRCell():New( oSection4, "nValor6"  ,,STR0018+ " 6",/*Picture*/,TAM_VALOR/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")		// Valor
TRCell():New( oSection4, "nValor7"  ,,STR0018+ " 7",/*Picture*/,TAM_VALOR/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")		// Valor
TRCell():New( oSection4, "nValor8"  ,,STR0018+ " 8",/*Picture*/,TAM_VALOR/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")		// Valor

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCOR030Imp ºAutor³ Gustavo Henrique   º Data ³ 25/05/06    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Query para impressao do relatorio de visao resumida        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPO1 - Objeto TReport do relatorio                        º±±
±±º          ³ EXPL1 - Indica se esta sendo chamado da rotina de consulta º±±
±±º          ³         da visao gerencial (PCOA180)                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orcamentario                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PCOR051C( oReport, lCallPrg )
         
Local aPeriodo 	:= {}
Local aNovPer	:= {}
Local nX

Local oVisao	:= oReport:Section(1)
Local oContaOG	:= oReport:Section(1):Section(1)
    
// Obtem os periodos
aPeriodo	:= PCO055CalcPer( TMPAK1->AK1_TPPERI ,TMPAK1->AK1_INIPER ,TMPAK1->AK1_FIMPER )	
aNovPer		:= {}   

For nX := 1 TO Len(aPeriodo)
	If DTOS(CTOD(PadR(aPeriodo[nX],10))) >= DTOS(mv_par01) .And. DTOS(CTOD(PadR(aPeriodo[nX],10))) <= DTOS(mv_par02)
		aAdd(aNovPer, aPeriodo[nX])
	EndIf
Next

aPeriodo := AClone(aNovPer)

If Empty(aNovPer)
	HELP("  ",1,"PCOR0151")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia impressao da 1a. e 2a. secao do relatório                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetLandScape()

oReport:OnPageBreak({|| If( oReport:Page() > 1, (	oVisao:PrintLine(),;
													oReport:SkipLine(),;
													oContaOG:PrintLine(),;
													oReport:SkipLine() ), .T. ) } )

oVisao:Init()

AKO->( dbSetOrder( 3 ) )
AKO->( MsSeek( xFilial() + PadR( TMPAK1->AK1_CODIGO, TamSX3("AKO_CODIGO")[1] ) + "001" ) )

Do While !oReport:Cancel() .And. AKO->( ! EoF() .And. AKO_FILIAL + AKO_CODIGO + AKO_NIVEL == ;
								xFilial() + PadR( TMPAK1->AK1_CODIGO, TamSX3("AKO_CODIGO")[1] ) + "001" ) 

	If oReport:Cancel()
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime cabecalho do relatorio e pula linha para inicio do relatorio   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oVisao:PrintLine()
	oReport:SkipLine()	

	PCOR055CoR4( AKO->AKO_CODIGO, AKO->AKO_CO, aNovPer, oReport)
         
	AKO->( dbSkip() )

EndDo

oVisao:Finish()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PCOR055CoR4 ³ Autor ³ Gustavo Henrique       ³ Data ³ 30/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de impressao da planilha orcamentaria do Centro         ³±±
±±³          ³orcamentario. Utiliza objeto TReport do Release 4              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PCOR055CoR4(cVisGer, cCO, aPeriodo, oReport )                  ³±±
±±³          ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cVisGer    - Orcamento                                        ³±±
±±³          ³ cCO        - Conta Orcamentaria                               ³±±
±±³          ³ aPeriodo   - Datas do periodo                                 ³±±
±±³          ³ oReport	  - Objeto TReport                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PCOR055CoR4(cVisGer, cCO, aPeriodo, oReport )
                
Local aArea	   		:= GetArea()
Local aAreaAKO		:= AKO->(GetArea())
Local aAreaTMPAK2	:= TMPAK2->(GetArea())
Local oContaOG		:= oReport:Section(1):Section(1)

oContaOG:Init()

If AKO->AKO_NIVEL =="001" .OR. ( AKO->AKO_CO >= mv_par03 .And. AKO->AKO_CO <= mv_par04 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime cabecalho e secao referente a conta orcamentaria gerencial     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oContaOG:PrintLine()
	PCOR055ItR4( cVisGer, cCO, aPeriodo, oReport )
EndIf

AKO->( dbSetOrder(2) )
AKO->( MsSeek( xFilial() + cVisGer + cCO ) )

Do While AKO->( !Eof() .And. AKO_FILIAL + AKO_CODIGO + AKO_COPAI == xFilial("AKO") + cVisGer + cCO )
	PCOR055CoR4( AKO->AKO_CODIGO, AKO->AKO_CO, aPeriodo, oReport )
	AKO->( dbSkip() )
EndDo

oContaOG:Finish()
	
RestArea(aAreaTMPAK2)
RestArea(aAreaAKO)
RestArea(aArea)
	
Return( NIL )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PCOR055ItR4 ³ Autor ³ Gustavo Henrique         ³ Data ³31/05/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de impressao dos itens da planilha orcamentaria por classe³±±
±±³          ³e conta gerencial definida na visao orcamentaria                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PCOR055ItR4( cVisGer,cCO,aPeriodo,oReport)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cVisGer    - Orcamento                                          ³±±
±±³          ³ cCO        - Conta Orcamentaria                                 ³±±
±±³          ³ aPeriodo   - Datas do periodo                                   ³±±
±±³          ³ oReport    - objeto TReport                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PCOR055ItR4( cVisGer, cCO, aPeriodo, oReport )

Local aArea			:= GetArea()
Local aAreaTMPAK2	:= TMPAK2->(GetArea())    
Local aAuxArea 		:= {}

Local cDescricao	:= ""
Local cUM 			:= ""  
Local nX 			:= 0
Local lTitle
Local cDesCla       := Space(Len(AK6->AK6_DESCRI))
Local aValorOrc     := {}
Local lVazio        := .T.
Local aAuxVlr
Local nPos
Local cPicture 		:= ""

aAuxVlr := {}
	
For nX := 1 To len(aPeriodo)
	
	dbSelectArea("TMPAK2")
	dbSetOrder(1)
	
	If MsSeek(xFilial("AK2")+PadR(cVisGer,Len(TMPAK2->AK2_ORCAME))+cCO+DTOS(aPeriodo[nX]))
        lTitle := .T.

		While TMPAK2->AK2_FILIAL+TMPAK2->AK2_ORCAME+TMPAK2->AK2_CO+DTOS(TMPAK2->AK2_PERIOD)== ;
				xFilial("AK2")+PadR(cVisGer,Len(TMPAK2->AK2_ORCAME))+cCO+DTOS(aPeriodo[nX])
		
		    If (TMPAK2->AK2_CLASSE >= mv_par05 .And. TMPAK2->AK2_CLASSE <= mv_par06) .And. ;
				(TMPAK2->AK2_OPER >= mv_par07 .And. TMPAK2->AK2_OPER <= mv_par08)		    
		    
				If !Empty(TMPAK2->AK2_CHAVE)
					aAuxArea := GetArea()
					AK6->(dbSetOrder(1))
					AK6->(dbSeek(xFilial()+TMPAK2->AK2_CLASSE))
					If !Empty(AK6->AK6_VISUAL)
						dbSelectArea(Substr(TMPAK2->AK2_CHAVE,1,3))
						dbSetOrder(Val(Substr(TMPAK2->AK2_CHAVE,4,2)))
						dbSeek(Substr(TMPAK2->AK2_CHAVE,6,Len(TMPAK2->AK2_CHAVE)))
						cDescricao := alltrim(&(AK6->AK6_VISUAL))						
						cUM := allTrim(&(AK6->AK6_UM))
					Else
						cDescricao:= ""
						cUM := ""    
					EndIf
					RestArea(aAuxArea)
					
				EndIf                 
				
				lVazio := .F.

				If (nPos:= Ascan(aAuxVlr, {|aVal|aVal[1]+aVal[2]== TMPAK2->AK2_ID+TMPAK2->AK2_CLASSE})) == 0
					dbSelectArea("AK6")
					dbSetOrder(1)
					dbSeek(xFilial()+TMPAK2->AK2_CLASSE)
					If AK6->AK6_FORMAT $ "1/3"
						cPicture := "@E 999999999999"
					Else
						cPicture := "@E 999,999,999,999"
					EndIf
					
					If AK6->AK6_DECIMA>0
						cPicture += "."+Replicate("9",AK6->AK6_DECIMA)
					EndIf
					cDescCla := AK6->AK6_DESCRI
                    dbSelectArea("AK2")
					aAdd(aAuxVlr, {TMPAK2->AK2_ID, TMPAK2->AK2_CLASSE, cDescCla,  cDescricao, cUM, TMPAK2->AK2_OPER, cPicture, ARRAY(Len(aPeriodo))})
					AFILL(aAuxVlr[Len(aAuxVlr)][8], 0 )
					aAuxVlr[Len(aAuxVlr)][8][nX] := TMPAK2->AK2_VALOR
				Else
					aAuxVlr[nPos][8][nX] += TMPAK2->AK2_VALOR
				EndIf	
	
			EndIf

			TMPAK2->(dbSkip())
			
		End

	EndIf

Next nX
	
If !lVazio
	aValorOrc := aClone(aAuxVlr)
    PCOR055DetR4(oReport, aValorOrc, aPeriodo)
EndIf

RestArea(aAreaTMPAK2)
RestArea(aArea)
	
Return( NIL ) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCOR055DetR4    ºAutor ³Gustavo Henrique º Data ³ 31/05/06 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao dos detalhes dos itens da planilha orcamentaria, º±±
±±º          ³ relacionada a visao gerencial selecionada.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orcamentario                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PCOR055DetR4( oReport, aValorOrc, aPeriodo )

Local nX,nY,nZ	:= 0
Local nCol		:= 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis das secoes do relatorio                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oClasse   := oReport:Section(1):Section(1):Section(1)
Local oValores  := oReport:Section(1):Section(1):Section(1):Section(1)

oReport:SetMeter( Len( aValorOrc ) )

oReport:SkipLine()
oClasse:Init()
      
For nX := 1 To Len( aValorOrc )
                                    
	oReport:IncMeter()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime secao com os dados da classe orcamentaria (item da planilha)   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oClasse:Cell( "cClasse" ):SetValue( X_CLASSE )
    oClasse:Cell( "cDesCla" ):SetValue( X_DESCLA )
    oClasse:Cell( "cDescri" ):SetValue( X_DESCRI )
    oClasse:Cell( "cUM"     ):SetValue( X_UM     )
    oClasse:Cell( "cOper"   ):SetValue( X_OPER   )

    oReport:SkipLine()
	oClasse:PrintLine()
	oReport:ThinLine()
	
    // Configurar colunas dos periodos no relatorio
	nCol 	:= 0
	nLenVal	:= Len( X_VALOR )
	nY := 1 // Periodo inicial

	Do While nY <= nLenVal
	
		oValores:Init()
                        
        // Inibe todas as colunas de impressao de valores nos periodos                   
		For nZ := 1 To 8

			oValores:Cell("nValor" + AllTrim(Str(nZ)) ):Hide()
			cValor := "nValor" + AllTrim( Str( nZ ) )
		    
			If nY <= nLenVal
				oValores:Cell(cValor):SetTitle(AllTrim( DToC( aPeriodo[nY] )))
				oValores:Cell(cValor):SetValue( Transform( X_VALOR[nY], X_PICTURE ) )
			Else
				oValores:Cell(cValor):SetTitle( "")
				oValores:Cell(cValor):SetValue( "" )
			EndIf
			oValores:Cell(cValor):Show()
			
		    nY ++
		    
        Next

		oValores:PrintLine()
		oValores:Finish()
		                           
	EndDo                           	
	
Next	

oClasse:Finish()

Return( NIL )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PCO055CalcPer ³ Autor ³ Reynaldo Tetsu Miyashita ³ Data ³21-01-2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula as datas do periodo de acordo com o tipo de periodo        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PCO055CalcPer( nTipo ,dIniPer ,dFimPer )                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nTipo - Tipo do periodo a ser calculado                           ³±±
±±³          ³ dIniPer - Data de inicio do periodo                               ³±±
±±³          ³ dFimPer - Data do fim do periodo                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION PCO055CalcPer( nTipo ,dIniPer ,dFimPer )
Local dX 		:= ctod("  / /  ")
Local dINI 		:= ctod("  / /  ")
Local aPeriodo 	:= {}

Do Case 
	// Semanal
	Case nTipo == "1"
		dIni := dIniPer
		If DOW(dIniPer)<>1
			dIni -= DOW(dIniPer)-1
		EndIf
	OtherWise
		dIni := CTOD("01/"+StrZero(MONTH(dIniPer),2,0)+"/"+StrZero(YEAR(dIniPer),4,0))
EndCase
dx := dIni
While dx < dFimPer
	aAdd( aPeriodo ,dX )
	Do Case  		
		// Semanal
		Case nTipo == "1"
			dx += 7
		// Quinzenal
		Case nTipo == "2"
			If DAY(dx) == 01
				dx	:= CTOD("15/"+StrZero(MONTH(dx),2,0)+"/"+StrZero(YEAR(dx),4,0))
			Else
				dx += 35
				dx	:= CTOD("01/"+StrZero(MONTH(dx),2,0)+"/"+StrZero(YEAR(dx),4,0))
			EndIf
		// Mensal
		Case nTipo == "3"
			dx += 35
			dx	:= CTOD("01/"+StrZero(MONTH(dx),2,0)+"/"+StrZero(YEAR(dx),4,0))
		// Bimestral
		Case nTipo == "4"
			dx += 62
			dx	:= CTOD("01/"+StrZero(MONTH(dx),2,0)+"/"+StrZero(YEAR(dx),4,0))
		// Semestral
		Case nTipo == "5"
			dx += 185
			dx	:= CTOD("01/"+StrZero(MONTH(dx),2,0)+"/"+StrZero(YEAR(dx),4,0))
		// Anual
		Case nTipo == "6"
			dx += 370
			dx	:= CTOD("01/"+StrZero(MONTH(dx),2,0)+"/"+StrZero(YEAR(dx),4,0))
	EndCase
End

Return( aPeriodo )


