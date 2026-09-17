#INCLUDE "MATR103C.CH"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR103  ³ Autor ³Alexandre Inacio Lemes ³ Data ³19/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Notas de Transferencia entre Filiais.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_Matr103C(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function U_Matr103C()

Local oReport

//Validação de aviso/bloqueio do relatório em Release 12.1.2510 ou superiores
oReport:= ReportDef()
oReport:PrintDialog()

                                               
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³Alexandre Inacio Lemes ³Data  ³19/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Notas de Transferencia entre Filiais.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ oExpO1: Objeto do relatorio                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local cTitle  := STR0001 //"Relação de Notas Transferencia entre Filiais"
Local oReport 
Local oFornece 
Local oSectSF1 
Local oSectSD1 
Local oCliente 
Local oSectSF2 
Local oSectSD2         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                   ³
//³ mv_par01 Da Filial                                                     ³ 
//³ mv_par02 Ate a Filial                                                  ³ 
//³ mv_par03 Imprime Itens?   Sim(1) / Nao(2)                              ³
//³ mv_par04 Imprimir:   Entradas(1) / Saidas(2) / Ambos(3)                ³
//³ mv_par05 Emissao de                                                    ³
//³ mv_par06 Emissao ate                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTR103",.F.)
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
oReport := TReport():New("MTR103",cTitle,"MTR103", {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003) //"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario."
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
oFornece:= TRSection():New(oReport,STR0017,{"SF1","SA2"},/*aOrdem*/) //"Relação de Notas Transferência entre Filiais"

TRCell():New(oFornece,"F1_FORNECE","SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oFornece,"F1_LOJA"   ,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oFornece,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oFornece:SetTotalInLine(.F.)
oFornece:SetTotalText(STR0010) // "TOTAL ENTRADAS ->>> "

oSectSF1:= TRSection():New(oFornece,STR0018,{"SF1"},/*aOrdem*/) //"Relação de Notas Transferência entre Filiais"
oSectSF1:SetHeaderPage()

TRCell():New(oSectSF1,"F1_EMISSAO","SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_DOC"    ,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_SERIE"  ,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_VALMERC","SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_VALICM" ,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_VALIPI" ,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_FRETE"  ,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_SEGURO" ,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_DESPESA","SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF1,"F1_VALBRUT","SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSectSD1:= TRSection():New(oSectSF1,STR0019,{"SD1","SB1"},/*aOrdem*/) //"Relação de Notas Transferência entre Filiais"

TRCell():New(oSectSD1,"D1_COD"    ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD1,"B1_DESC"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD1,"D1_VALICM" ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD1,"D1_VALIPI" ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD1,"D1_QUANT"  ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD1,"D1_VUNIT"  ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD1,"D1_VALDESC","SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD1,"D1_TOTAL"  ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSectSF1:Cell("F1_VALMERC"),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oFornece)
TRFunction():New(oSectSF1:Cell("F1_VALICM" ),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oFornece) 
TRFunction():New(oSectSF1:Cell("F1_VALIPI" ),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oFornece) 
TRFunction():New(oSectSF1:Cell("F1_FRETE"  ),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oFornece) 
TRFunction():New(oSectSF1:Cell("F1_SEGURO" ),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oFornece) 
TRFunction():New(oSectSF1:Cell("F1_DESPESA"),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oFornece) 
TRFunction():New(oSectSF1:Cell("F1_VALBRUT"),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oFornece) 


oCliente:= TRSection():New(oReport,STR0020,{"SF2","SA1"},/*aOrdem*/) //"Relação de Notas Transferência entre Filiais"

TRCell():New(oCliente,"F2_CLIENTE","SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oCliente,"F2_LOJA"   ,"SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oCliente,"A1_NOME"   ,"SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oCliente:SetTotalInLine(.F.)
oCliente:SetTotalText(STR0011) // "TOTAL SAIDAS   ->>> "

oSectSF2:= TRSection():New(oCliente,STR0021,{"SF2"},/*aOrdem*/) //"Relação de Notas Transferência entre Filiais"
oSectSF2:SetHeaderPage()

TRCell():New(oSectSF2,"F2_EMISSAO","SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_DOC"    ,"SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_SERIE"  ,"SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_VALMERC","SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_VALICM" ,"SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_VALIPI" ,"SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_FRETE"  ,"SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_SEGURO" ,"SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_DESPESA","SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSF2,"F2_VALBRUT","SF2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSectSD2:= TRSection():New(oSectSF2,STR0022,{"SD2","SB1"},/*aOrdem*/) //"Relação de Notas Transferência entre Filiais"

TRCell():New(oSectSD2,"D2_COD"    ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD2,"B1_DESC"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD2,"D2_VALICM" ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD2,"D2_VALIPI" ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD2,"D2_QUANT"  ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD2,"D2_PRCVEN" ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD2,"D2_DESC"   ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD2,"D2_TOTAL"  ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSectSD2,"D2_FILIAL" ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSectSF2:Cell("F2_VALMERC"),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oCliente)
TRFunction():New(oSectSF2:Cell("F2_VALICM" ),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oCliente) 
TRFunction():New(oSectSF2:Cell("F2_VALIPI" ),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oCliente) 
TRFunction():New(oSectSF2:Cell("F2_FRETE"  ),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oCliente) 
TRFunction():New(oSectSF2:Cell("F2_SEGURO" ),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oCliente) 
TRFunction():New(oSectSF2:Cell("F2_DESPESA"),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oCliente) 
TRFunction():New(oSectSF2:Cell("F2_VALBRUT"),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.T.,.F.,,oCliente) 

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Alexandre Inacio Lemes ³Data  ³19/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Notas de Transferencia entre Filiais.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local aAreaSM0   := SM0->(GetArea())
Local aFornece   := {}
Local aCliente   := {}
Local oFornece   := oReport:Section(1) 
Local oSectSF1   := oReport:Section(1):Section(1) 
Local oSectSD1   := oReport:Section(1):Section(1):Section(1) 
Local oCliente   := oReport:Section(2) 
Local oSectSF2   := oReport:Section(2):Section(1) 
Local oSectSD2   := oReport:Section(2):Section(1):Section(1) 
Local nX         := 0
Local lUsaFilTrf := UsaFilTrf()
Local cArqIdx    := ""
Local nIndex     := 0

Local cAliasSF1 := GetNextAlias()
Local cAliasSF2 := GetNextAlias()
Local cSelect   := "%%"
Local cFrom     := "%%"
Local cWhere    := "%%"
Local cWhereSF1 := "%%"
Local cWhereSF2 := "%%"

If mv_par04 == 1
	oReport:SetTitle(oReport:Title() + STR0005) //" - ENTRADAS "
ElseIf mv_par04 == 2
	oReport:SetTitle(oReport:Title() + STR0006) //" - SAIDAS   "
ElseIf mv_par04 == 3
	oReport:SetTitle(oReport:Title() + STR0016) //" - ENTRADAS E SAIDAS"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona as Filiais para geracao do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
M103SelTF(@aFornece,@aCliente)

If !Empty(mv_par01)
	MsSeek(Subs(cNumEmp,1,2)+mv_par01,.T.) // Reposiciona o cursor para a correta impressao do cabecalho
Else	
	DbSeek(Subs(cNumEmp,1,2)+ Subs(cNumEmp,3,10),.T.) // Posiciona na filial corrente
Endif
	
If (Len(aFornece)+Len(aCliente)) > 0

	If mv_par04 <> 2 .And. Len(aFornece) > 0

		TRPosition():New(oFornece,"SA2",1,{|| xFilial("SA2")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA})	

		dbSelectArea("SF1")
		dbSetOrder(2)
		dbSeek(xFilial("SF1")+aFornece[1][1]+aFornece[1][2])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Transforma parametros Range em expressao SQL                        ³	
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MakeSqlExpr(oReport:uParam)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query do relatório da secao 1                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:Section(1):BeginQuery()	

		cWhereSF1 := "%"
		cWhereSF1 += If(Len(aFornece) > 0 , "(" , "" )
		For nX := 1 To Len(aFornece)
			If nX > 1
				cWhereSF1 += " OR "
			Endif
			cWhereSF1 += "(F1_FORNECE='"+aFornece[nx][1] + "' AND F1_LOJA='"+aFornece[nx][2]+"')"
		Next 
		cWhereSF1 += If(Len(aFornece) > 0 , ")" , "" )
		If Len(cWhereSF1) > 2
			cWhereSF1 += " AND "
		EndIf
		cWhereSF1 += "%"
 
		If mv_par03 == 1 //lista itens
                cSelect := "%"
			cSelect += ",D1_FILIAL ,D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_VALICM, D1_VALIPI, D1_QUANT, D1_VUNIT, D1_VALDESC, D1_TOTAL, "
			cSelect += "B1_COD, B1_DESC "
                cSelect += "%" 

                cFrom := "%"
                cFrom += "," + RetSqlName("SD1") + " SD1, " + RetSqlName("SB1") + " SB1 "
                cFrom += "%" 

                cWhere := "%"
                cWhere += "AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE "
			cWhere += "AND D1_LOJA = F1_LOJA AND D1_TIPO = F1_TIPO AND B1_COD = D1_COD "
			
			If !Empty(xFilial("SB1")) //.And. cPaisloc <> "BRA"
				cWhere += "AND F1_FILIAL  = B1_FILIAL  "
			EndIf
			
			cWhere += "AND SD1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
			cWhere += "%"  
       EndIf

		BeginSql Alias cAliasSF1
		
		SELECT F1_FILIAL,  F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_VALBRUT,
		       F1_VALMERC, F1_VALIPI, F1_VALICM, F1_FRETE, F1_DESPESA, F1_SEGURO, SF1.R_E_C_N_O_ SF1RECNO
				%Exp:cSelect%

		FROM %table:SF1% SF1
		     %Exp:cFrom%

		WHERE F1_STATUS <> ' ' AND F1_STATUS <> 'B' AND 
	          F1_EMISSAO >= %Exp:Dtos(mv_par05)% AND 
			  F1_EMISSAO <= %Exp:Dtos(mv_par06)% AND 
			  %Exp:cWhereSF1%
			  SF1.%NotDel% 
			  %Exp:cWhere%
			  
		ORDER BY %Order:SF1% 
				
		EndSql 

		oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

        oSectSF2:Disable()

		oSectSF1:SetParentQuery()
	 	oSectSF1:SetParentFilter( { |cParam| (cAliasSF1)->F1_FORNECE + (cAliasSF1)->F1_LOJA == cParam },{ || (cAliasSF1)->F1_FORNECE + (cAliasSF1)->F1_LOJA })

        If mv_par03 == 1 
			oSectSD1:SetParentQuery()        
			oSectSD1:SetParentFilter( { |cParam| (cAliasSF1)->D1_DOC+(cAliasSF1)->D1_SERIE+(cAliasSF1)->D1_FORNECE+(cAliasSF1)->D1_LOJA == cParam },;
		                                { || (cAliasSF1)->D1_DOC+(cAliasSF1)->D1_SERIE+(cAliasSF1)->D1_FORNECE+(cAliasSF1)->D1_LOJA })	
		Else
            oSectSD1:Disable() 		
		EndIf
		
		oFornece:Print()	
	

	EndIf

	If mv_par04 <> 1 .And. Len(aCliente) > 0

		TRPosition():New(oCliente,"SA1",1,{|| xFilial("SA1")+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA})

		dbSelectArea("SF2")
		dbSetOrder(2)
		dbSeek(xFilial("SF2")+aCliente[1][1]+aCliente[1][2])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Transforma parametros Range em expressao SQL                        ³	
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MakeSqlExpr(oReport:uParam)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query do relatório da secao 2                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:Section(2):BeginQuery()	

		cWhereSF2 := "%"
		cWhereSF2 += If(Len(aCliente) > 0 , "(" , "" )
		For nX := 1 To Len(aCliente)
			If nX > 1
				cWhereSF2 += " OR "
			Endif
			cWhereSF2 += "(F2_CLIENTE='"+aCliente[nx][1] + "' AND F2_LOJA='"+aCliente[nx][2]+"')"
		Next 
		cWhereSF2 += If(Len(aCliente) > 0 , ")" , "" )
		If Len(cWhereSF2) > 2
			cWhereSF2 += " AND "
		EndIf
		cWhereSF2 += "%"
 
		If mv_par03 == 1 //lista itens
                cSelect := "%"
			cSelect += ",D2_FILIAL ,D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_VALICM, D2_VALIPI, D2_QUANT, D2_PRCVEN, D2_DESC, D2_TOTAL, "
			cSelect += "B1_COD, B1_DESC "
                cSelect += "%" 

                cFrom := "%"
                cFrom += "," + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1 "
                cFrom += "%" 

                cWhere := "%"
                cWhere += "AND D2_DOC     	  = F2_DOC     "
                cWhere += "AND D2_SERIE   	  = F2_SERIE   "
                cWhere += "AND D2_CLIENTE 	  = F2_CLIENTE "
			cWhere += "AND D2_LOJA    	  = F2_LOJA    "
			cWhere += "AND D2_TIPO    	  = F2_TIPO    "     
			
			If !Empty(xFilial("SB1")) //.And. cPaisloc <> "BRA"
				cWhere += "AND F2_FILIAL  = B1_FILIAL  AND F2_FILIAL = D2_FILIAL "
			EndIf
			   
			cWhere += "AND B1_COD     	  = D2_COD	   "
			cWhere += "AND SD2.D_E_L_E_T_ = ' ' "
			cWhere += "AND SB1.D_E_L_E_T_ = ' ' "
			cWhere += "%"  
            EndIf

		BeginSql Alias cAliasSF2
		
		SELECT F2_FILIAL,  F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_VALBRUT,
		       F2_VALMERC, F2_VALIPI, F2_VALICM, F2_FRETE, F2_DESPESA, F2_SEGURO, SF2.R_E_C_N_O_ SF2RECNO 
				%Exp:cSelect%

		FROM %table:SF2% SF2
		     %Exp:cFrom%
 
	    WHERE F2_EMISSAO >= %Exp:Dtos(mv_par05)% AND 
			  F2_EMISSAO <= %Exp:Dtos(mv_par06)% AND 
			  %Exp:cWhereSF2%
			  SF2.%NotDel% 
			  %Exp:cWhere%
			  
		ORDER BY %Order:SF2% 
				
		EndSql 

		oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)

        oSectSF1:Disable()
        oSectSF2:Enable()

		oSectSF2:SetParentQuery()
		oSectSF2:SetParentFilter( { |cParam| (cAliasSF2)->F2_CLIENTE + (cAliasSF2)->F2_LOJA == cParam },{ || (cAliasSF2)->F2_CLIENTE + (cAliasSF2)->F2_LOJA })

        If mv_par03 == 1 
			oSectSD2:SetParentQuery()
			oSectSD2:SetParentFilter( { |cParam| (cAliasSF2)->D2_DOC+(cAliasSF2)->D2_SERIE+(cAliasSF2)->D2_CLIENTE+(cAliasSF2)->D2_LOJA == cParam },;
		                                { || (cAliasSF2)->D2_DOC+(cAliasSF2)->D2_SERIE+(cAliasSF2)->D2_CLIENTE+(cAliasSF2)->D2_LOJA })
		Else
            oSectSD2:Disable() 		
		EndIf

		oCliente:Print()

	EndIf
Else
	Help(" ",1,"RECNO")
EndIf

SM0->(RestArea(aAreaSM0))

Return Nil 



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³M103SelTF º Autor ³ Materiais            º Data ³05/12/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Grava os Arrays aFornece e aCliente                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function M103SelTF(aFornece,aCliente)

Local lUsaFilTrf := UsaFilTrf()
Local aArea      := GetArea()
Local cArqIdx    := ""
Local nIndex     := 0
Local aAreaSM0   := SM0->(GetArea())

dbSelectArea("SM0")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procura o CNPJ da Filial para localizar o Fornecedor e/ou Cliente cadastrado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(mv_par02)
	MsSeek(Subs(cNumEmp,1,2)+mv_par01,.T.)
	While SM0->M0_CODIGO+SM0->M0_CODFIL >= (Subs(cNumEmp,1,2)+mv_par01) .And. SM0->M0_CODIGO+SM0->M0_CODFIL <= (Subs(cNumEmp,1,2)+mv_par02)
		If mv_par04 <> 1
			dbSelectArea("SA1")
			If !lUsaFilTrf
				dbSetOrder(3)
				If dbSeek(xFilial("SA1")+SM0->M0_CGC) 
					If cPaisLoc == "BRA"
				   		aAdd(aCliente, {SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME})
					Else   
					While Trim(SA1->A1_CGC) == Trim(SM0->M0_CGC)   
							If Ascan(aCliente,{|x| x[4]== SA1->A1_COD+SA1->A1_LOJA})==0 
		  					   	aAdd(aCliente, {SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,SA1->A1_COD+SA1->A1_LOJA})
		  					EndIf
						   	DBSkip()
						 EndDo				     
					EndIf
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta filtro e indice temporario na SA1 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cArqIdx := CriaTrab(,.F.)
				IndRegua("SA1", cArqIdx, "A1_FILTRF",,,STR0023) //"Selecionando Registros ..."
				nIndex := RetIndex("SA1")
				#IFNDEF TOP
					dbSetIndex(cArqIdx+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndex+1) // A1_FILTRF
				
				If dbSeek(SM0->M0_CODFIL) 
					If cPaisLoc == "BRA"
				   		aAdd(aCliente, {SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME})
					Else   
						While SA1->A1_CGC == SM0->M0_CGC   
							If Ascan(aCliente,{|x| x[4]== SA1->A1_COD+SA1->A1_LOJA})==0 
		  					   	aAdd(aCliente, {SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,SA1->A1_COD+SA1->A1_LOJA})
		  					EndIf
						   	DBSkip()
						 EndDo				     
					EndIf
				EndIf
				
				// Apagar o indice temporario
				dbSelectArea("SA1")
				RetIndex("SA1")
				Ferase( cArqIdx + OrdBagExt() )
			EndIf
		EndIf
		If mv_par04 <> 2
			dbSelectArea("SA2")
			If !lUsaFilTrf
				dbSetOrder(3)  
				If dbSeek(xFilial("SA2")+SM0->M0_CGC) 
					If cPaisLoc == "BRA"
						aAdd(aFornece, {SA2->A2_COD,SA2->A2_LOJA,SA2->A2_NOME})
					Else   
					While Trim(SA2->A2_CGC) == Trim(SM0->M0_CGC)   
							If Ascan(aFornece,{|x| x[4]== SA2->A2_COD+SA2->A2_LOJA})==0 
			  					aAdd(aFornece, {SA2->A2_COD,SA2->A2_LOJA,SA2->A2_NOME,SA2->A2_COD+SA2->A2_LOJA})
			  				EndIf
						   	DBSkip()
						EndDo
					EndIf
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta filtro e indice temporario na SA2 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cArqIdx := CriaTrab(,.F.)
				IndRegua("SA2", cArqIdx, "A2_FILTRF",,,STR0023) //"Selecionando Registros ..."
				nIndex := RetIndex("SA2")
				#IFNDEF TOP
					dbSetIndex(cArqIdx+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndex+1) // A2_FILTRF
				
				If dbSeek(SM0->M0_CODFIL) 
					If cPaisLoc == "BRA"
						aAdd(aFornece, {SA2->A2_COD,SA2->A2_LOJA,SA2->A2_NOME})
					Else   
						While SA2->A2_CGC == SM0->M0_CGC   
							If Ascan(aFornece,{|x| x[4]== SA2->A2_COD+SA2->A2_LOJA})==0 
			  					aAdd(aFornece, {SA2->A2_COD,SA2->A2_LOJA,SA2->A2_NOME,SA2->A2_COD+SA2->A2_LOJA})
			  				EndIf
						   	DBSkip()
						EndDo
					EndIf
				EndIf

				// Apagar o indice temporario
				dbSelectArea("SA2")
				RetIndex("SA2")
				Ferase( cArqIdx + OrdBagExt() )
			EndIf
		EndIf
		dbSelectArea("SM0")
		dbSkip()
	EndDo
EndIf

RestArea(aArea)
SM0->(RestArea(aAreaSM0))
Return Nil
