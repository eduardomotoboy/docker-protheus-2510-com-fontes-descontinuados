#Include "CTBR200C.Ch"
#Include "PROTHEUS.Ch"

#DEFINE TAM_VALOR	17
#DEFINE TAM_SALDO  19
// 17/08/2009 -- Filial com mais de 2 caracteres

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณ CTBR200  ณ Autor ณ Cicero J. Silva   	ณ Data ณ 01.08.06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Balancete por Centro de Custo           			 		  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe	 ณ Ctbr200        											  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno	 ณ Nenhum       											  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso 		 ณ SIGACTB      											  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum													  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Function U_CTBR200C()

Local aArea := GetArea()
Local oReport          
Local lOk := .T.
Local lSchedule		:= IsBlind()
Local nGeren		:= 0
Local cFilIni		:= cFilAnt  

PRIVATE cTipoAnt	:= "" // Pular sinteticas
PRIVATE cPerg	 	:= "CTR200"
PRIVATE nomeProg  	:= "CTBR200"
PRIVATE titulo
Private aSelFil		:= {}
	
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
	oReport := ReportDef(cPerg,lSchedule)
	oReport:PrintDialog()
EndIf

//Limpa os arquivos temporแrios 
CTBGerClean()

RestArea(aArea)   
cFilAnt := cFilIni

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDef บ Autor ณ Cicero J. Silva    บ Data ณ  01/08/06  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Definicao do objeto do relatorio personalizavel e das      บฑฑ
ฑฑบ          ณ secoes que serao utilizadas                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cPerg - Codigo do Grupo de Perguntas                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACTB                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportDef(cPerg,lSchedule)

Local oReport
Local oSCtrCC                        
Local oTotais 
Local cSayCC		:= CtbSayApro("CTT")
LOCAL cDesc1		:= OemToAnsi(STR0001)+ Upper(cSayCC)	//"Este programa ira imprimir o Balancete de  "
LOCAL cDesc2		:= OemToansi(STR0002)  //"de acordo com os parametros solicitados pelo Usuario"
Local aTamCC  	:= TamSX3("CTT_CUSTO")
Local aTamCCRes 	:= TamSX3("CTT_RES")
 
titulo := OemToAnsi(STR0003)+ Upper(cSayCC) 	// Balancete de Verificacao por 

oReport := TReport():New(nomeProg,titulo,cPerg,{|oReport| Iif( ReportPrint(oReport,cSayCC,lSchedule), .T., oReport:CancelPrint() )},cDesc1+cDesc2)
	
oReport:SetTotalInLine(.F.)
oReport:EndPage(.T.)
oReport:SetPortrait(.T.)
oReport:ParamReadOnly(.T.)

// Sessao 1
oSCtrCC := TRSection():New(oReport,cSayCC,{"cArqTmp","CTT"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	
oSCtrCC:SetTotalInLine(.F.)
oSCtrCC:SetHeaderPage()

TRCell():New(oSCtrCC,"CUSTO"	,"cArqTmp",STR0026,/*Picture*/,aTamCC[1]+6	,/*lPixel*/, /*{|| code-block de impressao }*/ )	// "CODIGO"
TRCell():New(oSCtrCC,"DESCCC"	,"cArqTmp",STR0027,/*Picture*/,/*Size*/	,/*lPixel*/, /*{|| code-block de impressao }*/ )		// "D E S C R I C A O"
TRCell():New(oSCtrCC,"SALDOANT"	,"cArqTmp",STR0028,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"SALDO ANTERIOR"
TRCell():New(oSCtrCC,"SALDODEB"	,"cArqTmp",STR0029,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"DEBITO"
TRCell():New(oSCtrCC,"SALDOCRD"	,"cArqTmp",STR0030,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"CREDITO"
TRCell():New(oSCtrCC,"MOVIMENTO","cArqTmp",STR0031,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"MOVIMENTO DO PERIODO"
TRCell():New(oSCtrCC,"SALDOATU"	,"cArqTmp",STR0032,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"SALDO ATUAL"

TRPosition():New( oSCtrCC, "CTT", 1, {|| xFilial("CTT") + cArqTMP->CUSTO  })

oTotais := TRSection():New( oReport,STR0034,,, .F., .F. )	//"Totais"
TRCell():New( oTotais,"TOT"			,,STR0027,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)	//"D E S C R I C A O"
TRCell():New(oTotais," "	    ,,,/*Picture*/,aTamCC[1]+6	,/*lPixel*/, /*{|| code-block de impressao }*/ )	// "DESCRIวรO EM BRANCO PARA ALINHAMENTO"
TRCell():New( oTotais,"TOT_ANT"		,,STR0028,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"SALDO ANTERIOR"
TRCell():New( oTotais,"TOT_DEBITO"	,,STR0029,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"DEBITO"
TRCell():New( oTotais,"TOT_CREDITO"	,,STR0030,/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"CREDITO"
TRCell():New( oTotais,"TOT_MOV"		,,STR0031,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"MOVIMENTO DO PERIODO"
TRCell():New( oTotais,"TOT_ATU"		,,STR0032,/*Picture*/,TAM_SALDO,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"CENTER")	//"SALDO ATUAL"

oSCtrCC:Cell("SALDOANT"):lHeaderSize  := .F.    
oSCtrCC:Cell("SALDODEB"):lHeaderSize  := .F.    
oSCtrCC:Cell("SALDOCRD"):lHeaderSize  := .F.    
oSCtrCC:Cell("MOVIMENTO"):lHeaderSize := .F.    
oSCtrCC:Cell("SALDOATU"):lHeaderSize  := .F.    

oTotais:Cell("TOT_ANT"):lHeaderSize     := .F.
oTotais:Cell("TOT_DEBITO"):lHeaderSize  := .F.
oTotais:Cell("TOT_CREDITO"):lHeaderSize := .F.
oTotais:Cell("TOT_MOV"):lHeaderSize     := .F.
oTotais:Cell("TOT_ATU"):lHeaderSize    := .F.

oReport:ParamReadOnly()	

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrintบ Autor ณ Cicero J. Silva    บ Data ณ  14/07/06  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Definicao do objeto do relatorio personalizavel e das      บฑฑ
ฑฑบ          ณ secoes que serao utilizadas                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportPrint(oReport,cSayCC,lSchedule)

Local oSCtrCC 		:= oReport:Section(1)
Local oTotais	 	:= oReport:Section(2)
Local aSetOfBook 	:= CTBSetOf(mv_par06)		
Local aCtbMoeda		:= {}
Local cArqTmp		:= ""
Local cFiltro		:= oSCtrCC:GetAdvplExp()
Local cCtaIni		:= Space(Len(CriaVar("CT1_CONTA")))
Local cCtaFim		:= Repl('Z',Len(CriaVar("CT1_CONTA")))            
Local lImpSint		:= (mv_par05=1 .Or. mv_par05 ==3)
Local cSegAte 	   	:= mv_par11 // Imprimir ate o Segmento?
Local nDigitAte		:= 0
Local cSeparador		:= ""
Local dDataFim 		:= mv_par02
Local dDataLP  		:= mv_par22
Local lImpAntLP		:= (mv_par21==1)
Local lVlrZerado	:= (mv_par07==1) 
Local lPrintZero	:= (mv_par18==1)
Local l132			:= !(mv_par16==1)// Se imprime saldo movimento do periodo
Local lImpConta		:= .F.
Local lMov 			:= (mv_par16==1) // Imprime movimento ?
Local lPula			:= (mv_par17==1) 
Local lNormal		:= (mv_par19==1)
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotSldAnt	:= 0
Local nTotSldAtu	:= 0
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+mv_par08))
Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)
Local nDivide		:= 0
Local cMascara		:= IIF (Empty(aSetOfBook[6]),GetMv("MV_MASCCUS"),RetMasCtb(aSetOfBook[6],@cSeparador))// Mascara do Centro de Custo                  
Local cPicture 		:= Iif(!Empty(aSetOfBooks[4]),"@E 9,999,999,999.99","")
Local cDescMoeda 	:= ""
Local nK			:= 0
Local lColDbCr 		:= If(cPaisLoc $ "RUS",.T.,.F.) // Disconsider cTipo in ValorCTB function, setting cTipo to empty
Local lRedStorn		:= If(cPaisLoc $ "RUS",SuperGetMV("MV_REDSTOR",.F.,.F.),.F.)// Parameter to activate Red Storn
Local nTotMov1		:= 0
Local oMeter 		:= Nil
Local oText 		:= Nil
Local oDlg 			:= Nil
Local lEnd			:= .F.

If lSchedule
	mv_par23 := 2
EndIf	         

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se usa Set Of Books + Plano Gerencial (Se usar Planoณ
//ณ Gerencial -> montagem especifica para impressao)			 ณ
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

aCtbMoeda 	:= CtbMoeda(mv_par08,nDivide)
cDescMoeda	:= aCtbMoeda[2]

// Valida a Moeda
If Empty(aCtbMoeda[1])
	If ! lSchedule
 		Help(" ",1,"NOMOEDA")
 	EndIf
	Return .F.
EndIf

/*
If lMov
	oReport:SetLandScape(.T.)
Else
	oReport:SetPortrait(.T.)
EndIf
*/
oTotais:Cell("TOT_ANT"):HideHeader()
oTotais:Cell("TOT_DEBITO"):HideHeader()
oTotais:Cell("TOT_CREDITO"):HideHeader()
oTotais:Cell("TOT_MOV"):HideHeader()
oTotais:Cell("TOT_ATU"):HideHeader()
                
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

If !lMov //Nao Imprime Coluna Movimento!!
	oSCtrCC:Cell("MOVIMENTO"):Disable()	
	oTotais:Cell("TOT_MOV"):Disable()
EndIf
       

oSCtrCC:OnPrintLine( {|| cFilAnt := cArqTmp->FILIAL,;
					 ( IIf( lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCC == "1" .And. cTipoAnt == "2")), oReport:SkipLine(),NIL),;
								 cTipoAnt := cArqTmp->TIPOCC ) } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza titulo do relatorio: Analitico / Sintetico			 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF mv_par05 == 1
	Titulo:=	OemToAnsi(STR0007) + Upper(cSayCC)	//"BALANCETE SINTETICO DE  "
ElseIf mv_par05 == 2
	Titulo:=	OemToAnsi(STR0006) + Upper(cSayCC) 	//"BALANCETE ANALITICO DE  "
ElseIf mv_par05 == 3
	Titulo:=	OemToAnsi(STR0008) + Upper(cSayCC)	//"BALANCETE DE  "
EndIf

Titulo += 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) + Dtoc(mv_par02) + ;
			OemToAnsi(STR0011) + cDescMoeda 
			
If mv_par10 > "1"
	Titulo += " (" + Tabela("SL", mv_par10, .F.) + ")"
EndIf

If nDivide > 1			
	Titulo += " (" + OemToAnsi(STR0021) + Alltrim(Str(nDivide)) + ")"
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
//ณ Monta Arquivo Temporario para Impressao							  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lSchedule
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CTU","CTT",cCtaIni,cCtaFim,mv_par03,mv_par04,,,,,;
				 mv_par08,mv_par10,aSetOfBook,mv_par12,;
				  mv_par13,mv_par14,mv_par15,l132,lImpConta,,,;
				   lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,aGeren,,lImpSint,cFiltro/*aReturn[7]*/)
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;					
				 CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				  mv_par01,mv_par02,"CTU","CTT",cCtaIni,cCtaFim,mv_par03,mv_par04,,,,,;
				   mv_par08,mv_par10,aSetOfBook,mv_par12,;
				    mv_par13,mv_par14,mv_par15,l132,lImpConta,,,;
					 lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,aGeren,,lImpSint,cFiltro/*aReturn[7]*/,,,,,,,,,,,,aSelFil)},;
					  OemToAnsi(OemToAnsi(STR0014)),;  //"Criando Arquivo Tempor rio..."
					   OemToAnsi(STR0003)+cSayCC)     //"Balancete Verificacao Conta /"
					     			   
EndIf

If select( 'cArqTmp' ) <= 0 
	RETURN .F.
Endif

oSCTrCC:Cell("SALDOANT"):SetBlock({|| ValorCTB(cArqTmp->SALDOANT ,,,TAM_VALOR,nDecimais,.T.,cPicture,cArqTmp->CCNORMAL,,,,,,lPrintZero,.F.)})
oSCTrCC:Cell("SALDODEB"):SetBlock({|| ValorCTB(cArqTmp->SALDODEB ,,,TAM_VALOR,nDecimais,.F.,cPicture,cArqTmp->CCNORMAL,,,,,,lPrintZero,.F.,lColDbCr)})
oSCTrCC:Cell("SALDOCRD"):SetBlock({|| ValorCTB(cArqTmp->SALDOCRD ,,,TAM_VALOR,nDecimais,.F.,cPicture,cArqTmp->CCNORMAL,,,,,,lPrintZero,.F.,lColDbCr)})

If lMov
	oSCTrCC:Cell("MOVIMENTO"):SetBlock({|| ValorCTB(cArqTmp->MOVIMENTO,,,TAM_VALOR,nDecimais,.T.,cPicture,cArqTmp->CCNORMAL,,,,,,lPrintZero,.F.)})
EndIf
	
oSCTrCC:Cell("SALDOATU"):SetBlock({|| ValorCTB(cArqTmp->SALDOATU ,,,TAM_VALOR,nDecimais,.T.,cPicture,cArqTmp->CCNORMAL,,,,,,lPrintZero,.F.)})
                    
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

	If f200Fil(cSegAte, nDigitAte,cMascara)
		dbSkip()
		Loop
	EndIf   

	nTotDeb += f200Soma("D",cSegAte)
	nTotCrd += f200Soma("C",cSegAte)
	nTotSldAnt	+= f200Soma("A",cSegAte)
	nTotSldAtu	+= f200Soma("T",cSegAte)
	
	If cPaisLoc $ "RUS"
		nTotMov1 += RedStorTt(cArqTmp->SALDODEB,cArqTmp->SALDOCRD,cArqTmp->TIPOCC,cArqTmp->CCNORMAL,"T")
	Endif
	
    oSCtrCC:PrintLine() //Section(1)   
    	
    dbSkip()
    	
EndDo
If !oReport:nDevice == 4
	oTotais:Cell(" "):Disable()	
EndIf
oTotais:Cell("TOT"):SetTitle(OemToAnsi(STR0018))  		// "T O T A I S  D O  P E R I O D O: "
oTotais:Cell("TOT_DEBITO"):SetBlock( { || ValorCTB(nTotDeb,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr) } )
oTotais:Cell("TOT_CREDITO"):SetBlock( { || ValorCTB(nTotCrd,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr) } )
	
If lMov
	If lRedStorn
		nTotMov := nTotMov1
		oTotais:Cell("TOT_MOV"):SetBlock( { || 	ValorCTB(nTotMov,,,TAM_VALOR,nDecimais,.T.,cPicture,Iif(nTotMov<0,"1","2"),,,,,,lPrintZero,.F.,lColDbCr) } )
	Else
		nTotMov := (nTotCrd - nTotDeb)
		If Round(NoRound(nTotMov,3),2) <= 0
			oTotais:Cell("TOT_MOV"):SetBlock( { || 	ValorCTB(nTotMov,,,TAM_VALOR,nDecimais,.T.,cPicture,"1",,,,,,lPrintZero,.F.) } )
		ElseIf Round(NoRound(nTotMov,3),2) > 0
			oTotais:Cell("TOT_MOV"):SetBlock( { || 	ValorCTB(nTotMov,,,TAM_VALOR,nDecimais,.T.,cPicture,"2",,,,,,lPrintZero,.F.) } )
		EndIf
	Endif
EndIf

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
ฑฑบPrograma  ณf200Soma  บAutor  ณCicero J. Silva     บ Data ณ  24/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTBR230                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function f200Soma(cTipo,cSegAte)

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
ฑฑบPrograma  ณf200Fil   บAutor  ณCicero J. Silva     บ Data ณ  24/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTBR230                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function f200Fil(cSegAte, nDigitAte,cMascara)

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
/*/{Protheus.doc} ScheDef()

Defini็ใo de Static Function SchedDef para o novo Schedule

@author TOTVS
@since 03/06/2021
@version MP12
/*/
//-------------------------------------------------------------------

Static Function SchedDef()

Local aParam := {}

aParam := { "R",;            // Tipo R para relat๓rio P para processo
			"CTR200",;       // Pergunte do relat๓rio, caso nใo use, passar ParamDef
			,;               // Alias     
			,;               // Array de ordens
			STR0035,;        // Tํtulo 
			,;				 // Nome do Relat๓rio
			.F.,;            // Indica se permite que o agendamento possa ser cadastrado como sempre ativo
			.T. }            // Indica que o agendamento pode ser realizado por filiais

Return aParam
