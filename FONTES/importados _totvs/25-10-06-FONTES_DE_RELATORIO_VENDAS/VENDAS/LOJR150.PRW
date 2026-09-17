#INCLUDE "LOJR150.ch"
#include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJR150   º Autor ³ Paulo Augusto      º Data ³  18/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de vendas (Localizacao Nicaragua)                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Loja                                                       º±±
±±ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  DATA  ³ BOPS ³Program.³    ALTERACAO                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³21/02/07³119542³Conrado ³Retirada função de ajuste do dicionário.      ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function LOJR150()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1  := OemToAnsi(STR0001) //"Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := OemToAnsi(STR0002) //"de acordo com os parametros informados pelo usuario."
Local cDesc3  := OemToAnsi(STR0003) //"Relatorio de transacoes de vendas "
Local cPict   := ""
Local titulo  := OemToAnsi(STR0003) //"Relatorio de transacoes de vendas "
Local nLin    := 80

Local Cabec1  := ""
Local Cabec2  := ""
Local imprime := .T.
Local aOrd    := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private cbtxt      	 := Space(10)
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "LOJR150"
Private cPerg        := "LJR150"
Private nTipo        := 18
Private aReturn      := { OemToAnsi(STR0004), 1, OemToAnsi(STR0005), 2, 2, 1, "", 1}  //"Zebrado"###"Administracao"
Private nLastKey     := 0
Private cbcont     	 := 00
Private CONTFL     	 := 01
Private m_pag      	 := 01
Private wnrel      	 := "LOJR150" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| mv_par01  Filial Original de ?  |
//| mv_par02  Filial Original ate ? |
//| mv_par03  Numero de ?        	|
//| mv_par04  A Numero  ?        	|
//| mv_par05  Cliente de ?"      	|
//| mv_par06  Loja de ?          	|
//| mv_par07  Cliente ate ?"     	|
//| mv_par08  Loja ate ?"        	|
//| mv_par09  Vendedor de ?"     	|
//| mv_par10  Vendedor ate?"     	|
//| mv_par11  Data de ?          	|
//| mv_par12  Data ate ?         	|
//| mv_par13  Imprimir Vendas ?  	|
//| mv_par14  Qual Moeda ?       	|
//| mv_par15  Outras Moedas"        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

dbSelectArea("SF2")                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)
          
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo += IIf(MV_PAR13 == 1, OemToAnsi(STR0006),Iif(MV_PAR13 == 2,OemToAnsi(STR0007),OemToAnsi(STR0008))) + OemToAnsi(STR0004) + GetMV("MV_MOEDA"+alltrim(str(MV_PAR14))) //"  - Notas Tributadas"###"  -  Notas Isentas"###"  -  Notas Isentas e Tributadas"

RptStatus({|| Ljr150Imp(Cabec1,Cabec2,Titulo,nLin) },Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apos a geracao do relatorio fecha a area de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	dbSelectArea("TMP")
	dbCloseArea()
#ENDIF

dbSelectArea("SF2")
dbSetOrder(1)
SET(11,"ON")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³Ljr150Imp º Autor ³ Paulo Augusto      º Data ³  18/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao de impressao                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Ljr150Imp(Cabec1,Cabec2,Titulo,nLin)

Local cQuery  	:= ""
Local cSA1    	:= ""
Local cSA3    	:= ""
Local cFil    	:= ""
Local cLinha  	:= ""
Local dEmissao	:= Ctod("")
Local nTotFil 	:= 0
Local nTotEmi 	:= 0
Local nTotGer 	:= 0 
Local nTotImpFil:= 0 
Local nTotImpEmi:= 0 
Local nTotImpGer:= 0 
Local aArea   	:= GetArea()
Local lPrim		:=.T.	
Local cFiltra	:=""        
Local cCalcImp	:=""
Local nTotalImp	:= 0
Local nVlrFact	:=0

Private cSF2    := ""          

dbSelectArea("SA1") // A1_FILIAL+A1_COD+A1_LOJA
dbSetOrder(1)

dbSelectArea("SA3") // A3_FILIAL+A3_COD
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Cabecalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cPaisLoc == "NIC" .And. MV_PAR13 <> 1
	Cabec1 := OemToAnsi(STR0010)//  "Data      Numero Doc     Cliente        Nome.Cliente                                 Vendedor             Valor Total        Valor Imposto       Codigo de Exoneracao    "
    cLinha := "--------  -------------------  -----------  ----------------------------  -----------------------------    ---------------  ------------------  -------------------------"
Else
	//                             1         2         3         4         5         6         7         8         9         100       110       120       130       140       150       160       170       180       190
	//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Cabec1 := OemToAnsi(STR0009) //"Data      Numero Doc     Cliente        Nome.Cliente                                 Vendedor             Valor Total      Valor Imposto"
	            //   99/99/99  XXXXXX/XXX     XXXXXX/XX      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     XXXXXXXXXXXXXXX    999,999,999.99     999,999,999.99
	cLinha := "--------  -----------------  -----------  ----------------------------  -----------------------------    ---------------  ------------------  "
EndIf

#IFNDEF TOP
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Varre o SF2 enquanto nao for fim de arquivo, listando os historicos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ordena os registros por Data de Emissao + Filial						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   cChave := "DTOS(F2_EMISSAO)+F2_FILIAL"
   cArq   := CriaTrab(NIL,.F.)           
   IndRegua("SF2",cArq,cChave,,,,.F.) 
   dbGoTop()
    
	If cPaisLoc<>"BRA"  
       	aArea:=GetArea()
        DbSelectArea("SX3")
		DbSetOrder(2)
		If Dbseek("F2_VALIMP")
			While !EOF() .And. Subs(x3_campo,4,6)=="VALIMP"
				If !lPrim
				  	cFiltra += " .OR.  "         
					cCalcImp+= " + "
				Else	
					cFiltra +="("
					lPrim:= .F.
				EndIf
				cFiltra += " SF2->" + x3_campo  + " <> 0"
				cCalcImp+= "(cSF2)->"+x3_campo 
				DbSkip()
			EndDo        
			If !lPrim
				cFiltra += ")"
			EndIf	          
		   	If MV_PAR13==1
				cFiltra	:=	"!"+cFiltra
			EndIf	
		EndIf
		RestArea(aArea)
    EndIf
    
    If MV_PAR13 == 3  
    	cFiltra:=""
    EndIf	
	
	SF2->(dbSeek(DTOS(MV_PAR11)+MV_PAR01,.T.))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())
	
	While SF2->(!EOF()) .And. SF2->F2_FILIAL  <= MV_PAR02 .And.;
							   SF2->F2_EMISSAO <= MV_PAR12 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua o Filtro dos parametros³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If 	(SF2->F2_DOC     < MV_PAR03 .Or. SF2->F2_DOC     > MV_PAR04) .Or.;
			(SF2->F2_CLIENTE < MV_PAR05 .Or. SF2->F2_CLIENTE > MV_PAR07) .Or.;
			(SF2->F2_LOJA    < MV_PAR06 .Or. SF2->F2_LOJA    > MV_PAR08) .Or.;
			(SF2->F2_VEND1   < MV_PAR09 .Or. SF2->F2_VEND1   > MV_PAR10)
			SF2->( dbSkip() )
	    	Loop
	    EndIf
	   	
	   	If mv_par13 <> 3  .AND. &cFiltra
	   	 	SF2->( dbSkip() )
	      	Loop
	    EndIf
	    
	    If mv_par15 ==1 .AND. mv_par14 <> SF2->F2_MOEDA
	   	 	SF2->( dbSkip() )
	      	Loop
	    EndIf
    
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona no arquivo de vendedores para atra ves do campo³
		//³F2_VEND1, para pegar os dados do vendedor.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		cFilA3 := IIf(xFilial("SA3") == Space(FWGETTAMFILIAL), xFilial("SA3"), SF2->F2_FILIAL)
		SA3->(dbSeek( cFilA3 + SF2->F2_VEND1))
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona no Arquivo de Clientes atraves do campo, F2_COD+F2_LOCAL³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilA1 := IIf(xFilial("SA1") == Space(FWGETTAMFILIAL), xFilial("SA1"), SF2->F2_FILIAL)
		SA1->(dbSeek( cFilA1 + SF2->F2_CLIENTE + SF2->F2_LOJA))
		
		cSF2 := "SF2"
		cSA1 := "SA1"
		cSA3 := "SA3"
#ELSE
	cQuery := " SELECT F2_FILIAL,F2_EMISSAO,F2_HORA,F2_VALBRUT, F2_DOC, F2_MOEDA ,F2_SERIE, "		    
    If cPaisLoc=="NIC" .And. SF2->(FieldPos("F2_CODEXON")) > 0 
       	cQuery +=" F2_CODEXON,"
    Endif
    
    If cPaisLoc<>"BRA" 
       	aArea:=GetArea()
        DbSelectArea("SX3")
		DbSetOrder(2)
		If Dbseek("F2_VALIMP")
			
			While !EOF() .And. Subs(x3_campo,4,6)=="VALIMP"
				If lPrim 
					cFiltra:="("
					lPrim:=.F.   
				Else
					cFiltra +="	OR " 
					cCalcImp+= " + "
				EndIf
				cQuery+= x3_campo +","
				cFiltra += " SF2." + x3_campo + " <> 0  " 
				cCalcImp+= "(cSF2)->"+x3_campo 
				DbSkip()
			EndDo 
			If !lPrim
				cFiltra += ")  AND " 	
			EndIf
			If MV_PAR13==1
				cFiltra	:=	"NOT "+cFiltra
			EndIf	
		EndIf	
		RestArea(aArea)	
	EndIf
	If MV_PAR13 == 3  
    	cFiltra:=""
    EndIf
	
	cQuery += "A1_COD,A1_LOJA,A1_NOME,A3_COD,A3_NOME"
    cQuery += " FROM " +RetSQLName("SF2")+" SF2, " +RetSQLName("SA1")+" SA1, " +RetSQLName("SA3")+" SA3 "
	cQuery += " WHERE SF2.F2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "    
    
    If xFilial("SA1") == Space(FWGETTAMFILIAL)
    	cQuery += " SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "	
    Else
    	cQuery += " SA1.A1_FILIAL = SF2.F2_FILIAL AND "
    EndIf 
    
    cQuery += " SA1.A1_COD    = SF2.F2_CLIENTE AND "
 	cQuery += " SA1.A1_LOJA   = SF2.F2_LOJA AND	 "
    cQuery += " SA1.D_E_L_E_T_ = ' ' AND "	
    
	cQuery += cFiltra 
	If Mv_PAR15 == 1
		cQuery += " SF2.F2_MOEDA = " +Alltrim(str( MV_PAR14 ))+ " AND "	
	EndIf
    If xFilial("SA3") == Space(FWGETTAMFILIAL)
    	cQuery += " SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND "	
    Else
    	cQuery += " SA3.A3_FILIAL = SF2.F2_FILIAL AND "
    EndIf   
	cQuery += " SA3.A3_COD    = SF2.F2_VEND1 AND "
   	cQuery += " SA3.D_E_L_E_T_ = ' ' AND "	
   	cQuery += " SF2.F2_EMISSAO BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "' AND "
	cQuery += " SF2.F2_DOC     BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "    
	cQuery += " SF2.F2_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR07 + "' AND "    
	cQuery += " SF2.F2_LOJA    BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR08 + "' AND "    
	cQuery += " SF2.F2_VEND1   BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "    
   	cQuery += " ORDER BY F2_EMISSAO,F2_FILIAL"
	
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .T., .F.)
	
	TCSetField( "TMP", "F2_EMISSAO", "D", 8, 0 )
	TCSetField( "TMP", "F2_VALBRUT", "N", 14, 2 )
	
	dbSelectArea("TMP")
	
	SetRegua(40)
	
	cSF2 := "TMP"
	cSA1 := "TMP"
	cSA3 := "TMP"
	
	While (cSF2)->(!EOF())
	
#ENDIF  
  
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY OemToAnsi(STR0011) //"*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	                        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,"",Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra por Filial.					³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (cSF2)->F2_FILIAL <> cFil .or. (cSF2)->F2_EMISSAO <> dEmissao )
		If (!Empty(cFil), nLin+=2 ,)
  	   cFil := (cSF2)->F2_FILIAL
		@nLin,000 PSAY OemToAnsi(STR0012) + " - "+cFil+" "+ Posicione("SM0",1,cEmpAnt+cFil,"M0_NOME") //"Sucursal"
		nLin += 2
		@nLin,000 PSAY cabec1
		nLin ++
		@nLin,000 PSAY cLinha
		nLin ++		
   	Endif

	dEmissao := (cSF2)->F2_EMISSAO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao dos dados do relatorio.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@nLin,000 PSAY (cSF2)->F2_EMISSAO
	@nLin,010 PSAY (cSF2)->F2_DOC+" / "+(cSF2)->F2_SERIE
	@nLin,031 PSAY (cSA1)->A1_COD+" / "+(cSA1)->A1_LOJA
    @nLin,045 PSAY Subs((cSA1)->A1_NOME,1,20)   
    nTotalImp:=&cCalcImp
	nVlrFact:=(cSF2)->F2_VALBRUT
	If MV_PAR15 == 2
		nTotalImp:= Xmoeda(nTotalImp,(cSF2)->F2_MOEDA,MV_PAR14)
		nVlrFact:=Xmoeda(nVlrFact,(cSF2)->F2_MOEDA,MV_PAR14)
	EndIf
	
	@nLin,075 PSAY Subs((cSA3)->A3_NOME,1,20)
	@nLin,103 PSAY Transform(nVlrFact, PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14))
	@nLin,123 PSAY Transform(nTotalImp, PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14))
    
    If cPaisLoc=="NIC" .And. SF2->(FieldPos("F2_CODEXON")) > 0 
		@nLin,144 PSAY (cSF2)->F2_CODEXON
	EndIf	

	nTotFil += nVlrFact
	nTotEmi += nVlrFact
	nTotGer += nVlrFact
    
	nTotImpFil += nTotalImp
	nTotImpEmi += nTotalImp
	nTotImpGer += nTotalImp


	nLin ++ // Avanca a linha de impressao
	
	(cSF2)->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Total por Filial.					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (cSF2)->F2_FILIAL <> cFil )
		nLin ++
		If nLin > 55
			Cabec(Titulo,"",Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
		Endif
		@nLin,000 PSAY OemToAnsi(STR0013) + " " + cFil //"TOTAL SUCURS."        
		@nLin,103 PSAY Transform( nTotFil , PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14) )
		@nLin,123 PSAY Transform( nTotImpFil , PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14) )
		
		nTotFil := 0
		nTotImpFil := 0
		nLin ++
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Total por Data de Emissao.		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (cSF2)->F2_EMISSAO <> dEmissao )
		nLin ++
		If nLin > 55
			Cabec(Titulo,"",Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
		Endif

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³Totaliza por Data + Filial.	   ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( (cSF2)->F2_FILIAL == cFil )
			@nLin,000 PSAY OemToAnsi(STR0013) + " " + cFil
		    @nLin,103 PSAY Transform( nTotFil , PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14))
	   		@nLin,123 PSAY Transform( nTotImpFil , PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14) )
	   			   		
		   	nTotFil := 0
		   	nTotImpFil := 0
			nLin += 2
		Endif
		@nLin,000 PSAY OemToAnsi(STR0014) + " " + Dtoc(dEmissao) //"TOTAL"
		@nLin,103 PSAY Transform( nTotEmi , PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14) )
	   	@nLin,123 PSAY Transform( nTotImpEmi , PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14) )
   		   	
		nTotEmi := 0
		nTotImpEmi := 0
      nLin ++
	Endif
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,"",Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 6
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Total Geral do relatorio. . .                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin += 2
@nLin,000 PSAY OemToAnsi(STR0015) //"TOTAL GRAL."
@nLin,103 PSAY Transform( nTotGer , PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14) )                     
@nLin,123 PSAY Transform( nTotImpGer , PesqPict("SF2", "F2_VALBRUT",18,MV_PAR14) )

Roda(0,"",Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

RestArea(aArea)

Return 