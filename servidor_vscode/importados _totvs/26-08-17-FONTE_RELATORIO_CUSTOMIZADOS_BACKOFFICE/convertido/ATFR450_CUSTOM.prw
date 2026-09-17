#include "protheus.ch"
#include "report.ch"
#include "ATFR450C.ch"




//Verifica se o AVP do ATF esta ativo     
Static lAvpAtf := If(FindFunction("AFAvpAtf"),AFAvpAtf(),.f.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATFR450   บAutor  ณ Ramon Neves        บ Data ณ  09/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Demonstrativo: Cแlculo do AVP imobilizado                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAATF                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function U_ATFR450C()
Local oReport
Local lTReport		:= FindFunction("TRepInUse") .And. TRepInUse()
Local lDefTop		:= IIF( FindFunction("IfDefTopCTB"), IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)

//Controle de AVP de Ativo
Private cPerg		:= "AFR450"
Private aSelFil		:= {}
Private nTotalFil	:= 0  
Private cAliasAvp	:= GetNextAlias() 
Private aSelClass := {}

//Valida็ใo de aviso/bloqueio do relat๓rio em Release 12.1.2510 e superiores
If lAvpAtf

	If !lDefTop
		Help("  ",1,"AFR450TOP",,STR0001 ,1,0) //"Fun็ใo disponํvel apenas para ambientes TopConnect"
		Return
	EndIf

	If !lTReport
		Help("  ",1,"AFR450R4",,STR0009,1,0) //"Fun็ใo disponํvel apenas TREPORT"
		Return
	ENdIf

	lRet := Pergunte( cPerg , .T. )

	If lRet
		If mv_par09 == 1 .And. Len( aSelFil ) <= 0
			aSelFil := AdmGetFil()
			If Len( aSelFil ) <= 0
				Return
			EndIf
		EndIf
		
		If mv_par10 == 1 .And. FindFunction("AdmGetClass")
			aSelClass := AdmGetClass()
			If Len( aSelClass ) <= 0
				Return
			EndIf 			
		EndIf	

		oReport := ReportDef()
		oReport:PrintDialog()
	Endif
Else
	Help("  ",1,"AFR450NOFOUND",,STR0002 ,1,0) //"Dicionแrio desatualizado"
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณRamon Neves         บ Data ณ  08/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o LayOut do Relat๓rio:Cแlculo do AVP do imobilizado  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAATF                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport
Local oSecSN1
Local oSecFNF
Local oSecFIL
Local oBreak2
Local cTitulo	:= STR0003	//"Demonstrativo de Cแlculo do AVP do Imobilizado"
Local aOrd		:= {}		//em branco porque nใo se faz necessแrio ordenar nesse relat๓rio

Pergunte(cPerg,.F.)

oReport := TReport():New("ATFR450",cTitulo,cPerg,{|oReport| ATFR450Imp( oReport,aOrd,cTitulo)},STR0004) //"Este relat๓rio irแ imprimir informa็๕es do cแlculo do AVP conforme parโmetros informados"

oSecSN1 := TRSection():New( oReport,STR0012,{"SN1"},,,,"")//"Ficha do Ativo"
TRCell():New( oSecSN1,"N1_FILIAL" ,"SN1",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/)
TRCell():New( oSecSN1,"N1_CBASE"  ,"SN1",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/)
TRCell():New( oSecSN1,"N1_ITEM"   ,"SN1",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/)
TRCell():New( oSecSN1,"N1_DESCRIC","SN1",STR0005     ,/*Picture*/,/*Tamanho*/,/*lPixel*/) //"Desc. Item"

oSecFNF := TRSection():New( oSecSN1,STR0013,{"FNF"},,,,"")//"Movimentos AVP"
TRCell():New( oSecFNF,"DESC_SALDO",""   ,STR0006     ,"@!"       ,10         ,.F.       ,{|| Tabela("SL",(cAliasAvp)->FNF_TPSALD)}) //"Desc. Saldo"
TRCell():New( oSecFNF,"FNF_TPMOV" ,"FNF",STR0007     ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/        ) //"Desc. Movto"
TRCell():New( oSecFNF,"FNF_DTAVP" ,"FNF",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/        )
TRCell():New( oSecFNF,"FNF_VALOR" ,"FNF",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/        )
TRCell():New( oSecFNF,"FNF_ENT01" ,"FNF",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/        )
TRCell():New( oSecFNF,"FNF_ENT02" ,"FNF",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/        )
TRCell():New( oSecFNF,"FNF_ENT03" ,"FNF",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/        )
TRCell():New( oSecFNF,"FNF_ENT04" ,"FNF",/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/        )

oSecFIL := TRSection():New( oReport,STR0014 )//"Filial"       //se็ใo para utiliza็ใo do totalizador por filial
TRCell():New( oSecFIL,"TOT_FIL","",STR0010,"@E 9,999,999,999,999.99",/*Tamanho*/,/*lPixel*/)

oSecSN1:SetHeaderPage(.T.)
oSecFNF:SetHeaderPage(.T.)
oSecSN1:SetAutoSize()
oSecFNF:SetAutoSize()

oReport:ParamReadOnly()

oFunc := TRFunction():New(oSecFNF:Cell("FNF_VALOR"),,"ONPRINT",/*oBreak*/,STR0011,/*cPicture*/,{|| SaldoAprop(oSecSN1:Cell("N1_FILIAL"):GetValue(.T.),oSecSN1:Cell("N1_CBASE"):GetValue(.T.),oSecSN1:Cell("N1_ITEM"):GetValue(.T.))},.T.,.F.,.F.,oSecFNF) //"Saldo a Apropriar"
oFunc:HideHeader()

oBreak2 := TRBreak():New( oReport, oSecSN1:Cell('N1_FILIAL') , STR0010, /*lTotalInLine*/, 'NOMEBRK', .F. )
oBreak2:OnPrintTotal({|| nTotalFil := 0})
oBreak2:SetPageBreak(.T.)
 
TRFunction():New(oSecFIL:Cell("TOT_FIL"),,"ONPRINT",oBreak2,,,{|| nTotalFil},.F.,.F., .F.)

Return( oReport )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATFR450ImpบAutor  ณRamon Neves         บ Data ณ  08/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a impressใo do Relat๓rio Cแlculo do AVP do         บฑฑ
ฑฑบ          ณ imobilizado                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAATF                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบParametrosณ Expo1 = oReport                                            บฑฑ
ฑฑบ          ณ Expa1 = Array com ordem de pesquisa                        บฑฑ
ฑฑบ          ณ Expc1 = Titulo do relatorio                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ATFR450Imp(oReport,aOrd,cTitulo)
Local oSecSN1		:= oReport:Section(1)
Local oSecFNF		:= oReport:Section(1):Section(1)
Local cCodDe		:= ""
Local cCodAte		:= ""
Local cItemDe		:= ""
Local cItemAte		:= ""
Local dPeriodIni	:= CToD("")
Local dPeriodFim	:= ""
Local cQlSaldo		:= ""
Local nImprime		:= 0
Local nSelFili		:= 0
Local cSelFili		:= ""
Local cCondFil		:= ""
Local cWhereAux		:= ""
Local lFilClass		:= (MV_PAR10 == 1 .And. Len(aSelClass) > 0 .And. FindFunction("FormatClass"))
Local cTmpFil

Pergunte( cPerg , .F. )

cCodDe      := MV_PAR01
cCodAte     := MV_PAR02
cItemDe     := MV_PAR03
cItemAte    := MV_PAR04
dPeriodIni	:= MV_PAR05
dPeriodFim	:= MV_PAR06
cQlSaldo    := MV_PAR07
nImprime    := MV_PAR08
nSelFili    := MV_PAR09

//Tratamento filial
cWhereAux += " FNF_FILIAL " + GetRngFil( aSelfil , "FNF", .T., @cTmpFil )

//Tratamento tipo de saldo
If !Empty(cQlSaldo)
	cWhereAux += " AND FNF.FNF_TPSALD = '" +cQlSaldo+ "' "
Endif

//Tratamento Analitico|Sintetico
If nImprime == 2 //Sintetico
	cWhereAux += " AND FNF.FNF_TPMOV = '1' " //Exibe somente a constituicao
EndIf  

//Filtra Classifica็๕es patrimoniais
If lFilClass 
	cWhereAux += " AND  SN1.N1_PATRIM IN " + FormatClass(aSelClass, .T.)
EndIf

cWhereAux := "%" + cWhereAux + "%"

BEGIN REPORT QUERY oSecSN1

	BeginSql alias cAliasAvp

		SELECT	SN1.N1_FILIAL,SN1.N1_CBASE ,SN1.N1_ITEM   ,SN1.N1_DESCRIC,SN1.N1_PATRIM,FNF.FNF_FILIAL,
				FNF.FNF_CBASE,FNF.FNF_ITEM ,FNF.FNF_TPSALD,FNF.FNF_TPMOV ,FNF.FNF_DTAVP ,
				FNF.FNF_VALOR,FNF.FNF_ENT01,FNF.FNF_ENT02 ,FNF.FNF_ENT03 ,FNF.FNF_ENT04 


		FROM %table:FNF% FNF INNER JOIN %table:SN1% SN1
		    ON SN1.N1_FILIAL = FNF.FNF_FILIAL
		    	AND SN1.N1_CBASE = FNF.FNF_CBASE 
		    	AND SN1.N1_ITEM = FNF.FNF_ITEM

		WHERE 	SN1.N1_CBASE >= %Exp:cCodDe% AND SN1.N1_CBASE <= %Exp:cCodAte%
				AND SN1.N1_ITEM >= %Exp:cItemDe% AND SN1.N1_ITEM <= %Exp:cItemAte%
				AND FNF_DTAVP >= %Exp:DTOS(dPeriodIni)% AND FNF_DTAVP <= %Exp:DTOS(dPeriodFim)%
				AND %Exp:cWhereAux%
				AND FNF.%notDel%
				AND SN1.%notDel%

		ORDER BY N1_FILIAL,N1_CBASE,N1_ITEM,FNF_REVIS,FNF_DTAVP,FNF_SEQAVP,FNF_TPMOV

	EndSql

END REPORT QUERY oSecSN1


oSecFNF:SetParentQuery()
oSecFNF:SetParentFilter({|cParam| (cAliasAvp)->(FNF_FILIAL+FNF_CBASE+FNF_ITEM) == cParam},{|| (cAliasAvp)->(N1_FILIAL+N1_CBASE+N1_ITEM) })
CtbTmpErase(cTmpFil)
oSecSN1:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSaldoApropบAutor  ณRamon Neves         บ Data ณ  19/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula valor do saldo a constituir                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAATF                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ nSaldAVP (Valor do Saldo a Constituir)                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบParametrosณ Expc1 = Filial                                             บฑฑ
ฑฑบ          ณ Expc2 = Codigo do bem                                      บฑฑ
ฑฑบ          ณ Expc3 = Item                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SaldoAprop(cFil,cBase,cItem)
Local aArea		:= GetArea()
Local aAreaFNF	:= FNF->(GetArea())
Local lTranf		:= .F.
Local nSaldAvp	:= 0  //saldo a apropriar//exibir no relat๓rio

dbSelectArea("FNF")
dbSetOrder(1) //FNF_FILIAL+FNF_CBASE+FNF_ITEM+FNF_TIPO+FNF_SEQ+FNF_TPSALD+FNF_REVIS+FNF_SEQAVP+FNF_MOEDA+DTOS(FNF_DTAVP)

If MsSeek(cFil+cBase+cItem)
	
	While FNF->(!EOF()) .AND. FNF->(FNF_FILIAL+FNF_CBASE+FNF_ITEM) == cFil+cBase+cItem

		If FNF->FNF_TPMOV == "1" .And. FNF->FNF_STATUS != "7|8|9"

			nSaldAvp := FNF->FNF_VALOR - FNF->FNF_ACMAVP
						
		Endif
		
		//Valida se hแ transferencia entre filiais
		If FNF->FNF_TPMOV == "8" 
			lTranf := .T.	
		EndIf
		
		
	FNF->(DbSkip())
	EndDo

Endif

//Quando houver transferencia, o saldo deve ser zerado, pois ้ exibido na filia destino
If lTranf
	nSaldAvp := 0	
EndIf

nTotalFil += nSaldAvp

RestArea(aAreaFNF)
RestArea(aArea)

Return nSaldAvp

