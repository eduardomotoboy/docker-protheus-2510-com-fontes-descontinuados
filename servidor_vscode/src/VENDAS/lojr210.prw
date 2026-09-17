#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"    
#INCLUDE "LOJR210.CH"

#DEFINE NSALTO		50		// Distancia entre linhas do relatorio
#DEFINE MARGESQ		0030	// Margem esquerda do relatorio
#DEFINE MARGDIR		2300	// Margem direita do relatorio
#DEFINE CENTRO		1150	// Centro do relatorio (MARGDIR/2)

#DEFINE PITEM	0070	// Posicao do campo Item
#DEFINE PCODI	0180	// Posicao do campo Codigo
#DEFINE PDESC	0470	// Posicao do campo Descricao
#DEFINE PQUAN	1165	// Posicao do campo Quantidade
#DEFINE PUNMD	1360	// Posicao do campo Unidade de Medida
#DEFINE PVUNI	1480	// Posicao do campo Valor Unitario
#DEFINE PVDSC	1780	// Posicao do campo Valor do desconto
#DEFINE PVTOT	2075	// Posicao do campo Valor total do item


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³LojR210   ºAutor  ³Vendas CRM          º Data ³  16/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do Documento Auxiliar de Venda (DAV) a partir do  º±±
±±º          ³orcamento salvo no SIGALOJA.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SIGALOJA                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function LojR210()
Local aArea			:= GetArea()			// Armazena o posicionamento atual
Local aAreaSA1		:= SA1->(GetArea())	// Armazena o posicionamento do SA1
Local lRet			:= .T.
Local lMvLjDAVECF	:= SuperGetMv("MV_LJDAVEC",,.F.)
Local lPafNfce		:= IIf(ExistFunc("LjPafNFCe"),LjPafNFCe(),.F.)	//Usa PAF-NFC-e c/ Impressora Não Fiscal

IF LjNfPafEcf(SM0->M0_CGC) .And. !lMvLjDAVECF .And. AllTrim(SM0->M0_ESTCOB) $ "PB|ES"
	//#"Para o Estado da Paraíba e Espírito Santo não é permitido a impressão em impressora laser"
	//#"Configure o parametro MV_LJDAVEC para .T. (Impressão em ECF)"
	MsgAlert(STR0030+CHR(10)+CHR(13)+STR0031)
	lRet := .F.
EndIf

//De acordo com o (REQUISITO IV - Inciso IV do PAF-NFC-e), não é permitido imprimir ou alterar ou cancelar o DAV após a emissão do Documento Eletrônico
If lRet .And. lPafNfce .And. !Empty(SL1->L1_DOC)
	MsgStop(STR0037) //"Conforme previsto em legislação (REQUISITO IV - Inciso IV do PAF-NFC-e), é vedada a reimpressão do DAV após emitido o Documento Fiscal Eletrônico da venda."
	lRet := .F.
EndIf

//³ Não permite Reimpressao de DAV ³
If lRet .And. !Empty(AllTrim(SL1->L1_COODAV))
	lRet := .F.
	MsgStop(STR0022)//"Conforme previsto no ATO COTEPE/ICMS 14, DE 16 DE MARÇO DE 2011, é vedada a reimpressão do DAV"	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Não imprime DAV cancelado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. AllTrim(SL1->L1_STORC) == "C"
	lRet := .F.
	MsgStop(STR0028)//"DAV Cancelada. Impressão não permitida"
EndIf

/* Não emite DAV por ECF quando venda já finalizada, 
 devido a atualização de COO realizada na impressão*/
If lRet .AND. !Empty(AllTrim(SL1->L1_NUMCFIS))
	lRet := .F.
	MsgStop(STR0023) //"Já foi emitido Cupom Fiscal para essa conta, é vedada a impressão do DAV"
EndIf

If lRet .And. !lPafNfce .And. ( Empty(AllTrim(SL1->L1_PAFMD5)) .Or. (SL1->L1_TPORC <> "D"))
	lRet := .F.
	MsgStop(STR0032) //"Este orçamento não foi gerado como DAV em ambiente PAF-ECF portanto relatório não será gerado"
EndIf
            
If lRet
	//³ Posiciona no arquivo de Clientes³
	DbSelectArea( "SA1" )
	SA1->(DbSetOrder( 1 ))
	SA1->(DbSeek( xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA ))

	If lMvLjDAVECF .OR. LjAnalisaLeg(55)[1]
		Processa({|| ImpRelECF() },STR0001) //"Imprimindo DAV"
	Else
		Processa({|| ImpRel() },STR0001) //"Imprimindo DAV"	
	EndIf
	
	RestArea(aAreaSA1)
	RestArea(aArea)
EndIf

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ImpRel    ºAutor  ³Vendas CRM          º Data ³  16/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do relatorio DAV                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR210                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpRel()
Local oFontNor  	:= NIL								// Fonte normal para impressao do relatorio
Local oFontItem	  	:= NIL								// Fonte para impressao dos itens do orcamento
Local oFontNeg  	:= NIL								// Fonte em negrito para destaque de mensagem
Local oPrint		:= Nil								// Objeto de impressao
Local nLin			:= 100000 							// Posicao da linha inicial
Local nPag			:= 0 								// Quantidade de paginas impressas
Local cPictQuant	:= PesqPict("SL2","L2_QUANT")		// Picture da quantidade
Local cPictVrUni	:= "@E 999,999,999.9999"            // Picture do valor unitario	//Reduzimos a picture para caber na impressão
Local cPictVrTot	:= PesqPict("SL2","L2_VLRITEM")		// Picture do valor do item
Local nTotal		:= 0								// Acumulador do total
Local nDesconto		:= 0								// Acumulador de descontos sobre os itens
Local cCodProDav	:= ""								// Formata codigo
Local nDescNf		:= 0								// Desconto sobre o documento
Local lCancelado	:= .F.								// Sinaliza item cancelado
Local nJurosNf		:= 0								// Juros lancado na venda
Local aDav			:= {}								// Linhas para impressão customizada
Local nX			:= 0								// Controle Loop for
Local nQtdeProd		:= 0

Static NMAX			:= 0								// Numero maximo de linhas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as fontes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE Font oFontNor	Name 'Courier New'	Size 0, 10	Of oPrint
DEFINE Font oFontItem	Name 'Courier New'	Size 0, 8.5 Of oPrint
DEFINE Font oFontNeg	Name 'Courier New'	Size 0, 12	Of oPrint Bold

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Configura impressao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint := TMSPrinter():New( STR0002 ) //"Documento Auxiliar de Venda - DAV"

oPrint:Setup()
oPrint:SetPortrait()
oPrint:SetFont( oFontNor )

//Define maximo de linhas para a impressao configurada
NMAX := oPrint:nVertRes()-50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos itens orcados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Considera os registros deletados
SET DELETED OFF
DbSelectArea("SL2")
SL2->(DbSetOrder(1)) //L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO     
SL2->(DbSeek(xFilial("SL2")+SL1->L1_NUM))

While !SL2->(Eof()) .AND. (SL2->L2_FILIAL+SL2->L2_NUM == SL1->L1_FILIAL+SL1->L1_NUM)
	
	If !Empty(SL2->L2_PAFMD5) .AND. ( Empty(SL2->L2_CONTDOC) .OR. (!Empty(SL2->L2_CONTDOC) .AND. !Empty(SL2->L2_NUMORIG)) )

		lCancelado	:= IIF(SL2->L2_VENDIDO == "N", .T., .F.)
	
		//Verifica se deve inserir uma quebra
		If nLin > NMAX
			Cabec(	@oPrint	, @oFontNor,@oFontNeg,@nLin,;
					@nPag	, oFontItem)
		EndIf
	
		cCodProDav := SubStr(SL2->L2_PRODUTO,1,15)
		
		oPrint:Say(nLin,PITEM,SL2->L2_ITEM			   	   	  		   		,oFontItem)
		oPrint:Say(nLin,PCODI,cCodProDav									,oFontItem)
		
		//Impressão da descrição do produto
		If !lCancelado
			LojRQuebraLinha(@oPrint,@nLin,oFontItem,SL2->L2_DESCRI,38)
		Else                                                                          
			LojRQuebraLinha(@oPrint,@nLin,oFontItem,SL2->L2_DESCRI + " [CANCELADO]",38)
		EndIf
		oPrint:Say(nLin,PQUAN,Transform(SL2->L2_QUANT,cPictQuant)			,oFontItem)
		oPrint:Say(nLin,PUNMD,SL2->L2_UM				  		   			,oFontItem)
		oPrint:Say(nLin,PVUNI,Transform(SL2->L2_VRUNIT,cPictVrUni)			,oFontItem)
		oPrint:Say(nLin,PVDSC,Transform(SL2->L2_VALDESC,cPictVrTot)		,oFontItem)
		oPrint:Say(nLin,PVTOT,Transform(SL2->L2_VLRITEM,cPictVrTot)		,oFontItem)
		
		//Incrementa acumuladores
		If !lCancelado		
			nTotal 		+= SL2->L2_VLRITEM + SL2->L2_VALDESC 
			nDesconto	+= SL2->L2_VALDESC
		EndIf
	
		nLin += NSALTO 
		nQtdeProd++ //Para validar se o DAV está em branco      
	EndIf
	
	SL2->(DbSkip())
End

//Desconsidera os registros deletados
SET DELETED ON

nDesconto += SL1->L1_DESCONT
nJurosNF  := (((nTotal-nDesconto)*SL1->L1_JUROS)/100)

//PE para customizar impressao DAV
If ExistBlock("LJR210DAV")	  		
	aDav := ExecBlock( "LJR210DAV", .F., .F. )
	
  	If ValType(aDav) == "A"
	
		For nX := 1 to Len(aDav)
			nLin += NSALTO       
		
			//Verifica se deve inserir uma quebra
			If nLin > NMAX
				Cabec(	@oPrint	, @oFontNor,@oFontNeg,@nLin,;
						@nPag	, oFontItem)
			EndIf
	
			oPrint:Say(nLin,0070,aDav[nX],oFontItem)
			
		Next nX	
	Else 
		MsgStop(STR0029)	//"Ponto de Entrada LJR210DAV compilado de forma indevida. Retorno esperado:Array."
	EndIf
EndIf

/*Variavel com o desconto do documento */
nDescNF 	:= Iif(SL1->L1_DESCONT > 0, SL1->L1_DESCONT, nDesconto)                
nJurosNF  	:= (((nTotal-nDescNF)*SL1->L1_JUROS)/100)

/*Impressao do rodape com totalizadores*/
RdpFim(	@oPrint	, @oFontNor 	, @oFontNeg	, @nLin		,;
		@nPag	, nTotal		, nDesconto	, nDescNf	,;
		nJurosNf, SL1->L1_FRETE )

/*Finaliza impressao*/
oPrint:EndPage()
oPrint:End()

If nQtdeProd > 0
	oPrint:Preview()
Else
	MsgAlert(STR0033) //"Relatório sem informações para visualização, não será gerado ! "
EndIf

Return Nil           

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Cabec     ºAutor  ³Vendas CRM          º Data ³  16/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime o cabecalho do relatorio de DAV                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpO1 - Objeto de impressao                                 º±±
±±º          ³ExpO2 - Objeto da fonte normal                              º±±
±±º          ³ExpO3 - Objeto da fonte negrito                             º±±
±±º          ³ExpN4 - Numero da linha corrente                            º±±
±±º          ³ExpN5 - Quantidade de paginas atual                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR210                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Cabec(	oPrint	, oFontNor	,oFontNeg	, nLin,;
						nPag	, oFontItem)
Local nCol		:= 0 
Local nI		:= 0
Local nLinha    := 0
Local nQtdeL    := 0
Local cTexto	:= ""
Local cImprimeLi:= ""
Local cDAVOS	:= ""	//Retorno das DAV-OS anteriores - - Requisito XLI do Ato Cotepe 0608 para Oficina de Conserto
Local lMvLjDAVOS:= SuperGetMv("MV_LJDAVOS",,.F.)
Local aInfoDAVOS:= {}

If nPag > 0
	oPrint:EndPage() 		//Encerra a pagina atual
EndIf

oPrint:StartPage()
nPag++

//Titulo
oPrint:Box(075,MARGESQ,175,MARGDIR)       

If lMvLjDAVOS
	cTexto := STR0026 //"ORDEM DE SERVIÇO (DAV-OS)"
Else
	cTexto := STR0003 //"DOCUMENTO AUXILIAR DE VENDA - ORCAMENTO"
EndIf

nCol := Centraliza(cTexto,.F.)
oPrint:Say(100,nCol,cTexto,oFontNor)

//Mensagem em destaque
oPrint:Box(175,MARGESQ,350,MARGDIR)
cTexto := STR0004 //"NÃO É DOCUMENTO FISCAL - NÃO É VALIDO COMO RECIBO E COMO GARANTIA DE MERCADORIA"
nCol := Centraliza(cTexto,.T.)
oPrint:Say(200,nCol,cTexto,oFontNeg)
cTexto := "-" + STR0005 //" NÃO COMPROVA PAGAMENTO"
nCol := Centraliza(cTexto,.T.)
oPrint:Say(275,nCol,cTexto,oFontNeg)

//Identificacao do Estabelecimento
oPrint:Box(350,MARGESQ,450,MARGDIR)
cTexto := STR0006 //"Identificacao do Estabelecimento Emitente"
nCol := Centraliza(cTexto,.F.)
oPrint:Say(375,nCol,cTexto,oFontNor)

//Denominacao do cliente
oPrint:Box(450,MARGESQ,550,MARGDIR)
cTexto := STR0007 + SM0->M0_NOMECOM //"Denominação: "
oPrint:Say(475,100,cTexto,oFontNor)
cTexto := "CNPJ: " + Transform(SM0->M0_CGC,"@R! NN.NNN.NNN/NNNN-99")
nCol := (MARGDIR - RetTam(cTexto,.T.))
oPrint:Say(475,nCol,cTexto,oFontNor)

//Identificacao do destinatario
oPrint:Box(550,MARGESQ,700,MARGDIR)   
cTexto := STR0008 //"Identificacao do Destinatário"
//nCol := Centraliza(cTexto,.F.)
oPrint:Say(575,100,cTexto,oFontNor)

//Dados do destinatario
cTexto := STR0009 + SL1->L1_CLIENTE + " - " + SA1->A1_NOME //"Nome: "
oPrint:Say(625,100,cTexto,oFontNor)
cTexto := STR0010 + Transform(SA1->A1_CGC,Iif(RetPessoa(SA1->A1_CGC) == "F","@R 999.999.999-99","@R! NN.NNN.NNN/NNNN-99")) //"CNPJ/CPF: "
nCol := ((MARGDIR - RetTam(cTexto,.T.)) + 90)
oPrint:Say(625,nCol,cTexto,oFontNor)

nLinha := 700        

//Informacao do orcamento
If lMvLjDAVOS    
    AAdd(aInfoDAVOS , "Nr Fabricacao: " + ALLTRIM(PadR(SL1->L1_NUMFAB,TamSX3("L1_NUMFAB")[1]))) //Padr colocado para que caso o conteudo seja somente numérico seu conteudo seja trazido
    AAdd(aInfoDAVOS , "Marca: " + ALLTRIM(SL1->L1_MARCVEI))
    AAdd(aInfoDAVOS , "Modelo: " + ALLTRIM(SL1->L1_MODEVEI))
    AAdd(aInfoDAVOS , "Ano: " + ALLTRIM(Str(SL1->L1_ANOFVEI)))
    AAdd(aInfoDAVOS , "Placa: " + ALLTRIM(SL1->L1_PLACVEI) )
    AAdd(aInfoDAVOS , "Renavam: " + ALLTRIM(PadR(SL1->L1_RNVMVEI,TamSX3("L1_RNVMVEI")[1]))) //Padr colocado para que caso o conteudo seja somente numérico seu conteudo seja trazido
	cTexto	:= "" 
	cImprimeLi:= ""	
    For nI:= 1 to Len(aInfoDAVOS)
    	cTexto += aInfoDAVOS[nI] + "	"
    	
    	If RetTam(cTexto, .F.) > 2000
    		cImprimeLi += cTexto + CHR(10)+CHR(13)
			cTexto	:= ""
			nQtdeL  += 1
		EndIf
    Next
    
	cDAVOS 	 := PesqDAVOS()
    nQtdeL	 += 1
	oPrint:Box(nLinha,MARGESQ,(nQtdeL*60)+725,MARGDIR)
	oPrint:Say(nLinha,100,cImprimeLi,oFontNor)	
	If !Empty(cDAVOS)
		nLinha += 50
		cTexto := STR0027 + ALLTRIM(cDAVOS) // "DAV-OS Origem: "
		oPrint:Say(nLinha,100,cTexto,oFontNor)		
	EndIf
	
	nLinha := (nQtdeL*60)+800
	oPrint:Box(nLinha,MARGESQ,nLinha + 100,MARGDIR)
	
Else
	oPrint:Box(nLinha,MARGESQ,925,MARGDIR)
EndIf

nLinha += 50
cTexto := STR0011 + StrZero(Val(SL1->L1_NUMORC),10) //"Nº do Documento: "
oPrint:Say(nLinha,100,cTexto,oFontNor)
cTexto := STR0012 + "___________________ " //"Nº do Documento Fiscal: 
nCol := (MARGDIR - RetTam(cTexto,.F.))
oPrint:Say(nLinha,nCol,cTexto,oFontNor)

If lMvLjDAVOS
	nLinha += 100
Else
	nLinha := 950	
EndIf	
oPrint:Say(nLinha,PITEM,STR0013	,oFontItem) //"Item"
oPrint:Say(nLinha,PCODI,STR0014	,oFontItem) //"Código"
oPrint:Say(nLinha,PDESC,STR0015	,oFontItem) //"Descrição"
oPrint:Say(nLinha,PQUAN,STR0016	,oFontItem) //"Quant."
oPrint:Say(nLinha,PUNMD,STR0017	,oFontItem) //"U.M."
oPrint:Say(nLinha,PVUNI,STR0018	,oFontItem) //"Vlr.Unit."
oPrint:Say(nLinha,PVDSC,STR0019	,oFontItem) //"Vlr.Desc."
oPrint:Say(nLinha,PVTOT,STR0020	,oFontItem) //"Vlr.Total"

nLin := nLinha + NSALTO

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³RdpFim    ºAutor  ³Vendas CRM          º Data ³  16/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime o rodape do relatorio de DAV                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpO1 - Objeto de impressao                                 º±±
±±º          ³ExpO2 - Objeto da fonte normal                              º±±
±±º          ³ExpO3 - Objeto da fonte negrito                             º±±
±±º          ³ExpN4 - Numero da linha corrente                            º±±
±±º          ³ExpN5 - Quantidade de paginas atual                         º±±
±±º          ³ExpN6 - Totalizador da venda                                º±±
±±º          ³ExpN7 - Totalizador de descontos concedidos                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR210                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RdpFim(	oPrint	, oFontNor	, oFontNeg	, nLin		,;
						nPag	, nTotal	, nDesconto	, nDescNf	,;
						nJurosNf, nFrete 	)	
Local nCol 		:= 0
Local cTexto	:= 0 
Local cPictTot	:= PesqPict("SL1","L1_VLRTOT")
Local nTotFrete	:= 0	
Local nTotLiqui	:= 0	

Default nFrete := 0 //Valor de frete

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o rodape ira caber na pagina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nLin + 375) >= NMAX		
	Cabec(	@oPrint,@oFontNor,@oFontNeg,@nLin,;
			@nPag	) 
EndIf

oPrint:Box(nLin,MARGESQ,nLin+300,MARGDIR)	

nTotFrete := nTotal
	
cTexto:= "B R U T O " + Replicate(".",(88 - Len(AllTrim(Transform(nTotFrete,cPictTot)))))		
oPrint:Say(nLin+25,100,cTexto,oFontNor)
cTexto := AllTrim(Transform(nTotFrete,cPictTot))	
nCol := (MARGDIR - RetTam(cTexto,.T.))
oPrint:Say(nLin+25,nCol,cTexto,oFontNor)

cTexto := "D E S C O N T O " + Replicate(".",(80 - Len(AllTrim(Transform(nDescNf,cPictTot)))))
oPrint:Say(nLin+75,100,cTexto,oFontNor)
cTexto := AllTrim(Transform(nDescNf,cPictTot))
nCol := ((MARGDIR - RetTam(cTexto,.T.))-22)
oPrint:Say(nLin+75,nCol,cTexto,oFontNor)

cTexto := "J U R O S " + Replicate(".",(87 - Len(AllTrim(Transform(nJurosNf,cPictTot)))))
oPrint:Say(nLin+125,100,cTexto,oFontNor)
cTexto := AllTrim(Transform(nJurosNf,cPictTot))
nCol := ((MARGDIR - RetTam(cTexto,.T.))-10)
oPrint:Say(nLin+125,nCol,cTexto,oFontNor)

cTexto := "A C R E S C I M O " + Replicate(".",(80 - Len(AllTrim(Transform(nFrete,cPictTot)))))
oPrint:Say(nLin+175,100,cTexto,oFontNor)
cTexto := AllTrim(Transform(nFrete,cPictTot))
nCol := ((MARGDIR - RetTam(cTexto,.T.))-10)
oPrint:Say(nLin+175,nCol,cTexto,oFontNor)

nTotLiq := ((nTotal + nJurosNf) - nDescNf) + nFrete
 	
cTexto := "L I Q U I D O " + Replicate(".",(84 - Len(AllTrim(Transform(nTotLiq,cPictTot)))))	
oPrint:Say(nLin+225,100,cTexto,oFontNor)
cTexto := AllTrim(Transform(nTotLiq,cPictTot))		
nCol := (MARGDIR - RetTam(cTexto,.T.))
oPrint:Say(nLin+225,nCol,cTexto,oFontNor)


oPrint:Box(nLin+350,MARGESQ,nLin+375,MARGDIR)	
cTexto := STR0021 //"E vedada a autenticacao deste documento"
nCol := Centraliza(cTexto,.F.)
oPrint:Say(nLin+375,nCol,cTexto,oFontNor)	

nLin += 375 + NSALTO	

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³CentralizaºAutor  ³Vendas CRM          º Data ³  16/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para calculo da posicao inicial de impressao de uma  º±±
±±º          ³string, a partir de seu tamanho e fonte.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpC1 - Texto a ser impresso                                º±±
±±º          ³ExpL2 - Indica se o texto sera impresso em negrito          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR210                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Centraliza(cTexto,lNegrito)
Return (CENTRO - (RetTam(cTexto,lNegrito)/2))

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³RetTam    ºAutor  ³Vendas CRM          º Data ³  16/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para calculo da posicao inicial de impressao de uma  º±±
±±º          ³string, a partir de seu tamanho e fonte.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpC1 - Texto a ser impresso                                º±±
±±º          ³ExpL2 - Indica se o texto sera impresso em negrito          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR210                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetTam(cTexto,lNegrito)
Local nTamCarac := Iif(lNegrito,26,22)
Return (Len(cTexto)*nTamCarac)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ImpRelECF ºAutor  ³Vendas CRM          º Data ³  03/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do relatorio DAV via ECF(Relatorio Gerencial)     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR210                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpRelECF()
Local cTexto 		:= ""								// Texto de impressao
Local cLinha    	:= ""								// Conteudo da Linha
Local cEOL      	:= Chr(13) + Chr(10)				// Caracter de controle para pular linha
Local cDAVOS		:= ""  								//Retorno das DAV-OS anteriores - - Requisito XLI do Ato Cotepe 0608 para Oficina de Conserto
Local cPictQuant	:= PesqPict("SL2","L2_QUANT")		// Picture da quantidade
Local cPictVrTot	:= PesqPict("SL2","L2_VLRITEM")		// Picture do valor do item
Local cPictTot		:= PesqPict("SL1","L1_VLRTOT")		// Picture do valor total
Local cPictVrUni	:= PesqPict("SL2","L2_VRUNIT")		// Picture do valor unitario
Local nTotal		:= 0								// Acumulador do total
Local nDesconto		:= 0								// Acumulador de descontos
Local nDescNf		:= 0								// Desconto sobre o documento
Local cDoc			:= Space(TamSx3("L1_DOC")[1])		// Numero do COO utilizado na impressão da DAV por ECF
Local cImpressora	:= LJGetStation("IMPFISC")
Local cPorta		:= LJGetStation("PORTIF")
Local lRet			:= .T.
Local lAbriuECF		:= .F.								// Sinaliza se abriu a comunicação com o ECF para finalizar
Local lCancelado	:= .F. 
Local lMvLjDAVOS	:= SuperGetMv("MV_LJDAVOS",,.F.)
Local aDav			:= {}								// Linhas para impressão customizada
Local nX			:= 0								// Controle Loop for
Local nQtdeProd		:= 0
Local lIsPafNfce 	:= ExistFunc("LjTipoPAF") .AND. LjTipoPAF() == "1" .OR. SuperGetMv("MV_PAFNFCE",,.F.) //MV_PAFNFCE - utlizado somente no ambiente interno para que o sistema simule ambiente  PAF-NFC-e SC.
Local lPOS 			:= STFIsPOS() 						//É Totvs PDV ?

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre comunicacao com o ECF ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlECF == -1
	cImpressora	:= LJGetStation("IMPFISC")
	cPorta		:= LJGetStation("PORTIF")
	
	If cImpressora == "BEMATECH MP20FI"
		cImpressora := "BEMATECH MP20FI II" 
	EndIf

	IF lIsPafNfce
		LjMsgRun( STR0036,, { || nHdlECF := INFAbrir( cImpressora,cPorta ) } )  //"Aguarde. Abrindo a Impressora Não Fiscal..."
	Else
		LjMsgRun( STR0024,, { || nHdlECF := IFAbrir( cImpressora,cPorta ) } )  //"Aguarde. Abrindo a Impressora Fiscal..."
	Endif 
		               
	//Verifica se estabeleceu conexão com o ECF
	If nHdlECF == -1
		lRet 		:= .F.
		Alert(STR0034) //"Sem comunicação com o ECF. Verifique!"
	Else
		lAbriuECF	:= .T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos itens orcados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := lRet .And. IFVenda(,.T.)

If lRet
	//Considera os registros deletados
	SET DELETED OFF
	DbSelectArea("SL2")
	SL2->(DbSetOrder(1)) //L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO     
	SL2->(DbSeek(xFilial("SL2")+SL1->L1_NUM))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao do Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//Identificacao do Relatorio Gerencial	
	cTexto += "DAV" + cEOL
	
	//Titulo
	If lMvLjDAVOS
		cTexto += STR0026 //"ORDEM DE SERVIÇO (DAV-OS)"
	Else
		cTexto += STR0003 //"DOCUMENTO AUXILIAR DE VENDA - ORCAMENTO"
	EndIf
	
	cTexto += " " + cEOL //Pula linha
	//Mensagem em destaque
	cLinha := STR0004  //"NÃO É DOCUMENTO FISCAL - NÃO É VALIDO COMO RECIBO E COMO GARANTIA DE MERCADORIA"
	cTexto += RemoveAcento(cLinha) + cEOL
	
	cLinha := "-" + STR0005  //" NÃO COMPROVA PAGAMENTO"
	cTexto += RemoveAcento(cLinha) + cEOL
	
	cTexto += " " + cEOL //Pula linha
	//Identificacao do Estabelecimento
	cLinha := STR0006 //"Identificacao do Estabelecimento Emitente"
	cTexto += RemoveAcento(cLinha) + cEOL
	
	//Denominacao do cliente
	cLinha := STR0007 + SM0->M0_NOMECOM //"Denominação: "
	cTexto += RemoveAcento(cLinha) + cEOL
	
	cLinha := "CNPJ: " + Transform(SM0->M0_CGC,"@R! NN.NNN.NNN/NNNN-99")
	cTexto += RemoveAcento(cLinha) + cEOL
	
	/////////////////////////
	//Identificacao do destinatario
	cLinha := STR0008 //"Identificacao do Destinatário"
	cTexto += RemoveAcento(cLinha) + cEOL
	
	//Dados do destinatario
	cLinha := STR0009 + SL1->L1_CLIENTE + " - " + SA1->A1_NOME //"Nome: "
	cTexto += RemoveAcento(cLinha) + cEOL
	
	cLinha := STR0010 + Transform(SA1->A1_CGC,Iif(RetPessoa(SA1->A1_CGC) == "F","@R 999.999.999-99","@R! NN.NNN.NNN/NNNN-99")) //"CNPJ/CPF: "
	cTexto += RemoveAcento(cLinha) + cEOL

	//DAV-OS
	If lMvLjDAVOS

		cTexto += "Nr Fabricacao: " + ALLTRIM(SL1->L1_NUMFAB) + cEOL 
		cTexto += "Marca: " + ALLTRIM(SL1->L1_MARCVEI) + cEOL 
		cTexto += "Modelo: " + ALLTRIM(SL1->L1_MODEVEI) + cEOL 
		cTexto += "Ano: " + ALLTRIM(SL1->L1_ANOFVEI) + cEOL 
		cTexto += "Placa: " + ALLTRIM(SL1->L1_PLACVEI) + cEOL 
		cTexto += "Renavam: " + ALLTRIM(SL1->L1_RNVMVEI) + cEOL 	

		cDAVOS := PesqDAVOS() 
		If !Empty(cDAVOS)
			cTexto += STR0027 + ALLTRIM(cDAVOS) + cEOL   //"DAV-OS Origem: "
		EndIf      				
	EndIf
	
	//Informaão do orçamento
	cLinha := STR0011 + StrZero(Val(SL1->L1_NUMORC),10) + "  " //"Nº do Documento: "
	cTexto += RemoveAcento(cLinha) + cEOL   
	
	cLinha := STR0012 //"Nº do Documento Fiscal: 
	cTexto += RemoveAcento(cLinha) + "______________" + cEOL
	          
	//Cabecalhos dos itens
	cLinha := Upper(RemoveAcento(STR0013)) + " " + Upper(RemoveAcento(STR0014)) + "      " + Upper(RemoveAcento(STR0015)) // Item Código      Descricao
	cTexto += RemoveAcento(cLinha) + cEOL
	
	cLinha := "QTDE." + "  " + "UN." + "    " + "VL.UNIT." + "    " + "VL.DESC." + "     " + "VL.TOTAL" //QTD. UN. Vlr.Unit. Vlr.Desc.  Vlr.Total        
	cTexto += RemoveAcento(cLinha) + cEOL
	 
	While !SL2->(Eof()) .AND. (SL2->(L2_FILIAL+L2_NUM) == xFilial("SL2")+SL1->L1_NUM)

		If lIsPafNfce .Or. ( !Empty(SL2->L2_PAFMD5) .AND. ( Empty(SL2->L2_CONTDOC) .OR. (!Empty(SL2->L2_CONTDOC) .AND. !Empty(SL2->L2_NUMORIG)) ) )
			lCancelado	:= (SL2->L2_VENDIDO == "N")
	
		    //ITEM CODIGO DECRICAO
			cLinha := SubStr(AllTrim(SL2->L2_ITEM) + SPACE(5),1,5)
			cLinha += SubStr(AllTrim(SL2->L2_PRODUTO) + SPACE(14),1,14)   
			cLinha += SubStr(AllTrim(SL2->L2_DESCRI),1,20)
			
			If lCancelado 
				cLinha += " [CANCELADO]"
			EndIf
			
			cTexto += RemoveAcento(cLinha) + cEOL
			
			cLinha := AllTrim(Transform(SL2->L2_QUANT,		cPictQuant))
			cLinha += "  " + AllTrim(SL2->L2_UM) + SPACE(4)
			cLinha += "  " + AllTrim(Transform(SL2->L2_VRUNIT,		cPictVrUni)) + SPACE(3)
			cLinha += "  " + AllTrim(Transform(SL2->L2_VALDESC, 	cPictVrTot)) + SPACE(8)
			cLinha += "  " + AllTrim(Transform(SL2->L2_VLRITEM	,	cPictVrTot))
		
			cTexto += RemoveAcento(cLinha) + cEOL		
			
			//Incrementa acumuladores
			If !lCancelado			
				nTotal 	+= SL2->L2_VLRITEM
				nDesconto	+= SL2->L2_VALDESC
			EndIf
			
			nQtdeProd++
		EndIf
		SL2->(DbSkip())
	End

	//Desconsidera os registros deletados
	SET DELETED ON
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variavel com o desconto do documento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDescNf := SL1->L1_DESCONT
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao do rodape com totalizadores³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLinha := "Total...:" + Transform(nTotal + SL1->L1_JUROS,cPictTot)
	cTexto += RemoveAcento(cLinha) + cEOL
	
	cLinha := "Desconto:" + Transform(nDescNf,cPictTot) 
	cTexto += RemoveAcento(cLinha) + cEOL
	
	cLinha := "Liquido.:" + Transform((nTotal - nDescNf),cPictTot)
	cTexto += RemoveAcento(cLinha) + cEOL
	
	cLinha := STR0021 //"É vedada a autenticação deste documento"
	cTexto += RemoveAcento(cLinha) + cEOL
	
	//PE para customizar impressao DAV
	If ExistBlock("LJR210DAV") //	  		
		aDav := ExecBlock( "LJR210DAV", .F., .F. )
		
	  	If ValType(aDav) == "A"
	  			
			For nX := 1 to Len(aDav)
				cLinha := aDav[nX]
				cTexto += RemoveAcento(cLinha) + cEOL				
			Next nX	
			
		Else 
			MsgStop(STR0029)	//"Ponto de Entrada LJR210DAV compilado de forma indevida. Retorno esperado:Array."
		EndIf
	EndIf
	
	If nQtdeProd > 0 
		//³Realiza impressao³
		If lIsPafNfce
			If lPOS
				STWPrintTextNotFiscal(cTexto)
			Else
				INFTexto(cTexto)
			EndIf
		Else
			STBImpItMF( "ImpRelECF" , cTexto, 1 , .F.)
		 
			//³Atualiza L1_COODAV conforme previsto na Legislação do PAF-ECF ³
			IfPegCupom( nHdlECF, @cDoc ) 
							
			//Quando PDVPAF, DAV é gerado na retaguarda, atualiza L1_COODAV também na retaguarda
			//Durante o processo de homologação o DAV é impresso no PDV e deve-se atualizar na retaguarda a impressão do mesmo.
			If LjHomolPaf() .AND. !Empty(SL1->L1_NUMORIG) .AND. LjxBGetPaf()[2]
				FR271CMyCall( "LjxCooDav", {"SL1"}, SL1->L1_NUMORIG, cDoc )
			EndIf

			//Atualiza L1_COODAV para evitar reimpressão
			LjxCooDav(SL1->L1_NUM, cDoc)
		Endif 
	Else
		MsgAlert(STR0035) //"Relatório sem informações, não será impresso ! "
	EndIf
	        
	//Se abriu comunicacao com ECF no momento da impressao da DAV, finaliza a comunicacao apos impressao
	If lAbriuECF
		LjMsgRun( STR0025,, { || IFFechar( nHdlECF, cPorta ) } )  //"Aguarde. Fechando a Impressora Fiscal..."
		nHdlECF := -1 //Deve-se receber -1 pois ao imprimir um cupom no ECF, o próximo não estava sendo impresso 
	EndIf
EndIf
	
Return Nil           

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³RemoveAcento ºAutor  ³Vendas CRM       º Data ³  03/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Remove acentos/caracteres especiais nao suportados pelo ECF º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR210                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RemoveAcento(cString)
Local nX        := 0 
Local nY        := 0 
Local cSubStr   := ""
Local cRetorno  := ""

Local cStrEsp	:= "ÁÃÂÀáàâãÓÕÔóôõÇçÉÊéêº"  
Local cStrEqu   := "AAAAaaaaOOOoooCcEEeer" //char equivalente ao char especial

For nX:= 1 To Len(cString)
	cSubStr := SubStr(cString,nX,1)
	nY := At(cSubStr,cStrEsp)
	If nY > 0 
		cSubStr := SubStr(cStrEqu,nY,1)
	EndIf
    
	cRetorno += cSubStr
Next nX

Return cRetorno
                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PesqDAVOSºAutor  	³	Vendas CRM       º Data ³  26/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Remove acentos/caracteres especiais nao suportados pelo ECF º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR210                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function PesqDAVOS()
Local cAlias	   := "SL1"
Local cNumDAVOS	   := SL1->L1_DVOSORI
Local cFilial	   := SL1->L1_FILIAL
Local cIndex	   := ""
Local cChave	   := ""
Local cDAVOSAux    := ""
Local cQuery	   := ""
Local cTexto	   := ""
Local nRegSL1Atual := 0
Local nI		   := 0

cDAVOSAux	 := AllTrim(cNumDAVOS)
nRegSL1Atual := SL1->(RecNo())

While !(cDAVOSAux == "")
	#IFDEF TOP
		cAlias := "SL1TMP"
	
		If Select(cAlias) > 0
			(cAlias)->(DbCloseArea())
		EndIf
	
		cQuery	:= " SELECT L1_DVOSORI,L1_NUMORC "	
		cQuery	+= " FROM " + RetSqlName("SL1") + " SL1 "
		cQuery	+= " WHERE "
		cQuery	+= " SL1.D_E_L_E_T_  = ''  AND SL1.L1_FILIAL ='" + cFilial + "' "
		cQuery	+= " AND SL1.L1_NUMORC = '" + cNumDAVOS + "' "	
		cQuery := ChangeQuery( cQuery )
		DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)	
	#ELSE
		DbSelectArea("SL1")
		cIndex	:= CriaTrab(Nil,.F.)
		cChave	:= "L1_FILIAL+L1_NUMORC"
		IndRegua("SL1",cIndex,cChave,,,"Selecionando Registros...") //"Selecionando Registros..."
		DbSelectArea("SL1")
		nIndex  := RetIndex("SL1")
	    SL1->(DbSetIndex( cIndex + OrdBagExt() ))
		SL1->(DbSetOrder( nIndex + 1 ))
		SL1->(DbSeek(cFilial+cNumDAVOS))
	#ENDIF

	cNumDAVOS := (cAlias)->L1_DVOSORI
	cDAVOSAux := AllTrim(cNumDAVOS)
	cTexto	  += (cAlias)->L1_NUMORC + ","
EndDo

#IFDEF TOP
	(cAlias)->(DbCloseArea())
#ELSE
	If !Empty(cIndex)
		Ferase(cIndex+OrdBagExt())
	EndIf
#ENDIF

DbSelectArea("SL1")
SL1->(DbGoTo(nRegSL1Atual))
cTexto := Subs(cTexto,1,Len(cTexto)-1) //Corta a ultima vírgula

Return cTexto


//--------------------------------------------------------
/*/{Protheus.doc} LojRQuebraLinha
Impressão de Descrição do Produto a partir do objeto oPrint
@param   	oPrint - objeto Print
@param   	nLin - Linha corrente vinculado ao objeto oPrint
@param   	oFontItem - fonte de texto para impressão
@param		cTexto	- o texto da descrição
@param		nTam - tamanho máximo de caracteres por linha
@author  	Varejo
@version 	P12.1
@since   	23/02/2017
@sample
/*/
//-------------------------------------------------------- 
Static Function LojRQuebraLinha(oPrint, nLin, oFontItem, cTexto, nTam)

Local nPos := 0			//Posição do campo
Local cAux := ""		//Auxiliar

cTexto	:= Alltrim(cTexto)
cAux 	:= Alltrim(cTexto)
While !Empty(cTexto)

	//Verifico a última posição do espaço entre palavras
	If Len(cTexto) > nTam
		nPos := RAt(" ", Left(cTexto,nTam))
	Else
		nPos := 0
	EndIf

	//Aplico a quebra de linha
	If nPos <= 1
		cAux := cTexto
		cTexto := ""
	Else
		cAux := Left(cTexto, nPos-1)
		cTexto := Alltrim(Substr(cTexto,nPos))
	EndIf
	
	//Efetuo a impressão da descrição do produto
	oPrint:Say(nLin,PDESC,cAux + IIf(nPos > 0,CRLF,""),oFontItem)
	nLin += IIf(nPos > 0,NSALTO,0)
EndDo

Return nil
