#INCLUDE "MSOLE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "LOJR081.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ LojR081	³ Autora³ Vendas Clientes 		³ Data ³ 11.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emitir Etiquetas para Mala Direta de Cliente, Produto	  ³±±
±±³          ³ e Fornecedor  											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ LojR081(  ) 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nao tem													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function LojR081()
Local oDlgEtiq											// Objeto da janela para escolha do tipo de etiqueta
Local aArqs	:= {}										// Array com os arquivos disponiveis para emissao de etiqueta
Local nList := 1										// Escolha do tipo de arquivo, da listbox
Local oList												// Objeto ListBox
Local hWord												// Objeto OLE para integracao com o Word

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Release 11.5 - SmartClient HTML³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FindFunction ("LjChkHtml")
	If LjChkHtml()
		FwAvisoHtml()
		Return
	EndIf
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona conteudo no array aArqs que serah utilizado na ListBox³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aArqs, STR0003 )	// Fornecedor
Aadd( aArqs, STR0004 )	// Cliente
Aadd( aArqs, STR0005 )	// Produto

DEFINE MSDIALOG oDlgEtiq FROM 39,85 TO 165,300 TITLE OemToAnsi(STR0001) PIXEL OF STYLE DS_MODALFRAME  		//"Etiquetas para Mala Direta"
@ 003, 010 TO 45, 95 LABEL STR0006 OF oDlgEtiq PIXEL  														//"Arquivos"
@ 013, 015 LISTBOX oList VAR nList ITEMS aArqs SIZE 75,30 OF oDlgEtiq PIXEL
	
DEFINE SBUTTON FROM 48,34 TYPE 1 ENABLE OF oDlgEtiq ACTION ( LjR081Perg( nList, @hWord ) )					// Botao de confirmacao
DEFINE SBUTTON FROM 48,67 TYPE 2 ENABLE OF oDlgEtiq ACTION ( ( LOJR081Can( @hWord ), oDlgEtiq:End() ) )	// Botao para Cancelamento
ACTIVATE MSDIALOG oDlgEtiq CENTERED

Return Nil
          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJR081PERGºAutora ³Vendas Clientes     º Data ³  11/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Chama as perguntes e a função de impressão das etiquetas 	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       |Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LjR081Perg( nOpt, hWord )
Local cFunction    	:= ""			    			//Funcao principal
Local cPerg        	:= ""			  				//Perguntas relacionadas 
Local cTitle       	:= ""							//Titulo
Local cDescription 	:= ""							//Descricao da funcao
Local bProcess     	:= NIL							//Processamento a ser realizado
Local aInfoCustom  	:= {}							//Array com informacoes auxiliares
Local cString		:= ""							//Alias a ser utilizado	
Local lConfirma		:= .F.							//Informa se o usuário confirmou ou cancelou a tela
Local cCadastro 	:= STR0007						//Titulo da janela  //"Impressão de etiquetas"
Local aSays			:= {} 							//Descritivo da janela
Local aButtons 		:= {}					 		//Botoes que irao aparecer na janela 
Local lR1_1		    := GetRPORelease() >= "R1.1" // Verifica se o Release e superior ao R1.1  do Protheus 10
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama o pergunte para alimentar as variaveis de trabalho                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpt == 1 
	cString := "SA2"
	cPerg := "LJR82W" // Etiquetas de Fornecedores
ElseIf nOpt == 2 
	cString := "SA1"
	cPerg := "LJR81W"	// Etiquetas de Clientes
ElseIf nOpt == 3 
	cString := "SB1"
	cPerg := "LJR80W"  // Etiquetas de Produtos
EndIf                                 

If lR1_1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Alimentando as variaveis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFunction    := "LjR081Perg"
	cTitle       := STR0007
	cDescription := STR0002
	bProcess     := { |ExpO1| LjR081Imp( nOpt, cString, @hWord, ExpO1 ) }
	aInfoCustom  := {}
	
	tNewProcess():New(cFunction,cTitle,bProcess,cDescription,cPerg,aInfoCustom )
Else
	Pergunte( cPerg, .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a interface com o usuario                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd( aSays, STR0002 ) //"Este programa tem o objetivo de imprimir as etiquetas com os números de chamada "
	
	Aadd(aButtons, { 5, .T., { || Pergunte(cPerg,.T.) }})					// Chama a funcao Pergunte
	Aadd(aButtons, { 1, .T., { || (lConfirma:=.T.,FechaBatch()) }})		// Confirma a tela
	Aadd(aButtons, { 2, .T., { || (lConfirma:=.F.,FechaBatch()) }})		// Cancela a tela
	
	FormBatch(cCadastro, aSays, aButtons)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se houve confirmacao do processamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lConfirma
		Processa( { |lEnd| LjR081Imp( nOpt, cString, @hWord ) } )
	Endif
EndIf
	
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjR081Imp ºAutor  ³Vendas Clientes     º Data ³  12/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz o processamento do relatorio                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJR081                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LjR081Imp(nOpt, cString, hWord, ExpO1)
Local cCampo 			:= ""										// Nome do campo para criar o DOCVARIABLE no documento word
Local nColunas 			:= 5				 						// Numero de colunas da tabela
Local nLabelWidth 		:= 5				 						// Comprimento da etiqueta (em centimetros)
Local nLabelHeight 		:= 8										// Altura (em centimetros) da etiqueta
Local nLeftMargin 		:= 1										// Margem esquerda da pagina
Local nRightMargin 		:= 0.45				   						// Margem direita da pagina
Local nBottomMargin 	:= 0				   						// Margem inferior da pagina
Local nTopMargin 		:= 1.07				   						// Margem do topo da pagina
Local nEtiquetaInicial 	:= 1										// Numero da etiqueta que comecara a impressao
Local cArqTrb			:= ""										// Nome do arquivo de trabalho
Local nNumEtiquetas		:= 0					   					// Quantidade de etiquetas
Local cArqDot 			:= "LOJR081.DOT"							// Nome do arquivo modelo do Word (Tem que ser .DOT)
Local cPathDot 			:= Alltrim(GetMv("MV_DIRACA")) + cArqDot	// Path do arquivo modelo do Word
Local cPathEst			:= cPathEst:= Alltrim(GetMv("MV_DIREST")) 	// PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO
Local nRelatorio		:= 0										// Tipo do relatorio 
Local lR1_1		    	:= GetRPORelease() >= "R1.1" // Verifica se o Release e superior ao R1.1  do Protheus 10
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as variaveis conforme os parametros                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nColunas			:= MV_PAR03
nLabelWidth			:= MV_PAR04
nLabelHeight		:= MV_PAR05
nLeftMargin			:= MV_PAR06
nRightMargin		:= MV_PAR07
nBottomMargin		:= MV_PAR08
nTopMargin			:= MV_PAR09
nEtiquetaInicial	:= MV_PAR10

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia do DOT no ROOTPATH Protheus / Servidor ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File(cPathDot)
	MsgStop(STR0008 + cArqDot + STR0009) //"Atenção... "###" não encontrado no servidor"
Else

	If lR1_1
		ExpO1:SetRegua1(8)
		ExpO1:IncRegua1(STR0017)		//"Emitindo etiqueta para mala direta"
		ExpO1:SetRegua2(4)
		ExpO1:IncRegua2(STR0018)		//"Processamento do relatório"
		Sleep(2000)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o arquivo de trabalho                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTrb := CriaTrab( , .F. )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso exista link de comunicacao com o Word, este deve ser fechado     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType( hWord ) <> "U"
		If !Empty( hWord ) .AND. hWord <> "-1"
			OLE_CloseFile( hWord )
			OLE_CloseLink( hWord )
		EndIf
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criando link de comunicacao com o word                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	hWord := OLE_CreateLink()
	OLE_SetProperty ( hWord, oleWdVisible, .T.) //VISUALIZAR O DOT
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o diretorio local para copiar o documento Word                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MontaDir(cPathEst)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso encontre arquivo ja gerado na estacao                           ³
	//³ com o mesmo nome apaga primeiramente antes de gerar a nova impressao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If File( cPathEst + cArqDot )
		Ferase( cPathEst + cArqDot )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Copia do Server para o Remote, eh necessario                                    ³
	//³ para que o wordview e o proprio word possam preparar o arquivo para impressao e ³
	//³ ou visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da   ³
	//³ estacao , por exemplo C:\WORDTMP                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CpyS2T(cPathDot,cPathEst,.T.) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando novo documento do Word na estacao                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_NewFile( hWord, cPathEst + cArqDot)

	OLE_SetProperty( hWord, oleWdVisible, .F. )
	OLE_SetProperty( hWord, oleWdPrintBack, .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia o conteudo das etiquetas                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nNumEtiquetas := nEtiquetaInicial-1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera etiquetas para o cadastro de clientes³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cString == "SA1"
		nRelatorio := 1
		DbSelectarea( "SA1" )
		If !lR1_1
			ProcRegua( Reccount() )
		Endif
		
		DbSetOrder( 1 )
		DbSeek( xFilial( "SA1" ) + MV_PAR01, .T. )
		If lR1_1
			ExpO1:IncRegua1(STR0017)		//"Emitindo etiqueta para mala direta"
			ExpO1:SetRegua2(2)
			ExpO1:IncRegua2(STR0019)		//"Iniciando processamento das etiquetas para o cadastro de clientes"
			Sleep(2000)             
		EndIf
		While !Eof() .AND. SA1->A1_FILIAL + SA1->A1_COD <= xFilial( cString ) + MV_PAR02
			If !lR1_1
				IncProc(STR0028)	//"Processando ..." 
			EndIf
			nNumEtiquetas++
			
			cCampo := "Adv_Cod" + Alltrim(Str(nNumEtiquetas,9,0))
			OLE_SetDocumentVar( hWord, cCampo, Alltrim( SA1->A1_COD ) )
    	
			cCampo := "Adv_Nome" + Alltrim(Str(nNumEtiquetas,9,0))  	
			OLE_SetDocumentVar( hWord, cCampo, Alltrim( SA1->A1_NOME ) )

			cCampo := "Adv_End" + Alltrim(Str(nNumEtiquetas,9,0))  	
			OLE_SetDocumentVar( hWord, cCampo, SA1->A1_END )

			cCampo := "Adv_Com" + Alltrim(Str(nNumEtiquetas,9,0))
			OLE_SetDocumentVar( hWord, cCampo, SA1->A1_BAIRRO + " " + SA1->A1_MUN + " " + SA1->A1_EST )
		
			cCampo := "Adv_Cep" + Alltrim(Str(nNumEtiquetas,9,0))
			OLE_SetDocumentVar( hWord, cCampo, STR0010 + Subst( SA1->A1_CEP,1,5 ) + "-" + Substr( SA1->A1_CEP,6,3 ) )
		
			SA1->( DbSkip() )
		End
		If lR1_1
			ExpO1:IncRegua2(STR0020)		//"Terminando processamento das etiquetas para o cadastro de clientes"
			Sleep(2000)		
		EndIf	
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera etiquetas para o cadastro de fornecedores ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cString == "SA2"
		nRelatorio := 2
		DbSelectarea( "SA2" )
		If !lR1_1
			ProcRegua( Reccount() )
		EndIf
		DbSetOrder( 1 )
		DbSeek( xFilial( "SA2" ) + MV_PAR01, .T. )
		If lR1_1
			ExpO1:IncRegua1(STR0017)		//"Emitindo etiqueta para mala direta"
			ExpO1:SetRegua2(2)
			ExpO1:IncRegua2(STR0021)		//"Iniciando processamento das etiquetas para o cadastro de fornecedores"
			Sleep(2000)		        
		EndIf
		While !Eof() .AND. SA2->A2_FILIAL + SA2->A2_COD <= xFilial(cString) + MV_PAR02
			If !lR1_1
				IncProc(STR0028)	//"Processando ..." 
			EndIf
			
			nNumEtiquetas++
			
			cCampo := "Adv_Cod" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, Alltrim( SA2->A2_COD ) )
    	
			cCampo := "Adv_Nome" + Alltrim( Str( nNumEtiquetas,9,0 ) )  	
			OLE_SetDocumentVar( hWord, cCampo, Alltrim( SA2->A2_NOME ) )

			cCampo := "Adv_End" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, SA2->A2_END )

			cCampo := "Adv_Com" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, SA2->A2_BAIRRO + " " + SA2->A2_MUN + " " + SA2->A2_EST )
		
			cCampo := "Adv_Cep" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, STR0010 + Subst( SA2->A2_CEP,1,5 ) + "-" + Substr( SA2->A2_CEP,6,3 ) )
		
			SA2->( DbSkip() )
		End
		If lR1_1
			ExpO1:IncRegua2(STR0022)		//"Terminando processamento das etiquetas para o cadastro de fornecedores"
			Sleep(2000)
		EndIf	
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera etiquetas para o cadastro de produtos  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cString == "SB1"
		nRelatorio := 3
		DbSelectarea("SB1")
		If !lR1_1
			ProcRegua( Reccount() )
		EndIf

		DbSetOrder( 1 )
		DbSeek( xFilial( "SB1" ) + MV_PAR01, .T. )
		If lR1_1
			ExpO1:IncRegua1(STR0017)		//"Emitindo etiqueta para mala direta"
			ExpO1:SetRegua2(2)
			ExpO1:IncRegua2(STR0023)		//"Iniciando processamento das etiquetas para o cadastro de produtos"
			Sleep(2000)		        
		EndIf
		While !Eof() .AND. SB1->B1_FILIAL + SB1->B1_COD <= xFilial( cString ) + MV_PAR02
			If !lR1_1
				IncProc(STR0028)	//"Processando ..." 
			EndIf
			
			nNumEtiquetas++
			
			cCampo := "Adv_Cod" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, STR0011 + Alltrim( SB1->B1_COD ) )
    	
			cCampo := "Adv_Desc" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, STR0012 + Alltrim( SB1->B1_DESC ) )

			cCampo := "Adv_Tipo" + Alltrim( Str( nNumEtiquetas,9,0 ) )  	
			OLE_SetDocumentVar( hWord, cCampo, STR0013 + Alltrim( SB1->B1_TIPO ) )

			cCampo := "Adv_Grupo" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, STR0014 + SB1->B1_GRUPO )
		
			cCampo := "Adv_Un" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, STR0015 + SB1->B1_UM )
		
			cCampo := "Adv_Peso" + Alltrim( Str( nNumEtiquetas,9,0 ) )
			OLE_SetDocumentVar( hWord, cCampo, STR0016 + Alltrim( Transform( SB1->B1_PESO,"@E 999,999.9999" ) ) )
		
			SB1->( DbSkip() )
		End	
		If lR1_1
			ExpO1:IncRegua2(STR0024)		//"Terminando processamento das etiquetas para o cadastro de produtos"
			Sleep(2000)				
		EndIf
	EndIf

	If lR1_1
		ExpO1:IncRegua2(STR0025)			//"Enviando parametros de configuracao da pagina"
		Sleep(2000)	
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia os parametros de configuracao da pagina                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_SetDocumentVar( hWord, "nLinhas"			, StrTran(Str(Int(nNumEtiquetas/nColunas)+1),",",",")  )
	OLE_SetDocumentVar( hWord, "nColunas"			, StrTran(Str(nColunas),",",",")  )
	OLE_SetDocumentVar( hWord, "nLabelWidth"		, StrTran(Str(nLabelWidth),",",",")  )
	OLE_SetDocumentVar( hWord, "nLabelHeight"		, StrTran(Str(nLabelHeight),",",",")  )
	OLE_SetDocumentVar( hWord, "nLeftMargin"		, StrTran(Str(nLeftMargin),",",",")  )
	OLE_SetDocumentVar( hWord, "nRightMargin"		, StrTran(Str(nRightMargin),",",",")  )
	OLE_SetDocumentVar( hWord, "nBottomMargin"		, StrTran(Str(nBottomMargin),",",",")  )
	OLE_SetDocumentVar( hWord, "nTopMargin"			, StrTran(Str(nTopMargin),",",",")  )
	OLE_SetDocumentVar( hWord, "nEtiquetaInicial"	, StrTran(Str(nEtiquetaInicial),",",",")  )
	OLE_SetDocumentVar( hWord, "nNumEtiquetas"		, StrTran(Str(nNumEtiquetas),",",",")  )
	OLE_SetDocumentVar( hWord, "nRelatorio"			, StrTran(Str(nRelatorio),",",",")  )
	If lR1_1
		ExpO1:IncRegua2(STR0026)		//"Executando a macro do Word"
		Sleep(2000)
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa macro do Word                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_ExecuteMacro( hWord, "LOJR081" )
	If lR1_1
		ExpO1:IncRegua2(STR0027)		//"Atualizando variaveis do documento"
		Sleep(2000)		
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizando variaveis do documento                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_UpdateFields( hWord )
	
	OLE_SetProperty( hWord, oleWdVisible, .T. )	
	OLE_SetProperty( hWord, oleWdWindowState, "MAX" )
EndIf

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJR081CanºAutor  ³Vendas Clientes     º Data ³  10/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fecha arquivo do Word e o link de comunicacao               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR081                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LOJR081Can( hWord )

If ValType( hWord ) <> "U"
	If !Empty( hWord ) .AND. hWord <> "-1"
		OLE_CloseFile( hWord )
		OLE_CloseLink( hWord )
	EndIf
Endif

Return(.T.)


