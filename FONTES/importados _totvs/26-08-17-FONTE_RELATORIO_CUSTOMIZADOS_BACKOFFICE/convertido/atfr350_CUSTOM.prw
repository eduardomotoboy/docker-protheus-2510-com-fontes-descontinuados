#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#INCLUDE "ATFR350C.CH" 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefines do array que representa das 1 perguntasณ
//ณdo relatorio                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
#DEFINE PERIODO_DE			1
#DEFINE PERIODO_ATE			2
#DEFINE DEMONSTRAR			3
#DEFINE TAXA_DE				4
#DEFINE TAXA_ATE				5
#DEFINE QUEBRA					6
#DEFINE ENTIDADE_BASE			7
#DEFINE CODIGO					08
#DEFINE REVISAO				09
#DEFINE TIPO_MOV				10
#DEFINE COND_FILIAL			11
#DEFINE COND_TIPDEP			12

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTipos de Entidades Baseณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
#DEFINE CONTA				1
#DEFINE CCUSTO				2
#DEFINE SUBCONTA			3
#DEFINE CLASSE				4

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTipos de relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
#DEFINE ANALITICO		1
#DEFINE SINTETICO		2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTipos de quebraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
#DEFINE TODAS			1
#DEFINE DATA_MOV		2
#DEFINE ENTIDADE		3 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTipos de Movimentosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
#DEFINE TODOS_MOV				1
#DEFINE SIMUL_REAL_MOV		2
#DEFINE SIMUL_MOD_MOV		3
#DEFINE SALDO_MOV				4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATFR350   บAutor  ณAlvaro Camillo Neto บ Data ณ  12/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de movimentos de Simula็ใo                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAATF - Ativo Fixo                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ATFR350C()
Local oReport			:= nil
Local aRet				:= Array(12)

Local cTitulo			:= STR0001 //"Proje็ใo da Deprecia็ใo"
Local cAliasQry			:= GetNextAlias()
Local lRet				:= .T.
Local lSelTpDep			:= .T.
Local lTpDepr			:= .T.

Private aSelFil		:= {}
Private aSelTpDep		:= {}      
Private lSelFil		:= .F.
Private cPerg1		:= "AF350A"
Private cPerg2		:= "AF350B"  

//Valida็ใo de aviso/bloqueio do relat๓rio em Release 12.1.2510 e superiores
If TRepInUse()
	ATFCargaDf()
	If (lRet := Pergunte(cPerg1, .T.))	
		lSelFil	:= (MV_PAR11 == 1)
		lSelTpDep	:= lTpDepr .And. lSelTpDep .AND. (MV_PAR12 == 1)
			
		aRet[PERIODO_DE] 		:= MV_PAR01
		aRet[PERIODO_ATE] 	:= MV_PAR02
		aRet[DEMONSTRAR] 		:= MV_PAR03	
		aRet[TAXA_DE] 		:= MV_PAR04	
		aRet[TAXA_ATE] 		:= MV_PAR05		
		aRet[QUEBRA]			:= MV_PAR06	
		aRet[ENTIDADE_BASE]	:= MV_PAR07
		aRet[CODIGO]			:= MV_PAR08
		aRet[REVISAO]			:= MV_PAR09
		aRet[TIPO_MOV]		:= MV_PAR10
		aRet[COND_FILIAL]		:= MV_PAR11
		aRet[COND_TIPDEP]		:= MV_PAR12

		If lRet
			If lSelFil .And. Len( aSelFil ) <= 0
				aSelFil := AdmGetFil()
				If Len( aSelFil ) <= 0
					Return
				EndIf
			EndIf
			
			If lSelTpDep .AND. lTpDepr
				aSelTpDep := ATFGeTpDp()	
				If Len( aSelTpDep ) <= 0
					Return
				EndIf 		
			EndIf
		EndIf
		
		Pergunte(cPerg2, .T.)
		  
		oReport := ReportDef(aRet,cTitulo,cAliasQry,lTpDepr) 
		oReport:PrintDialog()  
	Endif 
Else
	Alert(STR0002) //"Este relat๓rio s๓ estแ disponํvel a partir da Release 4."
EndIf

Return

	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณAlvaro Camillo Neto บ Data ณ  13/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefini็ใo do Relatorio                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ATFR350                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef(aParam,cTitulo,cAliasQry,lTpDepr)  

Local oReport  	 	:= nil
Local cReport 		:= "ATFR350"
Local oSNS   			:= nil
Local oBreak	   		:= nil
Local cQuebra			:= ""
Local cCpoBase		:= ""
Local cTotal			:= ""
Local cOrdem 			:= ""
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine a quebra do relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aParam[QUEBRA] == TODAS  
	cQuebra := "NS_FILIAL+NS_DATA"
	cOrdem  := "NS_FILIAL,NS_DATA"
Else
	cQuebra := "NS_FILIAL"
	cOrdem  := "NS_FILIAL"
EndIf

If aParam[QUEBRA] == DATA_MOV
	cQuebra += "+NS_DATA"
	cOrdem += ",NS_DATA"
	cCpoBase := "%NS_DATA%"
	cTotal := STR0004 //"Total da Data" 
Else
	Do Case
		Case aParam[ENTIDADE_BASE] == CONTA
			cQuebra += "+NS_CONTA"
			cOrdem  += ",NS_CONTA"
			cTotal := STR0005 //"Total da Conta"	
		Case aParam[ENTIDADE_BASE] == CCUSTO
			cQuebra += "+NS_CONTA+NS_CCUSTO"
			cOrdem  += ",NS_CONTA,NS_CCUSTO"
			cTotal := STR0006 //"Total do C Custo" 
		Case aParam[ENTIDADE_BASE] == SUBCONTA
			cQuebra += "+NS_CONTA+NS_CCUSTO+NS_SUBCTA"
			cOrdem  += ",NS_CONTA,NS_CCUSTO,NS_SUBCTA"
			cTotal := STR0007 //"Total da SubConta"
		Case aParam[ENTIDADE_BASE] == CLASSE
			cQuebra += "+NS_CONTA+NS_CCUSTO+NS_SUBCTA+NS_CLVL"
			cOrdem  += ",NS_CONTA,NS_CCUSTO,NS_SUBCTA,NS_CLVL"
			cTotal := STR0008 //"Total da Classe Vlr"		
	EndCase
EndIf

If  aParam[DEMONSTRAR] == ANALITICO
	cOrdem += ",NS_CBASE,NS_ITEM"	
EndIf	

/*
 * Defini็ใo padrใo do relat๓rio TReport
 */
oReport  := TReport():New( cReport, cTitulo, cPerg1 , { |oReport| RepATF350(oReport,aParam,cOrdem,cAliasQry,lTpDepr) }, cTitulo )

	/*
	 * Desabilita o botใo de parโmetros de customiza็๕es do relat๓rio TReport
	 */
	oReport:ParamReadOnly()
	
	/*
	 * Configura o formato do relat๓rio para 'Paisagem'
	 */
	oReport:SetLandScape()
	
	oReport:DisableOrientation()
	
	DEFINE SECTION oSNS OF oReport TITLE STR0003 TABLES "SNS" //"Movimentos"
	TRCell():New(oSNS,"NS_FILIAL", "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
	 
	If aParam[DEMONSTRAR] == ANALITICO
		TRCell():New(oSNS,"NS_DATA"		, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_CONTA"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
		TRCell():New(oSNS,"NS_CCUSTO"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_SUBCTA"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_CLVL"		, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_CBASE"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_ITEM"		, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_TPMOV"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		
		If lTpDepr
			TRCell():New(oSNS,"NS_TPDEPR"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		EndIf
		
		TRCell():New(oSNS,"NS_VLRMOV1"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,{|| IIF((cAliasQry)->NS_TPMOV == "0",(cAliasQry)->NS_VLRACM1,(cAliasQry)->NS_VLRMOV1)},/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)		 	 
		TRCell():New(oSNS,"NS_VLRMOV2"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,{|| IIF((cAliasQry)->NS_TPMOV == "0",(cAliasQry)->NS_VLRACM2,(cAliasQry)->NS_VLRMOV2)},/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_VLRMOV3"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,{|| IIF((cAliasQry)->NS_TPMOV == "0",(cAliasQry)->NS_VLRACM3,(cAliasQry)->NS_VLRMOV3)},/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_VLRMOV4"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,{|| IIF((cAliasQry)->NS_TPMOV == "0",(cAliasQry)->NS_VLRACM4,(cAliasQry)->NS_VLRMOV4)},/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_VLRMOV5"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,{|| IIF((cAliasQry)->NS_TPMOV == "0",(cAliasQry)->NS_VLRACM5,(cAliasQry)->NS_VLRMOV5)},/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	ElseIf aParam[DEMONSTRAR] == SINTETICO
		If aParam[QUEBRA] == DATA_MOV .Or. aParam[QUEBRA] == TODAS 
			TRCell():New(oSNS,"NS_DATA"		, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		EndIf   
		If aParam[QUEBRA] == ENTIDADE .Or. aParam[QUEBRA] == TODAS
			Do Case
				Case aParam[ENTIDADE_BASE] == CONTA
					TRCell():New(oSNS,"NS_CONTA"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
				Case aParam[ENTIDADE_BASE] == CCUSTO
					TRCell():New(oSNS,"NS_CONTA"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
					TRCell():New(oSNS,"NS_CCUSTO"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
				Case aParam[ENTIDADE_BASE] == SUBCONTA
					TRCell():New(oSNS,"NS_CONTA"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
					TRCell():New(oSNS,"NS_CCUSTO"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
					TRCell():New(oSNS,"NS_SUBCTA"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
				Case aParam[ENTIDADE_BASE] == CLASSE
					TRCell():New(oSNS,"NS_CONTA"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
					TRCell():New(oSNS,"NS_CCUSTO"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
					TRCell():New(oSNS,"NS_SUBCTA"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
					TRCell():New(oSNS,"NS_CLVL"		, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.) 
			EndCase
		EndIf
			
		TRCell():New(oSNS,"NS_VLRMOV1"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)		 	 
		TRCell():New(oSNS,"NS_VLRMOV2"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_VLRMOV3"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_VLRMOV4"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
		TRCell():New(oSNS,"NS_VLRMOV5"	, "SNS", /*X3Titulo*/, /*cPicture*/, /*Tamanho*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	EndIF
	 		
	DEFINE FUNCTION FROM oSNS:Cell("NS_VLRMOV1") FUNCTION SUM NO END SECTION 
	DEFINE FUNCTION FROM oSNS:Cell("NS_VLRMOV2") FUNCTION SUM NO END SECTION
	DEFINE FUNCTION FROM oSNS:Cell("NS_VLRMOV3") FUNCTION SUM NO END SECTION
	DEFINE FUNCTION FROM oSNS:Cell("NS_VLRMOV4") FUNCTION SUM NO END SECTION
	DEFINE FUNCTION FROM oSNS:Cell("NS_VLRMOV5") FUNCTION SUM NO END SECTION
      
	oSNS:SetAutoSize()

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRepATF350 บAutor  ณ Alvaro Camillo Netoบ Data ณ  13/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a query dos dados da simulacao da deprecia็ใo      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ATFR350                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RepATF350(oReport,aParam,cOrdem,cAliasQry,lTpDepr)

Local oSecSNS		:= oReport:Section(1)
Local dDataDe		:= aParam[PERIODO_DE]
Local dDataAte	:= aParam[PERIODO_ATE]
Local nTxDe		:= aParam[TAXA_DE]
Local nTxAte		:= aParam[TAXA_ATE] 
Local cCodigo 	:= aParam[CODIGO]
Local cRevisao	:= aParam[REVISAO]
Local cTpMov		:= ""
Local cCpoBase	:= "%" + cOrdem + "%"
Local cCondFil	:= ""
Local cCondRev	:= "% %"
Local cTmpFil
/*
 * Variแveis de Campos Adicionais
 */ 
Local cCposAds	:= "%%"

Pergunte(cPerg2, .F.)

/*
 * Se existir o campo de m้todo de deprecia็ใo, o mesmo serแ adicionado a query
 */
If lTpDepr
	cCposAds := "% SNS.NS_TPDEPR , %"
EndIf
 
/*
 * Tratamento do Filtro de Filiais de acordo com Pergunte "Seleciona Filial ?"
 */
If lSelFil
	cCondFil 	:= "SNS.NS_FILIAL " + GetRngFil( aSelfil , "SNS", .T., @cTmpFil ) + " "
	cCondFil 	:= "%" + cCondFil + "%"
Else
	cCondFil 	:= "% SNS.NS_FILIAL = '" + XFILIAL("SNS") + "' %"
EndIf

//Filtra Classifica็๕es patrimoniais
If Len(aSelTpDep) > 0 
	cCondRev := "% AND  NS_TPDEPR IN " + FormatClass(aSelTpDep, .T.) + " %"
EndIf

Do Case
	Case aParam[TIPO_MOV] == TODOS_MOV
		cTpMov	:= "% '0','1','2' %"
	Case aParam[TIPO_MOV] == SALDO_MOV
		cTpMov	:= "% '0' %"	
	Case aParam[TIPO_MOV] == SIMUL_REAL_MOV  
		cTpMov	:= "% '1' %"
  	Case aParam[TIPO_MOV] == SIMUL_MOD_MOV 	
		cTpMov	:= "% '2' %"
EndCase
cOrdem := '%'+cOrdem+'%'

MakeSqlExpr(cPerg2)

// ---------------------------------------------//
//    Query Analitico 
//----------------------------------------------//
If aParam[DEMONSTRAR] == ANALITICO  
	BEGIN REPORT QUERY oSecSNS
		BeginSql alias cAliasQry	
			SELECT
				SNS.NS_FILIAL ,
				SNS.NS_DATA ,
				SNS.NS_TPMOV NS_TPMOV,
				SNS.NS_CBASE ,
				SNS.NS_ITEM ,
				SNS.NS_TIPOCNT ,
				SNS.NS_CONTA ,
				SNS.NS_CCUSTO ,
				SNS.NS_SUBCTA ,
				SNS.NS_CLVL ,
				%exp:cCposAds%
				SNS.NS_VLRMOV1 NS_VLRMOV1,
				SNS.NS_VLRMOV2 NS_VLRMOV2,
				SNS.NS_VLRMOV3 NS_VLRMOV3,
				SNS.NS_VLRMOV4 NS_VLRMOV4,
				SNS.NS_VLRMOV5 NS_VLRMOV5,
				SNS.NS_VLRACM1 NS_VLRACM1,
				SNS.NS_VLRACM2 NS_VLRACM2,
				SNS.NS_VLRACM3 NS_VLRACM3,
				SNS.NS_VLRACM4 NS_VLRACM4,
				SNS.NS_VLRACM5 NS_VLRACM5				 		
			FROM
				%table:SNS% SNS 
			WHERE
				SNS.%notDel%								AND
				%exp:cCondFil%							AND
				SNS.NS_DATA		>= %exp:dDataDe%		AND
				SNS.NS_DATA		<= %exp:dDataAte%		AND 	
				SNS.NS_TXDEPR1	>= %exp:nTxDe%			AND 	 		
				SNS.NS_TXDEPR1	<= %exp:nTxAte%		AND
				SNS.NS_CODIGO		= %exp:cCodigo%		AND
				SNS.NS_REVISAO	= %exp:cRevisao%		AND				
				SNS.NS_TPMOV IN (%exp:cTpMov%)
				%exp:cCondRev%												 
			ORDER BY %exp:cOrdem%
		EndSql	
	END REPORT QUERY oSecSNS PARAM mv_par01, mv_par02, mv_par03, mv_par04
Else

// ---------------------------------------------//
//    Query Sintetico 
//----------------------------------------------// 
	BEGIN REPORT QUERY oSecSNS
		BeginSql alias cAliasQry	
			SELECT
				%EXP:cCpoBase% ,
				SUM(NS_VLRMOV1) NS_VLRMOV1 ,
				SUM(NS_VLRMOV2) NS_VLRMOV2 ,
				SUM(NS_VLRMOV3) NS_VLRMOV3 ,
				SUM(NS_VLRMOV4) NS_VLRMOV4 ,
				SUM(NS_VLRMOV5) NS_VLRMOV5 		
			FROM
				%table:SNS% SNS
			WHERE
				SNS.%notDel%						AND
				%exp:cCondFil%					AND
				NS_DATA		>= %exp:dDataDe% 	AND
				NS_DATA		<= %exp:dDataAte%	AND 	
				NS_TXDEPR1 	>= %exp:nTxDe% 	AND 	 		
				NS_TXDEPR1 	<= %exp:nTxAte% 	AND
				NS_CODIGO = %exp:cCodigo% 		AND
				NS_REVISAO = %exp:cRevisao% 	AND
				NS_TPMOV In (%exp:cTpMov%)
				%exp:cCondRev%  
			GROUP BY %EXP:cCpoBase%
			ORDER BY %EXP:cCpoBase% 	
		EndSql	
	END REPORT QUERY oSecSNS PARAM mv_par01, mv_par02, mv_par03, mv_par04
EndIf
Pergunte(cPerg1, .F.)
CtbTmpErase(cTmpFil)
oSecSNS:Print()

Return
