#Include "ctbr700C.ch"
#Include "Protheus.ch"
//AMARRACAO
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³ Ctbr700  ³ Autor ³ Felipe Aurélio de Melo ³ Data ³ 17.12.08 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³                                                             ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ Nenhum                                                      ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ Nenhum                                                      ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctbr700C()
 
Private cProg     := "CTBR700"
Private cPerg     := "CTR700"
Private aRetor    := {}
Private aEstru    := {}
Private aItens    := {}
Private aCtbMoeda := {}
Private aSetOfBook:= {}
Private oReport
Private oSection1
Private oSection2
Private cRetSX5SL := ""
Private NomeProg := cProg

//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
Pergunte(cPerg,.T.)
oReport:=ReportDef()
oReport:PrintDialog()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³ ReportDef³ Autor ³ Felipe Aurélio de Melo ³ Data ³ 18.12.08 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³                                                             ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ Nenhum                                                      ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ Nenhum                                                      ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local aSelFil := {}
Local aOrd    := {STR0001,STR0002,STR0003}//"Padrao"###"Crescente"###"Decrescente"
Local cTitulo := STR0004//"DEMONSTRATIVO GERENCIAL MODELO 2"
Local cDescri := STR0005+Chr(10)+Chr(13)+STR0006//"Este programa ira imprimir o Demonstrativo Gerencial Modelo 2"##"Será impresso de acordo com os parametros solicitados pelo usuario."
Local bReport := { |oReport|	ReportPrint( oReport, aSelFil ) }

Local aSetOfBook:= CTBSetOf(mv_par07)
//Filtra Filiais

If !Empty(MV_PAR18) .And. (mv_par18 == 1) .And. (Len( aSelFil ) <= 0)
	aSelFil := AdmGetFil()
EndIf 

If ValType(mv_par17)=="N" .And. (mv_par17 == 1)
	cTitulo := CTBNomeVis( aSetOfBook[5] )
EndIf

oReport  	:= TReport():New(cProg, cTitulo, cPerg , bReport, cDescri,.T.,,.F.)
oReport		:SetCustomText( {|| CtCGCCabTR(,,,,,dDataBase,cTitulo,,,,,oReport,,,,,,,,,,mv_par02) } )                                      
oReport		:ParamReadOnly()
oSection1	:= TRSection():New(oReport  ,OemToAnsi(""),{"",""},aOrd)
oSection2	:= TRSection():New(oReport  ,OemToAnsi(""),{"",""},aOrd)

oSection1:SetPageBreak(.F.)
oSection1:SetLineBreak(.F.)
oSection1:SetHeaderPage(.F.)
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderSection(.F.)

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³ ReportDef³ Autor ³ Felipe Aurélio de Melo ³ Data ³ 18.12.08 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³                                                             ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ Nenhum                                                      ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ Nenhum                                                      ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportPrint(oReport,aSelFil)

Local x         := 1 
Local y         := 1 
Local nTot      := 0
Local nOrdRpt   := 0
Local nPosCbc   := 0
Local cValCtb   := ""
Local lPTable   := mv_par03 == 1
Local lTotLin   := mv_par16 == 1
Local lSldZro   := mv_par11 == 1
Local aMeses    := {OemToAnsi(STR0043),OemToAnsi(STR0044),OemToAnsi(STR0045),OemToAnsi(STR0046),OemToAnsi(STR0047),OemToAnsi(STR0048),;  //"Jan"###"Fev"###"Mar"###"Abr"###"Mai"###"Jun"
                    OemToAnsi(STR0049),OemToAnsi(STR0050),OemToAnsi(STR0051),OemToAnsi(STR0052),OemToAnsi(STR0053),OemToAnsi(STR0054)}
Local nMes		:= 0
Local nMesPos	:= 0
Local cMes		:= ""
local cAno		:= ""
Local nPeriodo 	:= 0
Local nItens	:= 0

Local lColDbCr		:= .T.
Local lCharSinal	:= .F.
Default aSelFil := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define tamanho da fonte de acordo com a quantidade de colunas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (MV_PAR05) > 0 .And. (MV_PAR05) <= 6
	oReport:nFontBody := 8
ElseIf (MV_PAR05) >= 7 .And. (MV_PAR05) <= 09                     
	oReport:nFontBody := 6 
Else
	oReport:nFontBody := 6
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza validações dos parametros preenchidos e Cria TRB     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !VldPerg()
	Return(.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava registros do arquivo temporário num array              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRetor := CriarArray(aSelFil)
aItens := aRetor[1]
aEstru := aRetor[2]

If Len(aItens) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe mais que 13 colunas e exclui caso exista  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For x:=1 To Len(aItens)
		If Len(aItens[x]) > 13
			aItens[x] := aSize(aItens[x],13)
		Else
			x := Len(aItens)
		EndIf					
	Next x
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria mais uma coluna e totaliza por linha                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTotLin
		For x:=1 To Len(aItens)
			aItens[x] := aSize(aItens[x],len(aItens[x])+1)
			If x == 1
				If lPTable
					aItens[x][Len(aItens[x])] := STR0007//"TOTAL POR LINHA"
				Else
					aItens[x][Len(aItens[x])] := STR0008//"TOTAIS"
				EndIf
			Else
				nTot := 0
				For y:=2 To Len(aItens[x])-1
					nTot += aItens[x][y]
				Next y
				aItens[x][Len(aItens[x])] := nTot
			EndIf
		Next x
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria seção, cabeçalho e totalizador                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	/*Alterando colunas do relatório(meses), para que as mesmas sejam apresentadas por extenso*/
	
	aItens[1][1] := (STR0055) // Atribui a primeira coluna o STR0055(CONSUMO EN LA PRODUCCION)
	 	
	nPeriodo:= CTB700PER()

	If Len(aItens) > 0
		If lPTable
			nItens	:= Len(aItens)
		Else
			nItens	:= Len(aItens[1])
		Endif
	
		If nItens > 13
			nItens	:= 13
		Endif
	 
		For x := 1 To nItens
			
			y := x-1
			
			If lPTable
				If x <= nPeriodo+1
					nMes 	:= Val(substring(aItens[x][1],6,2))
				Else
					nMes	:= nMesPos
				Endif
				
				nMesPos := nMes + 1
			Else
				If x <= nPeriodo+1
					nMes 	:= Val(substring(aItens[1][x],6,2))
				Else
					nMes	:= nMesPos
				Endif
	
				nMesPos	:= nMes + 1
			Endif
			
			If nMes > 0 
				If  nPeriodo == 4 // calendario trimestral
				  	If MV_PAR04 == 2 
				  		nMes := nMes
				  	Else
						nMes := if(nMes==1,3,nMes) 
						nMes := if(nMes==4,6,nMes)
						nMes := if(nMes==7,9,nMes)
						nMes := if(nMes==10,12,nMes)
					Endif
					
				ElseIf nPeriodo == 6 // calendario bimestral
					If MV_PAR04 == 2 
				  		nMes := nMes
				  	Else
						nMes := if(nMes==1,2,nMes) 
						nMes := if(nMes==3,4,nMes)
						nMes := if(nMes==5,6,nMes)
						nMes := if(nMes==7,8,nMes)
						nMes := if(nMes==9,10,nMes)
						nMes := if(nMes==11,12,nMes)
					Endif
				Endif
				
				If lTotLin			
					If x > 1 .and. (x <= Len(aItens) .or. x <= Len(aItens[1])-1 ) 			
						cMes    := 	Substring(aMeses[nMes],1,3)			
						If lPTable
							cAno			:= 	Substring(aItens[x][1],1,4)
							aItens[x][1] 	:= cMes+"/"+cAno
						Else
							cAno			:= 	Substring(aItens[1][x],1,4)
							aItens[1][x] 	:= cMes+"/"+cAno
						Endif												
					Endif
				Else
					If x > 1 .and. (x <= Len(aItens) .or. x <= Len(aItens[1]) ) 			
						cMes    := 	Substring(aMeses[nMes],1,3)			
						If lPTable
							cAno			:= 	Substring(aItens[x][1],1,4)
							aItens[x][1] 	:= cMes+"/"+cAno
						Else
							cAno			:= 	Substring(aItens[1][x],1,4)
							aItens[1][x] 	:= cMes+"/"+cAno
						Endif												
					Endif
				Endif											
			Endif
		Next x
	EndIf 				

	For x:=1 To Len(aItens[1])
		If x == 1
			If lPTable
				TRCell():New(oSection1,aItens[1][x],"",Ctr700Qbr(aItens[1][x],17,3,.T.),,,,,"LEFT",,"LEFT",,,.T.,CLR_WHITE,CLR_BLACK)
				TRCell():New(oSection2,aItens[1][x],"",Ctr700Qbr(aItens[1][x],17,3,.T.),,,,,"LEFT",,"LEFT",,,.T.,CLR_WHITE,CLR_BLACK)
			Else
				TRCell():New(oSection1,aItens[1][x],"",aItens[1][x],,20,,,"LEFT",,"LEFT",,,,CLR_WHITE,CLR_BLACK)
				TRCell():New(oSection2,aItens[1][x],"",aItens[1][x],,20,,,"LEFT",,"LEFT",,,,CLR_WHITE,CLR_BLACK)
			EndIf
		Else
			If lPTable
				TRCell():New(oSection1,aItens[1][x],"",Ctr700Qbr(aItens[1][x],17,3,.T.),/*"@E 999,999,999.99"*/,,,,"RIGHT",,"RIGHT",,,.T.,CLR_WHITE,CLR_BLACK)
				TRCell():New(oSection2,aItens[1][x],"",Ctr700Qbr(aItens[1][x],17,3,.T.),/*"@E 999,999,999.99"*/,,,,"RIGHT",,"RIGHT",,,.T.,CLR_WHITE,CLR_BLACK)
			Else
				TRCell():New(oSection1,aItens[1][x],"",aItens[1][x],/*"@E 999,999,999.99"*/,20,,,"RIGHT",,"RIGHT",,,.T.,CLR_WHITE,CLR_BLACK)
				TRCell():New(oSection2,aItens[1][x],"",aItens[1][x],/*"@E 999,999,999.99"*/,20,,,"RIGHT",,"RIGHT",,,.T.,CLR_WHITE,CLR_BLACK)
			EndIf
		EndIf
	Next x
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Remove primeira linha para não imprimir novamente como item  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aDel(aItens,1)
	aSize(aItens,Len(aItens)-1)

	aDel(aEstru,1)
	aSize(aEstru,Len(aEstru)-1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ordena registros conforme definição do parametro do TReport  ³
	//³ 1=Padrão, 2=Crescente, 3=Decrescente                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdRpt := oSection1:GetOrder()
	Do Case
		Case nOrdRpt == 2
			aSort(aItens,,,{|x,y| x[1] < y[1]})
		Case nOrdRpt == 3
			aSort(aItens,,,{|x,y| x[1] > y[1]})
	EndCase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa impressão                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter(Len(aItens))
	oSection1:Init()
	oSection2:Init()
	
	//Retirar Negrito
	oSection1:oReport:lBold     := .F.
	oSection1:oReport:oFontBody := TFont():New(oSection1:oReport:cFontBody,0,(oSection2:oReport:nFontBody+2)*(-1),,oSection1:oReport:lBold,,,,oSection1:oReport:lItalic,oSection1:oReport:lUnderline)
	oSection1:PrintLine()
	
	//Deixar Negrito
	oSection2:oReport:lBold     := .T.
	oSection2:oReport:oFontBody := TFont():New(oSection2:oReport:cFontBody,0,(oSection2:oReport:nFontBody+2)*(-1),,oSection2:oReport:lBold,,,,oSection2:oReport:lItalic,oSection2:oReport:lUnderline)
	oSection2:PrintLine()

	For x:=1 To Len(aItens)
		If oReport:Cancel()
			x:=Len(aItens)
		EndIf
	
		If lPTable
			For y:=1 To Len(aItens[x])
				If y == 1
					//Imprime com negrito desativado
					oSection1:Cell(oSection1:aCell[y]:cName):SetValue(aItens[x][y])
				Else
					//Imprime com negrito desativado
					nPosCbc := aScan(aEstru,{|x| Upper(Alltrim(x[1])) == Upper(AllTrim(oSection1:aCell[y]:cName))})
					If nPosCbc > 0
						cValCtb:=ValorCTB(aItens[x][y],,,14,02,.T.,"@E 99,999,999,999.99",aEstru[nPosCbc][4],,,,,,lSldZro,.F.,lColDbCr,lCharSinal)
					Else
						cValCtb:=ValorCTB(aItens[x][y],,,14,02,.T.,"@E 99,999,999,999.99","1",,,,,,lSldZro,.F.,lColDbCr,lCharSinal)						
					EndIf
					oSection1:Cell(oSection1:aCell[y]:cName):SetValue(cValCtb)
				EndIf
			Next y
			oSection1:PrintLine()
		Else
			For y:=1 To Len(aItens[x])
	
				//Alimenta as calulas da linha que será impressa
				Do Case
					Case AllTrim(aItens[x][1]) = "-"
						//Imprime uma linha a vai para o proximo registro a ser impresso
						oReport:ThinLine()    
						oReport:SkipLine()
						y:=Len(aItens[x])
	
					Case AllTrim(aEstru[x][3]) < "5"
						If AllTrim(aEstru[x][3]) $ "|3|4|"
							If y == 1
								//Imprime com negrito ativado
								oSection2:Cell(oSection2:aCell[y]:cName):SetValue(aItens[x][y])
							Else
								//Imprime com negrito ativado
								cValCtb:=ValorCTB(aItens[x][y],,,14,02,.T.,"@E 99,999,999,999.99",aEstru[x][4],,,,,,lSldZro,.F.,lColDbCr,lCharSinal)								
								oSection2:Cell(oSection2:aCell[y]:cName):SetValue(cValCtb)
							EndIf
						Else
							If y == 1
								//Imprime com negrito desativado
								oSection1:Cell(oSection1:aCell[y]:cName):SetValue(aItens[x][y])
							Else
								//Imprime com negrito desativado
								cValCtb:=ValorCTB(aItens[x][y],,,14,02,.T.,"@E 99,999,999,999.99",aEstru[x][4],,,,,,lSldZro,.F.,lColDbCr,lCharSinal)								
								oSection1:Cell(oSection1:aCell[y]:cName):SetValue(cValCtb)
							EndIf
						EndIf
					Otherwise
						If y == 1
							//Imprime com negrito ativado
							oSection2:Cell(oSection2:aCell[y]:cName):SetValue(aItens[x][y])
						Else
							//Imprime nulo, logo não aparecerá valor na celula
							oSection2:Cell(oSection2:aCell[y]:cName):SetValue()
						EndIf
				EndCase
			Next y
	
			//Executa impressão da linha alimentada acima
			Do Case
				Case AllTrim(aItens[x][1]) = "-"
				//Não executa impressão da seção, pois foi 
				//impresso pelo objeto principal
				
				Case AllTrim(aEstru[x][3]) < "5"
				//Executa impressão da seção em questão
					If AllTrim(aEstru[x][3]) $ "|3|4|"
						oSection2:PrintLine()
					Else
						oSection1:PrintLine()
					EndIf
	
				Otherwise
				//Executa impressão da seção em questão
					oSection2:PrintLine()
			EndCase
	
		EndIf
		oReport:IncMeter()
	Next x

	If cPaisloc == "PER"
		If MV_PAR18 == 1 
			If MV_PAR03 == 1 .And. MV_PAR06 == 1 .AND. MV_PAR16 == 2
				If MSGYESNO(STR0056)
					Processa({|| GerArq(AllTrim(MV_PAR19))},,STR0057)	
				EndIf
			Else
				If MSGYESNO(STR0056)
					Alert(STR0058 + STR0059)
				EndIf	
			EndIf  
		EndIf	
	EndIf		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza seção de impressão                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:Finish()
	oSection2:Finish()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime mensagem caso não tenha registros a serem impressos  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aItens) == 0
		oReport:PrintText(STR0009)//"Nao ha dados a serem exibidos"
	EndIf
	
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fTrataSlds³ Autor³ Felipe Aurelio de Melo³ Data ³ 14.10.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tratamento do retorno do parametro                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR560R4                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fTrataSlds()

Local cRet := ""

If mv_par13 = 1
	cRet := mv_par14
Else
	cRet := mv_par15
EndIf

Return(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³ CriarArray Autor ³ Felipe Aurélio de Melo ³ Data ³ 17.12.08 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³                                                             ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ Nenhum                                                      ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ Nenhum                                                      ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriarArray(aSelFil)

Local x       := 0
Local y       := 0
Local aRegs   := {}
Local aDtPer  := {}
Local lStsPrt := .T.
Local lPGSint := .T.
Local lImpMov := .T.
Local lSldZro := .T.
Local cSBook  := mv_par07
Local cMoeda  := mv_par08
Local cDscMd := IIf( Empty(mv_par12),mv_par08,mv_par12)
Local dDtIni  := StoD("")
Local dDtFim  := StoD("")
Local dDtLPs  := mv_par10
Local lPAntLP := mv_par09 == 1
Local lPTable := mv_par03 == 1
Local lMovPer := mv_par06 == 1
Local lConSld := mv_par13 == 1
Local cSaldos := fTrataSlds()

DEFAULT aSelFil := {}
//Deve usar calendario ou data de referencia
If mv_par04 == 1
	dbSelectArea("CTG")
	CTG->(DbSetOrder(1))
	If CTG->(DbSeek(xFilial("CTG")+mv_par01))
		While CTG->(!Eof() .And. xFilial("CTG")+mv_par01 = CTG_FILIAL+CTG_CALEND)
			If lPTable
				//Se tabela invertida não limitar quantidade de periodos
				aAdd(aDtPer,{CTG->CTG_DTINI,CTG->CTG_DTFIM})
			Else
				//Se tabela no formato original, não permitir mais que 12 colunas
				If Len(aDtPer) < 12
					aAdd(aDtPer,{CTG->CTG_DTINI,CTG->CTG_DTFIM})
				EndIf
			EndIf
			CTG->(DbSkip())
		End
	EndIf
Else
	For x:=0 To mv_par05-1
		dDtIni := FirstDay(mv_par02)
		dDtFim := LastDay(mv_par02)
		For y:=1 To x
			dDtIni := FirstDay(FirstDay(dDtIni)-1)
			dDtFim := LastDay(dDtIni)
		Next y
			
		If lPTable
			//Se tabela invertida não limitar quantidade de periodos
			aAdd(aDtPer,{dDtIni,dDtFim})
		Else
			//Se tabela no formato original, não permitir mais que 12 colunas
			If Len(aDtPer) < 12
				aAdd(aDtPer,{dDtIni,dDtFim})
			EndIf
		EndIf
	Next x
EndIf

//Ordenação crescente por padrão
aSort(aDtPer,,,{|x,y| x[1] < y[1]})

//Executa função conforme parametros
aRegs := GetSldVGerP(lStsPrt, oReport, aDtPer, lPTable, cSBook , cMoeda, cDscMd, lConSld, cSaldos, "", dDtLPs, lSldZro, lMovPer, lPGSint, lImpMov, lPAntLP, aSelFil)

Return(aRegs)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³ VldPerg  ³ Autor ³ Felipe Aurélio de Melo ³ Data ³ 18.12.08 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³                                                             ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ Nenhum                                                      ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ Nenhum                                                      ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VldPerg()

Local x    :=  0
Local lRet := .T.

//Valida todos os parâmetros
For x:=1 To 16
	lRet := U_PrmCtbrC(StrZero(x,2),.T.)
	If !lRet
		x := 16
	EndIf
Next x

// Define nome do relatorio conforme cadastro do livros
If lRet
	oReport:SetTitle(aSetOfBook[10])
	If (mv_par17 == 1)
		oReport:SetTitle( CTBNomeVis( aSetOfBook[5] ) )
	EndIf
EndIf

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³ Ctr700Qbr³ Autor ³ Felipe Aurélio de Melo ³ Data ³ 17.12.08 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³ Quebrar uma string em partes definidas via parametro        ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ cRet                                                        ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ cStr = String que será quebrada com Chr(13)+Chr(10)         ³±
±±³Parametros³ nTam = Definição do tamanho da string por quebra            ³±
±±³Parametros³ nTol = Tolerancia para quebrar string quando achar espaço   ³±
±±³Parametros³ lSpc = Quebrar string quando achar espaço                   ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Ctr700Qbr(cStr,nTam,nTol,lSpc)

Local x      :=  0
Local nCnt   :=  0
Local cRet   := ""
Default cStr := ""
Default nTol :=  0
Default lSpc := .F.
Default nTam := Len(AllTrim(cStr))/2

cStr := AllTrim(cStr)

For x:=1 To Len(cStr)
	nCnt ++
	cRet += SubStr(cStr,x,1)
	Do Case
		Case  lSpc .And. nTol  = 0
				//Quebrar quando achar espeço só 
				//funcionará quando informado tolerancia

		Case  lSpc .And. nTol != 0
				If nCnt >= nTam-nTol .And. nCnt <= nTam+nTol .And. SubStr(cStr,x,1) = " "
					nCnt := 0
					cRet += Chr(13)+Chr(10)
				ElseIf nTam+nTol = nCnt
					nCnt := 0
					cRet += Chr(13)+Chr(10)
				EndIf

		Case !lSpc .And. nCnt = nTam
				nCnt := 0
				cRet += Chr(13)+Chr(10)
	EndCase
Next x

Return(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³PrmCtbr700³ Autor ³ Felipe Aurélio de Melo ³ Data ³ 08.01.09 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³ Validar todos os parametros preenchidos                     ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ cRet:= .T. ou .F.                                           ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ cNumPar = Numero do parametro que foi preenchido            ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PrmCtbrC(cNumPar,lUltmVld)

Local lRet       := .T.
Local aTexto1    := {}
Local aTexto2    := {}
Default lUltmVld := .F.

// verifica existencia da consulta padrao SX5SL
If lRet .And. SXB->(!DbSeek("SX5SL"))
	aTexto1 := {}
	aTexto2 := {}
	Aadd( aTexto1,{STR0011,;//"A consulta padrão SX5SL está ausente e  "
	               STR0022})//"ela se faz necessário neste relatório.  "
	Aadd( aTexto2,{STR0025,;//"Executar a rotina UPDCTB com data igual "
	               STR0037,;//"ou superior ha 25/12/2008 para criar a  "
	               STR0018})//"consulta padrão em questão.             "
	ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
	lRet := .F.
EndIf

Do Case
//----------------------------------------------------------
	Case cNumPar == "01"
		//Validar se existe exercicio contábil informado
		CTG->(DbSetOrder(1))
		If !Empty(mv_par01) .And. CTG->(!DbSeek(xFilial("CTG")+mv_par01))
			aTexto1 := {}
			aTexto2 := {}
			Aadd( aTexto1,{STR0033,;//"O exercício contábil escolhido não      "
			               STR0027})//"existe no cadastro.                     "
			Aadd( aTexto2,{STR0031,;//"Favor verificar o cadastro do mesmo ou  "
			               STR0023,;//"escolher outro calendário mas que seja  "
			               STR0042})//"válido.                                 "
			ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
			lRet := .F.
		EndIf
		
//----------------------------------------------------------
	Case cNumPar == "02"

//----------------------------------------------------------
	Case cNumPar == "03"

//----------------------------------------------------------
	Case cNumPar == "04"
		If mv_par04 == 1
			//Calendario
			//verificar se o calendario informado está diferente de vazio
			//e verificar se existe no cadastro a informação preenchida
			CTG->(DbSetOrder(1))
			If Empty(mv_par01) .Or. CTG->(!DbSeek(xFilial("CTG")+mv_par01))
				aTexto1 := {}
				aTexto2 := {}
				Aadd( aTexto1,{STR0033,;//"O exercício contábil escolhido não      "
				               STR0026})//"existe no cadastro ou não foi preenchido"
				Aadd( aTexto2,{STR0031,;//"Favor verificar o cadastro do mesmo ou  "
				               STR0024,;//"escolher um ou outro calendário mas que "
				               STR0041})//"seja válido.                            "
				ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
				lRet := .F.
			EndIf
		Else
			//Informado
			//verificar se a data de referencia está diferente de vazio
			If lRet .And. Empty(mv_par02)
				aTexto1 := {}
				aTexto2 := {}
				Aadd( aTexto1,{STR0012,;//"A data de referência está vazia e       "
				               STR0016,;//"conforme definição do parâmetro detalhe "
				               STR0021})//"do período ela se torna obrigatória.    "
				Aadd( aTexto2,{STR0030,;//"Favor preencher com uma data o parâmetro"
				               STR0019})//"data de referência.                     "
				ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
				If lUltmVld
					lRet := .F.
				Else
					mv_par02 := FirstDay(dDataBase)
				EndIf
			EndIf
			//verificar se o periodo está maior de 0
			If lRet .And. mv_par05 == 0
				aTexto1 := {} 
				aTexto2 := {}
				Aadd( aTexto1,{STR0034,;//"O período informado está como 0 (zero) e"
				               STR0016,;//"conforme definição do parâmetro detalhe "
				               STR0021})//"do período ela se torna obrigatória.    "
				Aadd( aTexto2,{STR0029,;//"Favor preencher com um número maior que "
				               STR0010})//"0 (zero) o parâmetro período            "
				ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
				If lUltmVld
					lRet := .F.
				Else
					mv_par05 := 1
				EndIf
			EndIf
		EndIf

//----------------------------------------------------------
	Case cNumPar == "05"

//----------------------------------------------------------
	Case cNumPar == "06"

//----------------------------------------------------------
	Case cNumPar == "07"
		//faz a validacao do livro
		lRet := VdSetOfBook(mv_par07,.T.)
		If lRet
			aSetOfBook:= CTBSetOf(mv_par07)
			If !Empty(mv_par08)
				aCtbMoeda := CtbMoeda(mv_par08, aSetOfBook[9])
				If Empty(aCtbMoeda[1])
					Help(" ",1,"NOMOEDA")
					lRet := .F.
				Endif
			EndIf
		EndIf

//----------------------------------------------------------
	Case cNumPar == "08"
		CTO->(DbSetOrder(1))
		If CTO->(DbSeek(xFilial("CTO")+mv_par08))
			If Len(aSetOfBook) > 0 .And. !Empty(mv_par08)
				aCtbMoeda := CtbMoeda(mv_par08, aSetOfBook[9])
				If Empty(aCtbMoeda[1])
					Help(" ",1,"NOMOEDA")
					lRet := .F.
				Endif
			Else
				If Empty(mv_par08)
					Help(" ",1,"NOMOEDA")
					lRet := .F.
				EndIf
			EndIf
		Else
			Help(" ",1,"NOMOEDA")
			lRet := .F.
		EndIf

//----------------------------------------------------------
	Case cNumPar == "09"

//----------------------------------------------------------
	Case cNumPar == "10"
		//Verificar se o parametro posição anterior esta como 
		//Sim=1 e se estiver então forçar o preenchimento deste 
		//parametro = data
		If mv_par09 == 1 .And. Empty(mv_par10)
			aTexto1 := {} 
			aTexto2 := {}
			Aadd( aTexto1,{STR0013,;//"A data lucros/perdas está em branco e   "
			               STR0017,;//"conforme definição do parâmetro posição "
			               STR0014})//"anterior L/P ela se torna obrigatória.  "
			Aadd( aTexto2,{STR0030,;//"Favor preencher com uma data o parâmetro"
			               STR0020})//"data lucros/perdas.                     "
			ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
			lRet := .F.
		EndIf

//----------------------------------------------------------
	Case cNumPar == "11"

//----------------------------------------------------------
	Case cNumPar == "12"
		//Verificar se moeda existe
		CTO->(DbSetOrder(1))
		If !Empty(mv_par12) .And. CTO->(!DbSeek(xFilial("CTO")+mv_par12))
			Help(" ",1,"NOMOEDA")
			lRet := .F.
		EndIf

//----------------------------------------------------------
	Case cNumPar == "13"
		If mv_par13 == 1
			//Verificar se parametro 13 está igual a Sim=1 e se 
			//estiver vazio, forçar preenchimento deste parametro = saldo a consolidar 
			If Empty(mv_par14)
				aTexto1 := {} 
				aTexto2 := {}
				Aadd( aTexto1,{STR0035,;//"O saldo a consolidar está em branco e     "
				               STR0015,;//"conforme definição do parâmetro consolidar"
				               STR0040})//"saldo ela se torna obrigatória.           "
				Aadd( aTexto2,{STR0028,;//"Favor preencher com algum tipo de saldo o "
				               STR0038})//"parâmetro saldo a consolidar.             "
				ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
				If lUltmVld
					lRet := .F.
				Else
					mv_par14 := "1"
				EndIf
			EndIf
		Else
			//Verificar se parametro 13 está igual a Não=2 e se 
			//estiver, forçar preenchimento deste parametro = Tipo de saldo
			If Empty(mv_par15)
				aTexto1 := {} 
				aTexto2 := {}
				Aadd( aTexto1,{STR0036,;//"O tipo de saldo está vazio/em branco e    "
				               STR0015,;//"conforme definição do parâmetro consolidar"
				               STR0040})//"saldo ela se torna obrigatória.           "
				Aadd( aTexto2,{STR0028,;//"Favor preencher com algum tipo de saldo o "
				               STR0039})//"parâmetro tipo de saldo.                  "
				ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
				If lUltmVld
					lRet := .F.
				Else
					mv_par15 := "1"
				EndIf
			EndIf
		EndIf

//----------------------------------------------------------
	Case cNumPar == "14"
		//Verificar se parametro 13 está igual a Sim=1 e se 
		//estiver vazio, forçar preenchimento deste parametro = saldo a consolidar 
		If Empty(mv_par14) .And. mv_par13 == 1
			aTexto1 := {} 
			aTexto2 := {}
			Aadd( aTexto1,{STR0035,;//"O saldo a consolidar está em branco e     "
			               STR0015,;//"conforme definição do parâmetro consolidar"
			               STR0040})//"saldo ela se torna obrigatória.           "
			Aadd( aTexto2,{STR0028,;//"Favor preencher com algum tipo de saldo o "
			               STR0038})//"parâmetro saldo a consolidar.             "
			ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
			If lUltmVld
				lRet := .F.
			Else
				mv_par14 := "1"
			EndIf
		EndIf

//----------------------------------------------------------
	Case cNumPar == "15"
		//Verificar se parametro 13 está igual a Não=2 e se 
		//estiver, forçar preenchimento deste parametro = Tipo de saldo
		If Empty(mv_par15) .And. mv_par13 == 2
			aTexto1 := {} 
			aTexto2 := {}
			Aadd( aTexto1,{STR0036,;//"O tipo de saldo está vazio/em branco e    "
			               STR0015,;//"conforme definição do parâmetro consolidar"
			               STR0040})//"saldo ela se torna obrigatória.           "
			Aadd( aTexto2,{STR0028,;//"Favor preencher com algum tipo de saldo o "
			               STR0039})//"parâmetro tipo de saldo.                  "
			ShowHelpDlg(STR0032,aTexto1[1],5,aTexto2[1],5)//"INCOMPATIVEL"
			If lUltmVld
				lRet := .F.
			Else
				mv_par14 := "1"
			EndIf
		EndIf
	

//----------------------------------------------------------
	Case cNumPar == "16"

EndCase

Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ GerArq                                 ³ Data ³ 15.04.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Gera o arquivo magnético                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³ cDir - Diretorio de criacao do arquivo.                    ³±±
±±³            ³ cArq - Nome do arquivo com extensao do arquivo.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³10.2 REGISTRO DE COSTOS - ELEMENTOS DEL COSTO MENSUAL        ±±
±±³            ³                                                             ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GerArq(cDir)

Local nHdl  := 0
Local cLin  := ""
Local cSep  := "|"
Local cArq  := ""
Local nCont := 0
Local X     := 1 
Local Y     := 1 

cArq += "LE"                          // Fixo  'LE'
cArq +=  AllTrim(SM0->M0_CGC)         // Ruc
cArq +=  AllTrim(Str(Year(MV_PAR02))) // Ano
cArq += "00"                          // Mes
cArq += "00"                          // Fixo '00'
cArq += "100200"                      // Fixo '100200'
cArq += "00"                          // Fixo '00'
cArq += "1"
cArq += "1"
cArq += "1"
cArq += "1"
cArq += ".TXT" // Extensao

FOR nCont:=LEN(ALLTRIM(cDir)) TO 1 STEP -1
   IF SUBSTR(cDir,nCont,1)=='\' 
      cDir:=Substr(cDir,1,nCont)
      EXIT
   ENDIF   
NEXT 

nHdl := fCreate(cDir+cArq)
If nHdl <= 0
	ApMsgStop("Error al Crear Archivo TXT.")
Else
		// Impressão .TXT do aItens
		//[1][1] - Periodo					
		//[1][2] - Costo de Materiales y Suministros Directos			 
		//[1][3] - Costo de la Mano de Obra Directa			
		//[1][4] - Otros Costos Directos		
		//[1][5] - Gastos de Producción Indirectos: Materiales y Suministros Indirectos			
		//[1][6] - Gastos de Producción  Indirectos:Mano de Obra Indirecta			
		//[1][7] - Otros Gastos de Producción Indirectos

		For X:=1 To Len(aItens)
			cLin:=""			
			For Y:=1 To Len(aItens[X])	
				IF valtype(aItens[X][Y]) == "N"
					cLin += AllTrim(strtran(Transform(aItens[X][Y],"@E 99999999999.99"),",","."))
				Else
					cLin += AllTrim(strtran(Transform(aItens[X][Y],"@R 99999900"),",","."))
				Endif
				cLin += cSep		
			Next y	
			cLin += "1" // [1][8] - Indica el estado de la operación
			cLin += cSep	
			
			cLin += chr(13)+chr(10)		
			fWrite(nHdl,cLin)		
							
		Next X	 

	fClose(nHdl)
MsgAlert("Archivo TXT Generado con Êxito")
EndIf
Return Nil

STATIC FUNCTION CTB700PER()
// Verifica o tipo de calendário CAMPO PERIODO 
// 4  = Trimestral
// 6  = Bimestral
// 12 = Anual

Local nPeri  := 0
Local cQuery := ""
local lAlias := ChkFile("TMPTRM")

IF lAlias
	DbSelectArea( "TMPTRM" )
	DbCloseArea()
Endif

cQuery := " SELECT "
cQuery += "    COUNT(*) AS PERIODO"

cQuery += " FROM " +  RetSqlName("CTG")  
cQuery += " WHERE "
cQuery += "        CTG_FILIAL = '" + xFilial("CTG") +"' " 
cQuery += "    AND CTG_CALEND = '" + mv_par01 +"' " 
cQuery += "    AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPTRM",.T.,.T.)

nPeri:= TMPTRM->PERIODO  

DbSelectArea( "TMPTRM" )
DbCloseArea()

Return(nPeri)
