#INCLUDE "pcor060C.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE CELLTAMDATA (TOTAL->TOT_TAMCOL*7)

Static aPosCol := {}, aCabConteudo := {}, nUltCol := 0

Static _oPCOR0601
Static _oPCOR0602

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCOR060   ºAutor  ³ Gustavo Henrique   º Data ³  06/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Chamada do relatorio utilizando componente TReport         º±±
±±º          ³ disponivel no R4 ou o relatorio no formato ja existente    º±±
±±º          ³ no Release 3                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orcamentario                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function U_PCOR060C( lCallPrg, aPerg, lPerg)

Local oDlg
Local oListBox
Local aArea			:= GetArea()
Local aAreaAKO		:= {}
Local aAreaAK1TMP		:= {}
Local aAreaAK2TMP		:= {}
Local aPerVisao		:= {}
Local lOk				:= .T.           
Local oOk				:= LoadBitMap(GetResources(), "LBTIK")
Local oNo				:= LoadBitMap(GetResources(), "LBNO")
Local nDirAcesso 		:= 0   

Local bPrintRel

Private aTotList 		:= {}
Private aTotBlock 	:= {}

Default lCallPrg 		:= .F.    
Default lPerg	    	:= .F.
Default aPerg 		:= {}

	//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
	bPrintRel   	:= { || oReport := ReportDef( lCallPrg ), oReport:PrintDialog() }

	If lCallPrg

		aAreaAKO    := AKO->(    GetArea() )
		aAreaAK1TMP := TMPAK1->( GetArea() )
		aAreaAK2TMP := TMPAK2->( GetArea() )
		
	Else

		//quando chamado a partir do menu
		If Pergunte("PCRVIS", .T.)
	
			dbSelectArea("AKN")
			dbSetOrder(1)

			lOk := !Empty(MV_PAR01) .And. dbSeek(xFilial("AKN")+MV_PAR01)
			
			If SuperGetMV("MV_PCO_AKN",.F.,"2")!="1"  //1-Verifica acesso por entidade
				lOk := .T.                        // 2-Nao verifica o acesso por entidade
			Else
				nDirAcesso := PcoDirEnt_User("AKN", AKN->AKN_CODIGO, __cUserID, .F.)
			    If nDirAcesso == 0 //0=bloqueado
					Aviso(STR0018,STR0019,{STR0020},2)//"Atenção"###"Usuario sem acesso a esta configuração de visao gerencial. "###"Fechar"
					lOk := .F.
				Else
		    		lOk := .T.
				EndIf
			EndIf
			
			If lOk
				bPrintRel := { || U_PCOR060C(.T.,,.T.) }
				aPerVisao := {Str(MV_PAR02,1), MV_PAR03, MV_PAR04}
				PCO180EXE("AKN", AKN->(Recno()), 2,,, aPerVisao, .T., bPrintRel)
				DelPCOA180()
			EndIf

	    EndIf
	    
	    Return   //sempre retorna pois ja gerou o relatorio
	    
	EndIf

	If lOk 
	
		dbSelectArea("AKQ")
		dbSetOrder(1)
		dbSeek(xFilial("AKQ"))
		
		While ! Eof() .And. AKQ_FILIAL == xFilial("AKQ")
			aAdd(aTotList,{.F.,AKQ->AKQ_COD,AKQ->AKQ_DESCRI})
			aAdd(aTotBlock, { AKQ->(Recno()), AKQ->AKQ_BLOCK } ) 
		    dbSkip()
		End
		
		If Len(aTotList) > 0 
		
		If !IsBlind()	
				DEFINE MSDIALOG oDlg FROM 40,168 TO 380,730 TITLE STR0001 Of oMainWnd PIXEL  //"Escolha os Totais Visao Orcamentaria"
				
					@ 0,0 BITMAP oBmp RESNAME "PROJETOAP" Of oDlg SIZE 100,300 NOBORDER When .F. PIXEL
					oListBox := TWBrowse():New( 10,10,206,152,,{" OK ",STR0002,STR0003},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,) //"Codigo"###"Descricao"
					oListBox:SetArray(aTotList)
					oListBox:bLine := { || {If(aTotList[oListBox:nAt,1],oOk,oNo),aTotList[oListBox:nAT][2],aTotList[oListBox:nAT][3]}}
					oListBox:bLDblClick := { ||InverteSel(oListBox, oListBox:nAt, .T.)}
				
				   @ 10,230 BUTTON STR0004 	SIZE 45 ,10   FONT oDlg:oFont ACTION (lOk:=.T.,oDlg:End())  						OF oDlg PIXEL   //'Confirma >>'
				   @ 25,230 BUTTON STR0005 	SIZE 45 ,10   FONT oDlg:oFont ACTION (lOk:=.F.,oDlg:End())  						OF oDlg PIXEL   //'<< Cancela'
				   @ 40,230 BUTTON STR0006 	SIZE 45 ,10   FONT oDlg:oFont ACTION (MarcaTodos(oListBox, .F., .T.))  			OF oDlg PIXEL   //'Marcar Todos'
				   @ 55,230 BUTTON STR0007 	SIZE 45 ,10   FONT oDlg:oFont ACTION (MarcaTodos(oListBox, .F., .F.))  			OF oDlg PIXEL   //'Desmarcar Todos'
				   @ 70,230 BUTTON STR0008	SIZE 45 ,10   FONT oDlg:oFont ACTION (MarcaTodos(oListBox, .T.))  					OF oDlg PIXEL   //'Inverter Selecao'
				   @ 85,230 BUTTON STR0009	SIZE 45 ,10   FONT oDlg:oFont ACTION (InverteSel(oListBox, oListBox:nAt, .T.))  	OF oDlg PIXEL   //'Marca/Desmarca'
				
				ACTIVATE MSDIALOG oDlg CENTERED
		Else
			lOk := .T. 
			aTotList[1][1]	:= aList[1]
			aTotList[2][1]	:= aList[2]
		Endif
		
		Else
			HELP("  ",1,"PCOR0401")//Cadastro de totais visao orcamentaria esta vazio. Verifique!
			lOk := .F.
		EndIf	
			
		If lOk .And. (lOk := Elem_Selec(aTotList))
			If Len(aPerg) # 0
				aEval(aPerg, {|x, y| &("MV_PAR"+StrZero(y,2)) := x})
			EndIf

			Eval(bPrintRel)
		EndIf
		
	EndIf

RestArea(aArea)

If lCallPrg
	RestArea(aAreaAKO)
	RestArea(aAreaAK2TMP)
	RestArea(aAreaAK1TMP)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCOR060Proc ºAutor ³ Gustavo Henrique  º Data ³  06/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Processa os totalizadores selecionados e gera os arquivos  º±±
±±º          ³ temporarios CONTA e TOTAL para impressao do relatorio      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orcamentario                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function U_PCOR061C()

Local aEstrutAKO	:= {}
Local aEstrutTOT	:= {}
Local cArqConta		:= ""   
Local cArqTotal		:= ""
Local aChave1		:= {}
Local aChave2		:= {}

Local nCont			:= 0

AAdd(aEstrutAKO,{'XKO_RECNO'	,'C',10,0})
AAdd(aEstrutAKO,{'XKO_LDESC'	,'C',1,0})
AAdd(aEstrutAKO,{'XKO_ORCAME'	,'C',Len(AKO->AKO_CODIGO),0})
AAdd(aEstrutAKO,{'XKO_CO'		,'C',Len(AKO->AKO_CO),0})
AAdd(aEstrutAKO,{'XKO_NIVEL'	,'C',Len(AKO->AKO_NIVEL),0})
AAdd(aEstrutAKO,{'XKO_DESCRI'	,'C',Len(AKO->AKO_DESCRI),0})
AAdd(aEstrutAKO,{'XKO_TIPO'		,'C',Len(AKO->AKO_CLASSE),0})

If _oPCOR0601 <> Nil
	_oPCOR0601:Delete()
	_oPCOR0601:= Nil
Endif

aChave1	:= {"XKO_RECNO"}

_oPCOR0601 := FWTemporaryTable():New("CONTA")
_oPCOR0601:SetFields( aEstrutAKO )

_oPCOR0601:AddIndex("1", aChave1)	
_oPCOR0601:Create()

cArqConta		:= _oPCOR0601:GetRealName()

AAdd(aEstrutTOT,{'TOT_RECNO'	,'C',10,0})
AAdd(aEstrutTOT,{'TOT_SEQUEN'	,'C',3,0})
AAdd(aEstrutTOT,{'TOT_LDESC'	,'C',1,0})
AAdd(aEstrutTOT,{'TOT_LINHA'	,'N',10,0})
AAdd(aEstrutTOT,{'TOT_COLUNA'	,'N',10,0})
AAdd(aEstrutTOT,{'TOT_CONTEU'	,'C',100,0})
AAdd(aEstrutTOT,{'TOT_NROCOL'	,'N',10,0})
AAdd(aEstrutTOT,{'TOT_TAMCOL'	,'N',10,0})
AAdd(aEstrutTOT,{'TOT_LINIMP'	,'N',10,0})

If _oPCOR0602 <> Nil
	_oPCOR0602:Delete()
	_oPCOR0602:= Nil
Endif

aChave2	:= {"TOT_RECNO","TOT_SEQUEN"}

_oPCOR0602 := FWTemporaryTable():New("TOTAL")
_oPCOR0602:SetFields( aEstrutTOT )

_oPCOR0602:AddIndex("1", aChave2)	
_oPCOR0602:Create()

cArqTotal 		:= _oPCOR0602:GetRealName()

//dbSelectArea(TMPAK1)
                 
AKO->(   dbSetOrder(3) )
TOTAL->( dbSetOrder(1) )

If AKO->( MsSeek(xFilial()+PadR(TMPAK1->AK1_CODIGO,TamSX3("AKO_CODIGO")[1])+"001") )

	AKO->( MsSeek(xFilial()+PadR(TMPAK1->AK1_CODIGO,TamSX3("AKO_CODIGO")[1])) )
	                                                                                      
	Do While AKO->( !Eof() .And. AKO_FILIAL+AKO_CODIGO==xFilial("AKO")+PadR(TMPAK1->AK1_CODIGO,TamSX3("AKO_CODIGO")[1]))
		nCont++
		AKO->( dbSkip() )                                                            		
	EndDo
	
	ProcRegua(nCont)
	
	AKO->( MsSeek(xFilial()+PadR(TMPAK1->AK1_CODIGO,TamSX3("AKO_CODIGO")[1])+"001") )
	
	Do While AKO->( !Eof() .And. AKO_FILIAL+AKO_CODIGO+AKO_NIVEL==xFilial("AKO")+PadR(TMPAK1->AK1_CODIGO,TamSX3("AKO_CODIGO")[1])+"001")
		IncProc()
		U_PCOR063C( AKO->AKO_CODIGO, AKO->AKO_CO )
		AKO->( dbSkip() )
	EndDo
	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Gustavo Henrique   º Data ³  05/06/06  º±±
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
Static Function ReportDef( lCallPrg )

Local cReport	:= "PCOR060" // Nome do relatorio
Local cTitulo	:= STR0010	 // Titulo do relatorio

Local oVisao
Local oContaOG
Local oTotVis
 
Local oReport

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
oReport := TReport():New( cReport, cTitulo, "PCR030", { |oReport| U_PCOR062C( oReport, lCallPrg ) }, STR0021 ) // "Este relatório imprime os totalizadores da visao orcamentária, de acordo com os parâmetros selecionados."

Pergunte( "PCR030", .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio - Visao Orcamentaria Gerencial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oVisao := TRSection():New( oReport, cTitulo, {"TMPAK1"} )	// "Planilla Vision Ger. Presupuestaria"

TRCell():New( oVisao, "AK1_CODIGO", "TMPAK1", STR0002,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || TMPAK1->AK1_CODIGO } )	// Codigo
TRCell():New( oVisao, "AK1_DESCRI", "TMPAK1", STR0003,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || TMPAK1->AK1_DESCRI } )	// Descricao
TRCell():New( oVisao, "AK1_INIPER", "TMPAK1", STR0011,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || TMPAK1->AK1_INIPER } )	// Dt.Inicio
TRCell():New( oVisao, "AK1_FIMPER", "TMPAK1", STR0012,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || TMPAK1->AK1_FIMPER } )	// Dt.Fim

oVisao:SetHeaderPage()
oVisao:SetNoFilter({"TMPAK1"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 2a. secao do relatorio - Conta Orcamentaria Gerencial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oContaOG := TRSection():New( oVisao,STR0023, {"CONTA"} )	// "Conta Gerencial"

TRCell():New( oContaOG, "XKO_CO"    , "CONTA", STR0013,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// C.O.G.
TRCell():New( oContaOG, "XKO_NIVEL" , "CONTA", STR0014,/*Picture*/,10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// Nivel
TRCell():New( oContaOG, "XKO_DESCRI", "CONTA", STR0003,/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	// Descricao
TRCell():New( oContaOG, "XKO_TIPO"  , "CONTA", STR0015,/*Picture*/,15,/*lPixel*/,{ || If( CONTA->XKO_TIPO == "1", STR0017, STR0016 ) }/*{|| code-block de impressao }*/)	// Analitica ### Sintetica
oContaOG:SetNoFilter({"CONTA"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 3a. secao do relatorio - Classe Orcamentaria referente a conta orcamentaria da planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTotVis := TRSection():New( oContaOG,STR0024, {"TOTAL"} )	//"Detalhes do Totalizador"

TRCell():New( oTotVis, "COLUNA_1",,"COLUNA_1",/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,"LEFT")	// normalmente eh descricao
TRCell():New( oTotVis, "COLUNA_2",,"COLUNA_2",/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// Valor
TRCell():New( oTotVis, "COLUNA_3",,"COLUNA_3",/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// Valor
TRCell():New( oTotVis, "COLUNA_4",,"COLUNA_4",/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// Valor
TRCell():New( oTotVis, "COLUNA_5",,"COLUNA_5",/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// Valor
TRCell():New( oTotVis, "COLUNA_6",,"COLUNA_6",/*Picture*/,30/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// Valor
oTotVis:SetNoFilter({"TOTAL"})
                                                    
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PCOR060Prt  ³ Autor ³ Gustavo Henrique    ³ Data ³ 05/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de impressao da planilha orcamentaria.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PCOR060Prt()                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function U_PCOR062C( oReport )

Local oVisao		:= oReport:Section(1)
Local oContaOG	:= oReport:Section(1):Section(1)
Local cArqConta	:= ""
Local cArqTotal	:= ""

Local aArea		:= GetArea()

Processa( { || U_PCOR061C( @cArqConta, @cArqTotal ) },, STR0022 )	//"Processando totalizadores da planilha..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia impressao da 1a. e 2a. secao do relatório                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:OnPageBreak( { || oVisao:PrintLine(), oReport:SkipLine() } )

oReport:SetMeter( CONTA->( RecCount() ) ) 

CONTA->( dbGoTop() )

oVisao:Init()

Do While ! oReport:Cancel() .And. CONTA->( ! EoF() )
                         
	oReport:IncMeter()
	
	If oReport:Cancel()
		Exit
	EndIf

	oContaOG:Init()
	oContaOG:PrintLine()
	
	oReport:SkipLine()
	
	R060_DetConta( oReport )

	oContaOG:Finish()
	
	CONTA->( dbSkip() )
	
EndDo

oVisao:Finish()

CONTA->(dbCloseArea())
If _oPCOR0601 <> Nil
	_oPCOR0601:Delete()
	_oPCOR0601:= Nil
Endif

TOTAL->(dbCloseArea())
If _oPCOR0602 <> Nil
	_oPCOR0602:Delete()
	_oPCOR0602:= Nil
Endif

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PCOR060_It³ Autor ³ Gustavo Henrique      ³ Data ³ 05/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao dos itens da visao gerencial.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PCOR060_It( cVisGer, cCO )                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function U_PCOR063C( cVisGer, cCO )
Local aArea		:= GetArea()
Local aAreaAKO	:= AKO->(GetArea())
                  
// Se o centro Orcamentario pertence ao filtro que foi selecionado
If	( AKO->AKO_CO    >= MV_PAR01 .And. AKO->AKO_CO    <= MV_PAR02 ) .And.;
	( AKO->AKO_NIVEL >= MV_PAR03 .And. AKO->AKO_NIVEL <= MV_PAR04 ) // Se o Nivel pertence ao filtro que foi selecionado
	R060ContaOrc()
	R060Totais( aTotList, aTotBlock )
EndIf

dbSelectArea("AKO")
AKO->( dbSetOrder(2) )
If AKO->( MsSeek( xFilial() + cVisGer + cCO ) )
   	Do While AKO->( !Eof() .And. AKO_FILIAL+AKO_CODIGO+AKO_COPAI == xFilial("AKO") + cVisGer + cCO )
		U_PCOR063C( AKO->AKO_CODIGO, AKO->AKO_CO ) //aqui
		AKO->( dbSkip() )
	End
EndIf

RestArea(aAreaAKO)
RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060_DetContaºAutor ³Gustavo Henrique  º Data ³  05/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Detalhe do relatorio - contas orcamentarias                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orcamentario                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060_DetConta( oReport )

Local nTam	:= 300
Local nX	:= 0

For nX := 1 To Len(aTotList)
	If oReport:Cancel()
		Exit
	EndIf	
	If aTotList[nX][1]
		If TOTAL->( dbSeek( CONTA->XKO_RECNO + StrZero(nX,3) ) )
			Do While TOTAL->( ! Eof() .And. TOT_RECNO + TOT_SEQUEN == CONTA->XKO_RECNO + StrZero(nX,3) )
				R060_TotImp( CONTA->XKO_RECNO + StrZero(nX,3), oReport, nTam )
				TOTAL->(dbSkip())
			EndDo          
		EndIf
	EndIf
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060_TotImp ºAutor  ³ Gustavo Henrique º Data ³  05/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Impressao dos totalizadores para conta orcamentaria impressaº±±
±±º          ³no detalhe do relatorio                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orcamentario                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060_TotImp( cChave, oReport, nTamOrig )

Local nX			:= 0
Local nY			:= 0
Local nTam 			:= 0
Local nLinImpr		:= 0
Local nPosCol		:= 0
Local nCtd			:= 0
Local aDadosImpr	:= {}
Local aCabDes  		:= {}
Local aTotCol		:= {}

Local oVisao		:= oReport:Section(1)
Local oTotVis		:= oReport:Section(1):Section(1):Section(1)

Local cCell			:= ""
                          
nTam += nTamOrig

If TOTAL->TOT_LINHA == 1  //monta cabecalho dos totais

	// Monta cabecalho
	aPosCol := {}
	aCabConteudo := {}
	nCtd := 1

	Do While TOTAL->(! Eof() .And. TOT_RECNO+TOT_SEQUEN == cChave .And. TOT_LINHA == 1 )//cabecalho das totalizacoes

		aAdd(aPosCol, nTam)
		aAdd(aCabConteudo, TOTAL->TOT_CONTEU)
        aAdd(aTotCol, {StrZero(TOTAL->TOT_COLUNA,3), nCtd, Len(aPosCol)} )
        
		nTam += CELLTAMDATA

		If nTam > 2800
			aAdd(aCabDes, aClone(aCabConteudo))
			nTam := nTamOrig
        	aPosCol := {}
        	aCabConteudo := {}
        	nCtd++
      	EndIf   
		TOTAL->(dbSkip())
		
	EndDo

	If !Empty(aCabConteudo)
		aAdd(aCabDes, aClone(aCabConteudo))
	EndIf
    
	aDadosImpr := Array( Len(aCabDes), 0 )

	TOTAL->( dbSeek( cChave ) )  

	Do While TOTAL->(! Eof() .And. TOT_RECNO+TOT_SEQUEN == cChave)

		nLinImpr := TOTAL->TOT_LINHA

		Do While TOTAL->(! Eof() .And. TOT_RECNO+TOT_SEQUEN == cChave .And. TOT_LINHA==nLinImpr)
			nPosCol := ASCAN( aTotCol, {|x| x[1] == StrZero(TOTAL->TOT_COLUNA,3)} )
			If nPosCol > 0
				aAdd(aDadosImpr[aTotCol[nPosCol][2]],{nLinImpr,TOTAL->TOT_CONTEU, aTotCol[nPosCol][3]})
			EndIf
			TOTAL->(dbSkip())
		EndDo

	EndDo

	For nX := 1 To Len(aCabDes)

		If oReport:Cancel()
			Exit
		EndIf
                                  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia a impressao da secao de valores                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oTotVis:Init()	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime conteudo das celulas da secao de totalizadores           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oTotVis:Cell("COLUNA_1"):Hide()
		oTotVis:Cell("COLUNA_2"):Hide()
		oTotVis:Cell("COLUNA_3"):Hide()
		oTotVis:Cell("COLUNA_4"):Hide()
		oTotVis:Cell("COLUNA_5"):Hide()
		oTotVis:Cell("COLUNA_6"):Hide()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atribui o titulo de cada celula de secao de totalizadores        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nY := 1 To Len(aCabDes[nX])
			cCell := "COLUNA_" + AllTrim(Str(nY))
			oTotVis:Cell(cCell):cTitle := AllTrim(aCabDes[nX,nY])
		Next
        //para as colunas que ficaram sem titulo (para nao imprimir o nome da celula)
		For nY := Len(aCabDes[nX])+1 To 6  //sao 6 celulas no maximo
			cCell := "COLUNA_" + AllTrim(Str(nY))
			oTotVis:Cell(cCell):cTitle := ""
		Next

		nLinImpr := aDadosImpr[nX][1][1]
		nColImpr := 1

		For nY := 2 TO Len(aDadosImpr[nX])
			If oReport:Cancel()
				Exit
			EndIf	
			If nLinImpr != aDadosImpr[nX][nY][1]

				nLinImpr := aDadosImpr[nX][nY][1]
				nColImpr := 1

				If nLinImpr > 2        

					oTotVis:PrintLine()
					oTotVis:Cell("COLUNA_1"):Hide()
					oTotVis:Cell("COLUNA_2"):Hide()
					oTotVis:Cell("COLUNA_3"):Hide()
					oTotVis:Cell("COLUNA_4"):Hide()
					oTotVis:Cell("COLUNA_5"):Hide()
					oTotVis:Cell("COLUNA_6"):Hide()
					
				EndIf	

			EndIf	                 
			
			cCell := "COLUNA_" + AllTrim(Str(nColImpr))
			oTotVis:Cell(cCell):SetValue( AllTrim(aDadosImpr[nX][nY][2]) )
			oTotVis:Cell(cCell):Show()
       
			nColImpr++

	   	Next                               

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza impressao da secao de valores                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oTotVis:PrintLine()
	    oTotVis:Finish()

   	Next

EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PCOR060It ³ Autor ³ Edson Maricate        ³ Data ³07-01-2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de impressao da planilha orcamentaria.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PCOR060Imp(lEnd)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd - Variavel para cancelamento da impressao pelo usuario³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function U_PCOR064C(cVisGer,cCO)
Local aArea		:= GetArea()
Local aAreaAKO	:= AKO->(GetArea())
                  
// Se o centro Orcamentario pertence ao filtro que foi selecionado
IF (AKO->AKO_CO >= MV_PAR01 .AND. AKO->AKO_CO <= MV_PAR02 )
	// Se o Nivel pertence ao filtro que foi selecionado
	IF (AKO->AKO_NIVEL >= MV_PAR03 .AND. AKO->AKO_NIVEL <= MV_PAR04 )
		R060ContaOrc()
		R060Totais(aTotList, aTotBlock)
	EndIf
EndIf
dbSelectArea("AKO")
dbSetOrder(2)
If MsSeek(xFilial()+cVisGer+cCO)
   	While !Eof() .And. AKO->AKO_FILIAL+AKO->AKO_CODIGO+AKO->AKO_COPAI==xFilial("AKO")+cVisGer+cCO
		U_PCOR064C(AKO_CODIGO,AKO_CO)
		dbSelectArea("AKO")
		dbSkip()
	End
EndIf

RestArea(aAreaAKO)
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InverteSelºAutor  ³Paulo Carnelossi    º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inverte Selecao do list box - totalizadores                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InverteSel(oListBox,nLin, lInverte, lMarca) 
DEFAULT nLin := oListBox:nAt

If lInverte
	oListbox:aArray[nLin,1] := ! oListbox:aArray[nLin,1]

Else
   If lMarca
	   oListbox:aArray[nLin,1] := .T.
   Else
	   oListbox:aArray[nLin,1] := .F.
   EndIf
EndIf   

aTotList[nLin,1] := oListbox:aArray[nLin,1]

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaTodosºAutor  ³Paulo Carnelossi    º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Marca todos as opcoes do list box - totalizadores           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaTodos(oListBox, lInverte, lMarca)
Local nX
DEFAULT lMarca := .T.

For nX := 1 TO Len(oListbox:aArray)
	InverteSel(oListBox,nX, lInverte, lMarca)
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Elem_SelecºAutor  ³Paulo Carnelossi    º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se ha pelo menos uma opcao do list box selecionada º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Elem_Selec(aTotList)
Local nX, lRet := .F.
For nX := 1 TO Len(aTotList)
  If aTotList[nX][1]
     lRet := .T.
     Exit
  EndIf   
Next 

If !lRet
	HELP("  ",1,"PCOR0202") //Nao selecionado nenhuma totalizacao. Verifique!
EndIf	

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060TotaisºAutor  ³Paulo Carnelossi    º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa os blocos de codigos contidos no array atotBlock    º±±
±±º          ³do list box selecionado (aTotBlock - array recno TABELA AKQ)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060Totais(aTotList, aTotBlock)
Local nX, aResult := {}
For nX := 1 TO Len(aTotList)
	If aTotList[nX][1]
		AKQ->(dbGoto(aTotBlock[nX][1]))//3
		If !Empty(AKQ->AKQ_BLOCK)//t
			aResult := PCOExecForm(AKQ->AKQ_BLOCK)
			If Len(aResult) > 1  // primeira elemento e o cabecalho
				R060TotOrc(aResult[1], aResult[2], aResult[3], nX)
			EndIf
			aResult := {}
		EndIf
	EndIf
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060ContaOrcºAutor  ³Paulo Carnelossi  º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava as contas orcamentarias em arquivo temporario para    º±±
±±º          ³posterior impressao                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060ContaOrc()				

CONTA->(dbAppend())
CONTA->XKO_RECNO	:= StrZero(AKO->(Recno()),10)
CONTA->XKO_LDESC	:= "1"
CONTA->XKO_ORCAME	:= AKO->AKO_CODIGO
CONTA->XKO_CO		:= AKO->AKO_CO
CONTA->XKO_NIVEL	:= AKO->AKO_NIVEL
CONTA->XKO_DESCRI	:= AKO->AKO_DESCRI
CONTA->XKO_TIPO		:= AKO->AKO_CLASSE

Return						

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060TotOrc  ºAutor  ³Paulo Carnelossi  º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava totais das contas orcamentarias em arquivo temporario º±±
±±º          ³posterior impressao                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060TotOrc(aRet, aCols, nCols, nTotBlock)
Local nX, nY

For nX := 1 TO Len(aRet)
	For nY := 1 TO Len(aCols)
		TOTAL->(dbAppend())
		TOTAL->TOT_RECNO	:= StrZero(AKO->(Recno()),10)
       TOTAL->TOT_SEQUEN   := StrZero(nTotBlock, 3)
		TOTAL->TOT_LDESC	:= "1"
		TOTAL->TOT_LINHA	:= nX
		TOTAL->TOT_COLUNA	:= nY
		TOTAL->TOT_CONTEU	:= aRet[nX][nY]
		TOTAL->TOT_NROCOL	:= nCols
		TOTAL->TOT_TAMCOL   := aCols[nY]
		TOTAL->TOT_LINIMP	:= 0
    Next
Next
    
Return						



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060Cabec   ºAutor  ³Paulo Carnelossi  º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cabecalho principal do relatorio                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060Cabec()

PcoPrtCab(oPrint)
PcoPrtCol({20,370,470,2075,2250})
PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,cVisGer,oPrint,4,2,/*RgbColor*/,STR0002) //"Codigo"
PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,"",oPrint,4,2,/*RgbColor*/,"")
PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,cDesAK1,oPrint,4,2,/*RgbColor*/,STR0003) //"Descricao"
PcoPrtCell(PcoPrtPos(4),nLin,PcoPrtTam(4),60,DTOC(dIniPer),oPrint,4,2,/*RgbColor*/,STR0011) //"Dt.Inicio"
PcoPrtCell(PcoPrtPos(5),nLin,PcoPrtTam(5),60,DTOC(dFimPer),oPrint,4,2,/*RgbColor*/,STR0012) //"Dt.Fim"
nLin+=70

R060CabConta()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060Cabec   ºAutor  ³Paulo Carnelossi  º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cabecalho secundario (contas orcamentarias)do relatorio     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060CabConta()

PcoPrtCol({20,370,470,2150})
PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),30,STR0013,oPrint,2,1,RGB(230,230,230)) //"C.O."
PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),30,STR0014,oPrint,2,1,RGB(230,230,230)) //"Nivel"
PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),30,STR0003,oPrint,2,1,RGB(230,230,230)) //"Descricao"
PcoPrtCell(PcoPrtPos(4),nLin,PcoPrtTam(4),30,STR0015,oPrint,2,1,RGB(230,230,230)) //"Tipo"
nLin+=75

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060DetContaºAutor  ³Paulo Carnelossi  º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Detalhe do relatorio - contas orcamentarias                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060DetConta()
Local lDescricao := (CONTA->XKO_LDESC=="1")
Local nX

If lDescricao
	PcoPrtCol({20,370,470,2150})
	PcoPrtCell(PcoPrtPos(1),nLin,,60,CONTA->XKO_CO,oPrint,5,3)
	PcoPrtCell(PcoPrtPos(2),nLin,,60,CONTA->XKO_NIVEL,oPrint,5,3)
	PcoPrtCell(PcoPrtPos(3),nLin,,60,SPACE((VAL(CONTA->XKO_NIVEL)-1)*3)+CONTA->XKO_DESCRI,oPrint,5,3)
	If Empty(CONTA->XKO_TIPO).Or.CONTA->XKO_TIPO == "1"
		PcoPrtCell(PcoPrtPos(4),nLin,,60,STR0016,oPrint,5,3) //"Sintetica"
	Else
		PcoPrtCell(PcoPrtPos(4),nLin,,60,STR0017,oPrint,5,3) //"Analitica"
	EndIf
	CONTA->XKO_LDESC := "0"  //
EndIf	
nLin+= 70

For nX := 1 TO Len(aTotList)
	If aTotList[nX][1]
		R060Total(CONTA->XKO_RECNO+StrZero(nX,3),lDescricao)
	EndIf
	nLin += 40
Next
nLin+= 70

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060Total   ºAutor  ³Paulo Carnelossi  º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao dos totalizadores para conta orcamentaria impressaº±±
±±º          ³no detalhe do relatorio                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060Total(cChave, lDescricao)
Local nTam
//Impressao do relatorio
dbSelectArea("TOTAL")
dbSeek(cChave)

nTam := 300

If dbSeek(cChave)
	While TOTAL->(! Eof() .And. TOT_RECNO+TOT_SEQUEN == cChave)
		R060TotImpr(cChave, lDescricao, nTam)
	End
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R060TotImpr ºAutor  ³Paulo Carnelossi  º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao dos totalizadores para conta orcamentaria impressaº±±
±±º          ³no detalhe do relatorio                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R060TotImpr(cChave, lDescricao, nTamOrig)
Local nX, nY, nTam := 0, nLinImpr, aDadosImpr, nPosCol, nCtd
Local aCabPos := {}
Local aCabDes := {}
Local aTotCol := {}
Local aColunas := {}   // leo-04/04/05

nTam += nTamOrig

If TOTAL->TOT_LINHA == 1  //monta cabecalho dos totais
	//primeiro monta cabecalho
	aPosCol := {}
	aCabConteudo := {}
	nCtd := 1
	While TOTAL->(! Eof() .And. TOT_RECNO+TOT_SEQUEN == cChave .And. ;
		TOT_LINHA == 1  )//cabecalho das totalizacoes

		aAdd(aPosCol, nTam)

		aAdd(aCabConteudo, TOTAL->TOT_CONTEU)
        aAdd(aTotCol, {StrZero(TOTAL->TOT_COLUNA,3), nCtd, Len(aPosCol)} )
        
		nTam += CELLTAMDATA

		If nTam > 2800
			aAdd(aCabPos, aClone(aPosCol))
			aAdd(aCabDes, aClone(aCabConteudo))
        	nTam := aCabPos[1][2]  //sempre considera a coluna que imprime o 1o.periodo
        	aPosCol := {}
        	aCabConteudo := {}
        	aColunas := {}
        	nCtd++
      EndIf   
		nUltCol := TOTAL->TOT_COLUNA
		
		//TOTAL->(dbDelete()) // leo 06/04/05
		TOTAL->(dbSkip())
	End

	If !Empty(aCabConteudo)
		aAdd(aCabPos, aClone(aPosCol))
		aAdd(aCabDes, aClone(aCabConteudo))
		aAdd(aTotCol, aClone(aColunas))
	EndIf
    
   aDadosImpr := ARRAY(Len(aCabPos), 0)
   TOTAL->(dbSeek(cChave))  // leo 06/04/05
	While TOTAL->(! Eof() .And. TOT_RECNO+TOT_SEQUEN == cChave)
		nLinImpr := TOTAL->TOT_LINHA
		While TOTAL->(! Eof() .And. TOT_RECNO+TOT_SEQUEN == cChave .And. TOT_LINHA==nLinImpr)
			nPosCol := ASCAN( aTotCol, {|x| x[1] == StrZero(TOTAL->TOT_COLUNA,3)} )
			If nPosCol > 0
				aAdd(aDadosImpr[aTotCol[nPosCol][2]],{nLinImpr,TOTAL->TOT_CONTEU, aTotCol[nPosCol][3]})
			EndIf
			TOTAL->(dbDelete())
			TOTAL->(dbSkip())
		End
	End
	  
	For nX := 1 TO Len(aCabPos)
	    //impressao do cabecalho
	    If PcoPrtLim(nLin+100)
			nLin := 200
			R060Cabec()
		EndIf

		PcoPrtCol(aCabPos[nX])
		For nY := 1 TO Len(aCabDes[nX])
			//agora imprime o cabecalho
			PcoPrtCell(PcoPrtPos(nY), nLin, PcoPrtTam(nY), 30, aCabDes[nX][nY], oPrint, 2, 1, RGB(230,230,230) )
		Next
		nLin+=40

		//impressao dos dados
		nLinImpr := aDadosImpr[nX][1][1]
		nColImpr := 1
		For nY := 1 TO Len(aDadosImpr[nX])
			If nLinImpr != aDadosImpr[nX][nY][1]
				nLinImpr := aDadosImpr[nX][nY][1]
				nColImpr := 1
				nLin+=30
			EndIf	
//			PcoPrtCell(PcoPrtPos(nColImpr), nLin, PcoPrtTam(nY), 30, aDadosImpr[nX][nY][2], oPrint, 5, 3,,,If(nX==1.And.nColImpr==1,.F.,.T.))
			PcoPrtCell(PcoPrtPos(nColImpr), nLin, PcoPrtTam(nColImpr), 30, aDadosImpr[nX][nY][2], oPrint, 5, 3,,,If(nX==1.And.nColImpr==1,.F.,.T.))
			nColImpr++
	   	Next

		nLin+=40

   	Next

EndIf

Return