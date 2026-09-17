#Include "Ctbr100C.Ch"
#Include "PROTHEUS.Ch"

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA  			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT     	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO    	8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_VLR_CREDITO   	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15


// 17/08/2009 -- Filial com mais de 2 caracteres
//Seleciona Filiais

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr100	³ Autor ³ Simone Mie Sato   	³ Data ³ 09.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Item /Conta                   			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ U_Ctbr100C()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ SIGACTB      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctbr100C()
	PRIVATE titulo		:= ""
	Private nomeprog	:= "CTBR100"
	Private aSelFil		:= {}

	//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
	U_CTBR101C()

	//Limpa os arquivos temporários
	CTBGerClean()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR100R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 28/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Item /Conta - R4           	 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR100R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR101C()
Private cPictVal 		:= PesqPict("CT2","CT2_VALOR")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()
If !Empty( oReport:uParam )
	Pergunte( oReport:uParam, .F. )
EndIf
oReport :PrintDialog()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 28/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef() as Object
Local cREPORT		as Character
Local cSayItem		as Character
Local cPerg	   		as Character
Local aTamItem		as Array
Local aTamConta		as Array
Local aTamVal		as Array
Local aTamDesc		as Array
Local lQuebra		as Logical
Local cTITULO		as Character
Local cDESC			as Character
Local cTpValor		as Character

cREPORT				:= "CTBR100"
cSayItem			:= CtbSayApro("CTD")
cPerg	   			:= "CTR100"
aTamItem			:= TAMSX3("CTD_ITEM")
aTamConta			:= TAMSX3("CT1_CONTA")
aTamVal				:= TAMSX3("CT2_VALOR")
aTamDesc			:= {}
lQuebra				:= .F.

// "Balancete de Verificacao ITEM / Conta"
cTITULO		:= OemToAnsi(STR0003)+ Upper(cSayItem) + " / " + Upper(OemToAnsi(STR0021))
// "Este programa ira imprimir o Balancete de ITEM /  Conta de acordo com os parametros solicitados pelo Usuario. "
cDESC		:= OemToAnsi(STR0001)+ Upper(cSayItem) + " / " + Upper(OemtoAnsi(STR0021)) + OemToansi(STR0002)
cTpValor	:= GetMV("MV_TPVALOR")


If aTamConta[1] < 20
	aTamDesc		:= {22}
Else
	aTamDesc		:= TAMSX3("CT1_DESC01")
Endif

If aTamDesc[1] > 40 //40 - Tamanho Default CT1_DESC01
	lQuebra := .T.
Endif

If cTpValor == "D"
	aTamVal[1]:= aTamVal[1]+10
Else
	aTamVal[1]:= aTamVal[1]+4
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//"Este programa tem o objetivo de emitir o Cadastro de Itens Classe de Valor "
//"Sera impresso de acordo com os parametros solicitados pelo"
//"usuario"
oReport	:= TReport():New( cReport,cTITULO,cPERG, { |oReport| ReportPrint( oReport ) }, cDESC )

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
oSection0  := TRSection():New( oReport, cSayItem, {"cArqTmp","CT1"},, .F., .F. )
TRCell():New( oSection0, "ITEM"		, ,	cSayItem /*Titulo*/,/*Picture*/,aTamItem[1]+10/*Tamanho*/,/*lPixel*/,{ || EntidadeCTB(cArqTMp->ITEM,0,0,20,.F.,cMascara2,cSepara2,,,,,.F.) }/*CodeBlock*/)
TRCell():New( oSection0, "DESCITEM"	, ,	STR0025	 /*Titulo*/,/*Picture*/,aTamDesc[1]/*Tamanho*/,/*lPixel*/,{ || (cArqTMP->DESCITEM) }/*CodeBlock*/)
oSection0:SetLineStyle()

oSection1  := TRSection():New( oSection0, AllTrim(STR0021), {"cArqTmp","CT1"},, .F., .F. )	//	" Conta "
TRCell():New( oSection1, "CONTA"    , ,Capital(STR0027)/*Titulo*/,/*Picture*/,aTamConta[1]+len(GetMv("MV_MASCARA"))+1/*Tamanho*/,/*lPixel*/,{|| IIF(cArqTmp->TIPOCONTA=="2","  ","")+EntidadeCTB(cArqTmp->CONTA ,0,0,70,.F.,cMascara1,cSepara1,,,,,.F.) }/*CodeBlock*/)	//	"CODIGO    "
TRCell():New( oSection1, "DESCCTA"  , ,Capital(STR0025)/*Titulo*/,/*Picture*/,min(aTamDesc[1],40) /*Tamanho*/,/*lPixel*/,{ || (cArqTMp->DESCCTA)  }   /*CodeBlock*/,, lQuebra /*<lLineBreak> */,,, 5 /*<nColSpace> */,,,,)	              //"D E S C R I C A O   "
TRCell():New( oSection1, "SALDOANT" , ,Capital(STR0028)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,/*{ || (cArqTMp->SALDOANT) } /*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")	//	"SALDO ANTERIOR "
TRCell():New( oSection1, "SALDODEB" , ,Capital(STR0029)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,/*{ || (cArqTMp->SALDODEB) } /*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")	//	"DEBITO "
TRCell():New( oSection1, "SALDOCRD" , ,Capital(STR0030)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,/*{ || (cArqTMp->SALDOCRD) } /*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")	//	"CREDITO  "
TRCell():New( oSection1, "MOVIMENTO", ,Capital(STR0031)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,							    /*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")
TRCell():New( oSection1, "SALDOATU" , ,Capital(STR0032)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,/*{ || (cArqTMp->SALDOATU) } /*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")	//	"SALDO ATUAL "

oSection1:Cell("SALDOANT"):lHeaderSize		:= .F.
oSection1:Cell("SALDODEB"):lHeaderSize		:= .F.
oSection1:Cell("SALDOCRD"):lHeaderSize		:= .F.
oSection1:Cell("MOVIMENTO"):lHeaderSize		:= .F.
oSection1:Cell("SALDOATU"):lHeaderSize		:= .F.

oSection1:SetTotalInLine(.F.)
oSection1:SetTotalText(STR0020+" "+UPPER(cSayItem)) // "T O T A I S  D O  "
oSection1:SetHeaderPage(.T.)

oSection0:SetNoFilter("CT1")

//GESTAO - Inicio
//Relacao das filiais selecionadas para compor o relatorio

oSecFil := TRSection():New(oReport,"SECFIL")

TRCell():New(oSecFil,"CODFIL",,"Código",/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecFil,"EMPRESA",,"Empresa",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecFil,"UNIDNEG",,"Unidade de negócio",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecFil,"NOMEFIL",,"Filial",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)
// GESTAO - Fim

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 28/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )
Local oSection0 	:= oReport:Section(1)
Local oSection1 	:= oReport:Section(1):Section(1)

Local oBreak
Local oTotDeb
Local oTotCrd
Local oBreakGrp
Local oTotGrpDeb
Local oTotGrpCrd
Local oTotGerDeb
Local oTotGerCrd
Local oTotGerPer
Local oCreGer
Local oDebGer

Local cPicture
Local cDescMoeda
Local cGrupo		:= ""
Local cItemAnt 		:= ""
Local cSegAte   	:= mv_par14
Local cSegItAte   	:= mv_par29
Local cArqTmp		:= ""
Local cTipoAnt		:= ""
Local aCtbMoeda		:= {}
Local nDecimais
Local aTamVal		:= TAMSX3("CT2_VALOR")

Local dDataLP		:= mv_par28
Local dDataFim		:= mv_par02

Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local l132			:= .T.
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local lQbGrupo		:= Iif(mv_par13==1,.T.,.F.)
Local lImpMov		:= Iif(mv_par19==1,.T.,.F.)
Local lSaltaPag		:= Iif(mv_par21==1,.T.,.F.)
Local lPula			:= Iif(mv_par22==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par23==1,.T.,.F.)
Local lItemNormal	:= Iif(mv_par24==1,.T.,.F.)
Local lContaNormal	:= Iif(mv_par26==1,.T.,.F.)
Local lImpAntLP		:= Iif(mv_par27==1,.T.,.F.)
Local lImpTotIt		:= .T.								/// INDICA SE DEVE IMPRIMIR O TOTAL POR ITEM

Local nDivide		:= 0
Local nTamItem		:= Len(CriaVar("CTD_ITEM"))
Local n
Local lRecDesp0		:= Iif(mv_par35==1,.T.,.F.)
Local cRecDesp		:= mv_par36
Local dDtZeraRD		:= mv_par37
Local cSayItem		:= CtbSayApro("CTD")
Local cFilter 		:=""
Local cFilUser		:= ""
Local bCond
Local lCttSint		:= Iif(mv_par34==2,.F.,.T.)
Local nDigitAte		:= 0
Local nDigItmAte	:= 0
Local lColDbCr 		:= If(cPaisLoc $ "RUS",.T.,.F.) // Disconsider cTipo in ValorCTB function, setting cTipo to empty
Local lRedStorn		:= If(cPaisLoc $ "RUS",SuperGetMV("MV_REDSTOR",.F.,.F.),.F.)// Parameter to activate Red Storn
//Gestão - Inicio
Local oSecFil		:= oReport:Section("SECFIL")
Local nRegSM0		:= 0
Local aSM0			:= {}
Local nTamEmp		:= 0
Local nTamUnNeg		:= 0
Local nTamTit		:= 0
Local nX			:= 0
Local cFiLSel		:= ""
//Gestão - Fim

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Davi Torchio - 10/07/2007                                     ³
//³Controle de numeração de pagina para o relatorio personalizado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nPagIni		:= MV_PAR11 // parametro da pagina inicial
Private nPagFim		:= 999999 	// parametro da pagina final
Private nReinicia	:= 0    	// parametro de reinicio de pagina
Private l1StQb		:= .T.		// primeira quebra
Private lNewVars	:= .T.		// inicializa as variaveis
Private m_pag		:= MV_PAR11 // controle de numeração de pagina
Private nBloco      := 1		// controle do bloco a ser impresso
Private nBlCount	:= 0		// contador do bloco impresso
Private cMascara1	:= ""
Private cMascara2	:= ""
Private	cSepara1	:= ""
Private cSepara2	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par08)
	Return
Else
   aSetOfBook := CTBSetOf(mv_par08)
Endif

//Gestão-Inicio

If mv_par38 == 1
	aSelFil := AdmGetFil(.F.,.F.,"CQ5")
Else
	Aadd(aSelFil,cFilAnt)
Endif

If Len(aSelFil) > 1
	aSM0 := FWLoadSM0()
	oSection1:SetHeaderSection(.F.)
	nTamEmp := Len(FWSM0LayOut(,1))
	nTamUnNeg := Len(FWSM0LayOut(,2))
	cTitulo := oReport:Title()
	oReport:SetTitle(cTitulo + "Filiais selecionadas para o relatorio" )		//"Filiais selecionadas para o relatorio"
	nTamTit := Len(oReport:Title())
	oSecFil:Init()
	oSecFil:Cell("CODFIL"):SetBlock({||cFilSel})
	oSecFil:Cell("EMPRESA"):SetBlock({||aSM0[nLinha,SM0_DESCEMP]})
	oSecFil:Cell("UNIDNEG"):SetBlock({||aSM0[nLinha,SM0_DESCUN]})
	oSecFil:Cell("NOMEFIL"):SetBlock({||aSM0[nLinha,SM0_NOMRED]})
	For nX := 1 To Len(aSelFil)
		nLinha := Ascan(aSM0,{|sm0|,sm0[SM0_CODFIL] == aSelFil[nX]})
		If nLinha > 0
			cFilSel := Substr(aSM0[nLinha,SM0_CODFIL],1,nTamEmp)
			cFilSel += " "
			cFilSel += Substr(aSM0[nLinha,SM0_CODFIL],nTamEmp + 1,nTamUnNeg)
			cFilSel += " "
			cFilSel += Substr(aSM0[nLinha,SM0_CODFIL],nTamEmp + nTamUnNeg + 1)
			oSecFil:PrintLine()
		Endif
	Next
	oReport:SetTitle(cTitulo)
	oSecFil:Finish()
	oSection1:SetHeaderSection(.T.)
	oReport:EndPage()
Endif
// GESTAO - Fim

If mv_par25 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par25 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par25 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

aCtbMoeda  	:= CtbMoeda(mv_par10)
If Empty(aCtbMoeda[1])
	Help(" ",1,"NOMOEDA")
	lRet := .F.
Endif

If (mv_par35 == 1) .and. ( Empty(mv_par36) .or. Empty(mv_par37) )
	cMensagem	:= STR0023	// "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
	cMensagem	+= STR0024	// "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
	MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")
	lRet    	:= .F.
EndIf

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)

//Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1 	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf

// Mascara do Item Contabil
If Empty(aSetOfBook[7])
	cMascara2 := ""
Else
	cMascara2 := RetMasCtb(aSetOfBook[7],@cSepara2)
EndIf

//Ajusto as colunas de conta e item com a máscara
oSection0:Cell("ITEM" ):SetSize( oSection0:Cell("ITEM" ):GetSize() + Len( cMascara2 ) + 9 )
oSection1:Cell("CONTA"):SetSize( oSection1:Cell("CONTA"):GetSize() + Len( cMascara1 ) + 9 )

cPicture 		:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == 1
	Titulo:=	OemToAnsi(STR0007) + Upper(cSayItem)+ " / " + Upper(OemToAnsi(STR0021))	//"BALANCETE ANALITICO DE  / CONTA"
ElseIf mv_par07 == 2
	Titulo:=	OemToAnsi(STR0006) + Upper(cSayItem)+ " / "+ Upper(OemToAnsi(STR0021))	//"BALANCETE SINTETICO DE  / CONTA"
ElseIf mv_par07 == 3
	Titulo:=	OemToAnsi(STR0008) + Upper(cSayItem)+ " / "+ Upper(OemToAnsi(STR0021))	//"BALANCETE DE  / CONTA"
EndIf

Titulo += 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) + Dtoc(mv_par02) + ;
				OemToAnsi(STR0011) + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
EndIf

If nDivide > 1
	Titulo += " (" + OemToAnsi(STR0022) + Alltrim(Str(nDivide)) + ")"
EndIf

If lImpMov // Se imprime saldo movimento do periodo
	l132 := .F.
Endif

oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport,/*controle do cabeçalho pela rotina*/ ) } )

oReport:SetPageNumber( MV_PAR11 )

cFilUser := oSection0:GetAdvplExpr("CT1")
If Empty(cFilUser)
	cFilUser := ".T."
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT4","",mv_par03,mv_par04,,,mv_par05,mv_par06,,,mv_par10,;
				mv_par12,aSetOfBook,mv_par15,mv_par16,mv_par17,mv_par18, l132,.T.,,"CTD",;
				lImpAntLP,dDataLP,nDivide,lVlrZerado,,,mv_par30,mv_par31,mv_par32,mv_par33,,,,,,,,,cFilUser,lRecDesp0,;
				cRecDesp,dDtZeraRD,,,,,,,,,aSelFil,,,,,,,,lCttSint)},;
				OemToAnsi(OemToAnsi(STR0014)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0003)+cSayItem+" / "+OemToAnsi(STR0021))     //"Balancete Verificacao Conta /"

oReport:NoUserFilter()

cArqtMP->( DbGoTop() )

If mv_par07 == 1					// So imprime Conta Sintetica

	cFilter := "cArqTmp->TIPOCONTA  <>  '2'  "

	If mv_par34 == 1				// So imprime Item Contabil Sintetico
		cFilter += ".and. cArqTmp->TIPOITEM  <>  '2'  "
	ElseIf mv_par34 == 2			// So imprime Item Contabil Analitico
		cFilter += ".and. cArqTmp->TIPOITEM  <>  '1'  "
	EndIf

ElseIf mv_par07 == 2				// So imprime Conta Analitica

	cFilter := "cArqTmp->TIPOCONTA  <>  '1'  "

	If mv_par34 == 1				// So imprime Item Contabil Sintetico
		cFilter += ".and. cArqTmp->TIPOITEM  <>  '2'  "
	ElseIf mv_par34 == 2			// So imprime Item Contabil Analitico
		cFilter += ".and. cArqTmp->TIPOITEM  <>  '1'  "
	EndIf

EndIf

If mv_par34 == 1 .And. Empty(cFilter)			// So imprime Item Contabil Sintetico
	cFilter := "cArqTmp->TIPOITEM  <>  '2'  "
ElseIf mv_par34 == 2 .And. Empty(cFilter)		// So imprime Item Contabil Analitico
	cFilter := "cArqTmp->TIPOITEM  <>  '1'  "
EndIf

// Verifica Se existe filtragem Ate o Segmento
If ! Empty( cSegAte )
	nDigitAte := CtbRelDig( cSegAte, cMascara1 )
	If !Empty(cFilter)
		cFilter += " .and. "
	EndIf

	cFilter += ( 'Len(Alltrim(cArqTmp->CONTA)) <= ' + alltrim( Str( nDigitAte )) )
EndIf

// Verifica Se existe filtragem Ate o Segmento
If ! Empty( cSegItAte )
	nDigItmAte := CtbRelDig( cSegItAte, cMascara2 )
	If !Empty(cFilter)
		cFilter += " .and. "
	EndIf

	cFilter += ( 'Len(Alltrim(cArqTmp->ITEM)) <= ' + alltrim( Str( nDigItmAte )) )
EndIf

// Salta pagina por item
If lSaltaPag
	oSection0:SetPageBreak(.T.)
EndIf


oSection1:SetFilter( cFilter )
oSection1:SetParentFilter({|cParam| cArqTmp->ITEM == cParam  },{|| cArqTmp->ITEM })

If !lItemNormal		//	Se imprime Codigo Reduzido do Item (so imprimira reduzido se for analitico)
	oSection0:Cell("ITEM"):SetBlock( { || EntidadeCTB(IF(cArqTmp->TIPOITEM == "1",cArqTmp->ITEM,cArqTmp->ITEMRES),0,0,20,.F.,cMascara2,cSepara2,,,,,.F.) } )
Endif

If !lContaNormal	//	Se imprime Codigo Reduzido da Conta (so imprimira reduzido se for analitica)
	oSection1:Cell("CONTA"):SetBlock( { || EntidadeCTB(IF(cArqTmp->TIPOCONTA == "1",cArqTmp->CONTA,cArqTmp->CTARES),0,0,70,.F.,cMascara1,cSepara1,,,,,.F.) } )
EndIf

aTamVal[1] := aTamVal[1]+4

oSection1:Cell("SALDOANT"):SetBlock( { || ValorCTB(cArqTmp->SALDOANT,,,aTamVal[1],nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) } )
oSection1:Cell("SALDODEB"):SetBlock( { || ValorCTB(cArqTmp->SALDODEB,,,aTamVal[1],nDecimais,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.,lColDbCr) } )
oSection1:Cell("SALDOCRD"):SetBlock( { || ValorCTB(cArqTmp->SALDOCRD,,,aTamVal[1],nDecimais,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.,lColDbCr) } )
oSection1:Cell("SALDOATU"):SetBlock( { || ValorCTB(cArqTmp->SALDOATU,,,aTamVal[1],nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) } )

// Imprime Movimento
If !lImpMov
	oSection1:Cell("MOVIMENTO"):Disable()
Else
	oSection1:Cell("MOVIMENTO"):SetBlock( { || ValorCTB(cArqTmp->MOVIMENTO,,,aTamVal[1],nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,, lPrintZero,.F.) } )
EndIf


if  mv_par07 <> 1 									  // Imprime Contas Analiticas ou Ambas*/,;

	bCond := {|| If( cArqTmp->TIPOCONTA == "2" /*					      // Se a Conta e Analitica*/,;
					If( ((mv_par34 <> 1 .Or. mv_par34 == 3).And. cArqTmp->TIPOITEM == "2") /* // Imprime Item Analitico ou ambos .And. é um Analitico*/,;
						.T.,;
					/*Else*/;
						If( ((mv_par34 == 1 .Or. mv_par34 == 3) .And. cArqTmp->TIPOITEM <> "2") /* // Imprime Item Sintetico .And. é um Sintetico*/,;
							.T. ,;
						/*Else*/;
							.F. ) ),;
				    	/*EndIf*/;
					/*EndIf*/;
				 /*Else*/;
					.F. ) }
				 /*Endif*/
Else
	bCond := {|| If( (cArqTmp->TIPOCONTA == "1" .And. Empty(cArqTmp->SUPERIOR)) /* // Conta Sintetica .And. Sem Superiora*/,;
					If( ((mv_par34 <> 1 .Or. mv_par34 == 3) .And. cArqTmp->TIPOITEM == "2")         /* // Imprime Item Analitico ou Ambos .And. é Item Analitico */,;
						.T.,;
					/*Else*/;
						If( ((mv_par34 == 1 .Or. mv_par34 == 3) .And. cArqTmp->TIPOITEM <> "2") /* // Imprime Item Sintetico .And. é um Sintetico*/,;
							.T.,;
						/*Else*/;
							.F. ) ),;
						/*EndIf*/;
					/*EndIf*/;
				 /*Else*/;
					.F. ) }
				 /*EndIf*/
Endif


If lQbGrupo

	//Totais do Grupo
	oBreakGrp := TRBreak():New(oSection1, { || cArqTmp->GRUPO },{|| STR0019+" "+ RTrim( Upper(AllTrim(cGrupo) )) + " )" },,,.F.)	//	"T O T A I S  D O  G R U P O ("
	oBreakGrp:OnBreak( { |x| cGrupo := x } )

	oTotGrpDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || If( Eval(bCond), cArqTmp->SALDODEB,0 ) },.F.,.F.,.F.,oSection1)

	oTotGrpCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || Iif( Eval(bCond), cArqTmp->SALDOCRD,0 ) },.F.,.F.,.F.,oSection1)

	TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrpDeb:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr) },.F.,.F.,.F.,oSection1 )

	TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBreakGrp/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGrpCrd:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr) },.F.,.F.,.F.,oSection1 )

	If lImpMov
		// Totais de Movimentos
		If lRedStorn
			TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT", oBreakGrp/*oBreak/*oBreak*/,/*cTitulo*/,/*[ cPicture ]*/,;
				{ || (nTotMov := RedStorTt(oTotGrpDeb:GetValue(),oTotGrpCrd:GetValue(),,,"T")),;
				ValorCTB(nTotMov,,,aTamVal[1],nDecimais,.T.,cPicture,Iif( nTotMov < 0,"1","2"),,,,,, lPrintZero,.F.,lColDbCr)},.F.,.F.,.F.,oSection1)
		Else
			TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT", oBreakGrp/*oBreak/*oBreak*/,/*cTitulo*/,/*[ cPicture ]*/,;
				{ || (nTotMov := (oTotGrpCrd:GetValue() - oTotGrpDeb:GetValue())),;
				ValorCTB(nTotMov,,,aTamVal[1],nDecimais,.T.,cPicture,Iif( nTotMov < 0,"1","2"),,,,,, lPrintZero,.F.)},.F.,.F.,.F.,oSection1)
		Endif
	EndIf

	oTotGrpDeb:Disable()
	oTotGrpCrd:Disable()

EndIf


//Totais do Item
oBreak := TRBreak():New(oSection1, {|| cArqTMP->ITEM },{||	STR0020+" "+ RTrim( Upper(cSayItem) ) })	//	"T O T A I S  D O  "
oBreak :OnBreak( { |y| cItemAnt := y } )

oTotDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",oBreak/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || Iif( Eval(bCond), cArqTmp->SALDODEB,0 ) },.F.,.F.,.F.,oSection1)

oTotCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",oBreak/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || Iif( Eval(bCond), cArqTmp->SALDOCRD,0 ) },.F.,.F.,.F.,oSection1)

TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBreak/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotDeb:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr) },.F.,.F.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBreak/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotCrd:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr) },.F.,.F.,.F.,oSection1 )

If lImpMov
	// Totais de Movimentos
	If lRedStorn
		TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT", oBreak/*oBreak*/,/*cTitulo*/,/*[ cPicture ]*/,;
			{ || (nTotMov := RedStorTt(oTotDeb:GetValue(),oTotCrd:GetValue(),,,"T")),;
			ValorCTB(nTotMov,,,aTamVal[1],nDecimais,.T.,cPicture,Iif( nTotMov < 0,"1","2"),,,,,, lPrintZero,.F.,lColDbCr)},.F.,.F.,.F.,oSection1)
	Else
		TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT", oBreak/*oBreak*/,/*cTitulo*/,/*[ cPicture ]*/,;
			{ || (nTotMov := (oTotCrd:GetValue() - oTotDeb:GetValue())),;
			ValorCTB(nTotMov,,,aTamVal[1],nDecimais,.T.,cPicture,Iif( nTotMov < 0,"1","2"),,,,,, lPrintZero,.F.)},.F.,.F.,.F.,oSection1)
	Endif
EndIf

oTotDeb:Disable()
oTotCrd:Disable()


// Total Geral
oBrkEnd 	:= TRBreak():New( oReport, { || /*cArqTmp->(Eof())*/	}, OemToAnsi(STR0018), )

oTotGerDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",oBrkEnd/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || Iif( Eval(bCond), cArqTmp->SALDODEB,0 )  },.F.,.F.,.F.,oSection1)

oTotGerCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",oBrkEnd/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || Iif( Eval(bCond), cArqTmp->SALDOCRD,0 )  },.F.,.F.,.F.,oSection1)

TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBrkEnd/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotGerDeb:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBrkEnd/*oBreak*/,/*Titulo*/,/*cPicture*/,;
	{ || ValorCTB(oTotGerCrd:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

If lImpMov
	// Totais de Movimentos
	If lRedStorn
		TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT",/*oBreak*/,/*cTitulo*/,/*[ cPicture ]*/,;
			{ |lSection,lReport,lPage| nTotMov := RedStorTt(oTotGerDeb:GetValue(),oTotGerCrd:GetValue(),,,"T"),;
			ValorCTB(nTotMov,,,aTamVal[1],nDecimais,.T.,cPicture,Iif( nTotMov < 0,"1","2"),,,,,, lPrintZero,.F.,lColDbCr)},.F.,.T.,.F.,oSection1)
	Else

		oTotGerPer := TRFunction():New(oSection1:Cell("MOVIMENTO"),,"SUM",oBrkEnd/*oBreak*/,/*Titulo*/,/*cPicture*/,;
		{ || Iif( Eval(bCond), cArqTmp->SALDOCRD - cArqTmp->SALDODEB,0 )  },.F.,.F.,.F.,oSection1)

		TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT",oBrkEnd/*oBreak*/,/*cTitulo*/,/*[ cPicture ]*/,;
		{ || ValorCTB(oTotGerPer:GetValue(),,,aTamVal[1],nDecimais,.T.,cPicture,Iif( oTotGerPer:GetValue() < 0,"1","2"),,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1 )

	Endif
EndIf

oTotGerDeb:Disable()
oTotGerCrd:Disable()

If ValType(oTotGerPer) = "O"
	oTotGerPer:Disable()
EndIf

oSection1:OnPrintLine( {|| ( IIf(lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2")),;
								 oReport:SkipLine(),;
								 NIL),;
								 cTipoAnt := cArqTmp->TIPOCONTA	)  })

oSection0:Print()

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF

Return
