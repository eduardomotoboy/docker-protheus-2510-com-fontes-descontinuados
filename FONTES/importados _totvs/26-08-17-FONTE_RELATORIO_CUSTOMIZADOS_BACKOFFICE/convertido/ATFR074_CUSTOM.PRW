#Include "Protheus.ch"
#Include "ATFR074C.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATFR074   ºAutor  ³Fernando Radu Muscalu ºFecha ³ 18/05/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para a emissao do demonstrativo de depreciacao      º±±
±±º          ³ de bens com controle de rateio.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ativo Fixo                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                
Function U_ATFR074C()
Local oReport   

//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
oReport := ReportDef()

If Valtype(oReport) == 'O'
	oReport:SetEdit(.F.) 
	oReport:ParamReadOnly()
	oReport:SetLandScape()
	oReport:DisableOrientation()
	oReport:HideFooter()
	oReport:PrintDialog()	
EndIf
		
If Select("TRBATF") > 0
	TRBATF->(DbCloseArea())
Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef ³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel pela a configuracao do relatorio	 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ReportDef(oReport)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oReport	- Objeto: Instancia da classe TReport.	  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local nI		:= 0

Local aEntities	:= {}
Local aDescEnt	:= {}


Local oSecCab	
Local oSecIte
Local oSecRod1
Local oSecRod2
Local cPerg074	:= "AFR074"
Local oReport  

If !Pergunte(cPerg074,.T.)
	Return .F.
EndIf

oReport := TReport():New("ATFR074",STR0001,cPerg074,{|| GetQry(), Afr074PrtTop(oReport) }, "") //#"Demonstrativo de depreciação de bens com controle de rateio"

oSecCab 	:= TRSection():New(oReport,,{"TRBATF"})
oSecIte		:= TRSection():New(oSecCab,,{"TRBATF"})
oSecRod1	:= TRSection():New(oReport,,{"TRBATF"})
oSecRod2	:= TRSection():New(oReport,,{"TRBATF"})

aEntities := RetEntities("2")
aCpo      := RetEntities("3")
aDescEnt := RetDescEnt(aEntities)  

Do Case
Case mv_par01 == 1	//Movimentos

    //Dados Fixo - Cabecalho
	TRCell():New(oSecCab,"FILIAL",,STR0004/*X3Titulo*/, /*Picture*/, TamSX3("N1_FILIAL")[1] /*Tamanho*/,/*lPixel*/)	//#"Filial"	
	TRCell():New(oSecCab,"CBASE",,STR0005/*X3Titulo*/, /*Picture*/, TamSX3("N1_CBASE")[1] /*Tamanho*/,/*lPixel*/)		//#"Código do Bem"
	TRCell():New(oSecCab,"ITEM",,STR0006/*X3Titulo*/, /*Picture*/, TamSX3("N1_ITEM")[1] /*Tamanho*/,/*lPixel*/)		//#"Item"
	TRCell():New(oSecCab,"DESCR",,STR0007/*X3Titulo*/, /*Picture*/, TamSX3("N1_DESCRIC")[1] /*Tamanho*/,/*lPixel*/)		//#"Descrição"
	TRCell():New(oSecCab,"TIPO",,STR0008/*X3Titulo*/, /*Picture*/,  /*Tamanho*/,/*lPixel*/)		//#"Tipo"
	TRCell():New(oSecCab,"TPSALDO",,STR0009/*X3Titulo*/, /*Picture*/,  /*Tamanho*/,/*lPixel*/)	//#"Tipo de Saldo"
	TRCell():New(oSecCab,"VLRORIG",,STR0010,PesqPict("SN3","N3_VORIG1")/*Picture*/, TamSX3("N3_VORIG1")[1] /*Tamanho*/,/*lPixel*/)//#"Valor Original"
    
    oSecCab:SetHeaderPage(.t.)
    
	//Dados iterativos - Itens
	TRCell():New(oSecIte,"DTMOV",,STR0011,,35+TamSx3("N3_CBASE")[1])		//#"Data"
	TRCell():New(oSecIte,"VLRDEPR",,STR0012,PesqPict("SNX","NX_VLRBASE")/*Picture*/, TamSX3("NX_VLRBASE")[1] /*Tamanho*/,/*lPixel*/)	//#"Valor Deprec."
	TRCell():New(oSecIte,"VLRRATE",,STR0013,PesqPict("SNX","NX_VLRMOV")/*Picture*/, TamSX3("NX_VLRMOV")[1] /*Tamanho*/,/*lPixel*/)	//#"Valor Rateado"
    
	For nI := 1 to len(aEntities)
		TRCell():New(oSecIte,aEntities[nI],,aDescEnt[nI]/*X3Titulo*/, /*Picture*/,  TamSX3(aCpo[nI])[1] /*Tamanho*/,/*lPixel*/)	
	Next nI

	oSecIte:SetHeaderPage(.t.)
	oSecIte:SetLeftMargin(3)                     
	
	//Totalizadores
	TRCell():New(oSecRod1,"TOTAL",,,,35+TamSx3("N3_CBASE")[1])                     

	oSecRod1:SetHeaderSection(.f.)
	oSecRod1:SetLeftMargin(3)

	TRCell():New(oSecRod2,"TIPOATV",,STR0014,,35+TamSx3("N3_CBASE")[1])	//#"Tipo de Ativo"
	TRCell():New(oSecRod2,"TOTALDEP",,STR0012,PesqPict("SNX","NX_VLRBASE")/*Picture*/, TamSX3("NX_VLRBASE")[1]/*Tamanho*/,/*lPixel*/)//#"Valor Deprec."
	
	oSecRod2:SetHeaderSection(.f.)
	oSecRod2:SetLeftMargin(3)
	
Case mv_par01 == 2	//Bem X entidade
    
    //Dados Fixo - Cabecalho 
	TRCell():New(oSecCab,"FILIAL",,STR0004/*X3Titulo*/, /*Picture*/, TamSX3("N1_FILIAL")[1] /*Tamanho*/,/*lPixel*/)	//#"Filial"	
	TRCell():New(oSecCab,"CBASE",,STR0005/*X3Titulo*/, /*Picture*/, TamSX3("N1_CBASE")[1] /*Tamanho*/,/*lPixel*/)		//#"Código do Bem"
	TRCell():New(oSecCab,"ITEM",,STR0006/*X3Titulo*/, /*Picture*/, TamSX3("N1_ITEM")[1] /*Tamanho*/,/*lPixel*/)		//#"Item"
	TRCell():New(oSecCab,"DESCR",,STR0007/*X3Titulo*/, /*Picture*/, TamSX3("N1_DESCRIC")[1] /*Tamanho*/,/*lPixel*/)		//#"Descrição"
	TRCell():New(oSecCab,"TIPO",,STR0008/*X3Titulo*/, /*Picture*/,  /*Tamanho*/,/*lPixel*/)		//#"Tipo"
	TRCell():New(oSecCab,"TPSALDO",,STR0009/*X3Titulo*/, /*Picture*/,  /*Tamanho*/,/*lPixel*/)	//#"Tipo de Saldo"
	TRCell():New(oSecCab,"VLRORIG",,STR0010,PesqPict("SN3","N3_VORIG1")/*Picture*/, TamSX3("N3_VORIG1")[1] /*Tamanho*/,/*lPixel*/)//#"Valor Original"
	TRCell():New(oSecCab,"VLRDPACM",,STR0015,PesqPict("SN3","N3_VRDACM1")/*Picture*/, TamSX3("N3_VRDACM1")[1]/*Tamanho*/,/*lPixel*/)//#"Deprec. Acumulada"
    
    oSecCab:SetHeaderPage(.t.)
    
	//Dados iterativos - Itens
	
	For nI := 1 to len(aEntities)
		TRCell():New(oSecIte,aEntities[nI],,aDescEnt[nI]/*X3Titulo*/, /*Picture*/, TamSX3(aCpo[nI])[1] /*Tamanho*/,/*lPixel*/)	
	Next nI
	
	TRCell():New(oSecIte,"VLRRATE",,STR0013,PesqPict("SNX","NX_VLRMOV")/*Picture*/, TamSX3("NX_VLRMOV")[1]/*Tamanho*/,/*lPixel*/)//#"Valor Rateado"
	
	oSecIte:SetHeaderPage(.t.)
	oSecIte:SetLeftMargin(3)
	
Otherwise			//Entidade X Bem  

    //Dados Fixo - Cabecalho
	TRCell():New(oSecCab,"FILIAL",,STR0004/*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/)	//#"Filial"
	TRCell():New(oSecCab,"ENTIDA",,STR0016/*X3Titulo*/, /*Picture*/, 41/*Tamanho*/,/*lPixel*/)	//#"Entidade"
	TRCell():New(oSecCab,"DESCENT",,STR0007/*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/)	//#"Descrição"
    
    oSecCab:SetHeaderPage(.t.)
    
	//Dados iterativos - Itens
		
	TRCell():New(oSecIte,"FILIAL",,STR0004/*X3Titulo*/, /*Picture*/, TamSX3("N1_FILIAL")[1] /*Tamanho*/,/*lPixel*/)	//#"Filial"	
	TRCell():New(oSecIte,"CBASE",,STR0005/*X3Titulo*/, /*Picture*/, TamSX3("N1_CBASE")[1] /*Tamanho*/,/*lPixel*/)		//#"Código do Bem"
	TRCell():New(oSecIte,"ITEM",,STR0006/*X3Titulo*/, /*Picture*/, TamSX3("N1_ITEM")[1] /*Tamanho*/,/*lPixel*/)		//#"Item"
	TRCell():New(oSecIte,"DESCR",,STR0007/*X3Titulo*/, /*Picture*/, TamSX3("N1_DESCRIC")[1] /*Tamanho*/,/*lPixel*/)		//#"Descrição"
	TRCell():New(oSecIte,"TIPO",,STR0008/*X3Titulo*/, /*Picture*/,  /*Tamanho*/,/*lPixel*/)		//#"Tipo"
	TRCell():New(oSecIte,"TPSALDO",,STR0009/*X3Titulo*/, /*Picture*/,  /*Tamanho*/,/*lPixel*/)	//#"Tipo de Saldo"
	TRCell():New(oSecIte,"VLRORIG",,STR0010,PesqPict("SN3","N3_VORIG1")/*Picture*/, TamSX3("N3_VORIG1")[1] /*Tamanho*/,/*lPixel*/)//#"Valor Original"
	TRCell():New(oSecIte,"VLRRATE",,STR0013,PesqPict("SNX","NX_VLRMOV")/*Picture*/,  TamSX3("N3_VORIG1")[1]/*Tamanho*/,/*lPixel*/)//#"Valor Rateado"  
	
	oSecIte:SetHeaderPage(.t.)
	oSecIte:SetLeftMargin(3)
	
	//Totalizadores
	TRCell():New(oSecRod1,"TOTAL",,,,35)
	TRCell():New(oSecRod1,"ITEM",,STR0006/*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/)		//#"Item"
	TRCell():New(oSecRod1,"DESCR",,STR0007/*X3Titulo*/, /*Picture*/, TamSX3("N1_DESCRIC")[1]/*Tamanho*/,/*lPixel*/)	//#"Descrição"
	TRCell():New(oSecRod1,"TIPO",,STR0008/*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/)		//#"Tipo"
	TRCell():New(oSecRod1,"TPSALDO",,STR0009/*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/)	//#"Tipo de Saldo"
	TRCell():New(oSecRod1,"VLRORIG",,STR0010,PesqPict("SN3","N3_VORIG1")/*Picture*/, TamSX3("N3_VORIG1")[1]/*Tamanho*/,/*lPixel*/)//#"Valor Original"
	TRCell():New(oSecRod1,"TOTALRAT",,STR0013,PesqPict("SNX","NX_VLRMOV")/*Picture*/, TamSX3("NX_VLRMOV")[1]/*Tamanho*/,/*lPixel*/)//#"Valor Rateado"

	oSecRod1:SetHeaderSection(.f.)
	oSecRod1:SetLeftMargin(3)
End Case

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GetQry	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria arquivo atraves de query de acordo com o tipo de  	  ³±±
±±³          ³relatorio.											  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GetQry(nTipo)												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nTipo	- Numerico: Tipo de Relatorio				  		  ³±±
±±³          ³		1 - Movimentos do rateio mostrado por data  		  ³±±
±±³          ³		2 - Bem / Entidade							  		  ³±±
±±³          ³		2 - Entidade / Bem							  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetQry(nTipo)

Local cQry	 	:= ""

Local aSelFil	:= {}
Local aQuery	:= {}
Local cTmpFil
	
Default nTipo := mv_par01

aQuery := Afr074MountQry(nTipo)

cQry := "SELECT " + chr(13) + chr(10)

cQry += aQuery[1]	//Campos do select

cQry += "FROM " + chr(13) + chr(10)
cQry += "	" + RetSQLName("SNX") + " SNX " + chr(13) + chr(10)
cQry += "INNER JOIN " + chr(13) + chr(10)
cQry += "	" + RetSQLName("SN3") + " SN3  " + chr(13) + chr(10)
cQry += "ON " + chr(13) + chr(10)
cQry += "	N3_FILIAL = NX_FILIAL " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	SN3.D_E_L_E_T_ = ' '   " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	N3_CODRAT = NX_CODRAT " + chr(13) + chr(10)

If Alltrim(mv_par22) <> "*"
	cQry += "	AND  " + chr(13) + chr(10)
	cQry += "	N3_TPSALDO = '" + mv_par22 + "'  " + chr(13) + chr(10)			// MV_PAR22 (SE *, NAO COLOCAR NO FILTRO)
Endif

cQry += "INNER JOIN " + chr(13) + chr(10)
cQry += "	" + RetSQLName("SN1") + " SN1  " + chr(13) + chr(10)
cQry += "ON " + chr(13) + chr(10)
cQry += "	N1_FILIAL = NX_FILIAL " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	N1_CBASE = N3_CBASE " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	N1_ITEM = N3_ITEM " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	N1_GRUPO BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'	 " + chr(13) + chr(10)		// MV_PAR04 | MV_PAR05
cQry += "	AND " + chr(13) + chr(10)
cQry += "	N1_CBASE BETWEEN '" + mv_par06 + "' AND '" + mv_par08 + "'	 " + chr(13) + chr(10)		// MV_PAR06 | MV_PAR08
cQry += "	AND " + chr(13) + chr(10)
cQry += "	N1_ITEM  BETWEEN '" + mv_par07 + "' AND '" + mv_par09 + "'	 " + chr(13) + chr(10)		// MV_PAR07 | MV_PAR09
cQry += "	AND " + chr(13) + chr(10)
cQry += "	N1_AQUISIC BETWEEN '" + dtos(mv_par10) + "' AND '" + dtos(mv_par11) + "'  " + chr(13) + chr(10)		// MV_PAR10 | MV_PAR11
cQry += "	AND  " + chr(13) + chr(10)
cQry += "	SN1.D_E_L_E_T_ = ' ' " + chr(13) + chr(10)
cQry += "WHERE " + chr(13) + chr(10)
	
If mv_par20 == 1 //seleciona filiais = sim

	aSelFil := AdmGetFil()
	
    If len(aSelFil) > 0
		cQry += "	NX_FILIAL " + GetRngFil( aSelFil, 'SNX', .T., @cTmpFil ) + chr(13) + chr(10)
		cQry += "	AND " + chr(13) + chr(10)
	Endif
Else
	cQry += "	NX_FILIAL = '" + xFilial("SNX")	+ "'  " + chr(13) + chr(10)
	cQry += "	AND	 " + chr(13) + chr(10)
EndIf

cQry += "	SNX.D_E_L_E_T_ = ' ' " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	NX_MOEDA = '" + mv_par21 + "'  " + chr(13) + chr(10)								// MV_PAR21

If nTipo == 1
	cQry += "	AND " + chr(13) + chr(10)
	cQry += "	NX_DTMOV BETWEEN '" + dtos(mv_par02) + "' AND '" + dtos(mv_par03) + "'  " + chr(13) + chr(10)			// MV_PAR02 | MV_PAR03 (SOMENTE PARA TIPO REL = 1)
Endif

If mv_par01 == 3

	Do Case 
	Case mv_par23 == 1	
		
		cExpQry := Iif(Empty(mv_par12), "NX_NIV01 > ' '", "NX_NIV01 >= '" + mv_par12 + "' ")
		
		cQry += "	AND " + chr(13) + chr(10)
		cQry += "	" + cExpQry + chr(13) + chr(10)
		cQry += "	AND " + chr(13) + chr(10)
		cQry += " 	NX_NIV01 <= '" + mv_par13 + "'  " + chr(13) + chr(10)
		
	Case mv_par23 == 2
	
		cExpQry := Iif(Empty(mv_par14), "NX_NIV02 > ' '", "NX_NIV02 >= '" + mv_par14 + "' ")
		
		cQry += "	AND " + chr(13) + chr(10)
		cQry += "	" + cExpQry + chr(13) + chr(10)
		cQry += "	AND " + chr(13) + chr(10)
		cQry += " 	NX_NIV02 <= '" + mv_par15 + "'  " + chr(13) + chr(10)
	
	Case mv_par23 == 3
	
		cExpQry := Iif(Empty(mv_par16), "NX_NIV03 > ' '", "NX_NIV03 >= '" + mv_par16 + "' ")
		
		cQry += "	AND " + chr(13) + chr(10)
		cQry += "	" + cExpQry + chr(13) + chr(10)
		cQry += "	AND " + chr(13) + chr(10)
		cQry += " 	NX_NIV03 <= '" + mv_par17 + "'  " + chr(13) + chr(10)

	Otherwise	
	
		cExpQry := Iif(Empty(mv_par18), "NX_NIV04 > ' '", "NX_NIV04 >= '" + mv_par18 + "' ")
		
		cQry += "	AND " + chr(13) + chr(10)
		cQry += "	" + cExpQry + chr(13) + chr(10)
		cQry += "	AND " + chr(13) + chr(10)
		cQry += " 	NX_NIV04 <= '" + mv_par18 + "'  " + chr(13) + chr(10)
	
	End Case
	
Else

	cQry += "	AND " + chr(13) + chr(10)
	cQry += "	NX_NIV01 BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'  " + chr(13) + chr(10)	// MV_PAR12 | MV_PAR13

	cQry += "	AND " + chr(13) + chr(10)
	cQry += "	NX_NIV02 BETWEEN '" + mv_par14 + "' AND '" + mv_par15 + "'	 " + chr(13) + chr(10)	// MV_PAR14 | MV_PAR15

	cQry += "	AND " + chr(13) + chr(10)
	cQry += "	NX_NIV03 BETWEEN '" + mv_par16 + "' AND '" + mv_par17 + "'	 " + chr(13) + chr(10)	// MV_PAR16 | MV_PAR17

	cQry += "	AND " + chr(13) + chr(10)
	cQry += "	NX_NIV04 BETWEEN '" + mv_par18 + "' AND '" + mv_par19 + "'  " + chr(13) + chr(10)	// MV_PAR18 | MV_PAR19

Endif

cQry += aQuery[2] //Group e order

If Select("TRBATF") > 0
	TRBATF->(DbCloseArea())
Endif

cQry := ChangeQuery(cQry)

dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "TRBATF" , .T. , .F.)

CtbTmpErase(cTmpFil)
      	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Afr074MountQry³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Define as caracteristicas do arquivo e query de acordo com o 	  ³±±
±±³          ³tipo de relatorio.									  	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Afr074MountQry(nTipo)										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nTipo	- Numerico: Tipo de Relatorio				  		      ³±±
±±³          ³		1 - Movimentos do rateio mostrado por data  		      ³±±
±±³          ³		2 - Bem / Entidade							  		      ³±±
±±³          ³		2 - Entidade / Bem							  		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array[1] - String: com os campos de select				      ³±±
±±³          ³Array[2] - String: Clausulas como Group e Order			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 - GetQry                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Afr074MountQry(nTipo)

Local cFldSelect	:= ""	// Campos do Select
Local cEntities		:= ""	// Campos das entidades contabeis
Local cClauses		:= ""
Local cEntidade		:= ""
Local cAliasEnt		:= ""
Local cEntiDest		:= ""
Local cDescEnt		:= ""
Local nI			:= 0
Local aEnt			:= {}

cEntities := RetEntities("1")

Do Case

Case nTipo == 1
	cFldSelect := "	NX_FILIAL	FILIAL, " + chr(13) + chr(10)
	cFldSelect += "	NX_DTMOV 	DTMOV, " + chr(13) + chr(10)
	cFldSelect += "	N3_CBASE 	CBASE, " + chr(13) + chr(10)
	cFldSelect += "	N3_ITEM 	ITEM, " + chr(13) + chr(10)
	cFldSelect += "	N1_DESCRIC 	DESCR, " + chr(13) + chr(10)
	cFldSelect += "	N3_TIPO 	TIPO, " + chr(13) + chr(10)
	cFldSelect += "	N3_TPSALDO 	TPSALDO, " + chr(13) + chr(10)
	cFldSelect += "	NX_MOEDA 	MOEDA, " + chr(13) + chr(10)
	cFldSelect += cEntities + chr(13) + chr(10)
	cFldSelect += "	NX_VLRMOV 	VLRRATE, " + chr(13) + chr(10)
	cFldSelect += "	NX_VLRBASE 	VLRDEPR " + chr(13) + chr(10)
	
	cClauses := " ORDER BY " + chr(13) + chr(10)
	cClauses += "	NX_FILIAL, " + chr(13) + chr(10)
	cClauses += "	N3_CBASE, " + chr(13) + chr(10)
	cClauses += "	N3_ITEM, " + chr(13) + chr(10)
	cClauses += "	N3_TIPO, " + chr(13) + chr(10)
	cClauses += "	NX_DTMOV, " + chr(13) + chr(10)
	cClauses += "	N3_TPSALDO
	
Case nTipo == 2

	cFldSelect := "	NX_FILIAL	FILIAL, " + chr(13) + chr(10)
	cFldSelect += "	NX_CODRAT	CODRAT, " + chr(13) + chr(10)
	cFldSelect += "	NX_SEQUEN	SEQUEN, " + chr(13) + chr(10)
	cFldSelect += "	N1_CBASE 	CBASE,	 " + chr(13) + chr(10)
	cFldSelect += "	N1_ITEM 	ITEM, " + chr(13) + chr(10)
	cFldSelect += "	N1_DESCRIC 	DESCR, " + chr(13) + chr(10)	
	cFldSelect += cEntities + chr(13) + chr(10)
	cFldSelect += "	NX_MOEDA 	MOEDA, " + chr(13) + chr(10)
	cFldSelect += "	SUM(NX_VLRMOV) VLRRATE, " + chr(13) + chr(10)
	cFldSelect += "	SUM(NX_VLRBASE) VLRDPACM " + chr(13) + chr(10)
	
	cClauses := " GROUP BY " + chr(13) + chr(10)
  	cClauses += "	NX_FILIAL, " + chr(13) + chr(10)   
	cClauses += "	NX_CODRAT, " + chr(13) + chr(10)   
	cClauses += "	NX_SEQUEN, " + chr(13) + chr(10)   
	cClauses += "	N1_CBASE, " + chr(13) + chr(10)   
	cClauses += "	N1_ITEM, " + chr(13) + chr(10)   
	cClauses += "	N1_DESCRIC, " + chr(13) + chr(10)   
	cClauses += "	NX_MOEDA, " + chr(13) + chr(10)	
	
	aEnt := Separa(Substr(cEntities,1,Rat(",",cEntities)-1),",")
	                        
	cEntities := ""
	
	For nI := 1 to len(aEnt)
		cEntities += Substr(aEnt[nI],1,Rat(space(1),aEnt[nI])) + ", " + chr(10)
	Next nI	
	
	cClauses += Substr(cEntities,1, ( Rat(",",cEntities) -1 ) ) + chr(13) + chr(10)
  	
	cClauses += " ORDER BY " + chr(13) + chr(10)
	cClauses += " 	NX_FILIAL, " + chr(13) + chr(10)
	cClauses += " 	N1_CBASE, " + chr(13) + chr(10)
	cClauses += " 	N1_ITEM, " + chr(13) + chr(10)
	cClauses += " 	NX_CODRAT, " + chr(13) + chr(10)
	cClauses += " 	NX_SEQUEN " 

OtherWise

	Do Case 
	Case mv_par23 == 1
		cEntidade := "NX_NIV01"
		cAliasEnt := "CT1"
		cEntiDest := "CT1_CONTA"		
	Case mv_par23 == 2         
		cEntidade := "NX_NIV02"
		cAliasEnt := "CTT"	
		cEntiDest := "CTT_CUSTO"
	Case mv_par23 == 3
		cEntidade := "NX_NIV03"
		cAliasEnt := "CTD"
		cEntiDest := "CTD_ITEM"	
	Otherwise
		cEntidade := "NX_NIV04"	
		cAliasEnt := "CTH"
		cEntiDest := "CTH_CLVL"	
    End Case                         
      
	cFldSelect := "	NX_FILIAL FILIAL, " + chr(13) + chr(10)
	cFldSelect += " " + cEntidade + "	ENTIDA, " + chr(13) + chr(10)
	cFldSelect += cDescEnt 
	cFldSelect += " N1_CBASE CBASE, " + chr(13) + chr(10)
	cFldSelect += " N1_ITEM	ITEM, " + chr(13) + chr(10)
	cFldSelect += " N1_DESCRIC DESCR, " + chr(13) + chr(10)
	cFldSelect += " NX_CODRAT CODRAT, " + chr(13) + chr(10)
	cFldSelect += " NX_MOEDA MOEDA, " + chr(13) + chr(10)
	cFldSelect += " SUM(NX_VLRMOV) VLRRATE " + chr(13) + chr(10)

	cClauses := " GROUP BY " + chr(13) + chr(10)
	cClauses += " 	NX_FILIAL, " + chr(13) + chr(10)
	cClauses += " 	" + cEntidade + ", " + chr(13) + chr(10)
	cClauses += "	N1_CBASE, " + chr(13) + chr(10)
	cClauses += "	N1_ITEM	, " + chr(13) + chr(10)
	cClauses += "	N1_DESCRIC, " + chr(13) + chr(10)
	cClauses += "	NX_CODRAT, " + chr(13) + chr(10)
	cClauses += "	NX_MOEDA " + chr(13) + chr(10)
	cClauses += "ORDER BY " + chr(13) + chr(10)
	cClauses += "	NX_FILIAL, " + chr(13) + chr(10)
	cClauses += " 	" + cEntidade + ", " + chr(13) + chr(10)
	cClauses += "	N1_CBASE, " + chr(13) + chr(10)
	cClauses += "	N1_ITEM " + chr(13) + chr(10)

End Case

Return({cFldSelect,cClauses})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetEntities	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Define as caracteristicas do arquivo e query de acordo com o 	  ³±±
±±³          ³tipo de relatorio.									  	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³RetEntities(cTipoRet)										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cTipoRet	- String: Define o tipo de retorno 		  		      ³±±
±±³          ³		1 - Retorna as entidades em forma de string para uso em	  ³±±
±±³          ³		query na clausula SELECT.							      ³±±
±±³          ³		2 - Retorna as Entidades em Array unidimensional		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³xRet - String/Array: conforme o parametro cTipoRet		      ³±±
±±³          ³		1- String: com as entidades separadas por virgula	      ³±±
±±³          ³		2- Array: com as entidades em cada indice			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 				                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetEntities(cTipoRet)

Local cCompl		:= ""	// Numerador de campos das entidades pela base da tabela CTO

Local aDescEnt		:= {"CONTA","CUSTO","ITCTB","CLASSE"}

Local nQtdEnt		:= 0
Local nBaseEnt		:= 0
Local nI			:= 0
Local cCampo		:= ""
Local aCpo			:= {} 
Local aCpoRel		:= {}
Local aAreaCT0		:= CT0->(GetArea())
Local xRet :={}
Local nQtdEntATF   := 0

nBaseEnt := len(aDescEnt)

//Compoe as entidades contabeis

If Alltrim(cTipoRet) $ "1|2|3"
		
	xRet := ""
	CT0->(dbGoTop())
	CT0->(DbEval( {|| nQtdEnt++ },,{|| CT0_FILIAL == xFilial("CT0")} ))
	
	For nI := 1 to nBaseEnt
		cCompl := strzero(nI,TamSx3("CT0_ID")[1])
		cCampo := "NX_NIV" + cCompl
		if SNX->(FieldPos(cCampo)) > 0
			xRet += " "+ cCampo + space(1) + aDescEnt[nI] + ", "  + chr(13) + chr(10)
			aAdd(aCpo,cCampo)
		endif	
	Next nI	
	
	For nI := nBaseEnt+1 to nQtdEnt
		cCompl := strzero(nI,TamSx3("CT0_ID")[1])
		cCampo := "NX_EC" + cCompl +"DB" 
		if SNX->(FieldPos(cCampo)) > 0
			xRet += " "+ cCampo + space(1) + "NIV" + cCompl + ", " + chr(13) + chr(10)
			aAdd(aCpo,cCampo)
		endif	
	Next nI

	If Alltrim(cTipoRet) == "2"
		xRet := Substr(xRet,1, Rat(",",xRet) - 1 )
		xRet := Separa(xRet,",")
		
		For nI := 1 to len(xRet)
			xRet[nI] := Substr(xRet[nI],RAt(space(1),xRet[nI]))
			xRet[nI] := Alltrim(xRet[nI])
		Next nI
	Endif
	
	If Alltrim(cTipoRet) == "3"
		xRet := aClone(aCpo)
	EndIF
Endif

If !isBlind()
	If cTipoRet = '3' .and. Len(aCpo) <> nQtdEnt
		Help(" ",1,"ATFR074_ENTIDADES",,STR0033,1,0) 
	Endif
EndIf

RestArea(aAreaCT0)	
Return(xRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetDescEnt	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta a descricao das colunas do relatorio para as n entidades  ³±±
±±³          ³contabeis que possam existir.							  	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³RetDescEnt(aEnt)											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aEnt	- Array: Entidades Contabeis		 		  		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aRetDsc - Array: Descricao das Entidades do array aEnt	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 				                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetDescEnt(aEnt)

Local aRetDsc	:= {STR0017,STR0018,STR0019,STR0020}//#"Conta Contab."#"Centro Custo"#"Item da Conta"#"Classe de valor"

Local nI		:= 0

If Len(aEnt) > 4
	For nI := 5 to len(aEnt)
		aAdd(aRetDsc,STR0021 + Right(aEnt[nI],2))//#"Ent. Contab. "
	Next nI                
Endif
Return(aRetDsc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Afr074PrtTop	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de auxilio para a chamada da impressao do relatorio	  ³±±
±±³          ³definido pelo tipo no parametro mv_par01				  	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Afr074PrtTop(oReport)										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oReport	- objeto: Inst. classe tReport	 		  		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 				                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Afr074PrtTop(oReport)


Do Case
Case mv_par01 == 1 	// Movimentos
	Afr074PMov(oReport)
Case mv_par01 == 2 	// Bem X entidade
	Afr074PBem(oReport)
Otherwise			// entidade x Bem
	Afr074PEnt(oReport)	
End Case

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Afr074PMov	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio dos movimentos de rateio					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Afr074PMov(oReport)										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oReport	- objeto: Inst. classe tReport	 		  		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 				                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Afr074PMov(oReport)

Local oSecCab 		:= oReport:Section(1)
Local oSecIte		:= oReport:Section(1):Section(1)
Local oSecRod		:= oReport:Section(2)
Local oSecRod2		:= oReport:Section(3)

Local cAfr074Fil    := ""
Local cBase			:= ""
Local cItem			:= ""
Local cTipo			:= ""
Local cTpSaldo		:= ""
Local cEntidade		:= ""
Local cDtMov		:= ""   	

Local aTotalDep		:= Eval({|x| x := Array(3),aFill(x,0),x })	//total geral
Local nTtlTpDep		:= 0										//total por tipo
Local aTotalBem		:= Eval({|x| x := Array(3),aFill(x,0),x })	//total por Bem e item
Local aTtlDepFil    := Eval({|x| x := Array(3),aFill(x,0),x })	//total por filial

Local nI			:= 0

Local lFirst		:= .T.

Local aEntities		:= RetEntities("2")
Local aTipoAtv		:= {AtfxTpBem(1),AtfxTpBem(2),AtfxTpBem(3)} //Tipos Fiscais/Gerenciais e Incentivados

TRBATF->(DbGotop())

While TRBATF->(!Eof())
    
    If Alltrim(TRBATF->DTMOV) <> Alltrim(cDtMov) .or. Alltrim(TRBATF->FILIAL+TRBATF->CBASE+TRBATF->ITEM+TRBATF->TIPO+TRBATF->TPSALDO) <> Alltrim(cAfr074Fil+cBase+cItem+cTipo+cTpSaldo)
    
    	Afr074Total(TRBATF->TIPO,TRBATF->VLRDEPR,aTotalDep,aTipoAtv)	//total geral
    	Afr074Total(TRBATF->TIPO,TRBATF->VLRDEPR,aTtlDepFil,aTipoAtv)	//total por filial	
	    Afr074Total(TRBATF->TIPO,TRBATF->VLRDEPR,aTotalBem,aTipoAtv)	//total por bem e item	
	    nTtlTpDep += TRBATF->VLRDEPR									//total por tipo de bem

    Endif
    
    
	If Alltrim(TRBATF->FILIAL+TRBATF->CBASE+TRBATF->ITEM+TRBATF->TIPO+TRBATF->TPSALDO) <> Alltrim(cAfr074Fil+cBase+cItem+cTipo+cTpSaldo)
    	
    	oSecCab:Init()
    	
    	oSecCab:Cell("FILIAL"):SetValue( TRBATF->FILIAL)
		oSecCab:Cell("CBASE"):SetValue( TRBATF->CBASE )
		oSecCab:Cell("ITEM"):SetValue( TRBATF->ITEM )
		oSecCab:Cell("DESCR"):SetValue( TRBATF->DESCR )
		oSecCab:Cell("TIPO"):SetValue( TRBATF->TIPO )
		oSecCab:Cell("TPSALDO"):SetValue( TRBATF->TPSALDO )
		oSecCab:Cell("VLRORIG"):SetValue( AFR074ValOrig(TRBATF->FILIAL,TRBATF->CBASE,TRBATF->ITEM,TRBATF->TIPO,TRBATF->TPSALDO,TRBATF->MOEDA))
		
		oSecCab:PrintLine()
		oReport:ThinLine()
		
		oSecCab:Finish()
		
		lFirst := .t.
		
    Endif
    
    If lFirst
		oSecIte:Init()
		lFirst := .f.
    Endif
    
    If Alltrim(TRBATF->DTMOV) <> Alltrim(cDtMov) .or. Alltrim(TRBATF->FILIAL+TRBATF->CBASE+TRBATF->ITEM+TRBATF->TIPO+TRBATF->TPSALDO) <> Alltrim(cAfr074Fil+cBase+cItem+cTipo+cTpSaldo) 
	    oSecIte:Cell("DTMOV"):Show()
	    oSecIte:Cell("VLRDEPR"):Show()
    Else                            
    	oSecIte:Cell("DTMOV"):Hide()  
    	oSecIte:Cell("VLRDEPR"):Hide()
    Endif
    
	oSecIte:Cell("DTMOV"):SetValue(  stod(TRBATF->DTMOV) )
	oSecIte:Cell("VLRDEPR"):SetValue(  TRBATF->VLRDEPR  )
	oSecIte:Cell("VLRRATE"):SetValue(  TRBATF->VLRRATE )
	
    For nI := 1 to len(aEntities)
	    cEntidade := aEntities[nI]
    	oSecIte:Cell(aEntities[nI]):SetValue(&(" TRBATF->"+cEntidade+" "))
	Next nI
	
	oSecIte:PrintLine()    	
        
    cAfr074Fil	:= TRBATF->FILIAL
	cBase		:= TRBATF->CBASE
	cItem		:= TRBATF->ITEM
	cTipo		:= TRBATF->TIPO
	cTpSaldo	:= TRBATF->TPSALDO
   	cDtMov		:= TRBATF->DTMOV
   	
	TRBATF->(DbSkip()) 
	
	//Imprime total por tipo de bem
	If Alltrim(TRBATF->FILIAL+TRBATF->CBASE+TRBATF->ITEM+TRBATF->TIPO+TRBATF->TPSALDO) <> Alltrim(cAfr074Fil+cBase+cItem+cTipo+cTpSaldo)
		
		oSecRod:Init()
		oSecRod2:Init()
		
		oSecRod:Cell("TOTAL"):SetValue(  STR0022 + Alltrim(cBase) + STR0023 + Alltrim(cItem) + STR0024 + Alltrim(cTipo)) //#"Total do Bem "#" Item "#" e Tipo "
		oSecRod:PrintLine()
		
		oSecRod2:Cell("TOTALDEP"):SetValue(  nTtlTpDep ) 
		oSecRod2:PrintLine()
		
		oReport:ThinLine()
				
		nTtlTpDep := 0	
		
		oSecRod:Finish()
		oSecRod2:Finish()
		oSecIte:Finish()
	Endif

	If Alltrim(TRBATF->FILIAL+TRBATF->CBASE+TRBATF->ITEM) <> Alltrim(cAfr074Fil+cBase+cItem)
	
		oSecRod:Init()
		oSecRod2:Init()
			
		oSecRod:Cell("TOTAL"):SetValue(  STR0022 + Alltrim(cBase) + STR0023 + Alltrim(cItem)) 
		oSecRod:PrintLine()
		
		oSecRod2:Cell("TIPOATV"):SetValue(  STR0025 )	//#"FISCAL"
		oSecRod2:Cell("TOTALDEP"):SetValue(  aTotalBem[1] ) 
				
		oSecRod2:PrintLine()
			
		oSecRod2:Cell("TIPOATV"):SetValue(  STR0026 )	//#"GERENCIAL"
		oSecRod2:Cell("TOTALDEP"):SetValue(  aTotalBem[2] ) 
				
		oSecRod2:PrintLine()
	                           
		oSecRod2:Cell("TIPOATV"):SetValue(  STR0027 ) //#"INCENTIVADO"
		oSecRod2:Cell("TOTALDEP"):SetValue(  aTotalBem[3] ) 
				
		oSecRod2:PrintLine()
		
		aFill(aTotalBem,0) 
		
		oReport:ThinLine()
		
		oSecRod:Finish()
		oSecRod2:Finish()
		oSecIte:Finish()

	Endif

	
	//Imprime total por Filial
	If Alltrim(TRBATF->FILIAL) <> Alltrim(cAfr074Fil)  
        
		oSecRod:Init()
		oSecRod2:Init()
		
		oSecRod:Cell("TOTAL"):SetValue(  STR0028 + Alltrim(cAfr074Fil) ) //#"Total da Filial: "
		oSecRod:PrintLine()
				
		oSecRod2:Cell("TIPOATV"):SetValue(  STR0025 ) //#"FISCAL"
		oSecRod2:Cell("TOTALDEP"):SetValue(  aTtlDepFil[1] ) 
				
		oSecRod2:PrintLine()


		oSecRod2:Cell("TIPOATV"):SetValue(  STR0026 ) //#"GERENCIAL"
		oSecRod2:Cell("TOTALDEP"):SetValue(  aTtlDepFil[2] ) 
				
		oSecRod2:PrintLine()
                           
		oSecRod2:Cell("TIPOATV"):SetValue(  STR0027 ) //#"INCENTIVADO" 
		oSecRod2:Cell("TOTALDEP"):SetValue(  aTtlDepFil[3] ) 
				
		oSecRod2:PrintLine()
		//nTtlDepFil := 0
		
		aFill(aTtlDepFil,0) 
		
		oReport:ThinLine()
		
		oSecRod:Finish()
		oSecRod2:Finish()
		oSecIte:Finish()
	Endif
	
EndDo

oSecRod:Init()
oSecRod2:Init()

oSecRod:Cell("TOTAL"):SetValue(  STR0029  ) //#"TOTAL GERAL"
//oSecRod:Cell("TOTAL"):SetValue(  Replicate("*",80) + "TOTAL GERAL" + Replicate("*",80) ) 
oSecRod:PrintLine()

oSecRod2:Cell("TIPOATV"):SetValue(  STR0025 ) //#"FISCAL"	
oSecRod2:Cell("TOTALDEP"):SetValue(  aTotalDep[1] ) 
		
oSecRod2:PrintLine()


oSecRod2:Cell("TIPOATV"):SetValue(  STR0026 )//#"GERENCIAL" 	
oSecRod2:Cell("TOTALDEP"):SetValue(  aTotalDep[2] ) 
		
oSecRod2:PrintLine()
                           
oSecRod2:Cell("TIPOATV"):SetValue(  STR0027 )	//#"INCENTIVADO" 
oSecRod2:Cell("TOTALDEP"):SetValue(  aTotalDep[3] ) 
		
oSecRod2:PrintLine()

oSecRod:Finish()
oSecRod2:Finish()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Afr074PBem	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio Bem / entidade 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Afr074PBem(oReport)										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oReport	- objeto: Inst. classe tReport	 		  		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 				                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Afr074PBem(oReport)

Local oSecCab 		:= oReport:Section(1)
Local oSecIte		:= oReport:Section(1):Section(1)

Local cAfr074Fil    := ""
Local cCodRat		:= ""

Local nI			:= 0

Local lFirst 		:= .t.

Local aEntities 	:= RetEntities("2")
Local aSN3Data		:= {}

TRBATF->(DbGotop())

While TRBATF->(!Eof())
	
	//Dados Fixo - Cabecalho
	If Alltrim(TRBATF->FILIAL+TRBATF->CODRAT) <> Alltrim(cAfr074Fil+cCodRat)   
		
		aSn3Data := SN3->(GetAdvFVal("SN3",{"N3_TIPO","N3_TPSALDO"},TRBATF->FILIAL+Padr(TRBATF->CODRAT,TamSx3("N3_CODRAT")[1]),10))
		
		oSecCab:Init()  
		
		oSecCab:Cell("FILIAL"):SetValue( TRBATF->FILIAL )
		oSecCab:Cell("CBASE"):SetValue( TRBATF->CBASE )
		oSecCab:Cell("ITEM"):SetValue( TRBATF->ITEM )
		oSecCab:Cell("DESCR"):SetValue( TRBATF->DESCR )
		oSecCab:Cell("TIPO"):SetValue( aSn3Data[1] )
		oSecCab:Cell("TPSALDO"):SetValue( aSn3Data[2] )
		oSecCab:Cell("VLRORIG"):SetValue( AFR074ValOrig(TRBATF->FILIAL,TRBATF->CBASE,TRBATF->ITEM,aSn3Data[1],aSn3Data[2],TRBATF->MOEDA) )
		oSecCab:Cell("VLRDPACM"):SetValue( TRBATF->VLRDPACM )

		oSecCab:PrintLine()

		oReport:ThinLine()
		
		oSecCab:Finish()  
		
		lFirst := .t.
	Endif
    
    
    If lFirst
    	oSecIte:Init()
    	lFirst := .f.
    Endif	
    
    //impressao dos itens
    For nI := 1 to len(aEntities)
	    cEntidade := aEntities[nI]
    	oSecIte:Cell(aEntities[nI]):SetValue(&("TRBATF->"+cEntidade+" "))
	Next nI
	
	oSecIte:Cell("VLRRATE"):SetValue(  TRBATF->VLRRATE  )
    
    oSecIte:PrintLine()
    
    cAfr074Fil	:= TRBATF->FILIAL
	cCodRat		:= TRBATF->CODRAT
	
	TRBATF->(DbSkip()) 
		
	//Imprime a linha de separacao
	If Alltrim(TRBATF->FILIAL+TRBATF->CODRAT) <> Alltrim(cAfr074Fil+cCodRat)
		oSecIte:Finish()
		//oReport:SkipLine()
	Endif
	
EndDo


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Afr074PEnt	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio Entidade / Bem 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Afr074PEnt(oReport)										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oReport	- objeto: Inst. classe tReport	 		  		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nil															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 				                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function Afr074PEnt(oReport)

Local oSecCab 		:= oReport:Section(1)
Local oSecIte		:= oReport:Section(1):Section(1)
Local oSecRod		:= oReport:Section(2)

Local cAfr074Fil    := ""
Local cEntidade		:= ""

Local nTotalRat		:= 0
Local nTtlRatFil	:= 0

Local lFirst		:= .t.	

Local aSN3Data		:= {}

TRBATF->(DbGotop())

While TRBATF->(!Eof())
	
	aSn3Data := SN3->(GetAdvFVal("SN3",{"N3_TIPO","N3_TPSALDO"},TRBATF->FILIAL+Padr(TRBATF->CODRAT,TamSx3("N3_CODRAT")[1]),10))
	
	nTotalRat	+= TRBATF->VLRRATE
	nTtlRatFil  += TRBATF->VLRRATE
	
	If Alltrim(TRBATF->FILIAL + TRBATF->ENTIDA) <> Alltrim(cAfr074Fil + cEntidade)
		
		oSecCab:Init()  
		
		oSecCab:Cell("FILIAL"):SetValue( TRBATF->FILIAL )
		oSecCab:Cell("ENTIDA"):SetValue( TRBATF->ENTIDA )
		oSecCab:Cell("DESCENT"):SetValue( AFR074Ent( TRBATF->ENTIDA )  ) 
		
		oSecCab:PrintLine()
		oReport:ThinLine()
		
		oSecCab:Finish()  
		
		lFirst := .t.
	Endif
	
	If lFirst
		oSecIte:Init()
	Endif	
	
	oSecIte:Cell("CBASE"):SetValue( TRBATF->CBASE )
	oSecIte:Cell("ITEM"):SetValue( TRBATF->ITEM )
	oSecIte:Cell("DESCR"):SetValue( TRBATF->DESCR ) 
	oSecIte:Cell("TIPO"):SetValue( aSn3Data[1] )
	oSecIte:Cell("TPSALDO"):SetValue( aSn3Data[2] )
	oSecIte:Cell("VLRORIG"):SetValue( AFR074ValOrig(TRBATF->FILIAL,TRBATF->CBASE,TRBATF->ITEM,aSn3Data[1],aSn3Data[2],TRBATF->MOEDA) )
	oSecIte:Cell("VLRRATE"):SetValue(  TRBATF->VLRRATE  ) 
	
	oSecIte:PrintLine()
	
	cAfr074Fil	:= TRBATF->FILIAL
	cEntidade	:= TRBATF->ENTIDA
	
	TRBATF->(DbSkip())
	 
	//Imprime os totais pela entidade
	If Alltrim(TRBATF->FILIAL + TRBATF->ENTIDA) <> Alltrim(cAfr074Fil + cEntidade)

		oSecRod:Init()
		
		oSecRod:Cell("TOTAL"):SetValue(  STR0030 + Alltrim(cEntidade) ) //#"Total rateado da Entidade: "
		oSecRod:Cell("TOTALRAT"):SetValue(  nTotalRat ) 
		oSecRod:PrintLine()
		
		oReport:ThinLine()

		nTotalRat := 0
		oSecRod:Finish()
		oSecIte:Finish()
	Endif
    
	//Imprime os totais pela filial
	If Alltrim(TRBATF->FILIAL) <> Alltrim(cAfr074Fil)   
	
		oSecRod:Init()
		
		oSecRod:Cell("TOTAL"):SetValue(  STR0028 + Alltrim(cAfr074Fil) ) //#"Total da Filial: "
		oSecRod:Cell("TOTALRAT"):SetValue(  nTtlRatFil ) 
		
		oSecRod:PrintLine()
		oReport:ThinLine()
		
		nTtlRatFil := 0
		
		oSecRod:Finish()
		oSecIte:Finish()
	Endif
	
EndDo

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AFR074ValOrig	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o valor original do bem na moeda passada por parametro  	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AFR074ValOrig(cParFil,cParBem,cParItem,cParTpBem,cParTpSld,cParMoeda)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cParFil	- String: Filial	 		  		      				   ³±±
±±³          ³cParBem	- String: Codigo Base do Bem	 		  		      	   ³±±
±±³          ³cParItem	- String: Item do Bem	 		  		    		  	   ³±±
±±³          ³cParTpBem	- String: Tipo de Bem	 		  				      	   ³±±
±±³          ³cParTpSld	- String: Tipo de Saldo	 				  		      	   ³±±
±±³          ³cParMoeda	- String: Codigo da Moeda		 		  		      	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³nRetVlr	- Numerico: Valor na Moeda parametrizada			  	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AFR074ValOrig(cParFil,cParBem,cParItem,cParTpBem,cParTpSld,cParMoeda)

Local nRetVlr	:= 0 

Local cFieldVlr	:= ""
Local cChave	:= ""

Local aAreaSN3	:= SN3->(GetArea())

cChave := Padr(cParFil,TamSX3("N3_FILIAL")[1]) +;
Padr(cParBem,TamSX3("N3_CBASE")[1])+;
Padr(cParItem,TamSX3("N3_ITEM")[1])+;
Padr(cParTpBem,TamSX3("N3_TIPO")[1])

SN3->(DbSetOrder(1))	//N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ

If SN3->(DbSeek(cChave)) 
	While SN3->(!Eof()) .and. Alltrim(SN3->N3_FILIAL) == Alltrim(cParFil) .and.; 
	Alltrim(SN3->N3_CBASE) == Alltrim(cParBem) .and. Alltrim(SN3->N3_ITEM) == alltrim(cParItem) .and. Alltrim(SN3->N3_TIPO) == Alltrim(cParTpBem)
		
		If alltrim(SN3->N3_TPSALDO) == Alltrim(cParTpSld)                 
			nRetVlr := SN3->&( "N3_VORIG" + Str(Val(cParMoeda),1) )
			Exit
		Endif

		SN3->(DbSkip())
	EndDo
Endif


RestArea(aAreaSN3)
Return(nRetVlr)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Afr074Total	³ Rev.  ³Fernando Radu Muscalu  ³ Data ³27.07.2011	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza o array de totais com o valor a ser somado para o grupo 	   ³±±
±±³          ³de tipos de bem de acordo com o tipo (SN3).						   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Afr074Total(cTipoBem,nValor,aTotal,aTipos)						   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cTipoBem	- String: tipo do Bem 		  		      				   ³±±
±±³          ³nValor	- numerico: Valor a ser somado	 		  		      	   ³±±
±±³          ³aTotal	- Array: Array de totais  		  		    		  	   ³±±
±±³          ³	aTotal[1]-Numerico: Total Tipo FISCAL	  		    		  	   ³±±
±±³          ³	aTotal[2]-Numerico: Total Tipo GERENCIAL  		    		  	   ³±±
±±³          ³	aTotal[3]-Numerico: Total Tipo INCENTIVADO 		    		  	   ³±±
±±³          ³aTipos	- Array: Tipos de Bem agrupados nas categorias seguir: 	   ³±±
±±³          ³	aTipos[1]-String: Cadeia com os tipos agrupados como FISCAL		   ³±±
±±³          ³	aTipos[2]-String: Cadeia com os tipos agrupados como GEREMCIAL	   ³±±
±±³          ³	aTipos[3]-String: Cadeia com os tipos agrupados como INCENTIVADO   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³nIL															  	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - ATFR074 				                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function Afr074Total(cTipoBem,nValor,aTotal,aTipos)

Local nPos	:= aScan(aTipos,{|x| alltrim(cTipoBem) $ x })

If nPos > 0
	aTotal[nPos] += nValor
Endif
                                  
Return()  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFR074EntºAutor  ³Microsiga           º Data ³  03/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a descrição da entidade                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AFR074Ent( cEntidade )
Local aArea := GetArea()
Local cAliasEnt := "CT1"
Local cCampo	:= "CT1_DESC01"

Do Case
	Case mv_par23 == 1
		cAliasEnt := "CT1"
		cCampo	:= "CT1_DESC01"
	Case mv_par23 == 2
		cAliasEnt := "CTT"
		cCampo	:= "CTT_DESC01"
	Case mv_par23 == 3
		cAliasEnt := "CTD"
		cCampo	:= "CTD_DESC01"
	Otherwise
		cAliasEnt := "CTH"
		cCampo	:= "CTH_DESC01"
	End Case
	
cDesc := AllTrim(GetAdvFVal(cAliasEnt,cCampo, xFilial(cAliasEnt) + cEntidade ,1))
RestArea(aArea)
Return cDesc
