#INCLUDE "pcor340C.ch"
#INCLUDE "PROTHEUS.CH"
/*/
_F_U_N_C_ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³ PCOR340  ³ AUTOR ³ Edson Maricate        ³ DATA ³ 27/08/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Programa de impressao do demonstrativo de saldos por visoes  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ SIGAPCO                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³_DOCUMEN_ ³ PCOR340                                                      ³±±
±±³_DESCRI_  ³ Programa de impressao do demonstrativo de saldos por visoes  ³±±
±±³_FUNC_    ³ Esta funcao devera ser utilizada com a sua chamada normal a  ³±±
±±³          ³ partir do Menu do sistema.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function U_PCOR340C(aPerg)
Local aArea		:= GetArea()
Local lOk		:= .F.
Local lEnd	:= .F.

Private aSavPar	
Private aVarPriv  //variavel que contera as variaveis privates a ser enxergadas pelo job

Private cCadastro := STR0001 //"Demonstrativo de Saldos"
Private nLin	:= 10000
Default aPerg := {}

//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
If Len(aPerg) == 0
	oPrint := PcoPrtIni(cCadastro,,2,,@lOk,"PCR340")
Else
	aEval(aPerg, {|x, y| &("MV_PAR"+StrZero(y,2)) := x})
	oPrint := PcoPrtIni(cCadastro,,2,,@lOk,"")
EndIf

If lOk
	//salva parametros para nao conflitar com parambox
	aSavPar := {MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05, MV_PAR06, MV_PAR07}

	dbSelectArea("AKN")
	dbSetOrder(1)
	lOk := !Empty(MV_PAR01) .And. dbSeek(xFilial("AKN")+MV_PAR01)

	If lOk
		If SuperGetMV("MV_PCO_AKN",.F.,"2")!="1"  //1-Verifica acesso por entidade
			lOk := .T.                        // 2-Nao verifica o acesso por entidade
		Else
			nDirAcesso := PcoDirEnt_User("AKN", AKN->AKN_CODIGO, __cUserID, .F.)
		    If nDirAcesso == 0 //0=bloqueado
				Aviso(STR0006,STR0007,{},2)//"Atenção"###"Usuario sem acesso a esta configuração de visao gerencial. "###"Fechar"
				lOk := .F.
			Else
	    		lOk := .T.
			EndIf
		EndIf
	
		//impressao do relatorio
		If lOk
			aVarPriv := {}
			aAdd(aVarPriv, {"aSavPar", aClone(aSavPar)})
			aProcessa := PcoCubeVis(aSavPar[01],1               ,"Pcor340Sld",aSavPar[04],aSavPar[05],aSavPar[06],,aVarPriv)
			RptStatus( {|lEnd| PCOR340Imp(@lEnd,oPrint,aProcessa)})
		EndIf
	EndIf	
	//finaliza relatorio
	PcoPrtEnd(oPrint)
EndIf

RestArea(aArea)
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pcor340Sld³ Autor ³ Edson Maricate        ³ Data ³18/02/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de processamento para impressao do dem. de saldos.   ³±±
±±³          ³Esta funcao e chama pela pcocube nos niveis de processamento³±±
±±³          ³parametrizados / ou pre configurados                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Pcor340Sld                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function U_Pcor341C(cConfig,cChave)
Local aRetFim
Local nCrdFim
Local nDebFim

aRetFim := PcoRetSld(cConfig,cChave,aSavPar[2])
nCrdFim := aRetFim[1, aSavPar[3]]
nDebFim := aRetFim[2, aSavPar[3]]

nSldFim := nCrdFim-nDebFim

Return {nSldFim}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Pcor340Imp³ Autor ³ Edson Maricate        ³ Data ³18/02/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de impressao do demonstrativo de saldo.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PCOR340Imp(lEnd)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd - Variavel para cancelamento da impressao pelo usuario³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Pcor340Imp(lEnd,oPrint,aProcessa)

Local nx
Local cQuebra := ""
Local aColunas := {10,450,1200,1700}	
Local nColCod	:=	1
Local nColDesc:=	2
Local nColVal	:=	3
If aSavPar[07] <> 1
	aColunas := {450,1200,1700}	
	nColCod	:=	0
	nColDesc:=	1
	nColVal	:=	2           
Endif

PcoPrtCol(aColunas,.T.,2)

For nx := 1 To Len(aProcessa)
	If PcoPrtLim(nLin)
		nLin := 200
		PcoPrtCab(oPrint)
		nLin+=20
		PcoPrtCol(aColunas,.T.,2)
		If aSavPar[07]  == 1
			PcoPrtCell(PcoPrtPos(nColCod),nLin,PcoPrtTam(nColCod),30,STR0002,oPrint,2,1,RGB(230,230,230)) //"Codigo"
		Endif
		PcoPrtCell(PcoPrtPos(nColDesc),nLin,PcoPrtTam(nColDesc),30,STR0003,oPrint,2,1,RGB(230,230,230)) //"Descricao"
		PcoPrtCell(PcoPrtPos(nColVal),nLin,PcoPrtTam(nColVal),30,STR0004,oPrint,2,1,RGB(230,230,230)) //"Saldo Final"
		nLin+=70
	EndIf
	
	If lEnd
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),30,STR0005,oPrint,2,1,RGB(230,230,230)) //"Impressao cancelada pelo operador..."
	Endif

	If cQuebra<>aProcessa[nx,3]
		nLin+= 5
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),40,aProcessa[nx,3],oPrint,1,1,/*RgbColor*/)
		nLin+=45
		cQuebra := aProcessa[nx,3]
	EndIf
	Do Case
		Case aProcessa[nx,16] == "0" // Normal
			If aSavPar[07]  == 1
				PcoPrtCell(PcoPrtPos(nColCod),nLin,PcoPrtTam(nColCod),60,aProcessa[nx,1],oPrint,1,8,/*RgbColor*/) 
			Endif
			PcoPrtCell(PcoPrtPos(nColDesc),nLin,PcoPrtTam(nColDesc),60,aProcessa[nx,6],oPrint,1,8,/*RgbColor*/) 
			PcoPrtCell(PcoPrtPos(nColVal),nLin,PcoPrtTam(nColVal),60,Transform(aProcessa[nx,2,1],"@E 999,999,999,999.99"),oPrint,1,8,/*RgbColor*/,"",.T.) 
			nLin+=50			
		Case aProcessa[nx,16] == "1" // Negrito
			If aSavPar[07]  == 1
				PcoPrtCell(PcoPrtPos(nColCod),nLin,PcoPrtTam(nColCod),60,aProcessa[nx,1],oPrint,1,2,/*RgbColor*/) 
			Endif
			PcoPrtCell(PcoPrtPos(nColDesc),nLin,PcoPrtTam(nColDesc),60,aProcessa[nx,6],oPrint,1,2,/*RgbColor*/) 
			PcoPrtCell(PcoPrtPos(nColVal),nLin,PcoPrtTam(nColVal),60,Transform(aProcessa[nx,2,1],"@E 999,999,999,999.99"),oPrint,1,2,/*RgbColor*/,"",.T.) 
			nLin+=50			
		Case aProcessa[nx,16] == "2" // Total
			If aSavPar[07]  == 1
				PcoPrtCell(PcoPrtPos(nColCod),nLin,PcoPrtTam(nColCod),60,aProcessa[nx,1],oPrint,1,3,RGB(230,230,230)) 
			Endif
			PcoPrtCell(PcoPrtPos(nColDesc),nLin,PcoPrtTam(nColDesc),60,aProcessa[nx,6],oPrint,1,3,RGB(230,230,230)) 
			PcoPrtCell(PcoPrtPos(nColVal),nLin,PcoPrtTam(nColVal),60,Transform(aProcessa[nx,2,1],"@E 999,999,999,999.99"),oPrint,1,3,RGB(230,230,230),"",.T.) 
			nLin+=50			
		Case aProcessa[nx,16] == "3" // Linha sem valor
			If aSavPar[07]  == 1
  				PcoPrtCell(PcoPrtPos(nColCod),nLin,PcoPrtTam(nColCod),60,aProcessa[nx,1],oPrint,1,2,/*RgbColor*/) 
			Endif
			PcoPrtCell(PcoPrtPos(nColDesc),nLin,PcoPrtTam(nColDesc),60,aProcessa[nx,6],oPrint,1,2,/*RgbColor*/) 
			nLin+=50			
		Case aProcessa[nx,16] == "4" // traco
			If aSavPar[07]  == 1
				PcoPrtCell(PcoPrtPos(nColCod),nLin,PcoPrtTam(nColCod),20,"",oPrint,7,2,/*RgbColor*/) 
    		Endif
			PcoPrtCell(PcoPrtPos(nColDesc),nLin,PcoPrtTam(nColDesc),20,"",oPrint,7,2,/*RgbColor*/) 
			PcoPrtCell(PcoPrtPos(nColVal),nLin,PcoPrtTam(nColVal),20,"",oPrint,7,2,/*RgbColor*/,"",.T.) 
			nLin+=40						
	OtherWise
			If aSavPar[07]  == 1
				PcoPrtCell(PcoPrtPos(nColCod),nLin,PcoPrtTam(nColCod),45,aProcessa[nx,1],oPrint,1,1,/*RgbColor*/) 
			Endif	
			PcoPrtCell(PcoPrtPos(nColDesc),nLin,PcoPrtTam(nColDesc),45,aProcessa[nx,6],oPrint,1,1,/*RgbColor*/) 
			PcoPrtCell(PcoPrtPos(nColVal),nLin,PcoPrtTam(nColVal),45,Transform(aProcessa[nx,2,1],"@E 999,999,999,999.99"),oPrint,1,1,/*RgbColor*/,"",.T.) 
			nLin+=40
	EndCase	

Next
	
Return
