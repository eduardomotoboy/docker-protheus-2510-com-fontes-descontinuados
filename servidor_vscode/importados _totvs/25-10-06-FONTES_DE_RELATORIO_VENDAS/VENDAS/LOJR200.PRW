#INCLUDE "RWMAKE.CH"

Static lBas17	:= IIf(SFI->(ColumnPos("FI_BAS17"))>0 ,.T.,.F.)	// Existe Campo - SFI 
Static lBas19	:= IIf(SFI->(ColumnPos("FI_BAS19"))>0 ,.T.,.F.)	// Existe Campo - SFI 
Static lBas20	:= IIf(SFI->(ColumnPos("FI_BAS20"))>0 ,.T.,.F.)	// Existe Campo - SFI 

#DEFINE PICT_07        "@E 999,999.99"
#DEFINE PICT_12        "@E 999,999.99"
#DEFINE PICT_17        "@E 999,999.99"
#DEFINE PICT_18        "@E 999,999.99"
#DEFINE PICT_19        "@E 999,999.99"
#DEFINE PICT_20        "@E 999,999.99"
#DEFINE PICT_25        "@E 999,999.99"
#DEFINE PICT_ISENTO    "@E 999,999.99"
#DEFINE PICT_VALCON    "@E 999,999,999.99"
#DEFINE PICT_NTRIB     "@E 99,999,999.99"
#DEFINE PICT_SUBTRIB   "@E 9,999,999.99"
#DEFINE PICT_NUMREDZ   PesqPict("SFI", "FI_NUMREDZ")
#DEFINE PICT_CANCEL    "@E 999,999.99"
#DEFINE PICT_IMPDEBT   "@E 9,999,999.99"
#DEFINE PICT_ISS	   "@E 9,999,999.99"
#DEFINE PICT_OUTROSR   "@E 9,999,999.99"    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Lojr200	³ Autor ³ Rafael M. Quadrotti   ³ Data ³10.12.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mapa Resumo 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Lojr200													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SigaLoja  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA 	 ³ BOPS ³Prograd.³ALTERACAO									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³22/05/01  ³XXXXXX³A.Veiga ³Alteracao do Lay-Out do Relatorio conforme  ³±±
±±³          ³      ³        ³convenio do ICMS No.50 de 15 de Setembro de ³±±
±±³          ³      ³        ³2000.                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³31/07/06  ³102313³Dolis   ³Correcao da impressao para quando a pergunta³±±
±±³          ³      ³        ³LJR000 (data para emissao) do SX1 nao esti- ³±±
±±³          ³      ³        ³ver preenchida                              ³±±
±±³22/02/07  ³119542³Conrado ³Retirado ajuste de dicionário.              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Lojr200()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  	:= "Este Programa ira emitir o relatorio diario da Impressora fiscal"
Local cDesc2 	:= ""
Local cDesc3  	:= ""
Local cString 	:= "SFI"
Local nA      	:= 0
Local aRegs   	:={}
Local lParam  	:= .T.			//Identifica se os parametros necessarios foram preenchidos para a impressao do Relatorio
Local lNovo_Lay := .F.			//Verificar seu e estado de sao paulo. Se for ele utiliza um Lay-Out diferente para o Mapa Resumo
Local lLayOutGO := .F.			//Verificar se eh estado de Goias. Se for ele utiliza o Lay-Out para o Mapa Resumo conforme "Apendice XVIII (Art. 224)"
Local lLayOutMG := .F. 			//Verificar se é estado de Minas Gerais. Se for ele utiliza o Lay-Out para o Mapa Resumo conforme "Artigo 6º, Parte 1, Seção II, Anexo VI do RICMS/2002/MG"
Local lLayOutDF := .F. 			//Verificar se é estado de Brasília . Se for ele utiliza o Lay-Out para o Mapa Resumo conforme "Artigo "Artigo 506"
Local lLayOutRJ := .F. 			//Verificar se é estado de Rio de Janeiro. Se for ele utiliza o Lay-Out para o Mapa Resumo conforme "Artigo 506"

Private nLastkey:=0
Private m_pag 	:= 1
Private titulo  := "MAPA RESUMO"
Private wnRel   :="Lojr200"
Private tamanho := "M"
Private aReturn := { "zebrado", 1, "Administracao", 2, 2, 1, "",1 }
Private cPerg 	:= "LJR000"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "Lojr200"

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("LJR000",.F.)

If LjAnalisaLeg(44)[1]
	lNovo_Lay := .T.
	tamanho := "G"
ElseIf LjAnalisaLeg(54)[1]
	lLayOutGO := .T.
	tamanho := "G"
ElseIf LjAnalisaLeg(60)[1]
	lLayOutMG := .T.
	tamanho := "G"
ElseIf LjAnalisaLeg(81)[1]
	lLayOutDF := .T.
	tamanho := "G"
ElseIf LjAnalisaLeg(80)[1] 
	lLayOutRJ := .T.
	tamanho := "G"
EndIf

While lParam
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

	If nLastKey == 27
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se data do relatorio foi preenchida³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(mv_par01)
		MsgAlert("Favor preencher a Data para emissao!") 	
	Else
		lParam := .F.
	EndIf
End

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o SFI para emitir o relat¢rio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ChkFile("SFI")

If lNovo_Lay
	RptStatus({|lEnd| LjImpMap(@lEnd,wnRel,cString)},Titulo)
ElseIf lLayOutGO
	RptStatus({|lEnd| LjImpMapGO(@lEnd,wnRel,cString)},Titulo)
ElseIf lLayOutDF
	RptStatus({|lEnd| LjImpMapDF(@lEnd,wnRel,cString)},Titulo)
ElseIf lLayOutRJ
	RptStatus({|lEnd| LjImpMapRJ(@lEnd,wnRel,cString)},Titulo)
ElseIf lLayOutMG
	RptStatus({|lEnd| LjImpMapMG(@lEnd,wnRel,cString)},Titulo)
Else
	RptStatus({|lEnd| Lojr200Imp(@lEnd,wnRel,cString)},Titulo)
EndIf

Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return (NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Lojr200IMP³ Autor ³ Rafael M. Quadrotti   ³ Data ³10.12.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao  												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ IMPR000													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Lojr200Imp(lEnd,wnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aTotais := {0,0,0,0,0,0,0,0}
// aTotais[1] := Valor Contabil
// aTotais[2] := Base de calculo 7%
// aTotais[3] := Base de calculo 12%
// aTotais[4] := Base de calculo 18%
// aTotais[5] := Base de calculo 25%
// aTotais[6] := Isencao
// aTotais[7] := Nao Tributado
// aTotais[8] := Substituicao Tributaria 
Local dDtIni  := mv_par01                         // Data de emissao (parametro do relatorio)

@ 0,0 PSAY AVALIMP(132)
cPrograma := "Lojr200"
cTamanho := "M"
nCaracter := 15
LI := 80

DbSelectArea("SFI")
dbSetOrder(1)
MsSeek(xFilial("SFI")+DTOS(dDtIni))
While !EOF() .And. xFilial()==SFI->FI_FILIAL .AND. dDtIni == SFI->FI_DTMOVTO
	LI++
	//         1         2         3         4         5         6         7         8         9        10         11       12        13
	//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//9999999999 999999 9999999999 999999 99/99/99   99999999 9999999999 9999999999 9999999999 99999 99999 99999 99999 9999999999 99999
	If LI > 58
		ljCabec(dDtIni)
		LI := 12
	Endif
	
	@LI,00 PSAY FI_PDV 			PICTURE "999999"
	@LI,07 PSAY FI_NUMREDZ		PICTURE PICT_NUMREDZ
	@LI,12 PSAY FI_VALCON  		PICTURE PICT_VALCON
	@LI,29 PSAY FI_BAS7  		PICTURE PICT_07
	@LI,40 PSAY FI_BAS12 		PICTURE PICT_12
	@LI,51 PSAY FI_BAS18		PICTURE PICT_18
	@LI,62 PSAY FI_BAS25  		PICTURE PICT_25
	@LI,73 PSAY FI_ISENTO		PICTURE PICT_ISENTO
	@li,85 PSAY FI_NTRIB 		PICTURE PICT_NTRIB
	@LI,100 PSAY FI_SUBTRIB 	PICTURE PICT_SUBTRIB
	
	aTotais[1] += FI_VALCON
	aTotais[2] += FI_BAS7
	aTotais[3] += FI_BAS12
	aTotais[4] += FI_BAS18
	aTotais[5] += FI_BAS25
	aTotais[6] += FI_ISENTO
	aTotais[7] += FI_NTRIB
	aTotais[8] += FI_SUBTRIB
	
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos Totais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LI += 2
@LI,00 PSAY "TOTAIS DO DIA "
@LI,12 PSAY aTotais[1] 	PICTURE PICT_VALCON
@LI,29 PSAY aTotais[2] 	PICTURE PICT_07
@LI,40 PSAY aTotais[3] 	PICTURE PICT_12
@LI,51 PSAY aTotais[4] 	PICTURE PICT_18
@LI,62 PSAY aTotais[5]	PICTURE PICT_25
@LI,73 PSAY aTotais[6] 	PICTURE PICT_ISENTO
@LI,85 PSAY aTotais[7]	PICTURE PICT_NTRIB
@LI,100 PSAY aTotais[8]	PICTURE PICT_SUBTRIB

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Rodape ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 58
@li++,00 Psay repl("-",150)

@li++,00 PSAY "                      OBSERVACOES                           |  RESPONSAVEL PELO ESTABELECIMENTO: "
@li++,00 PSAY "                                                            |  NOME: "
@li++,00 PSAY "                                                            |  FUNCAO:                        ASSINATURA: "

Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjCabec   ºAutor  ³Andre / Rafael      º Data ³  21/12/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do cabecalho do Mapa Resumo                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³LjCabec(DtIni)                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao Possui Retorno                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LjCabec(dDtIni)

Li:=2
cNOME:="NOME:  " + If(Empty(SM0->M0_NOMECOM),SM0->M0_NOME,SM0->M0_NOMECOM)
nCOLUNA:=LEN(cNOME)+04
@LI,020 PSAY "MAPA RESUMO           [X] ECF  [ ] DE CAIXA  [ ] PDV"
@LI,090 PSAY "NUMERO: " + SFI->FI_NUMERO
@LI,115 PSAY "DATA: " + DTOC(dDtIni)
LI++
@LI,00 Psay  cNOME
@LI,nCOLUNA Psay "INSCRICAO ESTADUAL: " + (SM0->M0_INSC)
LI++                                                                                        
@li,00 Psay "ENDERECO: " + (SM0->M0_ENDCOB) + " MUNICIPIO: " + (SM0->M0_CIDCOB) + "  UF: " +(SM0->M0_ESTCOB)
LI++
@LI,00 PSAY "CGC: " +(SM0->M0_CGC)
li++
@li,00 Psay repl("-",175)
li++

@LI,00 PSAY " DOCUMENTO   |           |                                  V A L O R E S   F I S C A I S                        |                                    "
LI++
@LI,00 PSAY "   FISCAL    |   VALOR   |        OPERACOES COM DEBITO DE IMPOSTO       |    OPERACOES SEM DEBITO DO IMPOSTO     |      OBSERVACOES                   "
LI++
@LI,00 PSAY "-------------|           |----------------------------------------------|----------------------------------------|                                    "
LI++
@LI,00 PSAY " ECF  |C.R.Z.|  CONTABIL |       7%         12%        18%        25%   |  ISENTAS    N.TRIBUT.        OUTRAS    |                                    "

li++
@li,00 Psay repl("-",175)
LI++ 

Return (NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³LjImpMap     ³ Autor ³ Leonardo K. Pinheiro  ³ Data ³19.03.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao  												     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ IMPR000													     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LjImpMap(lEnd,wnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aTotais := {0,0,0,0,0,0,0,0,0,0}
// aTotais[1] := Movimento do dia
// aTotais[2] := Cancelamento/Desconto
// aTotais[3] := Valor contabil
// aTotais[4] := Substituicao tributaria
// aTotais[5] := Isenta ou nao tributada
// aTotais[6] := Base de calculo 7%
// aTotais[7] := Base de calculo 12%
// aTotais[8] := Base de calculo 18%
// aTotais[9] := Base de calculo 25%
// aTotais[10]:= Imposto debitado

Local dDtIni  	:= mv_par01                         // Data de emissao (parametro do relatorio)
Local aAreaSFI	:= {}
Local nVlMovi   := 0

@ 0,0 PSAY AVALIMP(220)
cPrograma := "Lojr200"
cTamanho := "G"
nCaracter := 15
LI := 80

DbSelectArea("SFI")
DbSetOrder(1)
DbSeek(xFilial("SFI")+DTOS(dDtIni))
While !EOF() .And. xFilial()==SFI->FI_FILIAL .AND. dDtIni == SFI->FI_DTMOVTO
	LI++

	If LI > 58
		LjMapCabec(dDtIni)
		LI := 12
	Endif

	@LI,05  PSAY FI_PDV 		 				PICTURE "999999"
	@LI,21  PSAY FI_COO							PICTURE "999999"
    
	aAreaSFI := SFI->(GetArea())
	DbSelectArea("SLG")
	DbSetOrder(1)
	If SLG->(DbSeek(xFilial("SLG")+cEstacao))
	   @LI,40  PSAY SLG->LG_SERIE
	EndIf
	RestArea(aAreaSFI)

	nVlMovi := FI_VALCON+FI_CANCEL+FI_DESC
	@LI,54  PSAY FI_NUMFIM
	@LI,64  PSAY nVlMovi						PICTURE PICT_VALCON
	@LI,81  PSAY FI_CANCEL+FI_DESC		  		PICTURE PICT_CANCEL
	@LI,91  PSAY FI_VALCON     					PICTURE PICT_VALCON
	@LI,104 PSAY FI_SUBTRIB 					PICTURE PICT_SUBTRIB
	@LI,120 PSAY FI_ISENTO+FI_NTRIB  			PICTURE PICT_ISENTO
	@LI,134 PSAY FI_BAS7						PICTURE PICT_07
	@li,151 PSAY FI_BAS12 						PICTURE PICT_12
	@LI,168 PSAY FI_BAS18					 	PICTURE PICT_18
	@LI,185 PSAY FI_BAS25					 	PICTURE PICT_25
	@LI,199 PSAY FI_IMPDEBT					 	PICTURE PICT_IMPDEBT
	@LI,213 PSAY FI_NUMREDZ					 	PICTURE PICT_NUMREDZ

	aTotais[1]  += nVlMovi
	aTotais[2]  += FI_CANCEL+FI_DESC
	aTotais[3]  += FI_VALCON
	aTotais[4]  += FI_SUBTRIB
	aTotais[5]  += FI_ISENTO+FI_NTRIB
	aTotais[6]  += FI_BAS7
	aTotais[7]  += FI_BAS12
	aTotais[8]  += FI_BAS18
	aTotais[9]  += FI_BAS25
	aTotais[10] += FI_IMPDEBT
	
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos Totais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LI += 2
@LI,00  PSAY "TOTAIS DO DIA "
@LI,64  PSAY aTotais[1]		PICTURE PICT_VALCON
@LI,81  PSAY aTotais[2]		PICTURE PICT_CANCEL
@LI,91  PSAY aTotais[3]		PICTURE PICT_VALCON
@LI,104 PSAY aTotais[4] 	PICTURE PICT_SUBTRIB
@LI,120 PSAY aTotais[5]  	PICTURE PICT_ISENTO
@LI,134 PSAY aTotais[6]		PICTURE PICT_07
@li,151 PSAY aTotais[7] 	PICTURE PICT_12
@LI,168 PSAY aTotais[8]		PICTURE PICT_18
@LI,185 PSAY aTotais[9]		PICTURE PICT_25
@LI,199 PSAY aTotais[10]	PICTURE PICT_IMPDEBT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Rodape ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 58
@li++,00 Psay repl("-",222)

@li++,00 PSAY "                      OBSERVACOES                           |  RESPONSAVEL PELO ESTABELECIMENTO: "
@li++,00 PSAY "                                                            |  NOME: "
@li++,00 PSAY "                                                            |  FUNCAO:                        ASSINATURA: "

Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjMapCabec ºAutor  ³ Leonardo K. Pinheiro º Data ³  19/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do cabecalho do Mapa Resumo                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³LjMapCabec(DtIni)                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao Possui Retorno                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LjMapCabec(dDtIni)

Li:=2
cNOME:="NOME:  " + If(Empty(SM0->M0_NOMECOM),SM0->M0_NOME,SM0->M0_NOMECOM)
nCOLUNA:=LEN(cNOME)+04
@LI,020 PSAY "MAPA RESUMO           [X] ECF  [ ] DE CAIXA  [ ] PDV"
@LI,090 PSAY "NUMERO: " + SFI->FI_NUMERO
@LI,115 PSAY "DATA: " + DTOC(dDtIni)
LI++
@LI,00 Psay  cNOME
@LI,nCOLUNA Psay "INSCRICAO ESTADUAL: " + (SM0->M0_INSC)
LI++
@li,00 Psay "ENDERECO: " + (SM0->M0_ENDCOB) + " MUNICIPIO: " + (SM0->M0_CIDCOB) + "  UF: " +(SM0->M0_ESTCOB)
LI++
@LI,00 PSAY "CGC: " +(SM0->M0_CGC)
li++
@li,00 Psay repl("-",222)
li++

@LI,00 PSAY "NUMERO DE ORDEM | CONT.ORDEM  |         DOCUMENTO FISCAL        |  MOVIMENTO  | CANCELAMENTO/ |   VALOR  | SUBSTITUICAO |  ISENTA   |                          BASE DE CALCULO                          | IMPOSTO   | CONTADOR"
LI++
@LI,00 PSAY "DO EQUIPAMENTO  | OPERACAO NR |---------------------------------|    DO DIA   |   DESCONTO    | CONTABIL |  TRIBUTARIA  |  OU NAO   |-------------------------------------------------------------------| DEBITADO  | REDUCAO "
LI++
@LI,00 PSAY "                |    FINAL    |       SERIE E      |   NUMERO   |             |               |          |              | TRIBUTADA |       7%       |       12%      |       18%      |       25%      |           |         "
LI++
@LI,00 PSAY "                |             |       SUBSERIE     |    FINAL   |     (R$)    |      (R$)     |   (R$)   |     (R$)     |    (R$)   |      (R$)      |      (R$)      |      (R$)      |      (R$)      |   (R$)    |   'Z'   "

li++
@li,00 Psay repl("-",222)
LI++

Return (NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³LjImpMapGO   ³ Autor ³ Alberto Deviciente    ³ Data ³06.10.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao  												     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ LjImpMapGO												     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ LOJR200  												     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LjImpMapGO(lEnd,wnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aTotais := {0,0,0,0,0,0,0,0,0,0,0,0,0}

// aTotais[01] := Venda Bruta
// aTotais[02] := Cancelamento/Desconto
// aTotais[03] := Totalizador de ISS
// aTotais[04] := Valor Contabil (Venda Liquida)
// aTotais[05] := Isentas / Nao Tribut.
// aTotais[06] := Subst. Tribut.
// aTotais[07] := Outros Recebimentos
// aTotais[08] := Base de calculo 7%
// aTotais[09] := Base de calculo 12%     
// aTotais[10] := Base de calculo 17%     
// aTotais[11] := Base de calculo 18%
// aTotais[12] := Base de calculo 25%
// aTotais[13] := Imposto Debitado

Local dDtIni  	  := mv_par01                         // Data de emissao (parametro do relatorio)
Local aAreaSFI	  := {}
Local lFieldBas17 := FieldPos( "FI_FI_BAS17" )>0
Local nValAliq17  := 0

@ 0,0 PSAY AVALiMP(220)
cPrograma := "Lojr200"
cTamanho := "G"
nCaracter := 15
Li := 80

DbSelectArea("SFI")
DbSetOrder(1)
DbSeek(xFiLial("SFI")+DTOS(dDtIni))
While !EOF() .And. xFiLial()==SFI->FI_FILiAL .AND. dDtIni == SFI->FI_DTMOVTO
	Li++

	If Li > 58
		LjMapCabGO(dDtIni)
	Endif

	@Li,02  PSAY FI_PDV 		 				PICTURE "999999"
	@Li,12  PSAY FI_NUMREDZ 					PICTURE PICT_NUMREDZ
	@Li,23  PSAY FI_COO 		 				PICTURE "999999"
    
	aAreaSFI := SFI->(GetArea())
	DbSelectArea("SLG")
	DbSetOrder(1)
	If SLG->(DbSeek(xFiLial("SLG")+cEstacao))
	   @Li,33  PSAY SLG->LG_SERIE
	EndIf
	RestArea(aAreaSFI)
	
	@Li,41  PSAY FI_NUMFIM
	@Li,50  PSAY FI_VALCON+FI_CANCEL+FI_DESC+FI_ISS PICTURE PICT_VALCON  // VENDA BRUTA
	@Li,68  PSAY FI_CANCEL+FI_DESC		  			PICTURE PICT_CANCEL  // DESCONTO/CANCELAMENTO
	@Li,81  PSAY FI_ISS					  			PICTURE PICT_ISS     // TOTALIZADOR ISS
	@Li,93  PSAY FI_VALCON     						PICTURE PICT_VALCON  // VALOR CONTABIL (VENDA LIQUIDA)
	@Li,107 PSAY FI_ISENTO+FI_NTRIB  				PICTURE PICT_ISENTO  // ISENTAS/NAO TRIBUT.
	@Li,119 PSAY FI_SUBTRIB 						PICTURE PICT_SUBTRIB // SUBST. TRIBUT.
	@Li,131 PSAY FI_OUTROSR 						PICTURE PICT_OUTROSR // OUTROS RECEBIMENTOS
	@Li,143 PSAY FI_BAS7							PICTURE PICT_07      // BASE 7%
	@Li,155 PSAY FI_BAS12 							PICTURE PICT_12		 // BASE 12%
	If lFieldBas17
		@Li,167 PSAY FI_BAS17 						PICTURE PICT_17		 // BASE 17%	
	Else
		@Li,167 PSAY nValAliq17						PICTURE PICT_17		 // BASE 17%		
	Endif	
	@Li,179 PSAY FI_BAS18					 		PICTURE PICT_18		 // BASE 18%
	@Li,191 PSAY FI_BAS25					 		PICTURE PICT_25		 // BASE 25%
	@Li,203 PSAY FI_IMPDEBT					 		PICTURE PICT_IMPDEBT // IMPOSTO DEBITADO
	
	aTotais[01] += FI_VALCON+FI_CANCEL+FI_DESC+FI_ISS
	aTotais[02] += FI_CANCEL+FI_DESC
	aTotais[03] += FI_ISS
	aTotais[04] += FI_VALCON
	aTotais[05] += FI_ISENTO+FI_NTRIB
	aTotais[06] += FI_SUBTRIB
	aTotais[07] += FI_OUTROSR
	aTotais[08] += FI_BAS7
	aTotais[09] += FI_BAS12
	aTotais[10] += Iif(lFieldBas17,FI_BAS17,	nValAliq17)
	aTotais[11] += FI_BAS18
	aTotais[12] += FI_BAS25
	aTotais[13] += FI_IMPDEBT
	
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos Totais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Li += 2
@Li,00  PSAY "TOTAIS DO DIA "

@Li,50  PSAY aTotais[01] PICTURE PICT_VALCON
@Li,68  PSAY aTotais[02] PICTURE PICT_CANCEL
@Li,81  PSAY aTotais[03] PICTURE PICT_ISS
@Li,93  PSAY aTotais[04] PICTURE PICT_VALCON
@Li,107 PSAY aTotais[05] PICTURE PICT_ISENTO
@Li,119 PSAY aTotais[06] PICTURE PICT_SUBTRIB
@Li,131 PSAY aTotais[07] PICTURE PICT_OUTROSR
@Li,143 PSAY aTotais[08] PICTURE PICT_07
@Li,155 PSAY aTotais[09] PICTURE PICT_12
@Li,167 PSAY aTotais[10] PICTURE PICT_17
@Li,179 PSAY aTotais[11] PICTURE PICT_18
@Li,191 PSAY aTotais[12] PICTURE PICT_25
@Li,203 PSAY aTotais[13] PICTURE PICT_IMPDEBT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Rodape ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Li := 58
@Li++,00 Psay repl("-",216)

@Li++,00 PSAY "                                  OBSERVACOES                                  |  RESPONSAVEL PELO ESTABELECIMENTO: "
@Li++,00 PSAY "                                                                               |  NOME: "
@Li++,00 PSAY "                                                                               |  FUNCAO:                                        ASSINATURA: "

Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjMapCabGO ºAutor  ³ Alberto Deviciente   º Data ³ 06.10.2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do cabecalho do Mapa Resumo - Layout Estado Goias.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³LjMapCabGO(DtIni)                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao Possui Retorno                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR200                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LjMapCabGO(dDtIni)
Local cNome := "NOME: " + If(Empty(SM0->M0_NOMECOM),SM0->M0_NOME,SM0->M0_NOMECOM)

Li:=2
@Li,020 PSAY "MAPA RESUMO           [X] ECF  [ ] DE CAIXA  [ ] PDV"
@Li,090 PSAY "NUMERO: " + SFI->FI_NUMERO
@Li,115 PSAY "DATA: " + DTOC(dDtIni)
Li++
@Li,00 Psay  cNome
nCOLUNA:=LEN(cNome)+04
@LI,nCOLUNA Psay "INSCRICAO ESTADUAL: " + (SM0->M0_INSC) + Space(20) + " CCE: "
Li++
@Li,00 Psay "ENDERECO: " + (SM0->M0_ENDCOB) + " MUNICIPIO: " + (SM0->M0_CIDCOB) + "  UF: " +(SM0->M0_ESTCOB)
Li++
@Li,00 PSAY "CNPJ: " +(SM0->M0_CGC)
Li++
@Li,00 Psay repl("-",216)
Li++

@Li,00 PSAY "                 DOCUMENTO FISCAL                 |               |              |             |  VALOR    |  OPERACOES SEM DEBITO DO IMPOSTO  |              OPERACOES COM DEBITO DO IMPOSTO              | "
Li++
@Li,00 PSAY "--------------------------------------------------|     VENDA     |  DESCONTO/   | TOTALIZADOR | CONTABIL  |-----------------------------------|-----------------------------------------------------------| "
Li++
@Li,00 PSAY "          | No. CONT.|  COO   | DOC. PRE-IMPRESSO |     BRUTA     | CANCELAMENTO |   DE ISS    |  (VENDA   | ISENTAS/  |  SUBST.   |  OUTROS   |            BASE DE CALCULO POR ALIQUOTA EFETIVA           |    IMPOSTO "
Li++
@Li,00 PSAY " ECF No.  |  RED Z   | RED Z  |-------------------|               |              |             |  LIQUIDA) | NAO TRIB. |  TRIBUT.  | RECEBIM.  |    7%     |    12%    |    17%    |    18%    |    25%    |    DEBITADO "
Li++
@Li,00 PSAY "          |  (CRZ)   |        | SERIE |    No.    |      (R$)     |    (R$)      |     (R$)    |   (R$)    |   (R$)    |   (R$)    |   (R$)    |   (R$)    |   (R$)    |   (R$)    |   (R$)    |   (R$)    | "

Li++
@Li,00 Psay repl("-",216)
Li++

Return (NIL)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³LjImpMapMG³ Autor ³ Felipe S. Martinez   ³ Data ³05.03.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao  												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ IMPR000													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LjImpMapMG(lEnd,wnRel,cString)

Local aTotais := {0,0,0,0,0,0,0,0,0,0,0,0}
// aTotais[1] := Valor Contabil
// aTotais[2] := Base de calculo 7%
// aTotais[3] := Base de calculo 12%
// aTotais[4] := Base de calculo 18%
// aTotais[5] := Base de calculo 25%
// aTotais[6] := Isencao
// aTotais[7] := Nao Tributado
// aTotais[8] := Substituicao Tributaria 
// aTotais[9] := Valor Contabil ISS
// aTotais[10] := Cancelamentos ISS
// aTotais[11] := Total Geral (GT)
// aTotais[12] := Base de calculo 20%
Local dDtIni  := mv_par01  // Data de emissao (parametro do relatorio)

@ 0,0 PSAY AVALIMP(220)
cPrograma := "Lojr200"
cTamanho := "G"
nCaracter := 15
LI := 80

DbSelectArea("SFI")
dbSetOrder(1)
MsSeek(xFilial("SFI")+DTOS(dDtIni))
While !EOF() .And. xFilial()==SFI->FI_FILIAL .AND. dDtIni == SFI->FI_DTMOVTO
	LI++

	If LI > 58
		LjMapCabMG(dDtIni)
		LI := 12
	Endif
	
	@LI,00 PSAY FI_PDV 			PICTURE "999999"
	@LI,08 PSAY FI_NUMREDZ		PICTURE PICT_NUMREDZ
	@LI,14 PSAY FI_VALCON  		PICTURE PICT_VALCON      
	@LI,31 PSAY FI_BAS7  		PICTURE PICT_07
	@LI,47 PSAY FI_BAS12 		PICTURE PICT_12
	@LI,62 PSAY FI_BAS18		PICTURE PICT_18
	@LI,77 PSAY Iif(lBas20,FI_BAS20,0)   		PICTURE PICT_20 // TRATAMENTO DO FEMCP / FEM-MG - ALIQ 20%
	@LI,92 PSAY FI_BAS25  		PICTURE PICT_25				
	@LI,107 PSAY FI_ISENTO		PICTURE PICT_ISENTO		
	@LI,120 PSAY FI_NTRIB 		PICTURE PICT_NTRIB		  
	@LI,133 PSAY FI_SUBTRIB	 	PICTURE PICT_SUBTRIB	  
	@Li,147 PSAY FI_ISS			PICTURE PICT_VALCON		  
	@Li,164 PSAY FI_CANCEL		PICTURE PICT_CANCEL		  
	@Li,180 PSAY FI_GTFINAL		PICTURE PICT_VALCON 	  
	@Li,201 PSAY FI_COO			PICTURE "@!" 			  
	@Li,209 PSAY FI_OBS			PICTURE "@!" 

	aTotais[1] += FI_VALCON
	aTotais[2] += FI_BAS7
	aTotais[3] += FI_BAS12
	aTotais[4] += FI_BAS18
	aTotais[5] += FI_BAS25
	aTotais[6] += FI_ISENTO
	aTotais[7] += FI_NTRIB
	aTotais[8] += FI_SUBTRIB
	aTotais[9] += FI_ISS
	aTotais[10] += FI_CANCEL
	aTotais[11] += FI_GTFINAL	
	aTotais[12] += Iif(lBas20,FI_BAS20,0) 				// TRATAMENTO DO FEMCP / FEM-MG - ALIQ 20%
	
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos Totais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LI += 2
@LI,00 PSAY "TOTAIS DO DIA"
@LI,14 PSAY aTotais[1] 	PICTURE PICT_VALCON
@LI,31 PSAY aTotais[2] 	PICTURE PICT_07
@LI,47 PSAY aTotais[3] 	PICTURE PICT_12
@LI,62 PSAY aTotais[4] 	PICTURE PICT_18						
@LI,77 PSAY aTotais[12]	PICTURE PICT_20 // TRATAMENTO DO FEMCP / FEM-MG - ALIQ 20%
@LI,92 PSAY aTotais[5]	PICTURE PICT_25
@LI,107 PSAY aTotais[6] PICTURE PICT_ISENTO
@LI,120 PSAY aTotais[7]	PICTURE PICT_NTRIB
@LI,133 PSAY aTotais[8]	PICTURE PICT_SUBTRIB
@LI,147 PSAY aTotais[9]	PICTURE PICT_VALCON
@LI,164 PSAY aTotais[10] PICTURE PICT_CANCEL 
@LI,180 PSAY aTotais[11] PICTURE PICT_VALCON 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Rodape ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LI := 58
@LI++,00 Psay repl("-",220)

@LI++,00 PSAY "                      OBSERVACOES                           |  RESPONSAVEL PELO ESTABELECIMENTO: "
@LI++,00 PSAY "                                                            |  NOME: "
@LI++,00 PSAY "                                                            |  FUNCAO:                        ASSINATURA: "

Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjMapCabMG   ºAutor  ³Felipe S Martinez  ºData ³  05/03/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do cabecalho do Mapa Resumo de MG                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³LjMapCabMG(dDtIni)                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao Possui Retorno                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LjMapCabMG(dDtIni)

LI:=2
cNOME:="NOME:  " + If(Empty(SM0->M0_NOMECOM),SM0->M0_NOME,SM0->M0_NOMECOM)
nCOLUNA:=LEN(cNOME)+04
@LI,020 PSAY "MAPA RESUMO           [X] ECF  [ ] DE CAIXA  [ ] PDV"
@LI,090 PSAY "NUMERO: " + SFI->FI_NUMERO              
@LI,115 PSAY "DATA: " + DTOC(dDtIni)
LI++
@LI,00 Psay  cNOME
@LI,nCOLUNA Psay "INSCRICAO ESTADUAL: " + (SM0->M0_INSC)
LI++
@li,00 Psay "ENDERECO: " + (SM0->M0_ENDCOB) + " MUNICIPIO: " + (SM0->M0_CIDCOB) + "  UF: " +(SM0->M0_ESTCOB)
LI++
@LI,00 PSAY "CGC: " +(SM0->M0_CGC)
LI++
@LI,00 Psay repl("-",220)
LI++

@LI,00 PSAY " DOCUMENTO   |                |                                               V A L O R E S   F I S C A I S                                          |                |               |                |       |                              "
LI++
@LI,00 PSAY "   FISCAL    |     VALOR      |                OPERACOES COM DEBITO DE IMPOSTO                            |      OPERACOES SEM DEBITO DO IMPOSTO     |      VALOR     |    CANCELA-   |      TOTAL.    |  COO. |  OBSERVACOES                 "
LI++
@LI,00 PSAY "-------------|    CONTABIL    |---------------------------------------------------------------------------|------------------------------------------|    CONTABIL    |     MENTOS    |      GERAL     |       |                              "
LI++
@LI,00 PSAY " ECF  |C.R.Z.|      ICMS      |     7%              12%           18%             20%            25%      |   ISENTAS       N.TRIBUT.     OUTRAS     |       ISS      |      ICMS     |     ( GT )     |       |                              "

LI++
@LI,00 Psay repl("-",220)
LI++ 

Return (NIL)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³LjImpMapRJ³ Autor ³ Alexandre Miguel     ³ Data ³21.09.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao  												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ IMPR000													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LjImpMapRJ(lEnd,wnRel,cString)

Local aTotais := {0,0,0,0,0,0,0,0,0,0,0,0}
// aTotais[1] := Valor Contabil
// aTotais[2] := Base de calculo 7%
// aTotais[3] := Base de calculo 12%
// aTotais[4] := Base de calculo 18%
// aTotais[5] := Base de calculo 25%
// aTotais[6] := Isencao
// aTotais[7] := Nao Tributado
// aTotais[8] := Substituicao Tributaria 
// aTotais[9] := Valor Contabil ISS
// aTotais[10] := Cancelamentos ISS
// aTotais[11] := Total Geral (GT)
// aTotais[12] := Base de calculo 19%
Local dDtIni  := mv_par01  // Data de emissao (parametro do relatorio)

@ 0,0 PSAY AVALIMP(220)
cPrograma := "Lojr200"
cTamanho := "G"
nCaracter := 15
LI := 80

DbSelectArea("SFI")
dbSetOrder(1)
MsSeek(xFilial("SFI")+DTOS(dDtIni))
While !EOF() .And. xFilial()==SFI->FI_FILIAL .AND. dDtIni == SFI->FI_DTMOVTO
	LI++

	If LI > 58
		LjMapCabRJ(dDtIni)
		LI := 12
	Endif
	
	@LI,00 PSAY FI_PDV 			PICTURE "999999"
	@LI,08 PSAY FI_NUMREDZ		PICTURE PICT_NUMREDZ
	@LI,14 PSAY FI_VALCON  		PICTURE PICT_VALCON      
	@LI,31 PSAY FI_BAS7  		PICTURE PICT_07
	@LI,47 PSAY FI_BAS12 		PICTURE PICT_12
	@LI,62 PSAY FI_BAS18		PICTURE PICT_18
	@LI,77 PSAY Iif(lBas19, FI_BAS19,0)  		PICTURE PICT_19 // TRATAMENTO DO FECP - RJ - ALIQ 19%
	@LI,92 PSAY FI_BAS25  		PICTURE PICT_25				
	@LI,107 PSAY FI_ISENTO		PICTURE PICT_ISENTO		
	@LI,120 PSAY FI_NTRIB 		PICTURE PICT_NTRIB		  
	@LI,133 PSAY FI_SUBTRIB	 	PICTURE PICT_SUBTRIB	  
	@Li,147 PSAY FI_ISS			PICTURE PICT_VALCON		  
	@Li,164 PSAY FI_CANCEL		PICTURE PICT_CANCEL		  
	@Li,180 PSAY FI_GTFINAL		PICTURE PICT_VALCON 	  
	@Li,201 PSAY FI_COO			PICTURE "@!" 			  
	@Li,209 PSAY FI_OBS			PICTURE "@!" 

	aTotais[1] += FI_VALCON
	aTotais[2] += FI_BAS7
	aTotais[3] += FI_BAS12
	aTotais[4] += FI_BAS18
	aTotais[5] += FI_BAS25
	aTotais[6] += FI_ISENTO
	aTotais[7] += FI_NTRIB
	aTotais[8] += FI_SUBTRIB
	aTotais[9] += FI_ISS
	aTotais[10] += FI_CANCEL
	aTotais[11] += FI_GTFINAL	
	aTotais[12] += Iif(lBas19, FI_BAS19,0) 				// TRATAMENTO DO DO FECP - RJ - ALIQ 19%
	
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos Totais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LI += 2
@LI,00 PSAY "TOTAIS DO DIA"
@LI,14 PSAY aTotais[1] 	PICTURE PICT_VALCON
@LI,31 PSAY aTotais[2] 	PICTURE PICT_07
@LI,47 PSAY aTotais[3] 	PICTURE PICT_12
@LI,62 PSAY aTotais[4] 	PICTURE PICT_18
@LI,77 PSAY aTotais[12]	PICTURE PICT_19 // TRATAMENTO DO FECP - RJ - ALIQ 19%
@LI,92 PSAY aTotais[5]	PICTURE PICT_25
@LI,107 PSAY aTotais[6] PICTURE PICT_ISENTO
@LI,120 PSAY aTotais[7]	PICTURE PICT_NTRIB
@LI,133 PSAY aTotais[8]	PICTURE PICT_SUBTRIB
@LI,147 PSAY aTotais[9]	PICTURE PICT_VALCON
@LI,164 PSAY aTotais[10] PICTURE PICT_CANCEL 
@LI,180 PSAY aTotais[11] PICTURE PICT_VALCON

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Rodape ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LI := 58
@LI++,00 Psay repl("-",220)

@LI++,00 PSAY "                      OBSERVACOES                           |  RESPONSAVEL PELO ESTABELECIMENTO: "
@LI++,00 PSAY "                                                            |  NOME: "
@LI++,00 PSAY "                                                            |  FUNCAO:                        ASSINATURA: "

Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjMapCabRJ   ºAutor  ³Alexandre Miguel   ºData ³  21/09/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do cabecalho do Mapa Resumo de RJ                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³LjMapCabRJ(dDtIni)                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao Possui Retorno                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LjMapCabRJ(dDtIni)

LI:=2
cNOME:="NOME:  " + If(Empty(SM0->M0_NOMECOM),SM0->M0_NOME,SM0->M0_NOMECOM)
nCOLUNA:=LEN(cNOME)+04
@LI,020 PSAY "MAPA RESUMO           [X] ECF  [ ] DE CAIXA  [ ] PDV"
@LI,090 PSAY "NUMERO: " + SFI->FI_NUMERO              
@LI,115 PSAY "DATA: " + DTOC(dDtIni)
LI++
@LI,00 Psay  cNOME
@LI,nCOLUNA Psay "INSCRICAO ESTADUAL: " + (SM0->M0_INSC)
LI++
@li,00 Psay "ENDERECO: " + (SM0->M0_ENDCOB) + " MUNICIPIO: " + (SM0->M0_CIDCOB) + "  UF: " +(SM0->M0_ESTCOB)
LI++
@LI,00 PSAY "CGC: " +(SM0->M0_CGC)
LI++
@LI,00 Psay repl("-",220)
LI++

@LI,00 PSAY " DOCUMENTO   |                |                                               V A L O R E S   F I S C A I S                                          |                |               |                |       |                              "
LI++
@LI,00 PSAY "   FISCAL    |     VALOR      |                OPERACOES COM DEBITO DE IMPOSTO                            |      OPERACOES SEM DEBITO DO IMPOSTO     |      VALOR     |    CANCELA-   |      TOTAL.    |  COO. |  OBSERVACOES                 "
LI++
@LI,00 PSAY "-------------|    CONTABIL    |---------------------------------------------------------------------------|------------------------------------------|    CONTABIL    |     MENTOS    |      GERAL     |       |                              "
LI++
@LI,00 PSAY " ECF  |C.R.Z.|      ICMS      |     7%              12%           18%             19%            25%      |   ISENTAS       N.TRIBUT.     OUTRAS     |       ISS      |      ICMS     |     ( GT )     |       |                              "


LI++
@LI,00 Psay repl("-",220)
LI++ 

Return (NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³LjImpMapDF³ Autor ³ Alexandre Miguel     ³ Data ³21.09.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao  												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ IMPR000													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LjImpMapDF(lEnd,wnRel,cString)

Local aTotais := {0,0,0,0,0,0,0,0,0,0,0,0}
// aTotais[1] := Valor Contabil
// aTotais[2] := Base de calculo 7%
// aTotais[3] := Base de calculo 12%
// aTotais[4] := Base de calculo 18%
// aTotais[5] := Base de calculo 25%
// aTotais[6] := Isencao
// aTotais[7] := Nao Tributado
// aTotais[8] := Substituicao Tributaria 
// aTotais[9] := Valor Contabil ISS
// aTotais[10] := Cancelamentos ISS
// aTotais[11] := Total Geral (GT)
// aTotais[12] := Base de calculo 17%
Local dDtIni  := mv_par01  // Data de emissao (parametro do relatorio)

@ 0,0 PSAY AVALIMP(220)
cPrograma := "Lojr200"
cTamanho := "G"
nCaracter := 15
LI := 80

DbSelectArea("SFI")
dbSetOrder(1)
MsSeek(xFilial("SFI")+DTOS(dDtIni))
While !EOF() .And. xFilial()==SFI->FI_FILIAL .AND. dDtIni == SFI->FI_DTMOVTO
	LI++

	If LI > 58
		LjMapCabDF(dDtIni)
		LI := 12
	Endif
	
	@LI,00 PSAY FI_PDV 			PICTURE "999999"
	@LI,08 PSAY FI_NUMREDZ		PICTURE PICT_NUMREDZ
	@LI,14 PSAY FI_VALCON  		PICTURE PICT_VALCON      
	@LI,31 PSAY FI_BAS7  		PICTURE PICT_07
	@LI,47 PSAY FI_BAS12 		PICTURE PICT_12
	@LI,62 PSAY Iif(lBas17,FI_BAS17,0)  		PICTURE PICT_17 // TRATAMENTO DO FEMCP / FEM - DF - ALIQ 17%
	@LI,77 PSAY FI_BAS18		PICTURE PICT_18
	@LI,92 PSAY FI_BAS25  		PICTURE PICT_25				
	@LI,107 PSAY FI_ISENTO		PICTURE PICT_ISENTO		
	@LI,120 PSAY FI_NTRIB 		PICTURE PICT_NTRIB		  
	@LI,133 PSAY FI_SUBTRIB	 	PICTURE PICT_SUBTRIB	  
	@Li,147 PSAY FI_ISS			PICTURE PICT_VALCON		  
	@Li,164 PSAY FI_CANCEL		PICTURE PICT_CANCEL		  
	@Li,180 PSAY FI_GTFINAL		PICTURE PICT_VALCON 	  
	@Li,201 PSAY FI_COO			PICTURE "@!" 			  
	@Li,209 PSAY FI_OBS			PICTURE "@!" 			  

	aTotais[1] += FI_VALCON
	aTotais[2] += FI_BAS7
	aTotais[3] += FI_BAS12
	aTotais[4] += FI_BAS18
	aTotais[5] += FI_BAS25
	aTotais[6] += FI_ISENTO
	aTotais[7] += FI_NTRIB
	aTotais[8] += FI_SUBTRIB
	aTotais[9] += FI_ISS
	aTotais[10] += FI_CANCEL
	aTotais[11] += FI_GTFINAL	
	aTotais[12] += Iif(lBas17,FI_BAS17,0) 				// TRATAMENTO DO FEMCP / FEM - DF - ALIQ 17%
	
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos Totais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LI += 2
@LI,00 PSAY "TOTAIS DO DIA"
@LI,14 PSAY aTotais[1] 	PICTURE PICT_VALCON
@LI,31 PSAY aTotais[2] 	PICTURE PICT_07
@LI,47 PSAY aTotais[3] 	PICTURE PICT_12
@LI,62 PSAY aTotais[12]	PICTURE PICT_17 // TRATAMENTO DO FEMCP / FEM - DF - ALIQ 17%
@LI,77 PSAY aTotais[4] 	PICTURE PICT_18
@LI,92 PSAY aTotais[5]	PICTURE PICT_25
@LI,107 PSAY aTotais[6] PICTURE PICT_ISENTO
@LI,120 PSAY aTotais[7]	PICTURE PICT_NTRIB
@LI,133 PSAY aTotais[8]	PICTURE PICT_SUBTRIB
@LI,147 PSAY aTotais[9]	PICTURE PICT_VALCON
@LI,164 PSAY aTotais[10] PICTURE PICT_CANCEL 
@LI,180 PSAY aTotais[11] PICTURE PICT_VALCON 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Rodape ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LI := 58
@LI++,00 Psay repl("-",220)

@LI++,00 PSAY "                      OBSERVACOES                           |  RESPONSAVEL PELO ESTABELECIMENTO: "
@LI++,00 PSAY "                                                            |  NOME: "
@LI++,00 PSAY "                                                            |  FUNCAO:                        ASSINATURA: "

Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjMapCabDF   ºAutor  ³Alexandre Miguel   ºData ³  21/09/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do cabecalho do Mapa Resumo de DF                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³LjMapCabRJ(dDtIni)                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao Possui Retorno                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LjMapCabDF(dDtIni)

LI:=2
cNOME:="NOME:  " + If(Empty(SM0->M0_NOMECOM),SM0->M0_NOME,SM0->M0_NOMECOM)
nCOLUNA:=LEN(cNOME)+04
@LI,020 PSAY "MAPA RESUMO           [X] ECF  [ ] DE CAIXA  [ ] PDV"
@LI,090 PSAY "NUMERO: " + SFI->FI_NUMERO              
@LI,115 PSAY "DATA: " + DTOC(dDtIni)
LI++
@LI,00 Psay  cNOME
@LI,nCOLUNA Psay "INSCRICAO ESTADUAL: " + (SM0->M0_INSC)
LI++
@li,00 Psay "ENDERECO: " + (SM0->M0_ENDCOB) + " MUNICIPIO: " + (SM0->M0_CIDCOB) + "  UF: " +(SM0->M0_ESTCOB)
LI++
@LI,00 PSAY "CGC: " +(SM0->M0_CGC)
LI++
@LI,00 Psay repl("-",220)
LI++

@LI,00 PSAY " DOCUMENTO   |                |                                               V A L O R E S   F I S C A I S                                          |                |               |                |       |                              "
LI++
@LI,00 PSAY "   FISCAL    |     VALOR      |                OPERACOES COM DEBITO DE IMPOSTO                            |      OPERACOES SEM DEBITO DO IMPOSTO     |      VALOR     |    CANCELA-   |      TOTAL.    |  COO. |  OBSERVACOES                 "
LI++
@LI,00 PSAY "-------------|    CONTABIL    |---------------------------------------------------------------------------|------------------------------------------|    CONTABIL    |     MENTOS    |      GERAL     |       |                              "
LI++
@LI,00 PSAY " ECF  |C.R.Z.|      ICMS      |     7%              12%           18%             17%            25%      |   ISENTAS       N.TRIBUT.     OUTRAS     |       ISS      |      ICMS     |     ( GT )     |       |                              "

LI++
@LI,00 Psay repl("-",220)
LI++ 

Return (NIL)

