#INCLUDE "protheus.ch"
#INCLUDE "ATFR310C.ch"

// 17/08/2009 - Ajuste para filiais com mais de 2 caracteres.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATFR310   º Autor ³ Marcos S. Lobo.    º Data ³  14/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório Apolices de Seguro x Bens.					        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ATFR310C(cApolIni,cApolFim,cSegIni,cSegFim)
Local oReport

//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
oReport:=ReportDef(cApolIni,cApolFim,cSegIni,cSegFim)
oReport:PrintDialog()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Claudio D. de Souza    ³ Data ³23/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(cApolIni,cApolFim,cSegIni,cSegFim)
Local oReport,oSection1, oSection2
Local cReport := "ATFR310"
Local cAlias1 := "SNB"
Local cAlias2 := "SN1"
Local cTitulo := STR0002 //"Apólices de Seguro x Bens"
Local cDescri := STR0001 // "Este programa emite o relatório Apólice de Seguro x Bens."
Local bReport := { |oReport|	ReportPrint( oReport, cApolIni,cApolFim,cSegIni,cSegFim ) }
Local aOrd := {}

dbSelectArea("SIX")
dbSetOrder(1)
If MsSeek("SNB",.F.)
	While !SIX->(Eof()) .and. SIX->INDICE == "SNB" .and. SIX->ORDEM <= "2"

		if ( FwRetIdiom()=="es" )
			aAdd(aOrd,SIX->DESCSPA)
		else
			if ( FwRetIdiom()=="en" )
				aAdd(aOrd,SIX->DESCENG)
			else
				aAdd(aOrd,SIX->DESCRICAO)
			endif
		endif 
	
		SIX->(dbSkip())
	EndDo
Else
	aOrd 	:= {STR0005,STR0006}	///"Número da Apólice + Cod. Cia. Seguro"#"Cod. Cia. Seguro + Número da Apólice"
Endif

Pergunte( "AFR310" , .F. )
oReport  := TReport():New( cReport, cTitulo, "AFR310" , bReport, cDescri )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio Valores nas Moedas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New( oReport, STR0010, {cAlias1,cAlias2}, aOrd )		//"Dados da Apólice"

TRCell():New( oSection1, "NB_APOLICE" , cAlias1 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "NB_DESCRIC" , cAlias1 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "NB_CODSEG"  , cAlias1 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "NB_CSEGURO" , cAlias1 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "VIGENCIA"   , cAlias1 ,STR0009     ,/*Picture*/,21/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "NB_VLRSEG"  , cAlias1 ,/*X3Titulo*/,""/*Picture*/, 27 /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)
oSection1:SetHeaderPage()

oSection2 := TRSection():New( oSection1, STR0011, {cAlias2} )		//"Dados dos bens"
TRCell():New( oSection2, "N1_CBASE"  , cAlias2 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "N1_ITEM"   , cAlias2 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "N1_DESCRIC", cAlias2 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "N1_CHAPA"  , cAlias2 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "N1_LOCAL"  , cAlias2 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "N1_AQUISIC", cAlias2 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection2, "N1_BAIXA"  , cAlias2 ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³Claudio D. de Souza º Data ³  23/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query de impressao do relatorio                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport As Object, cApolIni As Character,cApolFim As Character,cSegIni As Character,cSegFim As Character)
Local oSection1 As Object
Local oSection2 As Object
Local cQuery 	As Character
Local cChave 	As Character
Local cKeySN1	As Character

oSection1 := oReport:Section(1)
oSection2 := oReport:Section(1):Section(1)
cQuery 	:= "SNB"
cChave 	:= SNB->(IndexKey(oSection1:GetOrder()))
cKeySN1 := ""

If !Empty(cApolIni) .or. !Empty(cApolFim)
	mv_par01 := cApolIni
	mv_par02 := cApolFim
Endif

If !Empty(cSegIni) .or. !Empty(cSegFim)
	mv_par03 := cSegIni
	mv_par04 := cSegFim
Endif

cQuery 	:= GetNextAlias()
cChave 	:= "%"+SqlOrder(SNB->(IndexKey(oSection1:GetOrder())))+"%"

oSection1:BeginQuery()

BeginSql Alias cQuery
	SELECT
		NB_APOLICE, NB_DESCRIC, NB_CODSEG, NB_CSEGURO, NB_DTINI, NB_DTVENC,
		NB_MOEDA, NB_VLRSEG
	FROM
		%table:SNB% SNB
	WHERE
		SNB.NB_FILIAL = %xfilial:SNB% AND
		SNB.NB_APOLICE >= %Exp:mv_par01% AND
		SNB.NB_APOLICE <= %Exp:mv_par02% AND
		SNB.NB_CODSEG  >= %Exp:mv_par03% AND
		SNB.NB_CODSEG  <= %Exp:mv_par04% AND
		SNB.%notDel%
	ORDER BY %Exp:cChave%
EndSql

oSection1:EndQuery()

oSection1:Cell("VIGENCIA"):SetBlock( {|| DTOC((cQuery)->NB_DTINI)+"-"+DTOC((cQuery)->NB_DTVENC) })
oSection1:Cell("NB_VLRSEG"):SetBlock( {|| GetMv("MV_SIMB"+ALLTRIM((cQuery)->NB_MOEDA)) + " " + Transform((cQuery)->NB_VLRSEG, PesqPict("SNB", "NB_VLRSEG")) })

// Verifica tambem se imprime bens baixados.
If mv_par06==1
	If mv_par07 == 2
		oSection2:Cell("N1_BAIXA"):Disable()
	Else
		oSection2:Cell("N1_BAIXA"):SetBlock( {|| If(!Empty(SN1->N1_BAIXA), SN1->N1_BAIXA, "")})
	Endif
Endif

oReport:SetMeter((cQuery)->(LastRec()))
oSection1:Init()

While (cQuery)->(!EOF()) .And. !oReport:Cancel()

	oReport:IncMeter()
	cKeySN1 := xFilial("SN1")+(cQuery)->(NB_APOLICE+NB_CODSEG)

	SN1->(dbSetOrder(5))
	If SN1->(!MsSeek(cKeySN1))		//// SE NAO ENCONTRAR BEM ASSOCIADO A ESTA APOLICE
		If mv_par05 == 1				//// EMITE APOLICE SEM BENS ? = SIM
			oSection1:PrintLine()
		Endif
		(cQuery)->(dbSkip())
		Loop								//// PASSA PARA A PROXIMA APOLICE
	Endif
	oSection1:PrintLine()
	If mv_par06 == 1					/// SE O PARAMETRO 6 ESTIVER PARA IMPRIMIR OS BENS
		oSection2:Init()
		While SN1->(!Eof()) .and. cKeySN1 == SN1->(N1_FILIAL+N1_APOLICE+N1_CODSEG) .And. ! oReport:Cancel()
			If mv_par07==1 .Or. Empty(SN1->N1_BAIXA)
				oSection2:PrintLine()
			EndIf
			SN1->(dbSkip())
		EndDo
		oSection2:Finish()
		oReport:ThinLine()
		oReport:SkipLine()
	Endif
	(cQuery)->(dbSkip())
EndDo
oSection1:Finish()

Return Nil
