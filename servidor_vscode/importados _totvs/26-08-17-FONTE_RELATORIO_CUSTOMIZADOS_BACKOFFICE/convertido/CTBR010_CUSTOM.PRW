#INCLUDE "CTBR010C.CH"
#INCLUDE "PROTHEUS.CH"

STATIC __oTempTable

// 17/08/2009 -- Filial com mais de 2 caracteres

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ctbr010  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 10/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Impressao do Plano de Contas              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_Ctbr010C()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function U_Ctbr010C()

	Private titulo		:= ""
	Private nomeprog	:= "CTBR010"

	//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
	U_CTBR011C()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR010R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 01/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Impressao do Plano de Contas - R4			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR010R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function U_CTBR011C( cMoeda )
Local oReport
Local lExterno	:= ( cMoeda <> Nil )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef()

If ValType( oReport ) == "O"

	If ! Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf	
	
	If ! lExterno
		oReport :PrintDialog()
	Else               
	    mv_par06 := iif( ! Empty( cMoeda ) , cMoeda , '01' )
	
	    // faz a impressão do relatorio
	    oReport:Print()
	EndIf
Endif	

oReport := Nil

Return                                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 01/08/06 ³±±
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
Static Function ReportDef()
Local aArea	   		:= GetArea()   
Local cReport		:= "CTBR010"
Local cTitulo		:= STR0008				   			// "Listagem do Plano de Contas"
Local cDesc			:= STR0001//+STR002+STR003			// "Este programa ir  imprimir o Plano de Contas."
Local cPerg	   		:= "CTR010"			  
Local aOrdem 		:= {"Codigo","Descricao"}	// Cod,Descricao"       
Local cSeparador	:= "" 
Local cMascara		:= ""                                              
Local aCtbMoeda		:={}
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamDesc01	:= TAMSX3("CT1_DESC01")
Local cMoeda		:= mv_par06

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³Add por Icaro Queiroz | Claudio - em 24 de Agosto de 2010 ³
*³Variaveis para tratamento de tipificacao - CTBR015        ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local bTitulo		:= { |cCampo| SX3->( dbSetOrder(2) ), SX3->( MsSeek( cCampo ) ), X3Titulo() }
Local cTitCpo
Local oSection11

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
oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| ReportPrint( oReport ) }, cDesc ) 

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
oSection1  := TRSection():New( oReport, STR0028, {"CT1"}, aOrdem, .F., .F. ) //"Conta Contábil"

TRCell():New( oSection1, "CCONTACT1"	,	   ,STR0009/*Titulo*/,/*Picture*/,aTamConta[1]+10/*Tamanho*/,/*lPixel*/,{|| EntidadeCTB(CT1->CT1_CONTA ,0,0,70,.F.,iif( Empty( mv_par08 ) , GetMv("MV_MASCARA") , RetMasCtb( mv_par08,@cSeparador) ) ,cSeparador,,,,,.F.) }/*CodeBlock*/)
TRCell():New( oSection1, "CT1_DC"		,"CT1" ,STR0019/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT1_RES"		,"CT1" ,STR0020/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)

TRCell():New( oSection1, "CT1_DESC01"	,"CT1" ,STR0021/*Titulo*/,/*Picture*/,aTamDesc01[1]+5,/*lPixel*/,{||If( ! Empty( mv_par06 ) , &("CT1->CT1_DESC" + mv_par06 ) , CT1->CT1_DESC01)})

TRCell():New( oSection1, "CT1_CLASSE"	,"CT1" ,STR0022/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT1_NORMAL"	,"CT1" ,STR0023/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT1_CTASUP"	,"CT1" ,STR0024/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT1_BLOQ"		,"CT1" ,STR0025/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³Add por Icaro Queiroz | Claudio - em 24 de Agosto de 2010      ³
*³Caso seja chamado do CTBR015, imprime as calunas de tipificacao³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Upper( FunName() ) == 'CTBR015'

	oSection11  := TRSection():New( oSection1, "Tipificação", {"CT1"}, aOrdem, .F., .F. ) //"Conta Contábil"

	If MV_TPO01 > 0
		cTitCpo := Eval( bTitulo, ( "CT1_TPO" + StrZero( MV_TPO01, 2 ) ) )
		TRCell():New( oSection11, "CT1_TPO01"		,"CT1" , cTitCpo,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || &( "CT1->CT1_TPO" + StrZero( MV_TPO01, 2 ) ) } )
		oSection11:Cell( 'CT1_TPO01' ):SetHeaderAlign( 'LEFT' )
	EndIf

	If MV_TPO02 > 0
		cTitCpo := Eval( bTitulo, ( "CT1_TPO" + StrZero( MV_TPO02, 2 ) ) )
		TRCell():New( oSection11, "CT1_TPO02"		,"CT1" , cTitCpo,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || &( "CT1->CT1_TPO" + StrZero( MV_TPO02, 2 ) ) } )
		oSection11:Cell( 'CT1_TPO02' ):SetHeaderAlign( 'LEFT' )
	EndIF

	If MV_TPO03 > 0
		cTitCpo := Eval( bTitulo, ( "CT1_TPO" + StrZero( MV_TPO03, 2 ) ) )
		TRCell():New( oSection11, "CT1_TPO03"		,"CT1" , cTitCpo,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || &( "CT1->CT1_TPO" + StrZero( MV_TPO03, 2 ) ) } )
		oSection11:Cell( 'CT1_TPO03' ):SetHeaderAlign( 'LEFT' )
	EndIf

	If MV_TPO04 > 0
		cTitCpo := Eval( bTitulo, ( "CT1_TPO" + StrZero( MV_TPO04, 2 ) ) )
		TRCell():New( oSection11, "CT1_TPO04"		,"CT1" , cTitCpo,/*Picture*/,/*Tamanho*/,/*lPixel*/, { || &( "CT1->CT1_TPO" + StrZero( MV_TPO04, 2 ) ) } )
		oSection11:Cell( 'CT1_TPO04' ):SetHeaderAlign( 'LEFT' )
	EndIf
EndIf

oSection1:SetTotalInLine(.F.)

Return(oReport)   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 01/08/06 ³±±
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
Local nIndexC 		:= 0
Local cTipoAnt      := ""
Local cFilter		:= ""
Local oSection1 	:= oReport:Section(1)
Local oSection11 

aCtbMoeda  	:= CtbMoeda( mv_par06 )
If Empty(aCtbMoeda[1])                       
	Help(" ",1,"NOMOEDA")
	Return
Endif

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Add por Icaro Queiroz | Claudio - em 24 de Agosto de 2010      ³
//*³Caso seja chamado do CTBR015, imprime as calunas de tipificacao³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Upper( FunName() ) == 'CTBR015'
	If 	CT1->( FieldPos( "CT1_TPO01" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO02" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO03" ) ) > 0 .And.;
		CT1->( FieldPos( "CT1_TPO04" ) ) > 0

		oSection11 	:= oReport:Section(1):Section(1)

		oSection11:SetParentFilter( {|cParam|	CT1->CT1_CONTA == cParam }, {|| CT1->CT1_CONTA } )
	Endif
EndIf

titulo:= OemToAnsi(STR0008)

oReport:SetPageNumber( mv_par04 ) //mv_par04 - Pagina Inicial
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDatabase,titulo,,,,,oReport) } )

cFilter := ""

cFilter :=  U_AddcFilC( cFilter , "CT1->CT1_FILIAL = '" + xFilial("CT1") + "'" )

IF ! Empty( mv_par01 ) .AND. ( mv_par01 <> NIL )
	cFilter :=  U_AddcFilC( cFilter , "CT1->CT1_CONTA  >= '" + mv_par01 + "'" )
Endif

If ! Empty( mv_par02 ) .And. ( mv_par02 <> NIL )
	cFilter :=  U_AddcFilC( cFilter , "CT1->CT1_CONTA  <= '" + mv_par02 + "'" )
Endif


IF mv_par03 == 2
	cFilter :=  U_AddcFilC( cFilter , "CT1->CT1_NCUSTO = 0" )
EndIF

If mv_par05 == 1
	cFilter :=  U_AddcFilC( cFilter , "CT1->CT1_CLASSE = '2'" )

Elseif mv_par05 == 2
	cFilter :=  U_AddcFilC( cFilter , "CT1->CT1_CLASSE = '1'" )
EndIf

If mv_par07 == 2
	cFilter :=  U_AddcFilC( cFilter , "CT1->CT1_BLOQ = '2'" )
EndIf

oSection1:SetFilter( cFilter )  

nIndexC := oSection1:GetOrder()

If nIndexC > 1
	oSection1:SetIdxOrder(6)
Endif
                                                 
oSection1:OnPrintLine( {|| U_CT10onpC( oReport ) })

oSection1:Print()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT10onprint ºAutor  ³Renato F. Campos    º Data ³  03/27/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Regra para pular linha do relatorio                          º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function U_CT10onpC( oReport )
Local lPula	:= Iif( mv_par10 == 1 , .T. , .F. )

IF lPula .And. CT1->CT1_CLASSE == "1"
	oReport:skipLine()	
Endif     

If mv_par09 == 1 .And. Empty(CT1->CT1_CTASUP)
	oReport:EndPage()
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AddcFilter ºAutor  ³Renato F. Campos    º Data ³  03/15/07      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para adicionar no filtro uma nova condição, respeitando º±±
±±º          ³ a string jah informada                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
FUNCTION U_AddcFilC( cStrFilter , cStrAdd )
	LOCAL cCond := " "

	DEFAULT cStrFilter := ""
	
	If cStrAdd == Nil .OR. Empty( cStrAdd )
	   Return " "
	Endif
	
	IF ! Empty( cStrFilter ) .And. ( cStrFilter <> Nil )
		cCond += " .And. "
	Endif
	
	cStrFilter := cStrFilter + cCond + cStrAdd

RETURN cStrFilter

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctbr010R3 ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 10/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Impressao do Plano de Contas              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_Ctbr010C()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function U_Ctbr012C(wnRel,dDataRef,cMoeda)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cString	:="CT1"
LOCAL aOrd	 	:= {OemToAnsi(STR0004),OemToAnsi(STR0005)}  //"Conta"###"Descri‡„o"
LOCAL cDesc1 	:= OemToAnsi(STR0001)  //"Este programa ir  imprimir o Plano de Contas."
LOCAL cDesc2 	:= OemToAnsi(STR0002)  //"Ser  impresso de acordo com os parƒmetros solicitados pelo"
LOCAL cDesc3 	:= OemToAnsi(STR0003)  //"usu rio."
Local lExterno 	:= wnRel <> Nil
Local lAltom := FWIsInCallStack("UTSTARTRPT") 
DEFAULT dDataRef:= dDataBase

//PRIVATE Tamanho	:=If(lExterno, "M", "G")
PRIVATE Tamanho := "M"
PRIVATE aReturn := { OemToAnsi(STR0006), 1,OemToAnsi(STR0007), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="CTBR010"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="CTR010"

li       := 80

Pergunte( "CTR010" , .F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01		// da conta                             	³
//³ mv_par02      	// ate a conta                          	³
//³ mv_par03      	// imprime centro de custo               	³ 
//³ mv_par04      	// folha inicial		         			³
//³ mv_par05		// Analitica - Sintetica - Todas        	³ 
//³ mv_par06		// Desc na Moeda						   	³ 
//³ mv_par07		// Imprime Bloqueadas?         	       		³ 
//³ mv_par08		// Mascara                    	       		³ 
//³ mv_par09		// Salta Pagina Novo Grupo?    	       		³ 
//³ mv_par10		// Salta linha sintetica ?			    	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE titulo:= OemToAnsi(STR0008)  //"Listagem do Plano de Contas"
PRIVATE cabec1 := ""  //"CONTA                          DC COD.RES.   D E N O M I N A C A O                    CLASSE COND NORMAL CTA SUPERIOR         BLOQ"
PRIVATE cabec2 := " "
PRIVATE cCancel:= OemToAnsi(STR0010)  //"***** CANCELADO PELO OPERADOR *****"

If ! lExterno
	wnrel:="CTBR010"            //Nome Default do relatorio em Disco
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
Else
	mv_par01 := Repl(" ", Len(mv_par01))
	mv_par02 := Repl("Z", Len(mv_par02))
	mv_par06 := cMoeda
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTr010Imp(@lEnd,wnRel,cString,lExterno)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ctr010Imp³ Autor ³ Pilar S Albaladejo    ³ Data ³ 10/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Impressao do Plano de Contas              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_Ctbr010C(lEnd,wnRel,cString)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBR010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctr010Imp(lEnd,WnRel,cString,lExterno)

Local aCtbMoeda	:= {}
Local cMascara
Local cSeparador 	:= "", nImprime := 1
Local lPula			:= Iif(mv_par10==1,.T.,.F.) 
Local lJaPulou		:= .F.
Local nLenMasc		:= TAMSX3("CT1_CONTA")[1]
Local nMasc			:= 1
Local nMaxCol		:= 220
Local cContaAnt		:= '' // verificação da conta anterior, usado para o saldo da linha
Local cClasseAnt	:= '' // verificação da conta anterior, usado para o saldo da linha
Local lImprime 		:= .T. 
Local cAlias		:= "CT1"
Local aCampos

If Tamanho == "M"
	nMaxCol := 132
Endif

//Verifica moeda 
aCtbMoeda  	:= CtbMoeda( mv_par06 )

If Empty( aCtbMoeda[1] )
	Help( " " , 1 , "NOMOEDA" )
	Return
Endif

If Empty( mv_par08 )
	cMascara := GetMv( "MV_MASCARA" )
Else
	cMascara := RetMasCtb( mv_par08 , @cSeparador )
EndIf

// Verifica ordem a ser impressa                                
nOrdem := aReturn[8]

dbSelectArea( "CT1" )

IF nOrdem == 2
	cChave 	:= "CT1_FILIAL + CT1_DESC" + mv_par06
	cIndex	:= CriaTrab(nil,.f.)

	IndRegua("CT1",cIndex,cChave,, "CT1_CONTA >= '" + mv_par01 + "' .And. " +;
									"CT1_CONTA <= '" + mv_par02 + "'",OemToAnsi(STR0011)) //"Selecionando Registros..."
	nIndex	:= RetIndex("CT1")

	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF

	dbSetOrder( nIndex + 1 )
	dbSeek( xFilial("CT1" ) )
Else
	dbSetOrder( 1 )
	dbSeek( xFilial("CT1") + mv_par01 , .T. )
End

SetRegua(RecCount())   						// Total de elementos da regua

If nOrdem == 1
	dbSelectArea("CT1")
	dbSetOrder(1)

	cCondicao:=	"CT1->CT1_FILIAL == xFilial('CT1') .And. CT1->CT1_CONTA <= mv_par02 .And. ! CT1->( Eof() )"

	If SuperGetMv("MV_CTASUP") = "S"

		aCampos := { { "CONTA"    , "C", Len(CT1->CT1_CONTA), 0 },;
				   	 { "SUPERIOR" , "C", Len(CT1->CT1_CONTA), 0 },;
				     { "ORDEMPRN" , "N", 6                  , 0 },; 
				     { "RECNO"    , "N", 6                  , 0 }}

		If __oTempTable <> Nil
			__oTempTable:Delete()
			__oTempTable := Nil
		Endif
		
		__oTempTable := FWTemporaryTable():New( "cArqTmpI" )  
		__oTempTable:SetFields(aCampos) 
		__oTempTable:AddIndex("1", {"CONTA"})
		__oTempTable:AddIndex("2", {"ORDEMPRN"})
		__oTempTable:AddIndex("3", {"SUPERIOR"})		
		
		//------------------
		//Criação da tabela temporaria
		//------------------
		__oTempTable:Create()  
		
		DbSetOrder(0)
        
		dbSelectArea("CT1")
        DbGoTop()
		DbSetOrder(1)
		CT1->(dbSeek(xFilial("CT1")))

		While &cCondicao
			cArqTmpI->( DbAppend() )

			Replace cArqTmpI->CONTA    With CT1->CT1_CONTA ;
			 	  , cArqTmpI->SUPERIOR With CT1->CT1_CTASUP;
				  ,	cArqTmpI->RECNO    With CT1->( Recno() )

			DbSkip()
		EndDo
		
		cCondicao := "! Eof()"
		DbSelectArea("cArqTmpI")
		DbSetOrder(2)
		DbGoTop()

		cAlias := "cArqTmpI"
	Endif
Else
	dbSelectarea( "CT1" )
	dbSetOrder( nIndex + 1 )
	CT1->(dbSeek(xFilial("CT1")))
	cCondicao := "CT1_FILIAL == xFilial('CT1') .And. !Eof()"

	cAlias := "CT1"
EndIF

If ! lExterno
	m_pag:=mv_par04
Endif

nColDC		:= nLenMasc+1
nColRES		:= nLenMasc+4
nColDESC	:= nLenMasc+15
nColCLASSE	:= nLenMasc+56
nColNORMAL	:= nLenMasc+68
nColCTASUP	:= nLenMasc+78
nColBLOQ	:= nColCTASUP+Len(CT1->CT1_CTASUP)+1

cabec1 := PADR(STR0009,nLenMasc)+" "+Padr(STR0019,nColRES-nColDC)+PADR(STR0020,nColDESC-nColRES)
cabec1 += PADR(STR0021,nColCLASSE-nColDESC)+PADR(STR0022,nColNORMAL-nColCLASSE)
cabec1 += PADR(STR0023,nColCTASUP-nColNORMAL)+PADR(STR0024,nColBLOQ-nColCTASUP)
If ! lExterno
	SetDefault(aReturn,cString)
	Cabec1 += STR0025
Else
	Cabec1 += STR0018 //"CL/CON"
Endif
cabec1 := OemToAnsi(cabec1)

If nOrdem == 1

	DbSelectArea( cAlias )

EndIf	
	
While &cCondicao 

	lImprime := .T. 

	If lEnd 	
		@Prow()+1,001 PSAY cCancel
		Exit
	EndIF
     
	IncRegua()

	If ( cAlias == "cArqTmpI" )
		CT1->( MsGoto( cArqTmpI->RECNO ))
	Endif

	IF ! Empty( mv_par01 ) .And. mv_par01 <> nil
	    IF CT1->CT1_CONTA < mv_par01
			lImprime := .F. 
	    ENDIF
	EndIf

	IF mv_par03 == 2
 		IF CT1->CT1_NCUSTO > 0
			lImprime := .F. 
		EndIF
	EndIF

	If mv_par07 == 2
		If CT1->CT1_BLOQ == "1"				// Conta Bloqueada
			lImprime := .F. 
		EndIf
	EndIf

	If mv_par05 == 1						// Imprime Analiticas
		If CT1->CT1_CLASSE == "1"
			lImprime := .F. 
		EndIf

	ElseIF mv_par05 == 2					// Imprime Sinteticas
		IF CT1->CT1_CLASSE = "2"
			lImprime := .F. 
		EndIf
	
	EndIf

    If lImprime // verifica se imprime a linha
		If nOrdem == 1
			If mv_par09 == 1						// Salta pagina quando muda de grupo 
				If Empty(CT1->CT1_CTASUP)
					li := 65
				EndIf
			EndIf		
		EndIf
		
	
		IF li > 55
			CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			li--
		EndIF
	
		cCodigo	:=	Alltrim(CT1->CT1_CONTA)
		cDesc := &('CT1->CT1_DESC' + mv_par06 )
	
		li++
	
		EntidadeCTB(CT1->CT1_CONTA,li,000,nLenMasc,.F.,cMascara,cSeparador)
		
		@li, nColDC 	PSAY CT1->CT1_DC        
		@li, nColRES 	PSAY Left(CT1->CT1_RES,10)
		@li, nColDESC 	PSAY Left(cDesc,40)
		
		If CT1->CT1_CLASSE == '1'
			@li, nColCLASSE PSAY STR0014
		ElseIf CT1->CT1_CLASSE == '2'
			@li, nColCLASSE PSAY STR0015
		EndIf
	
		If ! lExterno	
			If CT1->CT1_NORMAL == '1'
				@li, nColNORMAL PSAY STR0016
			ElseIf CT1->CT1_NORMAL =='2'
				@li, nColNORMAL PSAY STR0017
			EndIf
			
			@li, nColCTASUP PSAY CT1->CT1_CTASUP
			If CT1->CT1_BLOQ == "1"	
				@li, nColBLOQ PSAY OemToAnsi(STR0012)	//Sim
	
			ElseIf CT1->CT1_BLOQ == "2"	
				@li, nColBLOQ PSAY OemToAnsi(STR0013)	// Nao
			EndIf
		Else
			If CT1->CT1_NORMAL == '1'
				@li, nColNORMAL PSAY "- " + STR0016
	
			ElseIf CT1->CT1_NORMAL =='2'
				@li, nColNORMAL PSAY "- " + STR0017
			EndIf
		Endif
		
		lJaPulou := .F.
    Endif

	( cAlias )->( dbSkip() )

	If ( cAlias == "cArqTmpI" )
		CT1->( MsGoto( cArqTmpI->RECNO ))
	Endif

	// Pula linha entre sinteticas
	IF ! lJaPulou .And. lPula .And. ( CT1->CT1_CLASSE == "1" )
		li += 1
		@li,00 PSAY REPLICATE( " "  , nMaxCol )		
		lJaPulou := .T.
	EndIf			

EndDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se emissao foi alfabetica, deleta arquivo de trabalho        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 2
	dbSelectArea("CT1")
	dbClearFilter()
	RetIndex( "CT1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
EndIf

dbSelectarea( "CT1" )
dbSetOrder( 1 )

Set Filter To
If aReturn[5] = 1 .And. ! lExterno
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

If Select("cArqTmpI") > 0
	("cArqTmpI")->(DbCloseArea())
Endif

If lExterno .and. Select("cArqTmp") > 0
	("cArqTmp")->(DbCloseArea())
Endif

If ! lExterno
	MS_FLUSH()
Endif

//Exclui tabela temporaria do banco de dados
If __oTempTable <> Nil
	__oTempTable:Delete()
	__oTempTable := Nil
Endif
	

Return
