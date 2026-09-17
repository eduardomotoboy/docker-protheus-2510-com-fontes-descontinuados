#INCLUDE "MATR126C.CH"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR126  ³ Autor ³ Alexandre Inacio Lemes³ Data ³24/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mapa de rastreamento do contrato de Parceria.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_Matr126C(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function U_Matr126C( cAlias, nReg )

Local oReport

PRIVATE lAuto     := (nReg!=Nil) 

//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
oReport:= ReportDef(nReg)
oReport:PrintDialog()
                                           
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³Alexandre Inacio Lemes ³Data  ³25/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mapa de rastreamento do contrato de Parceria.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01: nReg = Registro posicionado do SC3 apartir Browse  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ oExpO1: Objeto do relatorio                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(nReg)

Local oReport 
Local oSection1 
Local oCell         
Local oBreak
Local cTitle := STR0001 // "Mapa de Contratos de Parceria Demonstrado "

Local cAliasSC3 := GetNextAlias()

If Type("lAuto") == "U"
	lAuto := (nReg!=Nil)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                   					    ³
//³ mv_par01      // Emissao de				                                    ³
//³ mv_par02      // Emissao Ate              				                    ³
//³ mv_par03      // Contrato de                             				    ³
//³ mv_par04      // Contrato Ate                                				³
//³ mv_par05      // Fornecedor de                               				³
//³ mv_par06      // Fornecedor Ate                              				³
//³ mv_par07      // Loja de                                     				³
//³ mv_par08      // Loja Ate				                                    ³
//³ mv_par09      // Imprime Contratos todos/em Aberto/Atendidos/Parcialm.Atend.|
//³ mv_par10      // Centro de Custos de				                        |
//³ mv_par11      // Centro de Custos ate               				        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTR126",.F.)
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
oReport := TReport():New("MTR126",cTitle,If(lAuto,Nil,"MTR126"), {|oReport| ReportPrint(oReport,cAliasSC3,nReg)},STR0002+" "+STR0003) //"Emite um mapa para rastreamento dos contratos de parceria ate os titulos emitidos no SE2." 
oReport:SetLandscape() 
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:= TRSection():New(oReport,STR0017,{"SC3","SA2","SC7","SF1","SD1","SE2"},/*aOrdem*/) //"Emite um mapa para rastreamento dos contratos de parceria ate os titulos emitidos no SE2." 
oSection1:SetHeaderPage()

oSection1:SetNoFilter("SA2")
oSection1:SetNoFilter("SC7")
oSection1:SetNoFilter("SF1")
oSection1:SetNoFilter("SD1")
oSection1:SetNoFilter("SE2")

TRCell():New(oSection1,"C3_NUM"    ,"SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_EMISSAO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_COD"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_LOJA"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_NREDUZ" ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_ITEM"   ,"SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_QUANT"  ,"SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_TOTAL"  ,"SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_NUM"    ,"SC7",STR0018,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NREDUZSC7" ,"SA2",STR0014,"@!",20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_QUANT"  ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_TOTAL"  ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,SerieNfId("SD1",3,"D1_SERIE"),"SD1",SerieNfId("SD1",7,"D1_SERIE"),/*Picture*/,SerieNfId("SD1",6,"D1_SERIE"),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_DOC"    ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E2_PREFIXO","SE2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E2_NUM"    ,"SE2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E2_PARCELA","SE2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E2_TIPO"   ,"SE2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E2_VENCTO" ,"SE2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"SaldoSE2"  ,"SE2",STR0015,"@E 999,999,999.99",14,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSection1,oSection1:Cell("C3_NUM"),STR0013,.F.) // TOTAIS
TRFunction():New(oSection1:Cell("C7_QUANT"),NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.F.,.F.) //"Total da Quantida da AE "
TRFunction():New(oSection1:Cell("C7_TOTAL"),NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.F.,.F.) //"Total do Valor Total da AE"
TRFunction():New(oSection1:Cell("SaldoSE2"),NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.F.,.F.) //"Total do Valor Total da AE"

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Alexandre Inacio Lemes ³Data  ³25/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Mapa de rastreamento do contrato de Parceria.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSC3,nReg)

Local oSection1 := oReport:Section(1) 
Local nOrdem    := oReport:Section(1):GetOrder() 
Local nVlrAbat  := 0
Local nSaldoSE2 := 0
Local cPrefixo  := ""

Local cQuery := ""

If Type("lAuto") == "U"
	lAuto := (nReg!=Nil)
Endif

dbSelectArea("SC3")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega os parametro caso o relatorio for usado a partir do browse.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAuto
	dbSelectArea("SC3")
	dbGoto(nReg)	
	mv_par01 := SC3->C3_EMISSAO
	mv_par02 := SC3->C3_EMISSAO
	mv_par03 := SC3->C3_NUM      
	mv_par04 := SC3->C3_NUM      
	mv_par05 := SC3->C3_FORNECE  
	mv_par06 := SC3->C3_FORNECE  
	mv_par07 := SC3->C3_LOJA     
	mv_par08 := SC3->C3_LOJA     
	mv_par09 := 1
	mv_par10 := SC3->C3_CC
	mv_par11 := SC3->C3_CC		
EndIf

If mv_par09 == 1
	oReport:SetTitle(oReport:Title() + OemToAnsi(STR0008)) //" - Todos"
ElseIf mv_par09 == 2
	oReport:SetTitle(oReport:Title() + OemToAnsi(STR0009)) //" - Pendentes"
ElseIf mv_par09 == 3
	oReport:SetTitle(oReport:Title() + OemToAnsi(STR0010)) //" - Atendidos"
ElseIf mv_par09 == 4
	oReport:SetTitle(oReport:Title() + OemToAnsi(STR0016)) //" - Parcialmente Atendidos"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                        ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lAuto
		MakeSqlExpr(oReport:uParam)
	Endif	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	

	cQuery :="%"
	If mv_par09 == 2 
		cQuery += "AND C3_QUJE = 0 "	
	ElseIf mv_par09 == 3
		cQuery += "AND C3_QUJE >= C3_QUANT "	
	ElseIf mv_par09 == 4
		cQuery += "AND C3_QUJE <> 0 AND C3_QUJE < C3_QUANT "	
	Endif
	cQuery +="%"	

	BeginSql Alias cAliasSC3

	SELECT SC3.*
	
	FROM %table:SC3% SC3
	
	WHERE C3_FILIAL = %xFilial:SC3% AND 
  		  C3_EMISSAO >= %Exp:Dtos(mv_par01)% AND 
		  C3_EMISSAO <= %Exp:Dtos(mv_par02)% AND 
		  C3_NUM >= %Exp:mv_par03% AND 
		  C3_NUM <= %Exp:mv_par04% AND 	 	  
	 	  C3_FORNECE >= %Exp:mv_par05% AND 
		  C3_FORNECE <= %Exp:mv_par06% AND 
		  C3_LOJA >= %Exp:mv_par07% AND 
		  C3_LOJA <= %Exp:mv_par08% AND 	 	  	
		  C3_CC >= %Exp:mv_par10% AND 
		  C3_CC <= %Exp:mv_par11% AND 	 	  	
		  SC3.%NotDel% 
		  %Exp:cQuery%
		  
	ORDER BY %Order:SC3% 
			
	EndSql 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Novo Indice para pesquisa do SC7.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndSC7 := CriaTrab(,.F.)
IndRegua( "SC7", cIndSC7, "C7_FILIAL+C7_NUMSC+C7_ITEMSC" )
nOrderSC7 := RetIndex("SC7") + 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Novo Indice para pesquisa do SD1.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndSD1 := CriaTrab(,.F.)
IndRegua( "SD1", cIndSD1, "D1_FILIAL+D1_PEDIDO+D1_ITEMPC" )
nOrderSD1 := RetIndex("SD1") + 1

oReport:SetMeter(SC3->(LastRec()))
oSection1:Init()

dbSelectArea(cAliasSC3)
While !oReport:Cancel() .And. !(cAliasSC3)->(Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter()
	
	oSection1:Cell("C3_NUM"):Show()
	oSection1:Cell("C3_EMISSAO"):Show()
	oSection1:Cell("A2_COD"):Show()
	oSection1:Cell("A2_LOJA"):Show()
	oSection1:Cell("A2_NREDUZ"):Show()
	oSection1:Cell("C3_ITEM"):Show()
	oSection1:Cell("C3_QUANT"):Show()
	oSection1:Cell("C3_TOTAL"):Show()
	oSection1:Cell("C7_NUM"):Show()
	oSection1:Cell("NREDUZSC7"):Show()
	oSection1:Cell("C7_QUANT"):Show()
	oSection1:Cell("C7_TOTAL"):Show()
	oSection1:Cell(SerieNfId("SD1",3,"D1_SERIE")):Show()
	oSection1:Cell("D1_DOC"):Show()
	oSection1:Cell("E2_PREFIXO"):Show()
	oSection1:Cell("E2_NUM"):Show()
	oSection1:Cell("E2_PARCELA"):Show()
	oSection1:Cell("E2_TIPO"):Show()
	oSection1:Cell("E2_VENCTO"):Show()
	oSection1:Cell("SaldoSE2"):Show()
	
	oSection1:Cell("C7_QUANT"):SetValue(0)
	oSection1:Cell("C7_TOTAL"):SetValue(0)
	oSection1:Cell("SaldoSE2"):SetValue(0)
	
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+(cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA))
	oSection1:Cell("NREDUZSC7"):SetValue(SA2->A2_NREDUZ)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca todas as autorizacoes de entrega SC7 a qual o item do SC3 esteja vinculado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC7")
	SC7->(dbSetOrder(nOrderSC7))
	If SC7->(dbSeek(xFilial("SC7")+(cAliasSC3)->C3_NUM+(cAliasSC3)->C3_ITEM))
		
		While SC7->(!Eof()) .And. SC7->C7_NUMSC+SC7->C7_ITEMSC == (cAliasSC3)->C3_NUM+(cAliasSC3)->C3_ITEM
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processar somente Autorizacoes de Entrega                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SC7->C7_TIPO == 2
				
				oSection1:Cell("C7_NUM"):Show()
				oSection1:Cell("NREDUZSC7"):Show()
				oSection1:Cell("C7_QUANT"):Show()
				oSection1:Cell("C7_TOTAL"):Show()
				
				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
				
				oSection1:Cell("NREDUZSC7"):SetValue(SA2->A2_NREDUZ)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Totaliza valor e quantidade das AES                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSection1:Cell("C7_QUANT"):SetValue( SC7->C7_QUANT )
				oSection1:Cell("C7_TOTAL"):SetValue( SC7->C7_TOTAL )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Busca todas as notas de entrada SD1 a qual o item do SC7 AE esteja vinculado.    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SD1")
				SD1->(dbSetOrder(nOrderSD1))
				If SD1->(dbSeek(xFilial("SD1")+SC7->C7_NUM+SC7->C7_ITEM))
					While SD1->(!Eof()) .And. SD1->D1_PEDIDO+SD1->D1_ITEMPC == SC7->C7_NUM+SC7->C7_ITEM
						
						oSection1:Cell(SerieNfId("SD1",3,"D1_SERIE")):Show()
						oSection1:Cell("D1_DOC"):Show()
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona o SF1 para buscar todos os titulos SE2 vinculados. ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SF1")
						SF1->(dbSetOrder(1))
						SF1->(dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
						
						cPrefixo := If(Empty(SF1->F1_PREFIXO),&(GetMV("MV_2DUPREF")),SF1->F1_PREFIXO)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Busca todos os Titulos SE2 vinculados a NFE.  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SE2")
						SE2->(dbSetOrder(6))
						If SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+cPrefixo+SF1->F1_DOC))
							
							While SE2->(!Eof()) .And. xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+cPrefixo+SF1->F1_DOC == ;
								SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM
								
								oSection1:Cell("E2_PREFIXO"):Show()
								oSection1:Cell("E2_NUM"):Show()
								oSection1:Cell("E2_PARCELA"):Show()
								oSection1:Cell("E2_TIPO"):Show()
								oSection1:Cell("E2_VENCTO"):Show()
								
								If SE2->E2_TIPO == PadR(MVNOTAFIS,Len(SE2->E2_TIPO))
									
									nVlrAbat := FaAbatCP(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_MOEDA,"S",dDataBase)
									nSaldoSE2:= Max(SE2->E2_SALDO - nVlrAbat,0)
									
									oSection1:Cell("SaldoSE2"):SetValue(nSaldoSE2)
									
									oSection1:PrintLine()
									
									oSection1:Cell("C3_NUM"):Hide()
									oSection1:Cell("C3_EMISSAO"):Hide()
									oSection1:Cell("A2_COD"):Hide()
									oSection1:Cell("A2_LOJA"):Hide()
									oSection1:Cell("A2_NREDUZ"):Hide()
									oSection1:Cell("C3_ITEM"):Hide()
									oSection1:Cell("C3_QUANT"):Hide()
									oSection1:Cell("C3_TOTAL"):Hide()
									oSection1:Cell("C7_NUM"):Hide()
									oSection1:Cell("NREDUZSC7"):Hide()
									oSection1:Cell("C7_QUANT"):Hide()
									oSection1:Cell("C7_TOTAL"):Hide()
									oSection1:Cell(SerieNfId("SD1",3,"D1_SERIE")):Hide()
									oSection1:Cell("D1_DOC"):Hide()
									
									oSection1:Cell("C7_QUANT"):SetValue( 0 )
									oSection1:Cell("C7_TOTAL"):SetValue( 0 )
									
								EndIf
								
								dbSelectArea('SE2')
								dbSkip()
								
							EndDo
							
						Else
							oSection1:PrintLine()
							
							oSection1:Cell("C3_NUM"):Hide()
							oSection1:Cell("C3_EMISSAO"):Hide()
							oSection1:Cell("A2_COD"):Hide()
							oSection1:Cell("A2_LOJA"):Hide()
							oSection1:Cell("A2_NREDUZ"):Hide()
							oSection1:Cell("C3_ITEM"):Hide()
							oSection1:Cell("C3_QUANT"):Hide()
							oSection1:Cell("C3_TOTAL"):Hide()
							oSection1:Cell("C7_NUM"):Hide()
							oSection1:Cell("NREDUZSC7"):Hide()
							oSection1:Cell("C7_QUANT"):Hide()
							oSection1:Cell("C7_TOTAL"):Hide()
							
							oSection1:Cell("C7_QUANT"):SetValue( 0 )
							oSection1:Cell("C7_TOTAL"):SetValue( 0 )
							
						EndIf
						
						dbSelectArea("SD1")
						dbSkip()
						
					EndDo
					
				Else

					oSection1:Cell("E2_PREFIXO"):Hide()
					oSection1:Cell("E2_NUM"):Hide()
					oSection1:Cell("E2_PARCELA"):Hide()
					oSection1:Cell("E2_TIPO"):Hide()
					oSection1:Cell("E2_VENCTO"):Hide()
					oSection1:Cell("SaldoSE2"):Hide()
			
					oSection1:PrintLine()
					
					oSection1:Cell("C3_NUM"):Hide()
					oSection1:Cell("C3_EMISSAO"):Hide()
					oSection1:Cell("A2_COD"):Hide()
					oSection1:Cell("A2_LOJA"):Hide()
					oSection1:Cell("A2_NREDUZ"):Hide()
					oSection1:Cell("C3_ITEM"):Hide()
					oSection1:Cell("C3_QUANT"):Hide()
					oSection1:Cell("C3_TOTAL"):Hide()
									
				EndIf
				
			EndIf
			
			dbSelectArea("SC7")
			dbSkip()
			
		EndDo
		
	Else
		
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+(cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA))
		
		oSection1:Cell("C7_NUM"):Hide()
		oSection1:Cell("NREDUZSC7"):Hide()
		oSection1:Cell("C7_QUANT"):Hide()
		oSection1:Cell("C7_TOTAL"):Hide()
		oSection1:Cell(SerieNfId("SD1",3,"D1_SERIE")):Hide()
		oSection1:Cell("D1_DOC"):Hide()
		oSection1:Cell("E2_PREFIXO"):Hide()
		oSection1:Cell("E2_NUM"):Hide()
		oSection1:Cell("E2_PARCELA"):Hide()
		oSection1:Cell("E2_TIPO"):Hide()
		oSection1:Cell("E2_VENCTO"):Hide()
		oSection1:Cell("SaldoSE2"):Hide()
		
		oSection1:PrintLine()
		
	EndIf
	
	dbSelectArea(cAliasSC3)
	dbSkip()
	
EndDo

oSection1:Finish()

RetIndex("SC7")
dbSelectArea("SC7")
dbSetOrder(1)   

RetIndex("SD1")
dbSelectArea("SD1")
dbSetOrder(1)   

dbSelectArea("SE2")
dbSetOrder(1)   

If File(cIndSC7+OrdBagExt())
	Ferase(cIndSC7+OrdBagExt())
Endif

If File(cIndSD1+OrdBagExt())
	Ferase(cIndSD1+OrdBagExt())
Endif

Return NIL
