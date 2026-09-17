#Include "CTR302C.Ch"
#Include "PROTHEUS.Ch"

#DEFINE TAM_VALOR	17
#DEFINE TAM_SALDO  19

STATIC lIsRussia	:= If(cPaisLoc$"RUS",.T.,.F.) // CAZARINI - Flag to indicate if is Russia location

// 17/08/2009 -- Filial com mais de 2 caracteres

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ CTBR302  ณ Autor ณ Jonathan Gonzalez   	ณ Data ณ10/03/2014ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Informe de Centro de Costos en 2 monedas                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ Ctbr302                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum       										           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ SIGACTB                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Function U_CTBR303C()

Local aArea		:= GetArea()
Local oReport          
Local lOk			:= .T.
Local lAtSlComp	:= Iif(GETMV("MV_SLDCOMP") == "S",.T.,.F.)
Local lSchedule	:= IsBlind()
Local nGeren		:= 0
Local cFilIni		:= cFilAnt  

PRIVATE cTipoAnt	:= "" // Pular sinteticas
PRIVATE cPerg		:= "CTR302"
PRIVATE nomeProg  := "CTBR302"
PRIVATE titulo
Private aSelFil	:= {}

//Valida็ใo de aviso/bloqueio do relat๓rio em Release 12.1.2510 e superiores
If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	lOk := .F.
EndIf 

If !FWGetRunSchedule()	     
	Pergunte( CPERG, .T. )
EndIf
 		
If lOk .And. mv_par24 == 1 .And. Len( aSelFil ) <= 0 .And. !lSchedule
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		lOk := .F.
	EndIf 
EndIf  
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Mostra tela de aviso - atualizacao de saldos            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cMensagem := OemToAnsi(STR0014)+chr(13)  		//"Si no se actualizan los saldos compuestos en"
cMensagem += OemToAnsi(STR0015)+chr(13)  		//"la emision de los informes (MV_SLDCOMP ='N'),"
cMensagem += OemToAnsi(STR0016)+chr(13)  		//"ejecute la rutina de actualizacion de saldos"
	
IF !lAtSlComp .and. ! lSchedule
	If !MsgYesNo(cMensagem,OemToAnsi(STR0017))	//"ATENCON"
		lOk := .F.
	EndIf
Endif

//Cria matriz para armazenar os parametros do filtro por plano gerencial, se o usuแrio 
//optar por esta opcao. 
Private aGeren := { "","","","","","","",""}              

For nGeren :=1 To Len(aGeren)
	aGeren[nGeren] := Space(Len(CriaVar("CT1_CONTA")))
Next	   
	
If ! lSchedule
	CtbTxtGer()
EndIf	

If SM0->M0_CODIGO <> cEmpAnt
	dbSelectArea("SM0")  //tratamento do SM0 para empresas que contem letras e numeros.
   	DbSeek(cEmpAnt+cFilAnt)
Endif

If lOk
	oReport := ReportDef(cPerg,lSchedule,aSelFil)
	oReport:PrintDialog()
EndIf

//Limpa os arquivos temporแrios 
CTBGerClean()

RestArea(aArea)   
cFilAnt := cFilIni

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDef บ Autor ณ Jonathan Gonzalez  บ Data ณ 10/03/2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Definicion de los secciones del reporte C. Costo           บฑฑ
ฑฑบ          ณ en 2 Monedas                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cPerg - Codigo do Grupo de Perguntas                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACTB                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportDef(cPerg,lSchedule,aSelFil)

Local oReport
Local oSCtrCC                        
Local oTotais 

Local cSayCC		:= CtbSayApro("CTT")

//"Este informe va a comparar el Saldo Anterior, D้bito, Cr้dito ....."
Local cDesc		:= OemToAnsi(STR0001) + OemToansi(STR0002)
Local aTamCC  		:= TamSX3("CTT_CUSTO")
Local cMoneda		:=iif(Empty(mv_par08), "01", PADL(AllTrim(mv_par08), 2, "0"))

Default aSelFil := {}
 
titulo := OemToAnsi(STR0003) //BALANCE DE CENTRO DE OSTOS EN 2 MONEDAS

oReport := TReport():New(nomeProg,titulo,cPerg,{|oReport| Iif( ReportPrint(oReport,cSayCC,lSchedule,aSelFil), .T., oReport:CancelPrint() )},cDesc)
oReport:Setlandscape(.F.)//Pag Horizontal	
oReport:SetTotalInLine(.F.)
oReport:EndPage(.T.)
//oReport:SetPortrait()
oReport:ParamReadOnly(.T.)

// Sessao 1
oSCtrCC := TRSection():New(oReport,cSayCC,{"cArqTmp","CTT"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	
oSCtrCC:SetTotalInLine(.F.)
oSCtrCC:SetHeaderPage()

TRCell():New(oSCtrCC,"CUSTO"	,"cArqTmp",STR0018			  ,/*Picture*/,aTamCC[1]+6	,/*lPixel*/,/*{|| code-block }*/ )// "CODIGO"
TRCell():New(oSCtrCC,"DESCCC"	,"cArqTmp",STR0019			  ,/*Picture*/,/*Size*/	,/*lPixel*/,/*{|| code-block }*/ )// "D E S C R I C A O"
TRCell():New(oSCtrCC,"SALDOANT"	,"cArqTmp",STR0020			  ,/*Picture*/,TAM_SALDO	,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")	//"SALDO ANTERIOR"
TRCell():New(oSCtrCC,"SALDOANC"	,"cArqTmp",STR0020 + cMoneda  ,/*Picture*/,TAM_SALDO	,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")	//"SALDO ANTERIOR 02"
TRCell():New(oSCtrCC,"SALDODEB"	,"cArqTmp",STR0033		      ,/*Picture*/,TAM_VALOR	,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")	//"DEBITO"
TRCell():New(oSCtrCC,"SALDODEC"	,"cArqTmp",STR0033 + cMoneda  ,/*Picture*/,TAM_VALOR	,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")	//"DEBITO 02"
TRCell():New(oSCtrCC,"SALDOCRD"	,"cArqTmp",STR0032			  ,/*Picture*/,TAM_VALOR	,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")	//"CREDITO"
TRCell():New(oSCtrCC,"SALDOCRC"	,"cArqTmp",STR0032 + cMoneda  ,/*Picture*/,TAM_VALOR	,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")	//"CREDITO 02"
TRCell():New(oSCtrCC,"SALDOATU"	,"cArqTmp",STR0024			  ,/*Picture*/,TAM_SALDO	,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")	//"SALDO ATUAL"
TRCell():New(oSCtrCC,"SALDOATC"	,"cArqTmp",STR0024 + cMoneda  ,/*Picture*/,TAM_SALDO	,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")	//"SALDO ATUAL 02"

TRPosition():New( oSCtrCC, "CTT", 1, {|| xFilial("CTT") + cArqTMP->CUSTO  })

oTotais := TRSection():New( oReport,STR0025,,, .F., .F. )	//"Totais" 
TRCell():New( oTotais,"TOT"		,, STR0019					,/*Picture*/,,/*lPixel*/,/*{|| code-block }*/)	//"D E S C R I C A O"
TRCell():New( oTotais,"TOT_ANT"	,, STR0020					,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")//"SALDO ANTERIOR"
TRCell():New( oTotais,"TOT_ANC"	,, STR0020 + cMoneda		,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")//"SALDO ANTERIOR 02"
TRCell():New( oTotais,"TOT_DEB"	,, STR0033					,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")//"DEBITO"
TRCell():New( oTotais,"TOT_DEC"	,, STR0033 + cMoneda		,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")//"DEBITO 02"
TRCell():New( oTotais,"TOT_CRD"	,, STR0032					,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")//"CREDITO"
TRCell():New( oTotais,"TOT_CRC"	,, STR0032 + cMoneda		,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")//"CREDITO 02"
TRCell():New( oTotais,"TOT_ATU"	,, STR0024					,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")//"SALDO ATUAL"
TRCell():New( oTotais,"TOT_ATC"	,, STR0024 + cMoneda		,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block }*/,/*"RIGHT"*/,,"CENTER")//"SALDO ATUAL 02"

oSCtrCC:Cell("SALDOANT")	:lHeaderSize  := .F.    
oSCtrCC:Cell("SALDOANC")	:lHeaderSize  := .F. 
oSCtrCC:Cell("SALDODEB")	:lHeaderSize  := .F.    
oSCtrCC:Cell("SALDODEC")	:lHeaderSize  := .F.
oSCtrCC:Cell("SALDOCRD")	:lHeaderSize  := .F.      
oSCtrCC:Cell("SALDOCRC")	:lHeaderSize  := .F.
oSCtrCC:Cell("SALDOATU")	:lHeaderSize  := .F.    
oSCtrCC:Cell("SALDOATC")	:lHeaderSize  := .F.   
  
oTotais:Cell("TOT_ANT")	:lHeaderSize := .F.
oTotais:Cell("TOT_ANC")	:lHeaderSize := .F.
oTotais:Cell("TOT_DEB")	:lHeaderSize := .F.
oTotais:Cell("TOT_DEC")	:lHeaderSize := .F.
oTotais:Cell("TOT_CRD")	:lHeaderSize := .F.
oTotais:Cell("TOT_CRC")	:lHeaderSize := .F.
oTotais:Cell("TOT_ATU")	:lHeaderSize := .F.
oTotais:Cell("TOT_ATC")	:lHeaderSize := .F.

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrintบ Autor ณ Jonathan Gonzalez  บ Data ณ 10/04/2014 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Funcion de impresiond del reporte C. Coosto en 2 Monedas   บฑฑ
ฑฑบ          ณ segun la funcion ReportDef() y los paramttros del grupo    บฑฑ
ฑฑบ          ณ preguntas "CTR302"                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportPrint(oReport,cSayCC,lSchedule,aSelFil)

Local oSCtrCC 		:= oReport:Section(1)
Local oTotais	 	:= oReport:Section(2)
Local oMeter		:= NIL
Local oText 		:= NIL 
Local oDlg			:= NIL   
Local aSetOfBook 	:= CTBSetOf(mv_par06)		
Local aCtbMoeda	:= {}
Local cArqTmp		:= ""
Local cFiltro		:= oSCtrCC:GetAdvplExp()
Local cCtaIni		:= Space(Len(CriaVar("CT1_CONTA")))
Local cCtaFim		:= Repl('Z',Len(CriaVar("CT1_CONTA")))            
Local lImpSint		:= (mv_par05=1 .Or. mv_par05 ==3)
Local cSegAte 	   	:= mv_par11 // Imprimir ate o Segmento?
Local nDigitAte	:= 0
Local cSeparador	:= ""
Local cMoeda		:= mv_par08
Local dDataFim 	:= mv_par02
Local dDataLP  	:= mv_par22
Local lImpAntLP	:= (mv_par21==1)
Local lVlrZerado	:= (mv_par07==1) 
Local lPrintZero	:= (mv_par18==1)
Local l132			:=.T.// Se imprime saldo movimento do periodo
Local lImpConta	:= .F.
Local lPula		:= (mv_par17==1) 
Local lNormal		:= (mv_par19==1)
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotSldAnt	:= 0
Local nTotSldAtu	:= 0
Local nTamCC  		:= 0
Local nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)
Local nDivide		:= 0 
Local cMascara		:= IIF (Empty(aSetOfBook[6]),GetMv("MV_MASCCUS"),RetMasCtb(aSetOfBook[6],@cSeparador))// Mascara do Centro de Custo                  
Local cPicture 	:= Iif(!Empty(aSetOfBooks[4]),"@E 9,999,999,999.99","")
Local cDescMoeda 	:= ""
Local lColDbCr 		:= If(cPaisLoc $ "RUS",.T.,.F.) // Disconsider cTipo in ValorCTB function, setting cTipo to empty
Local lRedStorn		:= If(cPaisLoc $ "RUS",SuperGetMV("MV_REDSTOR",.F.,.F.),.F.) // CAZARINI - 20/06/2017 - Parameter to activate Red Storn
Local lRet			:= .T.
Local cFilCTP 		:= xfilial("CTP")
Local lEnd			:= .F.

Private nTaxa
Private cTipoMoneda	:= "01"  // Inclucion de variable propia

Default lSchedule := FWGetRunSchedule()
Default aSelFil	  := {}

cMoeda := iif(Empty(cMoeda), "01", PADL(AllTrim(cMoeda), 2, "0"))

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//Valida que la moneda sea diferente de "01" y que no se a nula
If lRet

	If EMPTY(cMoeda) .Or. Val(cMoeda) < 1
	
		cMensagem	:= STR0027	//"el campo de Comparar con moneda es requerido"
		MsgAlert(cMensagem,STR0026)//MONEDA
		lRet    	:= .F.	
	    Return lRet
	    
	elseif cMoeda == "01"
	
		cMensagem	:= STR0028	//"Se va a comparar con el mismo tipo de moneda, seleccionar otra.""
		MsgAlert(cMensagem,STR0026) //MONEDA
		lRet    	:= .F.	
	    Return lRet   
	    	
    EndIf
    
EndIf

nTamCC := Len(CriaVar("CTT->CTT_DESC"+cMoeda))
	
DbSelectArea("CTP") 
DbSetOrder(2) 
If lRet
	If DbSeek(cFilCTP + cMoeda + DTOS(MV_PAR16))
		nTaxa := CTP_TAXA
	else
		MsgAlert(STR0031,STR0026) // "No se encontro tipo de cambio" , //moneda
		lRet    	:= .F.	
	    Return lRet
    EndIf
EndIf
If nTaxa == 0
	nTaxa := 1
Endif
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

If lSchedule
	mv_par23 := 2
EndIf	         

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se usa Set Of Books + Plano Gerencial (Se usar Planoณ
//ณ Gerencial -> montagem especifica para impressao)             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !ct040Valid(mv_par06) // Set Of Books
	Return .F.
EndIf 

If mv_par20 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par20 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par20 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	              

aCtbMoeda 	:= CtbMoeda(cMoeda,nDivide)
cDescMoeda	:= aCtbMoeda[2]

// Valida a Moeda
If Empty(aCtbMoeda[1])
	If ! lSchedule
 		Help(" ",1,"NOMOEDA")
 	EndIf
	Return .F.
EndIf

oTotais:Cell("TOT_ANT")	:HideHeader()
oTotais:Cell("TOT_ANC")	:lHeaderSize := .F.
oTotais:Cell("TOT_DEB")	:lHeaderSize := .F.
oTotais:Cell("TOT_DEC")	:lHeaderSize := .F.
oTotais:Cell("TOT_CRD")	:lHeaderSize := .F.
oTotais:Cell("TOT_CRC")	:lHeaderSize := .F.
oTotais:Cell("TOT_ATU")	:lHeaderSize := .F.
oTotais:Cell("TOT_ATC")	:lHeaderSize := .F.

If lNormal
	oSCTrCC:Cell("CUSTO"):SetBlock( { || Iif(cArqTmp->TIPOCC=="1","","  ")+EntidadeCTB(cArqTmp->CUSTO,0,0,20,.F.,cMascara,cSeparador,,,,,.F.) } )
Else
	oSCTrCC:Cell("CUSTO"):SetBlock( { || Iif(cArqTmp->TIPOCC=="1",	EntidadeCTB(cArqTmp->CUSTO,0,0,20,.F.,cMascara,cSeparador,,,,,.F.),;
		  											"  " + EntidadeCTB(cArqTmp->CCRES,0,0,20,.F.,cMascara,cSeparador,,,,,.F.) ) } )
EndIf

// Define o tamanho da descricao do CC
oSCTrCC:Cell("DESCCC"):SetSize(nTamCC)
                                      
// Define o tamanho da descricao da secao de totais
oTotais:Cell("TOT"):SetSize(56)

oSCtrCC:OnPrintLine( {|| cFilAnt := cArqTmp->FILIAL,;
					 ( IIf( lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCC == "1" .And. cTipoAnt == "2")), oReport:SkipLine(),NIL),;
								 cTipoAnt := cArqTmp->TIPOCC ) } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza titulo do relatorio: Analitico / Sintetico			  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF mv_par05 == 1
	Titulo:=	OemToAnsi(STR0006) + Upper(cSayCC)	//"BALANCETE SINTETICO"
ElseIf mv_par05 == 2
	Titulo:=	OemToAnsi(STR0005) + Upper(cSayCC) 	//"BALANCETE ANALITICO"
ElseIf mv_par05 == 3
	Titulo:=	OemToAnsi(STR0007) + Upper(cSayCC)	//"BALANCETE "
EndIf
//BALANCE DE CENTRO DE COSTOS EN 2 MONEDAS DE 99/99/9999 A 99/99/9999 EN CDESCMOEDA. TIPOD E CAMBIO AL DIA 99/99/9999 DE NTAXA
Titulo += 	OemToAnsi(STR0008) + DTOC(mv_par01) + OemToAnsi(STR0009) + Dtoc(mv_par02) + ;
			OemToAnsi(STR0010) + RTRIM(cDescMoeda) + OemToAnsi (STR0029) + DTOC(MV_PAR16) + OemToAnsi (STR0030)+  ALLTRIM(STR(nTaxa))
			
If mv_par10 > "1"
	Titulo += " (" + Tabela("SL", mv_par10, .F.) + ")"
EndIf

If nDivide > 1			
	Titulo += " (" + OemToAnsi(STR0013) + Alltrim(Str(nDivide)) + ")" //"DIV"
EndIf	

oReport:SetPageNumber(mv_par09) //mv_par09	-	Pagina Inicial
oReport:SetCustomText( { || CtCGCCabTR(,,,,,dDataFim,Titulo,,,,,oReport) } )

If mv_par23 == 1
	CtbOpGeren(mv_par23 == 1)
Else
	aGeren := Nil
EndIf	
              
#IFNDEF TOP
	If !Empty(cFiltro)
		CTT->( dbSetFilter( { || &cFiltro }, cFiltro ) )
	EndIf
#ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Arquivo Temporario para Impressao						  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lSchedule
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CTU","CTT",cCtaIni,cCtaFim,mv_par03,mv_par04,,,,,;
				 cTipoMoneda,mv_par10,aSetOfBook,mv_par12,;
				  mv_par13,mv_par14,mv_par15,l132,lImpConta,,,;
				   lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,aGeren,,lImpSint,cFiltro/*aReturn[7]*/)
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;					
				 CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				  mv_par01,mv_par02,"CTU","CTT",cCtaIni,cCtaFim,mv_par03,mv_par04,,,,,;
				   cTipoMoneda,mv_par10,aSetOfBook,mv_par12,;
				    mv_par13,mv_par14,mv_par15,l132,lImpConta,,,;
					 lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,aGeren,,lImpSint,cFiltro/*aReturn[7]*/,,,,,,,,,,,,aSelFil)},;
					  OemToAnsi(OemToAnsi(STR0011)),;  //"Criando Arquivo Tempor rio..."
					   OemToAnsi(STR0003)+cSayCC)     //"BALANCE DE CENTRO DE COSTOS EN 2 MONEDAS/"
					     			   
EndIf

If (select( 'cArqTmp' ) <= 0 ) 
	RETURN .F.
EndIf

oSCTrCC:Cell("SALDOANT"):SetBlock({|| ValorCTB(cArqTmp->SALDOANT ,,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.)})
oSCTrCC:Cell("SALDOANC"):SetBlock({|| ValorCTB(round(cArqTmp->SALDOANT / nTaxa,nDecimais) ,,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.)})

oSCTrCC:Cell("SALDODEB"):SetBlock({|| ValorCTB(cArqTmp->SALDODEB ,,,TAM_VALOR,nDecimais,.F.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.,lColDbCr)})
oSCTrCC:Cell("SALDODEC"):SetBlock({|| ValorCTB(round(cArqTmp->SALDODEB / nTaxa,nDecimais) ,,,TAM_VALOR,nDecimais,.F.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.,lColDbCr)})

oSCTrCC:Cell("SALDOCRD"):SetBlock({|| ValorCTB(cArqTmp->SALDOCRD ,,,TAM_VALOR,nDecimais,.F.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.,lColDbCr)})
oSCTrCC:Cell("SALDOCRC"):SetBlock({|| ValorCTB(round(cArqTmp->SALDOCRD / nTaxa,nDecimais),,,TAM_VALOR,nDecimais,.F.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.,lColDbCr)})

oSCTrCC:Cell("SALDOATU"):SetBlock({|| ValorCTB(cArqTmp->SALDOATU ,,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.)})
oSCTrCC:Cell("SALDOATC"):SetBlock({|| ValorCTB(round(cArqTmp->SALDOATU / nTaxa,nDecimais) ,,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.)})

                    
oReport:NoUserFilter()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia a impressao do relatorio                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("cArqTmp")
dbGotop()   
oReport:SetMeter( RecCount() )
cCCAnt := cArqTmp->CUSTO
oSCtrCC:Init()
Do While !Eof() .And. !oReport:Cancel()

    oReport:IncMeter()

    If oReport:Cancel()
    	Exit
    EndIf
    
	If f302Fil(cSegAte, nDigitAte,cMascara)
		dbSkip()
		Loop
	EndIf   

	nTotDeb 	+= f302Soma("D",cSegAte)
	nTotCrd 	+= f302Soma("C",cSegAte)
	nTotSldAnt	+= f302Soma("A",cSegAte)
	If !lRedStorn
		nTotSldAtu	+= f302Soma("T",cSegAte)
	Endif	

    oSCtrCC:PrintLine() //Section(1)   
    	
    dbSkip()
    	
EndDo

If lRedStorn
	nTotSldAtu := nTotSldAnt + (nTotDeb - nTotCrd)
Endif

oTotais:Cell("TOT"):SetTitle(OemToAnsi(STR0012))  		// "T O T A I S  D O  P E R I O D O: "

oTotais:Cell("TOT_ANT"):SetBlock( { || ValorCTB(nTotSldAnt,,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.,lColDbCr) } )
oTotais:Cell("TOT_ANC"):SetBlock( { || ValorCTB(round(nTotSldAnt / nTaxa,nDecimais),,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.,lColDbCr) } )
oTotais:Cell("TOT_DEB"):SetBlock( { || ValorCTB(nTotDeb,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr) } )
oTotais:Cell("TOT_DEC"):SetBlock( { || ValorCTB(round(nTotDeb / nTaxa,nDecimais),,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr) } )
oTotais:Cell("TOT_CRD"):SetBlock( { || ValorCTB(nTotCrd,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr) } )
oTotais:Cell("TOT_CRC"):SetBlock( { || ValorCTB(round(nTotCrd / nTaxa,nDecimais),,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr) } )
oTotais:Cell("TOT_ATU"):SetBlock( { || ValorCTB(nTotSldAtu,,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.,lColDbCr) } )
oTotais:Cell("TOT_ATC"):SetBlock( { || ValorCTB(round(nTotSldAtu / nTaxa,nDecimais),,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(lRedStorn,cArqTmp->CCNORMAL,cArqTmp->NORMAL),,,,,,lPrintZero,.F.,lColDbCr) } )


oTotais:Init()
oTotais:PrintLine()
oTotais:Finish()
oReport:SkipLine()

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
EndIf
dbselectArea("CT2")

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf302Soma  บAutor  ณJonathan Gonzalez   บ Data ณ  10/04/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTBR302                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function f302Soma(cTipo,cSegAte)

Local nRetValor		:= 0

	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If cArqTmp->TIPOCC == "1" .And. cArqTmp->NIVEL1
			If cTipo == "D"
				nRetValor := cArqTmp->SALDODEB
			ElseIf cTipo == "C"
				nRetValor := cArqTmp->SALDOCRD
			ElseIf cTipo == "A"
				nRetValor := cArqTmp->SALDOANT
			ElseIf cTipo == "T"
				nRetValor := cArqTmp->SALDOATU
			EndIf
		EndIf
	Else								// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If cArqTmp->TIPOCC == "2"
				If cTipo == "D"
					nRetValor := cArqTmp->SALDODEB
				ElseIf cTipo == "C"
					nRetValor := cArqTmp->SALDOCRD
				ElseIf cTipo == "A"
					nRetValor := cArqTmp->SALDOANT
				ElseIf cTipo == "T"
					nRetValor := cArqTmp->SALDOATU
				EndIf
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If cArqTmp->TIPOCC == "1" .And. cArqTmp->NIVEL1
				If cTipo == "D"
					nRetValor := cArqTmp->SALDODEB
				ElseIf cTipo == "C"
					nRetValor := cArqTmp->SALDOCRD
				ElseIf cTipo == "A"
					nRetValor := cArqTmp->SALDOANT
				ElseIf cTipo == "T"
					nRetValor := cArqTmp->SALDOATU
				EndIf
			EndIf
    	Endif
	EndIf

Return nRetValor


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf302Fil   บAutor  ณCicero J. Silva     บ Data ณ  24/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTBR302                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function f302Fil(cSegAte, nDigitAte,cMascara)

Local lDeixa	:= .F.

	If mv_par05 == 1					// So imprime Sinteticas
		If cArqTmp->TIPOCC == "2"
			lDeixa := .T.
		EndIf
	ElseIf mv_par05 == 2				// So imprime Analiticas
		If cArqTmp->TIPOCC == "1"
			lDeixa := .T.
		EndIf
	EndIf
	// Verifica Se existe filtragem Ate o Segmento
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)

		nDigitAte := CtbRelDig(cSegAte,cMascara) 	

		If Len(Alltrim(cArqTmp->CUSTO)) > nDigitAte
			lDeixa := .T.
		Endif
	EndIf

dbSelectArea("cArqTmp")

Return (lDeixa)

//-------------------------------------------------------------------
/*/{Protheus.doc} SchedDef
Retorna os parametros no schedule.

@return aReturn			Array com os parametros

@author  TOTVS
@since   07/04/2014
@version 12
/*/
//-------------------------------------------------------------------
Static Function SchedDef()

Local aParam  := {}

aParam := { "R",;			//Tipo R para relatorio P para processo
            "CTR302",;		//Pergunte do relatorio, caso nao use passar ParamDef
            ,;				//Alias
            ,;				//Array de ordens
            STR0003,;		//Titulo - Balanco de Centro de custo em 2 moedas
			,;				//Nome do Relat๓rio
			.F.,;			//Indica se permite que o agendamento possa ser cadastrado como sempre ativo
			.T. }			//Indica que o agendamento pode ser realizado por filiais

Return aParam
