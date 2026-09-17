#INCLUDE "PROTHEUS.CH"
#INCLUDE "LOJR075.CH"
#INCLUDE "REPORT.CH"

#DEFINE TAM_NFISC	55			//Tamanho da Coluna "Numero da Nota Fiscal"
#DEFINE TAM_SERIE	03			//Tamanho da Coluna "Serie"
#DEFINE TAM_CODVEN	08			//Tamanho da Coluna "Codigo do Vendedor"
#DEFINE TAM_NOMVEN	20			//Tamanho da Coluna "Nome do Vendedor"
#DEFINE TAM_CODCLI	08			//Tamanho da Coluna "Codigo do Cliente"
#DEFINE TAM_NOMCLI	20			//Tamanho da Coluna "Nome do Cliente"

Static lTroco := Iif(	cPaisLoc <> "BRA",;
						(SuperGetMV("MV_LJTRLOC",,.F.) .AND. SL1->(ColumnPos("L1_TROCO1")) > 0),;
						(SuperGetMV("MV_LJTROCO",,.F.) .AND. SL1->(ColumnPos("L1_TROCO1")) > 0))

Static lMvDescISS	:= SuperGetMV("MV_DESCISS",,.F.)			// Indica se ha desconto do iss no financeiro
Static oTempTable   := Nil										//Objeto tabela temporaria
Static lLGPD 		:= Iif(ExistFunc("LjPDUse"),LjPDUse(),.F.)	//Verifica se a funcionalidade de Dados Protegidos está sendo utilizada no sistema.
Static lL1VLRPGDG 	:= SL1->(ColumnPos("L1_VLRPGDG")) > 0 .AND. SL1->(ColumnPos("L1_VLRPGPX")) > 0 //Verifica se existe o campo onde é gravado o valor da venda paga em Pagamento Digital e  PIX

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³LOJR075   º Autor ³ Fernando Salvatori º Data ³  20/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Mapa de Vendas                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   ANALISTA   ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDanilo Calil  ³27/10/06³111955³Desabilitada a secao 4 para customizacaoº±±
±±ºDanilo Calil  ³06/03/07³119315³Converte a nTotTrocCx para String.      º±±
±±ºMarcio Lopes  ³02/05/07³121691³Retirada as sections do relatorio.      º±±
±±ºGuilherme     ³22/05/07³124636³Incluida validacao na impressao da colu-º±±
±±ºSantos        ³        ³      ³na de acrescimos para nao permitir a im-º±±
±±º              ³        ³      ³pressao de valores negativos.           º±±
±±ºNorbert Waage ³04/07/07³126641³Incluido o calculo e impressao do troco º±±
±±º              ³        ³      ³das vendas em dinheiro para o Brasil.   º±±
±±º              ³        ³      ³Foram incluidos os calculos de troco e  º±±
±±º              ³        ³      ³os totalizadores do rodape do relatorio.º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function LojR075()
Local oReport				//Objeto do relatorio
Local aArea := {}	//Armazena a area atual
Local lConfSmVw := totvs.framework.smartview.util.isConfig() // Smart View Configurado?
Local aBtOpcoes	:= {STR0064,STR0065} // "Versão Anterior (TReport)" #"Nova Versão (Smart View)"
Local nOpcRelat	:= 1

If lConfSmVw
	nOpcRelat := Aviso( STR0062, STR0063, aBtOpcoes, 2 ) // "Defina a versão" # "Qual versão do relatório deseja utilizar?"
EndIf

If nOpcRelat == 1 // Versao Antiga

	If !TRepInUse()
		MsgAlert("Atenção, esse relatório somente será exibido no Modo de Relatório Personalizado." +CHR(10)+CHR(13)+;
				"Altere o parâmetro MV_TREPORT para 2 e o relatório poderá ser emitido normalmente")
	Else

		aArea := GetArea()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³MV_PAR01 -> Filial de          ?³
		//³MV_PAR02 -> Filial ate         ?³
		//³MV_PAR03 -> Data de            ?³
		//³MV_PAR04 -> Data ate           ?³
		//³MV_PAR05 -> Caixa de           ?³
		//³MV_PAR06 -> Caixa ate          ?³
		//³MV_PAR07 -> Considera Devolução?³
		//³MV_PAR08 -> Formas de Pgto     ?³
		//³MV_PAR09 -> Qual moeda         ?³
		//³MV_PAR10 -> Outras Moedas      ?³    
		//³MV_PAR11 -> Numero do Movimento?³    
		//³MV_PAR12 -> Considera Impostos ?³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		Pergunte("LJR075",.F.)

		// Aqui completa com "aaa" em caso do usuário informar o campo "Caixa de" branco
		If Empty(MV_PAR05)
			MV_PAR05 := Repl("0",Len(MV_PAR05))
		EndIf

		//Interface de impressao
		oReport := LjR075RptDef()
		oReport:PrintDialog()
		
		RestArea( aArea )
	Endif
ElseIf nOpcRelat == 2 // Versao Smart View
	LOJR075SV()
EndIf	

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³LJ075GeraTº Autor ³ Fernando Salvatori º Data ³  20/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Gera filtro/arquivo temporario para uso do relatorio.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpL1 - Valor logico que indica se utiliza queries SQL     º±±
±±º          ³ ExpC2 - Nome do arquivo temporario a ser gerado            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºGeronimo Alves³13/10/05³086647³Correção para na devolucao na coluna    º±±
±±º              ³        ³      ³Total, somar tambem os impostos         º±±
±±ºHanna Caroline³11/10/05³087020³Inclusao do calculo do troco, no caso deº±±
±±º              ³        ³      ³pagamentos em dinheiro                  º±±
±±ºGeronimo Alves³05/12/05³089250³Implementacao continua, corrigido rela- º±±
±±º              ³        ³      ³cionamento entre tabelas SD1xSL2 atravezº±±
±±º              ³        ³      ³dos campos D1_NUMSEQ e L2_ITEMSD1.      º±±  
±±ºMarcos Roberto³01/11/06³111930³Correcao no Filtro do IndRegua para DBF º±±
±±º              ³        ³      ³pois estava ocorrendo error.log no AS400º±±
±±ºNorbert Waage ³13/02/07³119101³Substituicao do uso de espacos fixos de-º±±
±±º              ³        ³      ³limitados por aspas pelo comando Space()º±±
±±º              ³        ³      ³compatibilizando o fonte com o SINIEF.  º±±
±±ºGeronimo      ³05/04/07³121757³Correcao na query que nao estava selecioº±±
±±º              ³        ³      ³nando as devoluções.Esta ocorrencia deveº±±
±±º              ³        ³      ³se a nova logica de gravaçao das devolu-º±±
±±º              ³        ³      ³cõe onde nao eh mais criado um registro º±±
±±º              ³        ³      ³no SL2 com o tipo "D" (Item Devolvido)  º±±
±±ºNorbert Waage ³04/07/07³126641³Incluido o calculo e impressao do troco º±±
±±º              ³        ³      ³das vendas em dinheiro para o Brasil.   º±±
±±ºNorbert Waage ³12/07/07³128242³Implementacao do filtro do usuario para º±±
±±º              ³        ³      ³impressao na versao Release 3.          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LJ075GeraTmp(lUsaQuery)
Local cQuery     	:= ""				//Query para montagem do filtro
Local cSeekWhile 	:= ""				//Chave para Loop
Local cIndSL1    	:= ""				//IndRegua para o SL1
Local cIndSF1    	:= ""				//IndRegua para o SF1
Local cIndSE5    	:= ""				//IndRegua para o SE5
Local cCampoTr   	:= ""				//Armazena o conteudo do campo L1_TROCO
Local aCampos    	:= {}				//Campos da estrutura DBF
Local aTam       	:= {} 				//Retorno da funcao TamSX3 para campos DBF
Local aStruTRB   	:= {} 				//Array com os campos do TRB do tipo Data e Numerico para o comando TCSetField
Local nValDesc   	:= 0 				//Valor do Desconto
Local nValDProp  	:= 0				//Valor do Desconto Proporcional
Local nMoeda     	:= 1 				//Moeda de transacao(venda/devolucao) - Localizacoes
Local nX         	:= 0				// Variavel do for
Local nVlrTroco  	:= 0				//Utilizado para fazer a somatoria do campo L1_TROCO
Local nY			:= 1				//Contador utilizado na somatoria da variavel nVlrTroco	
Local nDecs      := MsDecimais(mv_par09)// Informa qual o numero de casas decimais de acordo com o tipo de moeda informada: fonte original MATXFUNC.PRX
Local lSLOExcl   	:= .F.				//Define se os registros do arq. SLO estao excluidos(LayAway-Porto Rico/EUA)
Local lSLPExcl   	:= .F.    			//Define se os registros do arq. SLP estao excluidos(LayAway-Porto Rico/EUA)
Local lUsaPCC    	:= (cPaisLoc == "BRA") .And. ( SL2->(ColumnPos("L2_VALPIS")) > 0 .AND. SL2->(ColumnPos("L2_VALCOFI")) > 0 .AND. SL2->(ColumnPos("L2_VALCOFI")) > 0 )	//Verifica se tem apuracao de PIS/COFINS/CSLL
Local nTotal     	:= 0								//Variavel utilizada para calcular o valor total
Local nPerc      	:= 0								//Variavel utilizada para calcular o percentual de PIS/COFINS/CSLL
Local lpTPAbISS  	:= ( GetNewPar("MV_TPABISS", "1") == "2" )	//Se parametro = 1 indica que quera efetuado um desconto
																//na duplicata quando o cliente recolhe ISS
																//Se parametro = 2 sera gerado um titulo de abatimento
Local nRestDiv   	:= 0								//Utilizada no calculo do Valor do ISS
Local aTemp      	:= {}								//Armazena as formas de pagamento
Local cDoc2         := Criavar("SL1->L1_DOC",.F.)		//Utilizada para verificar se o campo L1_DOC e nulo
Local cOrcres2      := Criavar("SL1->L1_ORCRES",.F.)	//Utilizada para verificar se o campo L1_ORCRES e nulo
Local cDocPed2      := Criavar("SL1->L1_DOCPED",.F.)	//Utilizada para verificar se o campo L1_DOCPED e nulo
Local nTamDocPed 	:= TamSx3("L1_DOCPED")[1]			//Tamanho do campo L1_DOCPED
Local nTamSerPed 	:= TamSx3("L1_SERPED")[1]			//Tamanho do campo L1_SERPED
Local nTamVend      := TamSx3("L1_VEND")[1]			//Tamanho do campo L1_VEND
Local nTamNome      := TamSx3("A3_NREDUZ")[1]			//Tamanho do campo A3_NREDUZ
Local cTipoDB	 	:= AllTrim(Upper(TcGetDb()))		//Define o tipo do banco de dados

Local cMVLWPREF1 	:= SuperGetMv("MV_LWPREF1",,"")	//Titulos Lay-Away  
Local cMVDESCSAI 	:= SuperGetMv("MV_DESCSAI",.F.,"1")	//Considera o desconto da venda ou nao
Local cDescSai      := ""
Local lEstorno      := SD1->(ColumnPos("D1_OPERADO")) > 0  .And. SL1->(ColumnPos("L1_STATUES")) > 0 .and. SL4->(ColumnPos("L4_OPERAES")) > 0  /// estorno de vendas.	
Local cQryAux    	:= ""
Local lCliRecIss 	:= .F.								// Cliente Recolhe ISS ?
Local lUsaNMov      := Val(MV_PAR11) > 0 .AND. SL1->(ColumnPos("L1_NUMMOV")) > 0    //Usa filtro por movimento no alias sl1
Local lUsaSF1NMo 	:= Val(MV_PAR11) > 0 .AND. SF1->(ColumnPos("F1_NUMMOV")) > 0
Local cArqTmp		:= ""
Local oTblmp		:= NIL

//Adicionamos zero a esquerda, pois antes o parametro "Numero do Movimento" 
// era do tipo Numerico, ou seja, se fosse uma unidade, so possuia um digito
If Len( AllTrim(MV_PAR11) ) == 1
	MV_PAR11 := PadL(AllTrim(MV_PAR11), Len(MV_PAR11), "0")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se usa Query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsaQuery
	ProcRegua( 4 )
	
	IncProc(STR0007);IncProc(STR0007)//"Selecionando registros para impressão..."
	
	LJ075aStru(@aStruTRB)
	
	cQuery := "SELECT DISTINCT "
	
	cQuery += "' ' LDEV ,"
	cQuery += "SL1.L1_FILIAL   FILIAL  ,"
	cQuery += "SL1.L1_EMISNF   DTEMI   ,"
	cQuery += "SL1.L1_DOC      N_FISCAL,"
	cQuery += "SL1.L1_SERIE    SERIE   ,"
	cQuery += "SL1.L1_DOCPED   N_FISCPED,"
	cQuery += "SL1.L1_SERPED   SERPED  ,"
	cQuery += "SL1.L1_VEND     VENDED  ,"
	cQuery += "SA3.A3_NREDUZ   NOME    ,"
	cQuery += "SL1.L1_CLIENTE  CLIENTE ,"
	cQuery += "SL1.L1_LOJA     LOJA    ,"
	cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
	cQuery += "SL1.L1_VLRTOT   VLRTOT  ,"
	cQuery += "SL1.L1_OPERADO  CAIXA   ,"
	cQuery += "SL1.L1_DINHEIR  DINHEIRO,"
	cQuery += "SL1.L1_CHEQUES  CHEQUES ,"
	cQuery += "SL1.L1_CARTAO   CARTAO  ,"
	cQuery += "SL1.L1_VLRDEBI  VLRDEBI ,"
	cQuery += "SL1.L1_CONVENI  CONVENIO,"
	cQuery += "SL1.L1_VALES    VALES   ,"
	cQuery += "SL1.L1_FINANC   FINANC  ,"
	cQuery += "SL1.L1_OUTROS   OUTROS  ,"
	cQuery += "SL1.L1_CREDITO  CREDITO ,"
	cQuery += "SL1.L1_VALISS   VALISS  ,"

	If lL1VLRPGDG
        cQuery += "SL1.L1_VLRPGDG VLRPGDG, "
		cQuery += "SL1.L1_VLRPGPX VLRPGPX, "
    EndIf
	
	If lVlrPisCof
		cQuery += "SL1.L1_ABTOPCC ABTOPCC, "
	Endif

	If SL1->( ColumnPos ( "L1_RECISS" ) ) > 0
		cQuery += "SL1.L1_RECISS C_RECISS, "
	Else
		cQuery += "SA1.A1_RECISS C_RECISS, "
	Endif
	
	cQuery += "(SUM(SL2.L2_VALDESC) + SUM(SL2.L2_DESCPRO)) DESCON ,"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Alterado o calculo do acrescimo devido a mudanca de³
	//³conceito na gravacao dos totais da venda.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += "(SL1.L1_VALBRUT + (SUM(SL2.L2_VALDESC) + SUM(SL2.L2_DESCPRO)) - SL1.L1_VALMERC) ACRES "
	
	If cPaisLoc <> "BRA"
		cQuery += ", SL1.L1_MOEDA  MOEDA,  "
		cQuery += "' '             LAYAWAY,"
		cQuery += "'   '           HISTOR  "
		If lTroco
			cQuery += ", SL1.L1_TROCO1  TROCO1, "
			cQuery += " SL1.L1_TROCO2  TROCO2,  "
			cQuery += " SL1.L1_TROCO3  TROCO3,  "
			cQuery += " SL1.L1_TROCO4  TROCO4,  "
			cQuery += " SL1.L1_TROCO5  TROCO5   "
		Endif
	Else
		If lTroco
			cQuery += ", SL1.L1_TROCO1  TROCO1 "
		EndIf
	Endif
	
	cQuery += "FROM "+RetSQLName("SL1")+" SL1, "
	cQuery += RetSQLName("SL2")+" SL2, "
	cQuery += RetSQLName("SA1")+" SA1, "
	cQuery += RetSQLName("SA3")+" SA3 "
	
	cQuery += "WHERE "
	
	cQuery += "SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' " 

	If lUsaNMov 
		cQuery += "AND SL1.L1_NUMMOV = '" + MV_PAR11  + "' "	
	EndIf

	cQuery += "AND SA1.A1_COD = SL1.L1_CLIENTE "
	cQuery += "AND SA1.A1_LOJA = SL1.L1_LOJA "
	
	cQuery += "AND SA3.A3_FILIAL = '"+ xFilial( "SA3" ) +"' "
	cQuery += "AND SA3.A3_COD = SL1.L1_VEND "
	
	cQuery += "AND SL1.L1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	
	cQuery += " AND (((SL1.L1_TIPO = 'V' AND SL1.L1_DOC <> '"+cDoc2+"' AND SL1.L1_ORCRES = '"+cOrcres2+"') OR (SL1.L1_TIPO = 'P' AND SL1.L1_DOCPED <> '"+cDocped2+"'))) "
	
	cQuery += "AND SL1.L1_EMISNF  BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
	cQuery += "AND SL1.L1_OPERADO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	
	cQuery += "AND SL2.L2_FILIAL = SL1.L1_FILIAL "
	cQuery += "AND SL2.L2_NUM = SL1.L1_NUM "
	
	If cPaisLoc $ "POR|EUA"
		cQuery += " AND L1_CONDPG <> 'LAY' "	  //Desprezar as finalizacoes de Lay-Away
	Endif
	
	cQuery += "AND SL1.D_E_L_E_T_ <> '*' "
	cQuery += "AND SL2.D_E_L_E_T_ <> '*' "
	cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
	cQuery += "AND SA3.D_E_L_E_T_ <> '*' "
	
	cQuery += "GROUP BY "
	cQuery += "SL1.L1_FILIAL, "
	cQuery += "SL1.L1_EMISNF, "
	cQuery += "SL1.L1_DOC, "
	cQuery += "SL1.L1_SERIE , "
	cQuery += "SL1.L1_DOCPED, "
	cQuery += "SL1.L1_SERPED, "
	cQuery += "SL1.L1_VEND , "
	cQuery += "SA3.A3_NREDUZ , "
	cQuery += "SL1.L1_CLIENTE , "
	cQuery += "SL1.L1_LOJA , "
	cQuery += "SA1.A1_NREDUZ , "
	cQuery += "SL1.L1_VALBRUT , "
	cQuery += "SL1.L1_VLRTOT , "
	cQuery += "SL1.L1_VALMERC , "
	cQuery += "SL1.L1_OPERADO , "
	cQuery += "SL1.L1_DINHEIR , "
	cQuery += "SL1.L1_CHEQUES , "
	cQuery += "SL1.L1_CARTAO , 	"
	cQuery += "SL1.L1_VLRDEBI ,"
	cQuery += "SL1.L1_CONVENI , "
	cQuery += "SL1.L1_VALES , "
	cQuery += "SL1.L1_FINANC , "
	cQuery += "SL1.L1_OUTROS , "
	cQuery += "SL1.L1_CREDITO, "
	cQuery += "SL1.L1_VALISS "
	
	If lL1VLRPGDG
        cQuery += ", SL1.L1_VLRPGDG "
		cQuery += ", SL1.L1_VLRPGPX "
    EndIf

	If cPaisLoc <> "BRA"
		cQuery += ", SL1.L1_MOEDA "
		
		If lTroco
			cQuery += ", SL1.L1_TROCO1, "
			cQuery += " SL1.L1_TROCO2 ,  "
			cQuery += " SL1.L1_TROCO3 ,  "
			cQuery += " SL1.L1_TROCO4 ,  "
			cQuery += " SL1.L1_TROCO5    "
		Endif
	ElseIf SL1->( ColumnPos ( "L1_TROCO1" ) ) > 0
		cQuery += ", SL1.L1_TROCO1 "
	Endif
	
	If lVlrPisCof
		cQuery += ", SL1.L1_ABTOPCC "
	Endif

	If SL1->( ColumnPos ( "L1_RECISS" ) ) > 0
		cQuery += ", SL1.L1_RECISS "
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebimento por Lay-Away(Porto Rico/EUA)      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc $ "POR|EUA"
		cQuery += "UNION ALL "
		
		cQuery += "SELECT DISTINCT "
		cQuery += "' ' LDEV ,"
		cQuery += "SLO.LO_FILIAL   FILIAL  ,"
		cQuery += "SE5.E5_DATA     DTEMI   ,"
		cQuery += "SLO.LO_NUMLAY   N_FISCAL,"
		cQuery += "SE5.E5_PREFIXO  SERIE   ,"
		cQuery += "'" + Space(nTamDocPed)	+ "' N_FISCPED,"
		cQuery += "'" + Space(nTamSerPed)	+ "' SERPED  ,"
		cQuery += "'" + Space(nTamVend)	 	+ "' VENDED  ,"
		cQuery += "'" + Space(nTamNome) 	+ "' NOME  ,"
		cQuery += "SE5.E5_CLIFOR   CLIENTE ,"
		cQuery += "SE5.E5_LOJA     LOJA    ,"
		cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
		cQuery += "SE5.E5_VALOR    VLRTOT  ,"
		cQuery += "SE5.E5_BANCO    CAIXA   ,"
		cQuery += "0.00            DINHEIRO,"
		cQuery += "0.00            CHEQUES ,"
		cQuery += "0.00            CARTAO  ,"
		cQuery += "0.00            VLRDEBI ,"
		cQuery += "0.00            CONVENIO,"
		cQuery += "0.00            VALES   ,"
		cQuery += "0.00            FINANC  ,"
		cQuery += "0.00            OUTROS  ,"
		cQuery += "0.00            CREDITO ,"
		cQuery += "0.00            VALISS  ,"
		cQuery += "0.00            DESCON  ,"
		cQuery += "0.00            ACRES   ,"
		cQuery += "SLO.LO_MOEDA    MOEDA   ,"
		cQuery += "'S'             LAYAWAY ,"

		If lL1VLRPGDG
			cQuery += "0.00        VLRPGDG ,"
			cQuery += "0.00        VLRPGPX ,"
		Endif
		
		If cTipoDB $ "ORACLE_DB2"
			cQuery += "SUBSTR(SE5.E5_HISTOR,1,3) HISTOR    "
		ElseIf cTipoDB == "INFORMIX"
			cQuery += "SE5.E5_HISTOR[1,3] HISTOR "
		Else
			cQuery += "SUBSTRING(SE5.E5_HISTOR,1,3) HISTOR "
		EndIf
		
		cQuery += " FROM "+ RetSqlName("SE5") + " SE5,"
		cQuery += RetSqlName("SLO") + " SLO,"
		cQuery += RetSqlName("SLP") + " SLP,"
		cQuery += RetSqlName("SA1") + " SA1"
		
		cQuery += " WHERE "
		
		cQuery += "  SE5.E5_PREFIXO = SLP.LP_PREFIXO AND "   //SE5 x SLP
		cQuery += "  SE5.E5_NUMERO = SLP.LP_NUME1 AND "
		cQuery += "  SE5.E5_PARCELA = SLP.LP_PARCELA AND "
		
		cQuery += "  SE5.E5_CLIFOR = SLO.LO_CLIENTE AND "	 //SLO x SE5
		cQuery += "  SE5.E5_LOJA = SLO.LO_LOJA AND "
		
		cQuery += "  SLP.LP_FILIAL = SLO.LO_FILIAL AND "	    //SLO x SLP
		cQuery += "  SLP.LP_NUMLAY = SLO.LO_NUMLAY AND "
		
		cQuery += "  SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' AND "	 //SLO x SA1
		cQuery += "  SLO.LO_CLIENTE = SA1.A1_COD AND "
		cQuery += "  SLO.LO_LOJA = SA1.A1_LOJA AND "
		
		cQuery += "  (SE5.E5_PREFIXO = '"+ &(cMVLWPREF1) +"' AND SE5.E5_TIPO = 'RA ' AND SE5.E5_RECPAG = 'R' AND SE5.E5_TIPODOC = 'RA') AND "    //LayAway - recebimento
		
		cQuery += "  SLO.LO_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
		cQuery += "  SE5.E5_DATA  BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' AND "
		cQuery += "  SE5.E5_BANCO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		
		cQuery += "AND SLO.D_E_L_E_T_ <> '*' "
		cQuery += "AND SLP.D_E_L_E_T_ <> '*' "
		cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
		cQuery += "AND SE5.D_E_L_E_T_ <> '*' "
		
		//Contemplar os casos em que o Lay-Away eh anulado no mesmo dia de seu cadastro.
		//Deve considerar o recebimento inicial feito na inclusao do Lay-Away, que serah
		//compensado com o cancelamento selecionado abaixo
		cQuery += "UNION ALL "
		
		cQuery += "SELECT DISTINCT "
		cQuery += "' ' LDEV ,"
		cQuery += "SE5.E5_FILIAL   FILIAL  ,"
		cQuery += "SE5.E5_DATA     DTEMI   ,"
		cQuery += "SLO.LO_NUMLAY   N_FISCAL,"
		cQuery += "SE5.E5_PREFIXO  SERIE   ,"
		cQuery += "'" + Space(nTamDocPed)	+ "' N_FISCPED,"
		cQuery += "'" + Space(nTamSerPed)	+ "' SERPED  ,"
		cQuery += "'" + Space(nTamVend)	 	+ "' VENDED  ,"
		cQuery += "'" + Space(nTamNome) 	+ "' NOME  ,"
		cQuery += "SE5.E5_CLIFOR   CLIENTE ,"
		cQuery += "SE5.E5_LOJA     LOJA    ,"
		cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
		cQuery += "SE5.E5_VALOR    VLRTOT  ,"
		cQuery += "SE5.E5_BANCO    CAIXA   ,"
		cQuery += "0.00            DINHEIRO,"
		cQuery += "0.00            CHEQUES ,"
		cQuery += "0.00            CARTAO  ,"
		cQuery += "0.00            VLRDEBI ,"
		cQuery += "0.00            CONVENIO,"
		cQuery += "0.00            VALES   ,"
		cQuery += "0.00            FINANC  ,"
		cQuery += "0.00            OUTROS  ,"
		cQuery += "0.00            CREDITO ,"
		cQuery += "0.00            VALISS  ,"
		cQuery += "0.00            DESCON  ,"
		cQuery += "0.00            ACRES   ,"
		cQuery += "SLO.LO_MOEDA    MOEDA   ,"
		cQuery += "'S'             LAYAWAY ,"

		If lL1VLRPGDG
			cQuery += "0.00        VLRPGDG ,"
			cQuery += "0.00        VLRPGPX ,"
		Endif

		If cTipoDB $ "ORACLE_DB2"
			cQuery += "SUBSTR(SE5.E5_HISTOR,1,3) HISTOR    "
		ElseIf cTipoDB == "INFORMIX"
			cQuery += "SE5.E5_HISTOR[1,3] HISTOR "
		Else
			cQuery += "SUBSTRING(SE5.E5_HISTOR,1,3) HISTOR "
		EndIf

		cQuery += "FROM "+RetSqlName("SLO") + " SLO,"
		cQuery += RetSqlName("SLP") + " SLP,"
		cQuery += RetSqlName("SE5") + " SE5,"
		cQuery += RetSqlName("SA1") + " SA1 "
		
		cQuery += " WHERE "
		
		cQuery += "  SLO.LO_STATUS = '4' AND"               //Lay-Away anulado
		
		cQuery += "  SLO.LO_NUMLAY = SLP.LP_NUMLAY AND"     //SLO x SLP
		cQuery += "  SLO.LO_FILIAL = SLP.LP_FILIAL AND"
		
		cQuery += "  SLP.LP_PREFIXO = SE5.E5_PREFIXO AND"   //SLP x SE5
		cQuery += "  SLP.LP_NUME1 = SE5.E5_NUMERO AND"
		cQuery += "  SLP.LP_PARCELA = SE5.E5_PARCELA AND"
		cQuery += "  SLP.LP_TIPOE1 = SE5.E5_TIPO AND"
		
		cQuery += "  SLO.LO_CLIENTE = SE5.E5_CLIFOR AND"	   //SLO x SE5
		cQuery += "  SLO.LO_LOJA = SE5.E5_LOJA AND"
		
		cQuery += "  SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' AND "	//SLO x SA1
		cQuery += "  SLO.LO_CLIENTE = SA1.A1_COD AND"
		cQuery += "  SLO.LO_LOJA = SA1.A1_LOJA AND"
		
		cQuery += " (SE5.E5_DATA BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "') AND "
		cQuery += " (SE5.E5_BANCO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "') AND "
		
		cQuery += " (SE5.E5_PREFIXO = '"+ &(cMVLWPREF1) +"' AND SE5.E5_TIPO = 'RA ' AND SE5.E5_TIPODOC = 'RA' AND E5_RECPAG = 'R') AND "    //Recebimento de Lay-Away
		
		cQuery += " SLO.D_E_L_E_T_<>'*' AND"
		cQuery += " SE5.D_E_L_E_T_<>'*' AND"
		cQuery += " SA1.D_E_L_E_T_<>'*' "
		//Nao verificar o arq. SLP porque eh excluido no cancelamento de Lay-Away
		
	Endif
	
	If MV_PAR07 == 1
		
		cQuery += "UNION ALL "
		
		cQuery += "SELECT DISTINCT "
		cQuery += "'|' LDEV              ,"
		cQuery += "SF1.F1_FILIAL   FILIAL   ,"
		cQuery += "SF1.F1_EMISSAO  DTEMI    ,"
		cQuery += "SF1.F1_DOC      N_FISCAL ,"
		cQuery += "SF1.F1_SERIE    SERIE    ,"
		cQuery += "'" + Space(nTamDocPed)	+ "' N_FISCPED,"
		cQuery += "'" + Space(nTamSerPed)	+ "' SERPED  ,"
		cQuery += "'" + Space(nTamVend)	 	+ "' VENDED  ,"
		cQuery += "'" + Space(nTamNome) 	+ "' NOME  ,"
		cQuery += "SF1.F1_FORNECE  CLIENTE  ,"
		cQuery += "SF1.F1_LOJA	   LOJA     ,"
		cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"      
		
		If cMVDESCSAI == "2"
			cDescSai +=	" - SD1.D1_VALDESC"
		EndIf		
		
		
		If lUsaPCC
			If MV_PAR12 == 1			
				cQuery += "SUM(( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) - ( ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALPIS / SL2.L2_VLRITEM  ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALCOFI / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;                                       				
				"( ( SL2.L2_VALCSLL / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) ) + ( SD1.D1_VALIMP1 + SD1.D1_VALIMP2 + SD1.D1_VALIMP3 + SD1.D1_VALIMP4 + SD1.D1_VALIMP5 ) ) VLRTOT ,"
			Else
				cQuery += "SUM(( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) - ( ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALPIS / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALCOFI / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALCSLL / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) ) ) VLRTOT ,"
			EndIf				
				
		Else
			If MV_PAR12 == 1

				cQuery += "SUM(SD1.D1_TOTAL" + cDescSai + " + SD1.D1_VALIPI + SD1.D1_VALIMP1 + SD1.D1_VALIMP2 + SD1.D1_VALIMP3 + SD1.D1_VALIMP4 + SD1.D1_VALIMP5 ) VLRTOT  ,"
			Else
				cQuery += "SUM(SD1.D1_TOTAL" + cDescSai + " + SD1.D1_VALIPI ) VLRTOT  ,"			
	
			EndIf	
			
		Endif
		
		If cTipoDB $ "ORACLE_DB2"
			cQuery += "SUBSTR(SD1.D1_NUMCQ,1,3) CAIXA   ,"
		ElseIf cTipoDB == "INFORMIX"
			cQuery += "SD1.D1_NUMCQ[1,3] CAIXA   ,"
		Else
			cQuery += "SUBSTRING(SD1.D1_NUMCQ,1,3) CAIXA   ,"
		EndIf

		cQuery += "0.00   DINHEIRO  ,"
		cQuery += "0.00   CHEQUES   ,"
		cQuery += "0.00   CARTAO    ,"
		cQuery += "0.00   VLRDEBI   ,"
		cQuery += "0.00   CONVENIO  ,"
		cQuery += "0.00   VALES     ,"
		cQuery += "0.00   FINANC    ,"
		cQuery += "0.00   OUTROS    ,"
		cQuery += "0.00   CREDITO   ,"
		cQuery += "0.00   VALISS    "

		If lL1VLRPGDG
			cQuery += ", 0.00  VLRPGDG "
			cQuery += ", 0.00  VLRPGPX "
		Endif

		If lVlrPisCof
			cQuery += ", 0.00  ABTOPCC "
		Endif

		If SL1->( ColumnPos ( "L1_RECISS" ) ) > 0
			cQuery += ", ' ' C_RECISS "
		Endif

		cQuery += ",0.00   DESCON "
		cQuery += ",0.00   ACRES  "
		
		If cPaisLoc <> "BRA"
			cQuery += ", SF1.F1_MOEDA  MOEDA , "
			cQuery += "' '             LAYAWAY,"
			cQuery += "'   '           HISTOR  "
			
			If lTroco
				cQuery += ", 0.00   TROCO1, "
				cQuery += " 0.00   TROCO2,  "
				cQuery += " 0.00   TROCO3,  "
				cQuery += " 0.00   TROCO4,  "
				cQuery += " 0.00   TROCO5   "
			Endif
		Else
			If lTroco
				cQuery += ", 0.00   TROCO1 "
			EndIf
		Endif
		
		cQuery += "FROM "+RetSQLName("SF1")+" SF1, "
		cQuery += RetSQLName("SA1")+" SA1, "
		cQuery += RetSQLName("SD1")+" SD1 "
		
		If lUsaPCC
			cQuery += ", " + RetSQLName("SD2") + " SD2, " + RetSQLName("SL2") + " SL2 "
		Endif
		
		cQuery += "WHERE SA1.A1_FILIAL = '"+xFilial( "SA1" )+"' "
		cQuery += "AND SA1.A1_COD = SF1.F1_FORNECE "
		cQuery += "AND SA1.A1_LOJA = SF1.F1_LOJA "  
		
		If lUsaSF1NMo
	   		cQuery += "AND SF1.F1_NUMMOV  = '"+MV_PAR11+"' "
		EndIf
		
		cQuery += "AND SF1.F1_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += "AND SF1.F1_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
		cQuery += "AND SF1.F1_TIPO = 'D' "
		
		cQuery += "AND SD1.D1_FILIAL  = SF1.F1_FILIAL "
		cQuery += "AND SD1.D1_DOC     = SF1.F1_DOC "
		cQuery += "AND SD1.D1_SERIE   = SF1.F1_SERIE "
		cQuery += "AND SD1.D1_FORNECE = SF1.F1_FORNECE "
		cQuery += "AND SD1.D1_LOJA    = SF1.F1_LOJA "
		cQuery += "AND SD1.D1_ORIGLAN = 'LO' "
		
		If	lEstorno 	 ////  estorno	
			cQuery += " AND SD1.D1_OPERADO = ' ' "   
		Endif
		If cTipoDB $ "ORACLE_DB2"
			cQuery += "AND SUBSTR(SD1.D1_NUMCQ,1,3) BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		ElseIf cTipoDB == "INFORMIX"
			cQuery += "AND SD1.D1_NUMCQ[1,3] BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		Else
			cQuery += "AND SUBSTRING(SD1.D1_NUMCQ,1,3) BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		EndIf

		cQuery += "AND SF1.D_E_L_E_T_ <> '*' "
		cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
		cQuery += "AND SD1.D_E_L_E_T_ <> '*' "
		
		If lUsaPCC
			
			cQuery += " AND SD2.D_E_L_E_T_ <> '*' AND SD2.D2_FILIAL = SF1.F1_FILIAL AND SD2.D2_DOC = SD1.D1_NFORI AND " + ;
			" SD2.D2_SERIE = SD1.D1_SERIORI AND " + ;
			" SD2.D2_COD = SD1.D1_COD AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SL2.D_E_L_E_T_ <> '*' AND " + ;
			" SL2.L2_FILIAL = SF1.F1_FILIAL AND SL2.L2_SERIE = SD2.D2_SERIE AND SL2.L2_DOC = SD2.D2_DOC AND " + ;
			" SL2.L2_PRODUTO = SD2.D2_COD AND SL2.L2_ITEM = SD2.D2_ITEMPV " 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Relaciono univocamente as tabelas SD1 e SL2 atraves dos campos D1_NUMSEQ e L2_ITEMSD1.                ³
			//³Caso L2_ITEMSD1 esteja vazio (que soh ocorrera com dados legados) este tratamento nao serah efetuado. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SL2->(ColumnPos("L2_ITEMSD1")) > 0
				cQuery += " AND ( SD1.D1_NUMSEQ = SL2.L2_ITEMSD1 OR SL2.L2_ITEMSD1 = '      '  OR SL2.L2_ITEMSD1 = '000000' ) "
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Obs. Na query aceito como valido os conteudos '     ' e '000000' porque na base pode existir   ³
				//³com este conteudo. Os registros com '      ' são registros antigos e os com '000000' são ini-  ³
				//³cializados desta forma no programa  Loja701C sendo que este campo nao eh alterado se a devolu- ³
				//³devolucao for efetuada pela rotina nova de troca  (LOJA720)                                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Endif                                                          
			
			
		Endif
		
		cQuery += "GROUP BY "
		cQuery += "SF1.F1_FILIAL, "
		cQuery += "SF1.F1_EMISSAO, "
		cQuery += "SF1.F1_DOC, "
		cQuery += "SF1.F1_SERIE, "
		cQuery += "SF1.F1_FORNECE, "
		cQuery += "SF1.F1_LOJA, "
		cQuery += "SA1.A1_NREDUZ,  "
		
		If cTipoDB $ "ORACLE_DB2"
			cQuery += "SUBSTR(SD1.D1_NUMCQ,1,3) "
		ElseIf cTipoDB == "INFORMIX"
			cQuery += "SD1.D1_NUMCQ[1,3] "
		Else
			cQuery += "SUBSTRING(SD1.D1_NUMCQ,1,3) "
		EndIf

		If cPaisLoc <> "BRA"
			cQuery += ", SF1.F1_MOEDA "
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancelamento do Lay-Away(Porto Rico/EUA)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc $ "POR|EUA"
			cQuery += "UNION ALL "
			
			cQuery += "SELECT DISTINCT "
			cQuery += "'|' LDEV             ,"
			cQuery += "SE5.E5_FILIAL   FILIAL  ,"
			cQuery += "SE5.E5_DATA     DTEMI   ,"
			cQuery += "SE5.E5_NUMERO   N_FISCAL,"
			cQuery += "SE5.E5_PREFIXO  SERIE   ,"
			cQuery += "'" + Space(nTamDocPed)	+ "' N_FISCPED,"
			cQuery += "'" + Space(nTamSerPed)	+ "' SERPED  ,"
			cQuery += "'" + Space(nTamVend)	 	+ "' VENDED  ,"
			cQuery += "'" + Space(nTamNome) 	+ "' NOME  ,"
			cQuery += "SE5.E5_CLIFOR   CLIENTE ,"
			cQuery += "SE5.E5_LOJA     LOJA    ,"
			cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
			cQuery += "SE5.E5_VALOR    VLRTOT  ,"
			cQuery += "SE5.E5_BANCO    CAIXA   ,"
			cQuery += "0.00            DINHEIRO,"
			cQuery += "0.00            CHEQUES ,"
			cQuery += "0.00            CARTAO  ,"
			cQuery += "0.00            VLRDEBI ,"
			cQuery += "0.00            CONVENIO,"
			cQuery += "0.00            VALES   ,"
			cQuery += "0.00            FINANC  ,"
			cQuery += "0.00            OUTROS  ,"
			cQuery += "0.00            CREDITO ,"
			cQuery += "0.00            VALISS  ,"
			cQuery += "0.00            DESCON  ,"
			cQuery += "0.00            ACRES   ,"
			cQuery += "SLO.LO_MOEDA    MOEDA   ,"
			cQuery += "'S'             LAYAWAY ,"
			cQuery += "'   '           HISTOR   "

			If lL1VLRPGDG
                cQuery += "0.00        VLRPGDG ,"
				cQuery += "0.00        VLRPGPX ,"
            Endif
			
			cQuery += " FROM "+ RetSqlName("SE5") + " SE5,"
			cQuery += RetSqlName("SLO") + " SLO,"
			cQuery += RetSqlName("SA1") + " SA1"
			
			cQuery += " WHERE "
			
			cQuery += "  (SE5.E5_DATA >= '" + Dtos(mv_par03) + "' AND SE5.E5_DATA <= '" + Dtos(mv_par04) + "') AND "
			cQuery += "  (SE5.E5_BANCO >= '" + mv_par05 + "' AND SE5.E5_BANCO <= '" + mv_par06 + "') AND "
			cQuery += "  (SE5.E5_PREFIXO = '"+ &(cMVLWPREF1) +"' AND SE5.E5_TIPO = 'RA ' AND SE5.E5_RECPAG = 'P' AND SE5.E5_TIPODOC = 'VL') AND "    //LayAway cancelado
			
			cQuery += "  SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' AND "  //SE5 x SA1
			cQuery += "  SE5.E5_CLIFOR = SA1.A1_COD AND "
			cQuery += "  SE5.E5_LOJA = SA1.A1_LOJA AND "
			
			cQuery += "  SE5.E5_NUMERO = SLO.LO_NUMLAY AND "	            //SE5 x SLO
			cQuery += "  SLO.LO_STATUS = '4' AND "
			
			cQuery += "  SE5.D_E_L_E_T_<>'*' AND "
			cQuery += "  SLO.D_E_L_E_T_<>'*' AND "
			cQuery += "  SA1.D_E_L_E_T_<>'*' "
			
		Endif
	Endif
/////////////////// union - novo    LDEV = + é estorno

	If MV_PAR07 == 1 .AND. lEstorno    
	
		cQuery += "UNION ALL "						
		cQuery += "SELECT DISTINCT "
		cQuery += "'+' LDEV              ,"
		cQuery += "SF1.F1_FILIAL   FILIAL   ,"
		cQuery += "SF1.F1_EMISSAO  DTEMI    ,"
		cQuery += "SF1.F1_DOC      N_FISCAL ,"
		cQuery += "SF1.F1_SERIE    SERIE    ,"
		cQuery += "'" + Space(nTamDocPed)	+ "' N_FISCPED,"
		cQuery += "'" + Space(nTamSerPed)	+ "' SERPED  ,"
		cQuery += "'" + Space(nTamVend)	 	+ "' VENDED  ,"
		cQuery += "'" + Space(nTamNome) 	+ "' NOME  ,"
		cQuery += "SF1.F1_FORNECE  CLIENTE  ,"
		cQuery += "SF1.F1_LOJA	   LOJA     ,"
		cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
		
		If cMVDESCSAI == "2"
			cDescSai +=	" - SD1.D1_VALDESC"
		EndIf
	
		If lUsaPCC
			If MV_PAR12 == 1			
				cQuery += "SUM(( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) - ( ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALPIS / SL2.L2_VLRITEM  ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALCOFI / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;				
				"( ( SL2.L2_VALCSLL / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) ) + ( SD1.D1_VALIMP1 + SD1.D1_VALIMP2 + SD1.D1_VALIMP3 + SD1.D1_VALIMP4 + SD1.D1_VALIMP5 ) ) VLRTOT ,"
			Else
				cQuery += "SUM(( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) - ( ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALPIS / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALCOFI / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI" + cDescSai + " ) * " + ;
				"( ( SL2.L2_VALCSLL / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) ) ) VLRTOT ,"
			EndIf					
		Else
			If MV_PAR12 == 1
				cQuery += "SUM(SD1.D1_TOTAL" + cDescSai + " + SD1.D1_VALIPI + SD1.D1_VALIMP1 + SD1.D1_VALIMP2 + SD1.D1_VALIMP3 + SD1.D1_VALIMP4 + SD1.D1_VALIMP5 ) VLRTOT  ,"
			Else
				cQuery += "SUM(SD1.D1_TOTAL" + cDescSai + " + SD1.D1_VALIPI ) VLRTOT  ,"			
			EndIf	
			
		Endif
		
	                        
		cQuery += "SD1.D1_OPERADO CAIXA   ,"           	
		cQuery += "0.00   DINHEIRO  ,"
		cQuery += "0.00   CHEQUES   ,"
		cQuery += "0.00   CARTAO    ,"
		cQuery += "0.00   VLRDEBI   ,"
		cQuery += "0.00   CONVENIO  ,"
		cQuery += "0.00   VALES     ,"
		cQuery += "0.00   FINANC    ,"
		cQuery += "0.00   OUTROS    ,"
		cQuery += "0.00   CREDITO   ,"
		cQuery += "0.00   VALISS    ,"

		If lL1VLRPGDG
			cQuery += "0.00  VLRPGDG ,"
			cQuery += "0.00  VLRPGPX ,"
		Endif

		If lVlrPisCof
			cQuery += "0.00  ABTOPCC ,"
		Endif

		If SL1->( ColumnPos ( "L1_RECISS" ) ) > 0
			cQuery += "' ' C_RECISS  ,"
		Endif

		cQuery += "0.00   DESCON    ,"
		cQuery += "0.00   ACRES "
		
		If cPaisLoc <> "BRA"
			cQuery += ", SF1.F1_MOEDA  MOEDA , "
			cQuery += "' '             LAYAWAY,"
			cQuery += "'   '           HISTOR  "
			
			If lTroco
				cQuery += ", 0.00   TROCO1, "
				cQuery += " 0.00   TROCO2,  "
				cQuery += " 0.00   TROCO3,  "
				cQuery += " 0.00   TROCO4,  "
				cQuery += " 0.00   TROCO5   "
			Endif
		Else
			If lTroco
				cQuery += ", 0.00   TROCO1 "
			EndIf
		Endif
		
		
		cQuery += "FROM "+RetSQLName("SF1")+" SF1, "
		cQuery += RetSQLName("SA1")+" SA1, "
		cQuery += RetSQLName("SD1")+" SD1 "
	
		
		If lUsaPCC
			cQuery += ", " + RetSQLName("SD2") + " SD2, " + RetSQLName("SL2") + " SL2 "
		Endif
		
		cQuery += "WHERE SA1.A1_FILIAL = '"+xFilial( "SA1" )+"' "
		cQuery += "AND SA1.A1_COD = SF1.F1_FORNECE "
		cQuery += "AND SA1.A1_LOJA = SF1.F1_LOJA " 
		
		If lUsaSF1NMo		 		
			cQuery += "AND SF1.F1_NUMMOV  = '"+MV_PAR11+"' "
		EndIf
		
		cQuery += "AND SF1.F1_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += "AND SF1.F1_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
		cQuery += "AND SF1.F1_TIPO = 'D' "
		
		cQuery += "AND SD1.D1_FILIAL  = SF1.F1_FILIAL "
		cQuery += "AND SD1.D1_DOC     = SF1.F1_DOC "
		cQuery += "AND SD1.D1_SERIE   = SF1.F1_SERIE "
		cQuery += "AND SD1.D1_FORNECE = SF1.F1_FORNECE "
		cQuery += "AND SD1.D1_LOJA    = SF1.F1_LOJA "
		cQuery += "AND SD1.D1_ORIGLAN = 'LO' "	
		cQuery += "AND SD1.D1_OPERADO  BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "			
		cQuery += "AND SF1.D_E_L_E_T_ <> '*' "
		cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
		cQuery += "AND SD1.D_E_L_E_T_ <> '*' "
	
		
				
		If lUsaPCC
	 
			cQuery += " AND SD2.D_E_L_E_T_ <> '*' AND SD2.D2_FILIAL = SF1.F1_FILIAL AND SD2.D2_DOC = SD1.D1_NFORI AND " + ;
	    		" SD2.D2_SERIE = SD1.D1_SERIORI AND " + ;
			" SD2.D2_COD = SD1.D1_COD AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SL2.D_E_L_E_T_ <> '*' AND " + ;
			" SL2.L2_FILIAL = SF1.F1_FILIAL AND SL2.L2_SERIE = SD2.D2_SERIE AND SL2.L2_DOC = SD2.D2_DOC AND " + ;
			" SL2.L2_PRODUTO = SD2.D2_COD AND SL2.L2_ITEM = SD2.D2_ITEMPV " 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Relaciono univocamente as tabelas SD1 e SL2 atraves dos campos D1_NUMSEQ e L2_ITEMSD1.                ³
			//³Caso L2_ITEMSD1 esteja vazio (que soh ocorrera com dados legados) este tratamento nao serah efetuado. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SL2->(ColumnPos("L2_ITEMSD1")) > 0
				cQuery += " AND ( SD1.D1_NUMSEQ = SL2.L2_ITEMSD1 OR SL2.L2_ITEMSD1 = '      '  OR SL2.L2_ITEMSD1 = '000000' ) "
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Obs. Na query aceito como valido os conteudos '     ' e '000000' porque na base pode existir   ³
				//³com este conteudo. Os registros com '      ' são registros antigos e os com '000000' são ini-  ³
				//³cializados desta forma no programa  Loja701C sendo que este campo nao eh alterado se a devolu- ³
				//³devolucao for efetuada pela rotina nova de troca  (LOJA720)                                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Endif                                                          
			
			
		Endif
		
		cQuery += "GROUP BY "
		cQuery += "SF1.F1_FILIAL, "
		cQuery += "SF1.F1_EMISSAO, "
		cQuery += "SF1.F1_DOC, "
		cQuery += "SF1.F1_SERIE, "
		cQuery += "SF1.F1_FORNECE, "
		cQuery += "SF1.F1_LOJA, "
		cQuery += "SA1.A1_NREDUZ,  " 
		cQuery += "SD1.D1_OPERADO "
	
	
		If cPaisLoc <> "BRA"
			cQuery += ", SF1.F1_MOEDA "
		Endif 
		
	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancelamento do Lay-Away(Porto Rico/EUA)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc $ "POR|EUA"
			cQuery += "UNION ALL "
			
			cQuery += "SELECT DISTINCT "
			cQuery += "'+' LDEV             ,"
			cQuery += "SE5.E5_FILIAL   FILIAL  ,"
			cQuery += "SE5.E5_DATA     DTEMI   ,"
			cQuery += "SE5.E5_NUMERO   N_FISCAL,"
			cQuery += "SE5.E5_PREFIXO  SERIE   ,"
			cQuery += "'" + Space(nTamDocPed)	+ "' N_FISCPED,"
			cQuery += "'" + Space(nTamSerPed)	+ "' SERPED  ,"
			cQuery += "'" + Space(nTamVend)	 	+ "' VENDED  ,"
			cQuery += "'" + Space(nTamNome) 	+ "' NOME  ,"
			cQuery += "SE5.E5_CLIFOR   CLIENTE ,"
			cQuery += "SE5.E5_LOJA     LOJA    ,"
			cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
			cQuery += "SE5.E5_VALOR    VLRTOT  ,"
			cQuery += "SE5.E5_BANCO    CAIXA   ,"
			cQuery += "0.00            DINHEIRO,"
			cQuery += "0.00            CHEQUES ,"
			cQuery += "0.00            CARTAO  ,"
			cQuery += "0.00            VLRDEBI ,"
			cQuery += "0.00            CONVENIO,"
			cQuery += "0.00            VALES   ,"
			cQuery += "0.00            FINANC  ,"
			cQuery += "0.00            OUTROS  ,"
			cQuery += "0.00            CREDITO ,"
			cQuery += "0.00            VALISS  ,"
			cQuery += "0.00            DESCON  ,"
			cQuery += "0.00            ACRES   ,"
			cQuery += "SLO.LO_MOEDA    MOEDA   ,"
			cQuery += "'S'             LAYAWAY ,"
			cQuery += "'   '           HISTOR   "

			If lL1VLRPGDG
                cQuery += "0.00        VLRPGDG ,"
				cQuery += "0.00        VLRPGPX ,"
            EndIf
			
			cQuery += " FROM "+ RetSqlName("SE5") + " SE5,"
			cQuery += RetSqlName("SLO") + " SLO,"
			cQuery += RetSqlName("SA1") + " SA1"
			
			cQuery += " WHERE "
			
			cQuery += "  (SE5.E5_DATA >= '" + Dtos(mv_par03) + "' AND SE5.E5_DATA <= '" + Dtos(mv_par04) + "') AND "
			cQuery += "  (SE5.E5_BANCO >= '" + mv_par05 + "' AND SE5.E5_BANCO <= '" + mv_par06 + "') AND "
			cQuery += "  (SE5.E5_PREFIXO = '"+ &(cMVLWPREF1) +"' AND SE5.E5_TIPO = 'RA ' AND SE5.E5_RECPAG = 'P' AND SE5.E5_TIPODOC = 'VL') AND "    //LayAway cancelado
			
			cQuery += "  SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' AND "  //SE5 x SA1
			cQuery += "  SE5.E5_CLIFOR = SA1.A1_COD AND "
			cQuery += "  SE5.E5_LOJA = SA1.A1_LOJA AND "
			
			cQuery += "  SE5.E5_NUMERO = SLO.LO_NUMLAY AND "	            //SE5 x SLO
			cQuery += "  SLO.LO_STATUS = '4' AND "
			
			cQuery += "  SE5.D_E_L_E_T_<>'*' AND "
			cQuery += "  SLO.D_E_L_E_T_<>'*' AND "
			cQuery += "  SA1.D_E_L_E_T_<>'*' "
		Endif
		
    Endif
/////////////////////////// fim do novo
	
	cQuery += "ORDER BY 2, 3, 14, 1 "
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o tratamento/compatibilidade com o Top Connect    		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQryAux:= cQuery //Guarda a query antes de executar o ChangeQuery() neste ponto, pois ira executar o ChangeQuery() depois dentro da funcao SqlToTrb(), p/ evitar erro em banco DB2
	cQuery := ChangeQuery(cQuery)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava um arquivo com a query para possiveis testes (DEBUG)   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//MemoWrite("C:\LOJR075.SQL",cQuery)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o ALIAS do arquivo temporario                     		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
	
	For nX := 1 To Len(aStruTRB)
		TcSetField( "TRB", aStruTRB[nX,1], aStruTRB[nX,2], aStruTRB[nX,3], aStruTRB[nX,4] )
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alterada a estrutura para arquivo local, pois o select sofrera alteração nos dados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aStruTRB := TRB->(dbStruct())
	TRB->(dbCloseArea())

	//Cria Tabela temporaria
	oTempTable := LjCrTmpTbl("TRB", aStruTRB)
  
	MsAguarde({|| SqlToTrb(cQryAux, aStruTRB, 'TRB' )},STR0061) //"Preparando Registros"

	IncProc(STR0007);IncProc(STR0007)//"Selecionando registros para impressão..."
	
	If SL1->(ColumnPos("L1_ABTOPCC")) > 0 .AND. cPaisLOC == "BRA"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Varre todo o arquivo de trabalho, se existir o campo L1_ABTOPCC e for BRASIL ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TRB->(DBGoTop())
		
		While ! TRB->(EOF())
			
			nParcelas := 0
			nRestDiv  := 0
			aTemp     := {}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Venda balcão não grava nada qdo tem abatimento total do PIS/COFINS/CSLL já o venda assistida grava ³
			//³no L1_OUTROS. Por isso esse processo para colocar o que foi abatido no campo L1_DINHEIR.           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	(	TRB->DINHEIRO	+	TRB->CHEQUES	+	TRB->CARTAO	+	TRB->VLRDEBI	+;
				TRB->CONVENIO 	+	TRB->VALES		+	TRB->FINANC	+	TRB->CREDITO ) == 0 .AND. ;
				(	TRB->OUTROS		==	TRB->ABTOPCC	.OR.TRB->OUTROS == 0 )
				
				If TRB->OUTROS == 0
					REPLACE DINHEIRO With TRB->ABTOPCC
				Else
					REPLACE DINHEIRO With TRB->OUTROS
				Endif
				
				REPLACE OUTROS   With 0
				
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava no array aTemp as formas de pagamento ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If TRB->DINHEIRO > 0
				nParcelas ++
				aAdd(aTemp, "DINHEIRO")
			Endif
			
			If TRB->CHEQUES > 0
				nParcelas ++
				aAdd(aTemp, "CHEQUES")
			Endif
			
			If TRB->CARTAO > 0
				nParcelas ++
				aAdd(aTemp, "CARTAO")
			Endif
			
			If TRB->VLRDEBI > 0
				nParcelas ++
				aAdd(aTemp, "VLRDEBI")
			Endif
			
			If TRB->CONVENIO > 0
				nParcelas ++
				aAdd(aTemp, "CONVENIO")
			Endif
			
			If TRB->VALES > 0
				nParcelas ++
				aAdd(aTemp, "VALES")
			Endif
			
			If TRB->FINANC > 0
				nParcelas ++
				aAdd(aTemp, "FINANC")
			Endif
			
			If TRB->CREDITO > 0
				nParcelas ++
				aAdd(aTemp, "CREDITO")
			Endif

			If lL1VLRPGDG .And. TRB->VLRPGDG > 0
				nParcelas ++
				aAdd(aTemp, "VLRPGDG")
			Endif

			If lL1VLRPGDG .And. TRB->VLRPGPX > 0
				nParcelas ++
				aAdd(aTemp, "VLRPGPX")
			Endif
			
			If TRB->OUTROS > 0
				nParcelas ++
				aAdd(aTemp, "OUTROS")
			Endif
			
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida se o cliente recolhe ISS³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Verifica se esta usando a nova configuracao para confirmar se o cliente recolhera o iss.
			If SuperGetMV("MV_LJRECIS",,.F.)  .And. SL1->( ColumnPos ( "L1_RECISS" ) ) > 0 
				lCliRecIss := TRB->C_RECISS == "1" .AND. lMvDescISS .AND. ! lpTPAbISS  	
			Else
				lCliRecIss :=  ( SA1->A1_RECISS == "1" .AND. lMvDescISS ) .AND. ! lpTPAbISS  					
			EndIf
			
			
			If lCliRecIss
				RecLock("TRB",.F.)
				For nX := 1 To Len(aTemp)
					FieldPut( ColumnPos ( aTemp[nX] ), ( FieldGet( ColumnPos( aTemp[nX] ) ) + Round( ( VALISS / nParcelas ), 2) ) )
					nRestDiv += Round( ( VALISS / nParcelas ), 2 )
				Next nX
				
				If nRestDiv <> VALISS
					FieldPut( ColumnPos( aTemp[nX] ), ( FieldGet( ColumnPos( aTemp[nX] ) ) - ( nRestDiv - VALISS ) ) )
				Endif
				MsUnlock()
				
			Endif
			TRB->(DbSkip())
			
		End
		
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Varre todo o arquivo de trabalho, se nao existir o campo L1_ABTOPCC ou nao for BRASIL ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TRB->(DBGoTop())
		
		While ! TRB->(EOF())
			
			nParcelas := 0
			nRestDiv  := 0
			aTemp     := {}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava no array aTemp as formas de pagamento ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If TRB->DINHEIRO > 0
				nParcelas ++
				aAdd(aTemp, "DINHEIRO")
			Endif
			
			If TRB->CHEQUES > 0
				nParcelas ++
				aAdd(aTemp, "CHEQUES")
			Endif
			
			If TRB->CARTAO > 0
				nParcelas ++
				aAdd(aTemp, "CARTAO")
			Endif
			
			If TRB->VLRDEBI > 0
				nParcelas ++
				aAdd(aTemp, "VLRDEBI")
			Endif
			
			If TRB->CONVENIO > 0
				nParcelas ++
				aAdd(aTemp, "CONVENIO")
			Endif
			
			If TRB->VALES > 0
				nParcelas ++
				aAdd(aTemp, "VALES")
			Endif
			
			If TRB->FINANC > 0
				nParcelas ++
				aAdd(aTemp, "FINANC")
			Endif
			
			If TRB->CREDITO > 0
				nParcelas ++
				aAdd(aTemp, "CREDITO")
			Endif

			If lL1VLRPGDG .And. TRB->VLRPGDG > 0
				nParcelas ++
				aAdd(aTemp, "VLRPGDG")
			Endif

			If lL1VLRPGDG .And. TRB->VLRPGPX > 0
				nParcelas ++
				aAdd(aTemp, "VLRPGPX")
			Endif
			
			If TRB->OUTROS > 0
				nParcelas ++
				aAdd(aTemp, "OUTROS")
			Endif
			
			If cPaisLoc == "BRA"
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Valida se o cliente recolhe ISS³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Verifica se esta usando a nova configuracao para confirmar se o cliente recolhera o iss.
				If SuperGetMV("MV_LJRECIS",,.F.) .And. SL1->( ColumnPos ( "L1_RECISS" ) ) > 0  
					lCliRecIss := TRB->C_RECISS == "1" .AND. lMvDescISS .AND. !lpTPAbISS  	
				Else
					lCliRecIss :=  ( SA1->A1_RECISS == "1" .AND. lMvDescISS ) .AND. ! lpTPAbISS  					
				EndIf
				
				If lCliRecIss
					RecLock("TRB",.F.)
					For nX := 1 To Len( aTemp )
						FieldPut( ColumnPos( aTemp[nX] ), ( FieldGet( ColumnPos( aTemp[nX] ) ) + Round( ( VALISS / nParcelas ), 2) ) )
						nRestDiv += Round( ( VALISS / nParcelas ), 2 )
					Next nX
					
					If nRestDiv <> VALISS
						FieldPut( ColumnPos( aTemp[nX] ), ( FieldGet( ColumnPos( aTemp[nX] ) ) - ( nRestDiv - VALISS ) ) )
					Endif
					MsUnLock()
				Endif
			EndIf
			
			TRB->(DbSkip())
		End
		
	Endif
	
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando Array aCampos com a estrutura do DBF         		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd( aCampos, {"LDEV","C",1,0} )
	
	aTam := TamSX3("L1_FILIAL")
	AAdd( aCampos, {"FILIAL","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_EMISNF")
	AAdd( aCampos, {"DTEMI","D",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_DOC")
	AAdd( aCampos, {"N_FISCAL","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_SERIE")
	AAdd( aCampos, {"SERIE","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_DOCPED")
	AAdd( aCampos, {"N_FISCPED","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_SERPED")
	AAdd( aCampos, {"SERPED","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VEND")
	AAdd( aCampos, {"VENDED","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("A3_NREDUZ")
	AAdd( aCampos, {"NOME","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CLIENTE")
	AAdd( aCampos, {"CLIENTE","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_LOJA")
	AAdd( aCampos, {"LOJA","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("A1_NREDUZ")
	AAdd( aCampos, {"NOM_CLI","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VLRTOT")
	AAdd( aCampos, {"VLRTOT","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_OPERADO")
	AAdd( aCampos, {"CAIXA","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_DINHEIR")
	AAdd( aCampos, {"DINHEIRO","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CHEQUES")
	AAdd( aCampos, {"CHEQUES","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CARTAO")
	AAdd( aCampos, {"CARTAO","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VLRDEBI")
	AAdd( aCampos, {"VLRDEBI","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CONVENI")
	AAdd( aCampos, {"CONVENIO","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VALES")
	AAdd( aCampos, {"VALES","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_FINANC")
	AAdd( aCampos, {"FINANC","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_OUTROS")
	AAdd( aCampos, {"OUTROS","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CREDITO")
	AAdd( aCampos, {"CREDITO","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VALISS")
	aAdd( aCampos, { "VALISS", "N", aTam[01], aTam[02] })
	
	aTam := TamSX3("L1_VLRTOT")
	AAdd( aCampos, {"DESCON","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VLRTOT")
	AAdd( aCampos, {"ACRES","N",aTam[1],aTam[2]} )
	
	If lVlrPisCof
		aTam := TamSX3("L1_ABTOPCC")
		AAdd( aCampos, {"ABTOPCC","N",aTam[1],aTam[2]} )
	Endif

	If lL1VLRPGDG
		aTam := TamSX3("L1_VLRPGDG")
		AAdd( aCampos, {"VLRPGDG","N",aTam[1],aTam[2]} )

		aTam := TamSX3("L1_VLRPGPX")
		AAdd( aCampos, {"VLRPGPX","N",aTam[1],aTam[2]} )
	Endif
	
	If cPaisLoc <> "BRA"
		aTam := TamSX3("L1_MOEDA")
		AAdd( aCampos, {"MOEDA","N",aTam[1],aTam[2]} )	
		AAdd( aCampos, {"LAYAWAY","C",1,0} )		
		AAdd( aCampos, {"HISTOR","C",3,0} )		
	Endif
	
	If lTroco
		aTam := TamSX3("L1_TROCO1")
		AAdd( aCampos, {"TROCO","N",aTam[1],aTam[2]} )
	EndIf

	oTblmp := LjCrTmpTbl("TRB", aCampos)
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abertura dos arquivos a serem utilizados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea( "TRB" )
	
	DbSelectArea( "SA1" )
	DbSetOrder( 1 )
	
	DbSelectArea( "SA3" )
	DbSetOrder( 1 )
	
	DbSelectArea( "SL2" )
	DbSetOrder( 1 )
	
	DbSelectArea( "SL1" )
	DbSetOrder( 1 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Selecionando os registros para filtro no arquivo.     		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SL1->L1_FILIAL >= '"+MV_PAR01+"' .AND. SL1->L1_FILIAL <= '"+MV_PAR02+"' .AND. "
	cQuery += "(((SL1->L1_TIPO == 'V' .AND. SL1->L1_DOC<>'"+cDoc2+"'  .AND. " 
	cQuery += "SL1->L1_ORCRES=='"+cOrcres2+"') .OR. (SL1->L1_TIPO == 'P' .AND. SL1->L1_DOCPED<>'"+cDocped2+"' ))) .AND. "
	cQuery += "DtoS(SL1->L1_EMISNF)  >= '"+DtoS(MV_PAR03)+"' .AND. DtoS(SL1->L1_EMISNF) <= '"+DtoS(MV_PAR04)+"' .AND. "
	cQuery += "SL1->L1_OPERADO >= '"+MV_PAR05+"' .AND. SL1->L1_OPERADO <= '"+MV_PAR06+"'"
	If cPaisLoc $ "POR|EUA"
		cQuery += " .AND. L1_CONDPG <> 'LAY' "	  //Desprezar as finalizacoes de Lay-Away
	Endif   
	
	If lUsaNMov 
		cQuery += " .AND. L1_NUMMOV =  '" + MV_PAR11 + "' "
	EndIf

	cIndSL1 := CriaTrab( NIL, .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtrando orcamento conforme informacoes do parametro.		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IndRegua("SL1",cIndSL1,IndexKey(),,cQuery)
	dbGotop()
	
	ProcRegua( Reccount() )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando arquivo temporario.                           		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do While !Eof()
		
		IncProc(STR0007)//"Selecionando registros para impressão..."
		
		If ! SA1->( DbSeek( xFilial( "SA1" ) + SL1->L1_CLIENTE + SL1->L1_LOJA ) )
			DbSkip()
			Loop
		Endif
		
		If ! SA3->( DbSeek( xFilial( "SA3" ) + SL1->L1_VEND ) )
			DbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se nao for Brasil, verifica as casas decimais da moeda selecionada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc <> "BRA"
			nMoeda  := Max(SL1->L1_MOEDA,1)
			nDecs   := MsDecimais(mv_par09)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Nao Imprimir outras moedas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par10 == 2
				If SL1->L1_MOEDA <> mv_par09
					DbSkip()
					Loop
				Endif
			Endif
			
			If lTroco
				For nY := 1 to MoedFin()
					cCampoTr  := "L1_TROCO" + AllTrim( Str ( nY ) )
					
					If SL1->( ColumnPos ( cCampoTr ) ) > 0
						nVlrTroco  += Round( xMoeda( & ( cCampoTr ),nY ,mv_par09 ,SL1->L1_EMISSAO ,nDecs + 1 ),nDecs )
					Endif
					
				Next nY
			Endif
			
		Else     
		
			If lTroco .AND. SL1->( ColumnPos ( "L1_TROCO1" ) ) > 0
				nVlrTroco  += Round( xMoeda( & ( "L1_TROCO1" ),nMoeda ,mv_par09 ,SL1->L1_EMISSAO ,nDecs + 1 ),nDecs )
			Endif
		
		Endif
		
		DbSelectArea( "SL2" )
		If ! DbSeek( cSeekWhile := SL1->L1_FILIAL + SL1->L1_NUM )
			DbSelectArea( "SL1" )
			DbSkip()
			Loop
		Endif
		
		nValDesc   := 0
		nValDProp  := 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazenando informacoes de desconto e desc. proporcional.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While cSeekWhile == L2_FILIAL + L2_NUM .AND. !Eof()
			
			nValDesc   += L2_VALDESC
			nValDProp  += L2_DESCPRO
			
			DbSkip()
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravando Arquivo Temporario.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea( "TRB" )
		RecLock( "TRB", .T. )
		
		REPLACE LDEV           With " "
		REPLACE FILIAL         With SL1->L1_FILIAL
		REPLACE DTEMI          With SL1->L1_EMISNF
		REPLACE N_FISCAL       With SL1->L1_DOC
		REPLACE SERIE          With SL1->L1_SERIE
		REPLACE N_FISCPED      With SL1->L1_DOCPED
		REPLACE SERPED         With SL1->L1_SERPED
		REPLACE VENDED         With SL1->L1_VEND
		REPLACE NOME           With SA3->A3_NREDUZ
		REPLACE CLIENTE        With SL1->L1_CLIENTE
		REPLACE LOJA           With SL1->L1_LOJA
		REPLACE NOM_CLI        With SA1->A1_NREDUZ
		REPLACE VLRTOT         With SL1->L1_VLRTOT
		REPLACE CAIXA          With SL1->L1_OPERADO
		
		// Venda balcão não grava nada qdo tem abatimento total do PIS/COFINS/CSLL já o venda assistida grava no
		// L1_OUTROS. Por isso esse processo para colocar o que foi abatido no campo L1_DINHEIR.
		If	  	SL1->( ColumnPos( "L1_ABTOPCC" ) ) > 0 .AND. ( SL1->L1_DINHEIR + SL1->L1_CHEQUES	+ SL1->L1_CARTAO + SL1->L1_VLRDEBI + ;
				SL1->L1_CONVENI + SL1->L1_VALES	+ SL1->L1_FINANC + SL1->L1_CREDITO ) == 0 	.AND. ;
				( SL1->L1_OUTROS == SL1->L1_ABTOPCC .OR. SL1->L1_OUTROS == 0 )
			
			If SL1->L1_OUTROS == 0
				REPLACE DINHEIRO	With SL1->L1_ABTOPCC
			Else
				REPLACE DINHEIRO	With SL1->L1_OUTROS
			Endif
			
			REPLACE OUTROS	With 0
			
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida se existe o campo troco, caso nao tenha valida ³
			//³se o valor liquido eh mairo que o valor em dinheiro   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc == "BRA"
				If  ( SL1->( ColumnPos( "L1_TROCO1" ) ) > 0 )
					REPLACE DINHEIRO	With (SL1->L1_DINHEIR - SL1->L1_TROCO1)
				Else
					REPLACE DINHEIRO	With SL1->L1_DINHEIR
				Endif
			Else
				REPLACE DINHEIRO	With SL1->L1_DINHEIR
			Endif

			REPLACE OUTROS         With SL1->L1_OUTROS

		Endif
		
		REPLACE CHEQUES		With SL1->L1_CHEQUES
		REPLACE CARTAO		With SL1->L1_CARTAO
		REPLACE VLRDEBI		With SL1->L1_VLRDEBI
		REPLACE CONVENIO	With SL1->L1_CONVENI
		REPLACE VALES		With SL1->L1_VALES
		REPLACE FINANC		With SL1->L1_FINANC
		REPLACE CREDITO		With SL1->L1_CREDITO
		REPLACE VALISS		With SL1->L1_VALISS
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Alterado o calculo do acrescimo devido a mudanca de³
		//³conceito na gravacao dos totais da venda.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		REPLACE ACRES		WITH SL1->L1_VALBRUT + (nValDesc + nValDProp) - SL1->L1_VALMERC
		REPLACE DESCON		With nValDesc + nValDProp

		If lL1VLRPGDG
			REPLACE VLRPGDG	With SL1->L1_VLRPGDG
			REPLACE VLRPGPX	With SL1->L1_VLRPGPX
		Endif
		
		If lVlrPisCof
			REPLACE ABTOPCC	With SL1->L1_ABTOPCC
		Endif
		
		nParcelas := 0
		nRestDiv  := 0
		aTemp     := {}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava no array aTemp as formas de pagamento ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->DINHEIRO > 0
			nParcelas ++
			aAdd(aTemp, "DINHEIRO")
		Endif
		
		If TRB->CHEQUES > 0
			nParcelas ++
			aAdd(aTemp, "CHEQUES")
		Endif
		
		If TRB->CARTAO > 0
			nParcelas ++
			aAdd(aTemp, "CARTAO")
		Endif
		
		If TRB->VLRDEBI > 0
			nParcelas ++
			aAdd(aTemp, "VLRDEBI")
		Endif
		
		If TRB->CONVENIO > 0
			nParcelas ++
			aAdd(aTemp, "CONVENIO")
		Endif
		
		If TRB->VALES > 0
			nParcelas ++
			aAdd(aTemp, "VALES")
		Endif
		
		If TRB->FINANC > 0
			nParcelas ++
			aAdd(aTemp, "FINANC")
		Endif
		
		If TRB->CREDITO > 0
			nParcelas ++
			aAdd(aTemp, "CREDITO")
		Endif

		If lL1VLRPGDG .And. TRB->VLRPGDG > 0
			nParcelas ++
			aAdd(aTemp, "VLRPGDG")
		Endif

		If lL1VLRPGPX .And. TRB->VLRPGPX > 0
			nParcelas ++
			aAdd(aTemp, "VLRPGPX")
		Endif
		
		If TRB->OUTROS > 0
			nParcelas ++
			aAdd(aTemp, "OUTROS")
		Endif
		
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
		
		// Verifica se esta usando a nova configuracao para confirmar se o cliente recolhera o iss.
		If SuperGetMV("MV_LJRECIS",,.F.) .And. SL1->( ColumnPos ( "L1_RECISS" ) ) > 0  
			lCliRecIss := TRB->C_RECISS == "1" .AND. lMvDescISS .AND. ! lpTPAbISS  	
		Else
			lCliRecIss :=  ( SA1->A1_RECISS == "1" .AND. lMvDescISS ) .AND. ! lpTPAbISS  					
		EndIf
			
		If lCliRecIss
			For nX := 1 To Len(aTemp)
				
				TRB->(FieldPut(ColumnPos(aTemp[nX]), ( FieldGet(ColumnPos(aTemp[nX])) + Round(( VALISS / nParcelas ), 2) )))
				
				nRestDiv += Round(( TRB->VALISS / nParcelas ), 2)
				
			Next nX
			
			If nRestDiv <> VALISS
				FieldPut(ColumnPos(aTemp[nX]), ( FieldGet(ColumnPos(aTemp[nX])) - ( nRestDiv - TRB->VALISS ) ))
			Endif
			
		Endif
		
		If cPaisLoc <> "BRA"
			REPLACE MOEDA	WITH nMoeda		
		Endif
		
		If lTroco
			REPLACE TROCO	WITH nVlrTroco
		Endif
		
		MsUnlock()
		
		DbSelectArea( "SL1" )
		DbSkip()
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apagando indice temporario.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	FErase( cIndSL1 + OrdBagExt() )
	RetIndex( "SL1" )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebimento por Lay-Away(Porto Rico/EUA)      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc $ "POR|EUA"
		
		DbSelectArea( "SLO" )
		DbSetOrder( 1 )
		
		DbSelectArea( "SLP" )
		DbSetOrder( 3 )
		
		DbSelectArea( "SE5" )
		DbSetOrder( 1 )
		
		cQuery := "DTOS(SE5->E5_DATA) >= '"  + DtoS(MV_PAR03) 	+ "' .AND. DTOS(SE5->E5_DATA) <= '"	+ DtoS(MV_PAR04)	+ "' "
		cQuery += ".AND. SE5->E5_BANCO >= '" + MV_PAR05			+ "' .AND. SE5->E5_BANCO <= '"		+ MV_PAR06			+ "' "
		cQuery += ".AND. (SE5->E5_PREFIXO = '"+ &(cMVLWPREF1) +"' .AND. SE5->E5_TIPO = 'RA ' .AND. SE5->E5_RECPAG = 'R' .AND. SE5->E5_TIPODOC = 'RA')"    //LayAway - recebimento
		
		cIndSE5 := CriaTrab( NIL, .F. )
		
		IndRegua("SE5",cIndSE5,IndexKey(),,cQuery)
		dbGotop()
		
		ProcRegua( Reccount() )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gerando arquivo temporario.                           		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof()
			
			IncProc(STR0007)//"Selecionando registros para impressão..."
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se nao encontrar o registro correspondente no SLP, verificar no SLO.³
			//³Deve considerar os Lay-Aways cancelados(LO_STATUS='4')              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lSLOExcl  := !SLO->(DbSeek(xFilial("SLO")+Trim(SE5->E5_NUMERO)))
			lSLPExcl  := !SLP->(DbSeek(xFilial("SLP")+SE5->E5_PREFIXO+Trim(SE5->E5_NUMERO)+SE5->E5_PARCELA))
			
			If lSLPExcl .AND. ( lSLOExcl .OR. ( !lSLOExcl .AND. SLO->LO_STATUS <> "4" ) )
				DbSkip()
				Loop
			Endif
			
			If !lSLPExcl .AND. !SLO->( DbSeek ( xFilial( "SLO" ) + SLP->LP_NUMLAY ) )
				DbSkip()
				Loop
			Endif
			
			If SLO->LO_FILIAL < mv_par01 .OR. SLO->LO_FILIAL > mv_par02
				DbSkip()
				Loop
			Endif
			
			If !SA1->( DbSeek ( xFilial ( "SA1" ) + SE5->E5_CLIFOR + SE5->E5_LOJA ) )
				DbSkip()
				Loop
			Endif
			
			nMoeda  := Max( SLO->LO_MOEDA,1 )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Nao Imprimir outras moedas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par10 == 2
				If SLO->LO_MOEDA <> mv_par09
					DbSkip()
					Loop
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravando Arquivo Temporario.                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea( "TRB" )
			RecLock( "TRB", .T. )
			
			REPLACE LDEV           With " "
			REPLACE FILIAL         With SLO->LO_FILIAL
			REPLACE DTEMI          With SE5->E5_DATA
			REPLACE N_FISCAL       With SLO->LO_NUMLAY
			REPLACE SERIE          With SE5->E5_PREFIXO
		
			REPLACE N_FISCPED      With Space(nTamDocPed)
			REPLACE SERPED         With Space(nTamSerPed)
			
			REPLACE VENDED         With Space(nTamVend)
			REPLACE NOME           With Space(nTamNome)
			REPLACE CLIENTE        With SLO->LO_CLIENTE
			REPLACE LOJA           With SLO->LO_LOJA
			REPLACE NOM_CLI        With SA1->A1_NREDUZ
			REPLACE VLRTOT         With SE5->E5_VALOR
			REPLACE CAIXA          With SE5->E5_BANCO
			
			REPLACE DINHEIRO       With 0.00
			REPLACE CHEQUES        With 0.00
			REPLACE CARTAO         With 0.00
			REPLACE VLRDEBI        With 0.00
			REPLACE CONVENIO       With 0.00
			REPLACE VALES          With 0.00
			REPLACE FINANC         With 0.00
			REPLACE OUTROS         With 0.00
			REPLACE CREDITO        With 0.00
			REPLACE VALISS         With 0.00
			REPLACE DESCON         With 0.00
			REPLACE ACRES          With 0.00
			REPLACE MOEDA          With nMoeda
			REPLACE LAYAWAY        With 'S'
			REPLACE HISTOR         With Substr(SE5->E5_HISTOR,1,3)

			If lL1VLRPGDG
                REPLACE VLRPGDG    With 0.00
				REPLACE VLRPGPX    With 0.00
            Endif
			
			MsUnlock()
			
			DbSelectArea( "SE5" )
			DbSkip()
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apagando indice temporario.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FErase( cIndSE5 + OrdBagExt() )
		RetIndex( "SE5" )
		
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificando se considera devolucoes.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR07 == 1
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abertura de arquivos com os indices                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea( "SD1" )
		DbSetOrder( 1 )
		
		DbSelectArea( "SF1" )
		DbSetOrder( 1 )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Selecionando parametros para filtro.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SF1->F1_FILIAL  >= '"+MV_PAR01+"' .AND. SF1->F1_FILIAL <= '"+MV_PAR02+"' .AND. "
		cQuery += "DtoS(SF1->F1_EMISSAO) >= '"+DtoS(MV_PAR03)+"' .AND. DtoS(SF1->F1_EMISSAO) <= '"+DtoS(MV_PAR04)+"' .AND. "
		cQuery += "SF1->F1_TIPO == 'D' "
  
		If lUsaSF1NMov 
			cQuery += " .AND. F1_NUMMOV =  '" + MV_PAR11 + "'"
		EndIf
				
		cIndSF1 := CriaTrab( NIL, .F. )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtrando as notas de entrada.                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IndRegua( "SF1",cIndSF1,IndexKey(),,cQuery )
		dbGotop()
		
		ProcRegua( RecCount() )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Varrendo as informacoes de documento de entrada.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof()
			
			IncProc(STR0007)//"Selecionando registros para impressão..."
			
			If ! SA1->( DbSeek( xFilial( "SA1" ) + SF1->F1_FORNECE + SF1->F1_LOJA ) )
				DbSkip()
				Loop
			Endif
			
			If cPaisLoc <> "BRA"
				nMoeda  := Max(SF1->F1_MOEDA,1)
				If mv_par10 == 2  //Nao Imprimir outras moedas
					If SF1->F1_MOEDA <> mv_par09
						DbSkip()
						Loop
					Endif
				Endif
			Endif
			
			DbSelectArea( "SD1" )
			If ! DbSeek( cSeekWhile := SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ) .Or. (lEstorno .And. !Empty(SD1->D1_OPERADO))
				DbSelectArea( "SF1" )
				DbSkip()
				Loop
			Endif
			
			If ( SubStr(D1_NUMCQ,1,3) < MV_PAR05 .OR. SubStr(D1_NUMCQ,1,3) > MV_PAR06 ) .OR. (D1_ORIGLAN <> "LO")
				DbSelectArea( "SF1" )
				DbSkip()
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravacao do arquivo temporario.                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea( "TRB" )
			RecLock( "TRB" , .T. )
			
			REPLACE LDEV           With "|"
			REPLACE FILIAL         With SF1->F1_FILIAL
			REPLACE DTEMI          With SF1->F1_EMISSAO
			REPLACE N_FISCAL       With SF1->F1_DOC
			REPLACE SERIE          With SF1->F1_SERIE
			REPLACE N_FISCPED      With Space(nTamDocPed)
			REPLACE SERPED         With Space(nTamSerPed)
			REPLACE VENDED         With Space(nTamVend)
			REPLACE NOME           With Space(nTamNome)
			REPLACE CLIENTE        With SF1->F1_FORNECE
			REPLACE LOJA           With SF1->F1_LOJA
			REPLACE NOM_CLI        With SA1->A1_NREDUZ
			REPLACE CAIXA          With SubStr(SD1->D1_NUMCQ,1,3)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se tem apuração de PIS/COFINS/CSLL, pego o percentual dos valores na tabela SL2 e faço o proporcional ³
			//³para a devolução, caso não use, o total é dado pela soma do valor bruto com o valor do ipi da tab. SF1³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaPCC
				
				SD2->(DbSetOrder(3))
				SL2->(DbSetOrder(3))
				
				DbSelectArea( "TRB" )
				REPLACE VLRTOT With 0
				
				While	SD1->D1_FILIAL	== xFilial("SD1")	.AND. SD1->D1_DOC		== SF1->F1_DOC		.AND.;
					SD1->D1_SERIE	== SF1->F1_SERIE	.AND. SD1->D1_FORNECE	== SF1->F1_FORNECE	.AND.;
					SD1->D1_LOJA	== SF1->F1_LOJA		.AND. !SD1->(EOF() )
					
					nTotal := ( SD1->D1_TOTAL - SD1->D1_VALDESC )
					
					If SD2->(DbSeek(xFilial("SD2") + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI))
						
						If SL2->(DbSeek(xFilial("SL2") + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_COD))
							
							While SL2->L2_Filial == xFilial("SL2") .AND. SL2->L2_SERIE == SD2->D2_SERIE .AND. ;
								SL2->L2_DOC == SD2->D2_DOC .AND. SL2->L2_PRODUTO == SD2->D2_COD .AND. ! SL2->(EOF())
								
								If SL2->L2_ITEM == SD2->D2_ITEMPV
									
									DbSelectArea( "TRB" )
									
									nPerc  := ( ( SL2->L2_VALPIS / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									nPerc  := ( ( SL2->L2_VALCOFI / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									nPerc  := ( ( SL2->L2_VALCSLL / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									REPLACE VLRTOT  With ( VLRTOT + nTotal )
									Exit
									
								Endif
								
								SL2->(DbSkip())
								
							End
							
						Endif
						
					Endif
					
					SD1->(DbSkip())
					
				End
				
			Endif
			
			DbSelectArea("TRB")
			
			If ! (	TRB->( ColumnPos( "VALPIS" ) ) > 0 .AND. TRB->( ColumnPos( "VALCOFI" ) ) > 0 .AND.;
				TRB->( ColumnPos( "VALCSLL" ) ) > 0 )
				
				REPLACE VLRTOT With ( SF1->F1_VALBRUT + SF1->F1_VALIPI )
				
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava conteudo no arquivo temporario³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			REPLACE DINHEIRO       With 0.00
			REPLACE CHEQUES        With 0.00
			REPLACE CARTAO         With 0.00
			REPLACE VLRDEBI        With 0.00
			REPLACE CONVENIO       With 0.00
			REPLACE VALES          With 0.00
			REPLACE FINANC         With 0.00
			REPLACE OUTROS         With 0.00
			REPLACE CREDITO        With 0.00
			REPLACE VALISS         With 0.00
			REPLACE DESCON         With 0.00
			REPLACE ACRES          With 0.00

			If lL1VLRPGDG
                REPLACE VLRPGDG    With 0.00
				REPLACE VLRPGPX    With 0.00
            Endif
			
			If cPaisLoc <> "BRA"
				REPLACE MOEDA       With nMoeda
			Endif
			
			MsUnlock()
			
			DbSelectArea( "SF1" )
			DbSkip()
			
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apagando indice temporario.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FErase( cIndSF1 + OrdBagExt() )
		RetIndex( "SF1" )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancelamento do Lay-Away(Porto Rico/EUA)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc $ "POR|EUA"
			
			DbSelectArea( "SLO" )
			DbSetOrder( 1 )
			
			DbSelectArea( "SA1" )
			DbSetOrder( 1 )
			
			DbSelectArea( "SE5" )
			DbSetOrder( 1 )
			
			cQuery := "DTOS(SE5->E5_DATA) >= '"+DtoS(MV_PAR03)+"' .AND. DTOS(SE5->E5_DATA) <= '"+DtoS(MV_PAR04)+"' .AND. "
			cQuery += "SE5->E5_BANCO >= '"+MV_PAR05+"' .AND. SE5->E5_BANCO <= '"+MV_PAR06+"' .AND. "
			cQuery += "(SE5->E5_PREFIXO = '"	+ &(cMVLWPREF1) + "' .AND. SE5->E5_TIPO = 'RA ' .AND. SE5->E5_RECPAG = 'P' .AND. SE5->E5_TIPODOC = 'VL')"    //LayAway - cancelamento
			
			cIndSE5 := CriaTrab( NIL, .F. )
			
			IndRegua("SE5",cIndSE5,IndexKey(),,cQuery)
			dbGotop()
			
			ProcRegua( Reccount() )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gerando arquivo temporario.                           		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While !Eof()
				
				IncProc(STR0007)//"Selecionando registros para impressão..."
				
				If !SLO->(DbSeek(xFilial("SLO")+Trim(SE5->E5_NUMERO)))
					DbSkip()
					Loop
				Endif
				
				If !SA1->(DbSeek(xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA))
					DbSkip()
					Loop
				Endif
				
				nMoeda  := Max(SLO->LO_MOEDA,1)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Nao Imprimir outras moedas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par10 == 2
					If SLO->LO_MOEDA <> mv_par09
						DbSkip()
						Loop
					Endif
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravacao do arquivo temporario.                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea( "TRB" )
				RecLock( "TRB" , .T. )
				
				REPLACE LDEV           With "|"
				REPLACE FILIAL         With SE5->E5_FILIAL
				REPLACE DTEMI          With SE5->E5_DATA
				REPLACE N_FISCAL       With SE5->E5_NUMERO
				REPLACE SERIE          With SE5->E5_PREFIXO
				REPLACE N_FISCPED      With Space(nTamDocPed)
				REPLACE SERPED         With Space(nTamSerPed)
				REPLACE VENDED         With Space(nTamVend)
				REPLACE NOME           With Space(nTamNome)
				REPLACE CLIENTE        With SE5->E5_CLIFOR
				REPLACE LOJA           With SE5->E5_LOJA
				REPLACE NOM_CLI        With SA1->A1_NREDUZ
				REPLACE VLRTOT         With SE5->E5_VALOR
				REPLACE CAIXA          With SE5->E5_BANCO
				
				REPLACE DINHEIRO       With 0.00
				REPLACE CHEQUES        With 0.00
				REPLACE CARTAO         With 0.00
				REPLACE VLRDEBI        With 0.00
				REPLACE CONVENIO       With 0.00
				REPLACE VALES          With 0.00
				REPLACE FINANC         With 0.00
				REPLACE OUTROS         With 0.00
				REPLACE CREDITO        With 0.00
				REPLACE VALISS         With 0.00
				REPLACE DESCON         With 0.00
				REPLACE ACRES          With 0.00
				REPLACE MOEDA          With nMoeda
				REPLACE LAYAWAY        With 'S'
				REPLACE HISTOR         With '   '

				If lL1VLRPGDG
                    REPLACE VLRPGDG    With 0.00
					REPLACE VLRPGPX    With 0.00
                Endif
				
				MsUnlock()
				
				DbSelectArea( "SE5" )
				DbSkip()
			End
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apagando indice temporario.                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FErase( cIndSE5 + OrdBagExt() )
			RetIndex( "SE5" )
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificando se considera estorno   .                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR07 == 1 .and. lEstorno
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abertura de arquivos com os indices                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea( "SD1" )
		DbSetOrder( 1 )
		
		DbSelectArea( "SF1" )
		DbSetOrder( 1 )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Selecionando parametros para filtro.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SF1->F1_FILIAL  >= '"+MV_PAR01+"' .AND. SF1->F1_FILIAL <= '"+MV_PAR02+"' .AND. "
		cQuery += "DtoS(SF1->F1_EMISSAO) >= '"+DtoS(MV_PAR03)+"' .AND. DtoS(SF1->F1_EMISSAO) <= '"+DtoS(MV_PAR04)+"' .AND. "
		cQuery += "SF1->F1_TIPO == 'D' " 
		
		If lUsaNMov 
			cQuery += " .AND. F1_NUMMOV =  '" + MV_PAR11 + "' "
		EndIf
		
		cIndSF1 := CriaTrab( NIL, .F. )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtrando as notas de entrada.                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IndRegua( "SF1",cIndSF1,IndexKey(),,cQuery )
		dbGotop()
		
		ProcRegua( RecCount() )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Varrendo as informacoes de documento de entrada.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof()
			
			IncProc(STR0007)//"Selecionando registros para impressão..."
			
			If ! SA1->( DbSeek( xFilial( "SA1" ) + SF1->F1_FORNECE + SF1->F1_LOJA ) )
				DbSkip()
				Loop
			Endif
			
			If cPaisLoc <> "BRA"
				nMoeda  := Max(SF1->F1_MOEDA,1)
				If mv_par10 == 2  //Nao Imprimir outras moedas
					If SF1->F1_MOEDA <> mv_par09
						DbSkip()
						Loop
					Endif
				Endif
			Endif
			
			DbSelectArea( "SD1" )
			If ! DbSeek( cSeekWhile := SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ) .Or. (SD1->D1_OPERADO < MV_PAR05 .or. SD1->D1_OPERADO > MV_PAR06 )
				DbSelectArea( "SF1" )
				DbSkip()
				Loop
			Endif
			

			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravacao do arquivo temporario.                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea( "TRB" )
			RecLock( "TRB" , .T. )
			
			REPLACE LDEV           With "+"
			REPLACE FILIAL         With SF1->F1_FILIAL
			REPLACE DTEMI          With SF1->F1_EMISSAO
			REPLACE N_FISCAL       With SF1->F1_DOC
			REPLACE SERIE          With SF1->F1_SERIE
			REPLACE N_FISCPED      With Space(nTamDocPed)
			REPLACE SERPED         With Space(nTamSerPed)
			REPLACE VENDED         With Space(nTamVend)
			REPLACE NOME           With Space(nTamNome)
			REPLACE CLIENTE        With SF1->F1_FORNECE
			REPLACE LOJA           With SF1->F1_LOJA
			REPLACE NOM_CLI        With SA1->A1_NREDUZ
			REPLACE CAIXA          With SD1->D1_OPERADO
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se tem apuração de PIS/COFINS/CSLL, pego o percentual dos valores na tabela SL2 e faço o proporcional ³
			//³para a devolução, caso não use, o total é dado pela soma do valor bruto com o valor do ipi da tab. SF1³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaPCC
				
				SD2->(DbSetOrder(3))
				SL2->(DbSetOrder(3))
				
				DbSelectArea( "TRB" )
				REPLACE VLRTOT With 0
				
				While	SD1->D1_FILIAL	== xFilial("SD1")	.AND. SD1->D1_DOC		== SF1->F1_DOC		.AND.;
					SD1->D1_SERIE	== SF1->F1_SERIE	.AND. SD1->D1_FORNECE	== SF1->F1_FORNECE	.AND.;
					SD1->D1_LOJA	== SF1->F1_LOJA		.AND. !SD1->(EOF() )
					
					nTotal := ( SD1->D1_TOTAL - SD1->D1_VALDESC )
					
					If SD2->(DbSeek(xFilial("SD2") + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI))
						
						If SL2->(DbSeek(xFilial("SL2") + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_COD))
							
							While SL2->L2_Filial == xFilial("SL2") .AND. SL2->L2_SERIE == SD2->D2_SERIE .AND. ;
								SL2->L2_DOC == SD2->D2_DOC .AND. SL2->L2_PRODUTO == SD2->D2_COD .AND. ! SL2->(EOF())
								
								If SL2->L2_ITEM == SD2->D2_ITEMPV
									
									DbSelectArea( "TRB" )
									
									nPerc  := ( ( SL2->L2_VALPIS / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									nPerc  := ( ( SL2->L2_VALCOFI / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									nPerc  := ( ( SL2->L2_VALCSLL / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									REPLACE VLRTOT  With ( VLRTOT + nTotal )
									Exit
									
								Endif
								
								SL2->(DbSkip())
								
							End
							
						Endif
						
					Endif
					
					SD1->(DbSkip())
					
				End
				
			Endif
			
			DbSelectArea("TRB")
			
			If ! (	TRB->( ColumnPos( "VALPIS" ) ) > 0 .AND. TRB->( ColumnPos( "VALCOFI" ) ) > 0 .AND.;
				TRB->( ColumnPos( "VALCSLL" ) ) > 0 )
				
				REPLACE VLRTOT With ( SF1->F1_VALBRUT + SF1->F1_VALIPI )
				
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava conteudo no arquivo temporario³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			REPLACE DINHEIRO       With 0.00
			REPLACE CHEQUES        With 0.00
			REPLACE CARTAO         With 0.00
			REPLACE VLRDEBI        With 0.00
			REPLACE CONVENIO       With 0.00
			REPLACE VALES          With 0.00
			REPLACE FINANC         With 0.00
			REPLACE OUTROS         With 0.00
			REPLACE CREDITO        With 0.00
			REPLACE VALISS         With 0.00
			REPLACE DESCON         With 0.00
			REPLACE ACRES          With 0.00

			If lL1VLRPGDG
                REPLACE VLRPGDG    With 0.00
				REPLACE VLRPGPX    With 0.00
            Endif
			
			If cPaisLoc <> "BRA"
				REPLACE MOEDA       With nMoeda
			Endif
			
			MsUnlock()
			
			DbSelectArea( "SF1" )
			DbSkip()
			
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apagando indice temporario.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FErase( cIndSF1 + OrdBagExt() )
		RetIndex( "SF1" )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancelamento do Lay-Away(Porto Rico/EUA)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc $ "POR|EUA"
			
			DbSelectArea( "SLO" )
			DbSetOrder( 1 )
			
			DbSelectArea( "SA1" )
			DbSetOrder( 1 )
			
			DbSelectArea( "SE5" )
			DbSetOrder( 1 )
			
			cQuery := "DTOS(SE5->E5_DATA) >= '"+DtoS(MV_PAR03)+"' .AND. DTOS(SE5->E5_DATA) <= '"+DtoS(MV_PAR04)+"' .AND. "
			cQuery += "SE5->E5_BANCO >= '"+MV_PAR05+"' .AND. SE5->E5_BANCO <= '"+MV_PAR06+"' .AND. "
			cQuery += "(SE5->E5_PREFIXO = '"	+ &(cMVLWPREF1) + "' .AND. SE5->E5_TIPO = 'RA ' .AND. SE5->E5_RECPAG = 'P' .AND. SE5->E5_TIPODOC = 'VL')"    //LayAway - cancelamento
			
			cIndSE5 := CriaTrab( NIL, .F. )
			
			IndRegua("SE5",cIndSE5,IndexKey(),,cQuery)
			dbGotop()
			
			ProcRegua( Reccount() )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gerando arquivo temporario.                           		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While !Eof()
				
				IncProc(STR0007)//"Selecionando registros para impressão..."
				
				If !SLO->(DbSeek(xFilial("SLO")+Trim(SE5->E5_NUMERO)))
					DbSkip()
					Loop
				Endif
				
				If !SA1->(DbSeek(xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA))
					DbSkip()
					Loop
				Endif
				
				nMoeda  := Max(SLO->LO_MOEDA,1)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Nao Imprimir outras moedas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par10 == 2
					If SLO->LO_MOEDA <> mv_par09
						DbSkip()
						Loop
					Endif
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravacao do arquivo temporario.                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea( "TRB" )
				RecLock( "TRB" , .T. )
				
				REPLACE LDEV           With "+"
				REPLACE FILIAL         With SE5->E5_FILIAL
				REPLACE DTEMI          With SE5->E5_DATA
				REPLACE N_FISCAL       With SE5->E5_NUMERO
				REPLACE SERIE          With SE5->E5_PREFIXO
				REPLACE N_FISCPED      With Space(nTamDocPed)
				REPLACE SERPED         With Space(nTamSerPed)
				REPLACE VENDED         With Space(nTamVend)
				REPLACE NOME           With Space(nTamNome)
				REPLACE CLIENTE        With SE5->E5_CLIFOR
				REPLACE LOJA           With SE5->E5_LOJA
				REPLACE NOM_CLI        With SA1->A1_NREDUZ
				REPLACE VLRTOT         With SE5->E5_VALOR
				REPLACE CAIXA          With SE5->E5_BANCO
				
				REPLACE DINHEIRO       With 0.00
				REPLACE CHEQUES        With 0.00
				REPLACE CARTAO         With 0.00
				REPLACE VLRDEBI        With 0.00
				REPLACE CONVENIO       With 0.00
				REPLACE VALES          With 0.00
				REPLACE FINANC         With 0.00
				REPLACE OUTROS         With 0.00
				REPLACE CREDITO        With 0.00
				REPLACE VALISS         With 0.00
				REPLACE DESCON         With 0.00
				REPLACE ACRES          With 0.00
				REPLACE MOEDA          With nMoeda
				REPLACE LAYAWAY        With 'S'
				REPLACE HISTOR         With '   '

				If lL1VLRPGDG
                    REPLACE VLRPGDG    With 0.00
					REPLACE VLRPGPX    With 0.00
                Endif
				
				MsUnlock()
				
				DbSelectArea( "SE5" )
				DbSkip()
			End
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apagando indice temporario.                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FErase( cIndSE5 + OrdBagExt() )
			RetIndex( "SE5" )
		Endif
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Indexando arquivo temporario para emissao do relatorio.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea( "TRB" )
	IndRegua("TRB",cArqTmp,"FILIAL + DtoS(DTEMI) + CAIXA + LDEV")
Endif
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³Lj075SomCxºAutor  ³Fernando Salvatori  º Data ³  21/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que realiza a soma dos valores de sub total para o   º±±
±±º          ³caixa                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR075                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   ANALISTA   ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºNorbert Waage ³04/07/07³126641³Incluido o calculo e impressao do troco º±±
±±º              ³        ³      ³das vendas em dinheiro para o Brasil.   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Lj075SomCx( aTotCx, 	nVlrTot, 	aFormaImp, 	nMoeda,		;
							nDecs, 		nTotImps,  	lLayAway,	nVlrTroco)
Local nX := 0		//Controle de loop
Local lCliRecIss := .F. // Cliente Recolhe ISS ?

For nX := 1 to Len( aFormaImp )
	If !lLayAway
		aTotCx[nX] += Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
	Else
		If Trim(aFormaImp[nX][1]) == Trim(TRB->HISTOR) .OR. ;  //Valido para CH, CC, CD, FI, VA, etc
			(Trim(aFormaImp[nX][1])=="$$" .AND. IsMoney(TRB->HISTOR))  //Dinheiro
			aTotCx[nX] += 	Round(xMoeda(TRB->VLRTOT,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
		Else
			aTotCx[nX] += Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
		Endif
	Endif
	If (IsMoney(aFormaImp[nX][1]) .OR. Trim(aFormaImp[nX][1])=="$$") .AND. lTroco .AND. nVlrTroco > 0
		aTotCx[nX] -= nVlrTroco
	Endif
Next nX

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))

// Verifica se esta usando a nova configuracao para confirmar se o cliente recolhera o iss.
If SuperGetMV("MV_LJRECIS",,.F.)  .And. SL1->( ColumnPos ( "L1_RECISS" ) ) > 0
	lCliRecIss := TRB->C_RECISS == "1" .AND. lMvDescISS  	
Else
	lCliRecIss :=  ( SA1->A1_RECISS == "1" .AND. lMvDescISS )  					
EndIf

If lCliRecIss
	nVlrTot -= TRB->VALISS
Endif

aTotCx[06] += Round(xMoeda(( IIf(lVlrPisCof,TRB->ABTOPCC,0) + iIf( lCliRecIss, TRB->VALISS, 0 ) ),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
aTotCx[07] += Round(xMoeda(TRB->DESCON,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
If cPaisLoc == "BRA"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incluida validacao do acrescimo para nao ³
	//³permitir a impressao de valores negativos³
	//³quando a venda possuir desconto.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If TRB->ACRES > 0
		aTotCx[08] += Round(xMoeda(TRB->ACRES,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
	EndIf
Else
	aTotCx[08] += Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
Endif
aTotCx[09] += Round(xMoeda(TRB->CREDITO,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
aTotCx[10] += Round(xMoeda(nVlrTot,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Lj075SomToºAutor  ³Fernando Salvatori  º Data ³  21/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que realiza a soma dos valores de sub total para os  º±±
±±º          ³demais totalizadores (data,filial,total geral)              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR075                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Lj075SomTot(aTotWrite,aTotRead,aFormaImp)
Local nX := 0        //Contador

For nX := 1 To Len(aTotWrite)
	aTotWrite[nX] += aTotRead[nX]
Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LJ075Imps ºAutor  ³Fernando Machima    º Data ³  15/08/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calcula o total de impostos variaveis discriminados de uma º±±
±±º          ³ venda ou devolucao - Localizacoes                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR075                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ075Imps(cAliasArq)

LOCAL nX							//Controle de loop
LOCAL nImpostos  := 0				//Valor dos impostos
LOCAL aArea      := GetArea()		//Area atual
LOCAL aTesImpInf := {}				//Dados fiscais da Tes

If cAliasArq == "SL1"
	DbSelectArea("SL2")
	DbSetOrder(3)
	If DbSeek(xFilial("SL2")+TRB->SERIE+TRB->N_FISCAL)
		While !Eof() .AND. xFilial("SL2") == SL2->L2_FILIAL .AND. ;
			TRB->SERIE+TRB->N_FISCAL == SL2->L2_SERIE+SL2->L2_DOC
			
			aTesImpInf  := TesImpInf(SL2->L2_TES)
			For nX := 1 to Len(aTesImpInf)
				If aTesImpInf[nX][3] == "1"  //Incide na NF
					nImpostos  += SL2->(FieldGet(ColumnPos("L2_"+Substr(aTesImpInf[nX][2],4,7))))
				Endif
			Next nX
			
			DbSkip()
		End
	Endif
ElseIf cAliasArq == "SF1"
	DbSelectArea("SD1")
	DbSetOrder(1)
	If DbSeek(xFilial("SD1")+TRB->N_FISCAL+TRB->SERIE+TRB->CLIENTE+TRB->LOJA)
		While !Eof() .AND. xFilial("SD1") == SD1->D1_FILIAL .AND. ;
			TRB->N_FISCAL+TRB->SERIE+TRB->CLIENTE+TRB->LOJA == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
			
			aTesImpInf  := TesImpInf(SD1->D1_TES)
			For nX := 1 to Len(aTesImpInf)
				If aTesImpInf[nX][3] == "1"  //Incide na NF
					nImpostos  += SD1->(FieldGet(ColumnPos("D1_"+Substr(aTesImpInf[nX][2],4,7))))
				Endif
			Next nX
			
			DbSkip()
		End
	Endif
Endif

RestArea(aArea)

Return (nImpostos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LJ075aStruºAutor  ³Fernando Machima    º Data ³  15/08/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria o array com os campos Data e Numero para a execucao doº±±
±±º          ³ comando TCSetField                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR075                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpA1 - Array com a estrutura do arquivo de trabalho.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   ANALISTA   ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºNorbert Waage ³04/07/07³126641³Incluido o calculo e impressao do troco º±±
±±º              ³        ³      ³das vendas em dinheiro para o Brasil.   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ075aStru(aStruTRB)

LOCAL aTam  := {} 	//Vetor com os tamanhos de cada campo[tamanho,decimal]

aTam := TamSX3("L1_EMISNF")
AAdd( aStruTRB, {"DTEMI","D",aTam[1],aTam[2]} )

aTam := TamSX3("L1_VLRTOT")
AAdd( aStruTRB, {"VLRTOT","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_DINHEIR")
AAdd( aStruTRB, {"DINHEIRO","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_CHEQUES")
AAdd( aStruTRB, {"CHEQUES","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_CARTAO")
AAdd( aStruTRB, {"CARTAO","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_VLRDEBI")
AAdd( aStruTRB, {"VLRDEBI","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_CONVENI")
AAdd( aStruTRB, {"CONVENIO","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_VALES")
AAdd( aStruTRB, {"VALES","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_FINANC")
AAdd( aStruTRB, {"FINANC","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_OUTROS")
AAdd( aStruTRB, {"OUTROS","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_CREDITO")
AAdd( aStruTRB, {"CREDITO","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_DESCONT")
AAdd( aStruTRB, {"DESCON","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_DESCONT")
AAdd( aStruTRB, {"ACRES","N",aTam[1],aTam[2]} )

If lVlrPisCof
	aTam := TamSX3("L1_ABTOPCC")
	AAdd( aStruTRB, {"ABTOPCC","N",aTam[1],aTam[2]} )
Endif

If lL1VLRPGDG
	aTam := TamSX3("L1_VLRPGDG")
	AAdd( aStruTRB, {"VLRPGDG","N",aTam[1],aTam[2]} )

	aTam := TamSX3("L1_VLRPGPX")
	AAdd( aStruTRB, {"VLRPGPX","N",aTam[1],aTam[2]} )
Endif

If cPaisLoc <> "BRA"
	aTam := TamSX3("L1_MOEDA")
	AAdd( aStruTRB, {"MOEDA","N",aTam[1],aTam[2]} )
	
	If lTroco
		aTam := TamSX3("L1_TROCO1")
		AAdd( aStruTRB, {"TROCO1","N",aTam[1],aTam[2]} )
		
		aTam := TamSX3("L1_TROCO2")
		AAdd( aStruTRB, {"TROCO2","N",aTam[1],aTam[2]} )
		
		aTam := TamSX3("L1_TROCO3")
		AAdd( aStruTRB, {"TROCO3","N",aTam[1],aTam[2]} )
		
		aTam := TamSX3("L1_TROCO4")
		AAdd( aStruTRB, {"TROCO4","N",aTam[1],aTam[2]} )
		
		aTam := TamSX3("L1_TROCO5")
		AAdd( aStruTRB, {"TROCO5","N",aTam[1],aTam[2]} )
	Endif

Else
	If lTroco
		aTam := TamSX3("L1_TROCO1")
		AAdd( aStruTRB, {"TROCO1","N",aTam[1],aTam[2]} )
	EndIf
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ075SngTrºAutor  ³Fernando Salvatori  º Data ³ 15/10/2004  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retira os valores de sangria e entrada de troco de um      º±±
±±º          ³ determinado periodo.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpL1 -> .T. - Utiliza Query / .F. - Utiliza Codebase      º±±
±±º          ³ determinado periodo.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ aRet -> [1]: Valor da Sangria.                             º±±
±±º          ³         [2]: Valor da entrada de troco.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function LJ075SngTr(cDeFilSE5	, cAteFilSE5	, uDatAtu	, ;
					cBancoDe	, cBancoAte		, aSangria	, ;
					nTroco		, aFormaImp		)
Local lUsaQuery := .F. 			//Utiliza Query
Local cQuery    := ""  			//Query concatenada
Local nPosMoed  := 0   			//Posicao da moeda
Local aArea     := GetArea()	//Area atual 

Local dData		:= uDatAtu      //Data de Pesquisa da Sangria      
Local lUsaSE5NMo := Val(MV_PAR11) > 0 .AND. SE5->(ColumnPos("E5_NUMMOV")) > 0

aRet := Array(2)
AFill( aRet, 0 )

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lUsaQuery := .T.
	Endif
#Endif

//Selecionando registros na query
If lUsaQuery
	cQuery := "SELECT SE5.E5_DATA, SE5.E5_VALOR, SE5.E5_BANCO, SE5.E5_AGENCIA, SE5.E5_CONTA, SE5.E5_PREFIXO,"
	cQuery += " SE5.E5_NUMERO, SE5.E5_PARCELA, SE5.E5_TIPO, SE5.E5_TIPODOC, SE5.E5_CLIFOR, SE5.E5_LOJA, SE5.E5_SEQ,"
	cQuery += " SE5.E5_VENCTO, SE5.E5_MOEDA, SE5.E5_RECPAG"
	cQuery += " FROM " + RetSQLName("SE5") + " SE5"
	cQuery += " WHERE SE5.E5_FILIAL BETWEEN '" + cDeFilSE5 + "' AND '" + cAteFilSE5 + "'"
	If lUsaSE5NMo
		cQuery += " AND SE5.E5_NUMMOV = '" + MV_PAR11 + "' "
	EndIf
	cQuery += " AND SE5.E5_DATA = '" + DTos(dData)  + "'"
	cQuery += " AND SE5.E5_BANCO BETWEEN '" + cBancoDe + "' AND '" + cBancoAte + "'"
	cQuery += " AND SE5.E5_TIPODOC = 'TR' "
	cQuery += " AND (SE5.E5_SITUACA <> 'C' OR SE5.E5_MOEDA <> 'ES')"
	cQuery += " AND SE5.D_E_L_E_T_ = ' '"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'SE5TMP', .F., .T.)
	
	TCSetField("SE5TMP", "E5_DATA", "D")
	TCSetField("SE5TMP", "E5_VENCTO", "D")
	
	While !EOF()
		//Verifica se tem cancelamento para este titulo.
		If TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
			DbSkip()
			Loop
		Endif
		
		If ( AllTrim(E5_TIPO) $ ( MV_CRNEG + "/PA" ) ) .OR. E5_VENCTO > E5_DATA
			DbSkip()
			Loop
		Endif
		
		If E5_RECPAG == "P" // => Saldo inicial
			If (nPosMoed := aScan( aFormaImp,{ |x| x[1] == E5_MOEDA } )) > 0
				aSangria[nPosMoed] += E5_VALOR
			Endif
		ElseIf E5_RECPAG == "R" // => Saldo inicial
			nTroco += E5_VALOR
		Endif
		
		DbSkip()
		
	End
	
	DbSelectArea("SE5TMP")
	dbCloseArea()
Else
	DbSelectArea("SE5")
	DbSetOrder(1)
	DbSeek(cDeFilSE5 + DToS( dData ), .T. )	// Filial + Data
	
	While !EOF() .AND. E5_FILIAL >= cDeFilSE5 .AND. E5_FILIAL <= cAteFilSE5
		
		If !(DToS(E5_DATA) = DToS(dData) .AND. E5_BANCO  >= cBancoDe .AND. E5_BANCO  <= cBancoAte)
			DbSkip()
			Loop
		Endif
		
		IF E5_SITUACA == "C"
			// Estorno ou cancelado
			DbSkip()
			Loop
		Endif
		
		//Verifica se tem cancelamento para este titulo.
		#IFDEF TOP 
			If TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
		#ELSE 
			If LjBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) // Funcao LjBxCanc encontrada no fonte LOJC030.prx 
		#ENDIF 
			DbSkip()
			Loop
		Endif

		If ( AllTrim(E5_TIPO) $ ( MV_CRNEG + "/PA" ) ) .OR. E5_VENCTO > E5_DATA
			DbSkip()
			Loop
		Endif
		
		IF E5_TIPODOC <> "TR"
			DbSkip()
			Loop
		Endif  
		
		If lUsaSE5NMov .AND. !LJVldMov("SE5") 
			DbSkip()
			Loop
		EndIf
		
		If E5_RECPAG == "P" // => Saldo inicial
			If (nPosMoed := aScan( aFormaImp,{ |x| x[1] == E5_MOEDA } )) > 0
				aSangria[nPosMoed] += E5_VALOR
			Endif
		ElseIf E5_RECPAG == "R" // => Saldo inicial
			nTroco += E5_VALOR
		Endif
		
		DbSkip()
		
	End
Endif

RestArea(aArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Ljr075RptDefºAutor  ³Hanna             º Data ³  25/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para informar as celulas que serao utilizadas no re- º±±
±±º          ³latorio                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJA075                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ljr075RptDef()
Local oReport										// Objeto do relatorio
Local oSection1										// Objeto da secao 1
Local oSection2										// Objeto da secao 2
Local oSection3										// Objeto da secao 2
Local oSection4										// Objeto da secao 2
Local cAlias1		:= "SL1"						// Define o cAlias1 como SL1
Local cSimbMoeda	:= ""  							// Simbolo da Moeda da Venda

If cPaisLoc == "BRA"
	cSimbMoeda := "R$"
Else
	cSimbMoeda := "$$"
EndIf

#IFDEF TOP
	cAlias1 := GetNextAlias()						// Pega o proximo Alias Disponivel
#Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera a tela com os dados para a confirmação da geracao do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Mapa de Vendas
//"Este programa tem como objetivo imprimir relatorio "
//"de acordo com os parametros informados pelo usuario."
DEFINE REPORT oReport NAME "LOJR075" TITLE STR0003 PARAMETER "LJR075" ACTION {|oReport| Ljr075PrtRpt( oReport )} DESCRIPTION STR0001 + STR0002
oReport:SetLandscape()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, com quebra por filial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport TITLE STR0048 TABLES "SL1"	//"Cabeçalho do Orçamento"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "FILIAL"	OF oSection1 ALIAS "SL1" TITLE STR0047 SIZE 20	// Filial

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao2 do relatorio, com quebra por data de emissao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection2 OF oSection1 TITLE STR0049 TABLES "SL1" 	//"Quebra por data"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "DTEMI" OF oSection2 PICTURE "99/99/9999" SIZE 10 TITLE STR0011	// DATA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao3 do relatorio, com quebra por Operador - Caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection3 OF oSection2 TITLE STR0050 TABLES "SL1" //"Quebra por operador"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao3³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "CAIXA"	OF oSection3 TITLE STR0010 SIZE 3		// CX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao3 do relatorio -Vendas emitidas por Dia x Caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection4 OF oSection3 TITLE STR0051 TABLES "SL1"  	//"Vendas emitidas por Dia x Caixa"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "N_FISCAL"	OF oSection4 SIZE TAM_NFISC						TITLE STR0012	//"N.Fisc."
DEFINE CELL NAME "SERIE"	OF oSection4 SIZE TAM_SERIE						TITLE STR0013 	// "Ser."

//Não imprimimos o código do vendedor para ambientes localizados, por causa do tamanho da NF
If cPaisLoc == "BRA"
	DEFINE CELL NAME "VENDED"	OF oSection4 SIZE TAM_CODVEN 						TITLE STR0014	// "Vend.  "
EndIf

DEFINE CELL NAME "NOME"		OF oSection4 SIZE TAM_NOMVEN 							TITLE STR0015	// "Nome Vend       "

DEFINE CELL NAME "A1_COD"	OF oSection4 ALIAS "SA1" SIZE TAM_CODCLI				TITLE STR0016	// "Clien. "
DEFINE CELL NAME "A1_NOME"	OF oSection4 ALIAS "SA1" SIZE TAM_NOMCLI 				TITLE STR0017	// "Nome Cliente        "

DEFINE CELL NAME "DINHEIRO"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( cSimbMoeda, STR0022 ) //"Dinheiro"
DEFINE CELL NAME "CHEQUES"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( "CH"		 , STR0023 ) //"Cheque"
DEFINE CELL NAME "CARTAO"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( "CC"		 , STR0024 ) //"Cartao"
DEFINE CELL NAME "CONVENIO"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( "CO"		 , STR0025 ) //"Convenio"
DEFINE CELL NAME "VALES"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( "VA"		 , STR0026 ) //"Vales"
DEFINE CELL NAME "FINANC"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( "FI"		 , STR0027 ) //"Financiado"
DEFINE CELL NAME "OUTROS"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE 						   STR0028	 //"Outros"
DEFINE CELL NAME "VLRDEBI"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( "CD"		 , STR0029 ) //"Debito"

If lL1VLRPGDG
    DEFINE CELL NAME "VLRPGDG"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( "PD"		 , "Pagto Digital" )	//"Pagto Digital"
	DEFINE CELL NAME "VLRPGPX"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE DescriCabec( "PX"		 , "Pagto PIX" )		//"Pagto PIX"
EndIf

DEFINE CELL NAME "RETENC"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE STR0038							 //"Retencöes"
DEFINE CELL NAME "DESCON"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE STR0018 							 //"Desc."
DEFINE CELL NAME "ACRES"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE STR0019 							 //"Acr."
DEFINE CELL NAME "CREDITO"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE STR0020 							 //"Credito"
DEFINE CELL NAME "VLRTOT"	OF oSection4 SIZE 16 PICTURE "@E 99,999,999.99" TITLE STR0021							 //"Total"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sections desabilitadas para customizacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:SetEdit(.F.)
oSection2:SetEdit(.F.)
oSection3:SetEdit(.F.)
oSection4:SetEdit(.F.)

oSection4:Cell("DINHEIRO"	):SetHeaderAlign( "RIGHT" )
oSection4:Cell("CHEQUES"	):SetHeaderAlign( "RIGHT" )
oSection4:Cell("CARTAO"		):SetHeaderAlign( "RIGHT" )
oSection4:Cell("CONVENIO"	):SetHeaderAlign( "RIGHT" )
oSection4:Cell("VALES"		):SetHeaderAlign( "RIGHT" )
oSection4:Cell("FINANC"		):SetHeaderAlign( "RIGHT" )
oSection4:Cell("OUTROS"		):SetHeaderAlign( "RIGHT" )
oSection4:Cell("VLRDEBI"	):SetHeaderAlign( "RIGHT" )

If lL1VLRPGDG
    oSection4:Cell("VLRPGDG"	):SetHeaderAlign( "RIGHT" )
	oSection4:Cell("VLRPGPX"	):SetHeaderAlign( "RIGHT" )
EndIf

oSection4:Cell("RETENC"		):SetHeaderAlign( "RIGHT" )
oSection4:Cell("DESCON"		):SetHeaderAlign( "RIGHT" )
oSection4:Cell("ACRES"		):SetHeaderAlign( "RIGHT" )
oSection4:Cell("CREDITO"	):SetHeaderAlign( "RIGHT" )
oSection4:Cell("VLRTOT"		):SetHeaderAlign( "RIGHT" )
Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Ljr075PrtRptºAutor  ³Hanna               º Data ³  11/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para impressao do relatorio personalizavel             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ lojr075                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpO1 - Objeto do relatorio                                  º±±
±±º          ³ ExpO2 - Tamanho do campo da NF                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   ANALISTA   ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºNorbert Waage ³04/07/07³126641³Incluido o calculo e impressao do troco   º±±
±±º              ³        ³      ³das vendas em dinheiro para o Brasil.     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ljr075PrtRpt(oReport)
Local cFilAtu		:= ""						// Filial atual utilizada no relatorio
Local cCaiAtu		:= ""						// Caixa utilizada no relatorio
Local uDatAtu		:= ""						// Data de emissao utilizada no relatorio
Local nX			:= ""						// Var Auxiliar
Local nScanForm		:= 0						// Posicao da forma de pagamento
Local nMoeda		:= 1						// Moeda da transacao
Local nTotTrocCx	:= 0						// Total de troco do caixa
Local nTotTrocDt	:= 0						// Total de troco da data
Local nTotTrocFl	:= 0						// Total de troco da filial
Local nVlrTroco		:= 0						// Valor do troco total
Local nDecs			:= MsDecimais(mv_par09)		// Num. de casas decimais da moeda selecionada
Local nTotImps		:= 0						// Total de impostos variaveis discriminados em uma venda - Localizacoes
Local lDados		:= .F.						// Valida se os dados foram gerados
Local aFormas		:= {}						// Array contendo as formas de pagamento
Local aFormaImp		:= {}						// Array com as formas de pagto que serao impressas
Local cFormasImp	:= ""						// Formas de pagamento que serao impressas
Local cSimbMoeda	:= ""						// Simbolo da moeda(Dinheiro)
Local nTroco		:= 0						// Entradas de Troco
Local nPosMoed		:= 0						// Posicao da moeda

Local aTotCx		:= Array(10)				// Array Total por caixa
Local aTotCxAux		:= Array(10)				// Array Auxiliar Total por caixa
Local aTotDt		:= Array(10)				// Array Total por data
Local aTotFi		:= Array(10)				// Array Total por Filial
Local aTotGer		:= Array(10)				// Array Total Geral
Local aSangria		:= Array(10)				// Armazena as sangrias Sangria
Local aPicts		:= Array(12)				// Array com as pictures de impressao

Local aTotCxDev		:= Array(10)				// Array Total por caixa
Local aTotCxDevAux	:= Array(10)				// Array Auxiliar Total por caixa
Local aTotDtDev		:= Array(10)				// Array Total por data
Local aTotFiDev		:= Array(10)				// Array Total por Filial
Local aTotGerDev	:= Array(10)				// Array Total Geral

Local lFirstDev		:= .T.						// Considera impressao de Devolucao
Local lFirstEst		:= .T.						// Considera impressao de Estorno
Local lSubTotCx		:= .F.						// Define se imprime sub-total para o Caixa
Local lSubTotDt		:= .F.						// Define se imprime sub-total para a Data
Local lSubTotFil	:= .F.						// Define se imprime sub-total para a Filial
Local lLayAway		:= .F.						// Define se eh Lay-Away
Local lUsaQuery		:= .F.						// Define se utiliza a query

Local nVlrTot		:= 0						// Impressao do Valor Total (SL1)
             
Local oSection1		:= oReport:Section(1)		// Define a secao 1 do relatorio
Local oSection2		:= oSection1:Section(1)		// Define que a secao 2 serah filha da secao 1
Local oSection3		:= oSection2:Section(1)		// Define que a secao 3 serah filha da secao 2
Local oSection4		:= oSection3:Section(1)		// Define que a secao 4 serah filha da secao 3
Local aEstorno		:= Array(10)    			// Array com estornos
Local lEstorno 		:= SD1->(ColumnPos("D1_OPERADO")) > 0  .And. SL1->(ColumnPos("L1_STATUES")) > 0 .and. SL4->(ColumnPos("L4_OPERAES")) > 0  /// estorno de vendas.
Local lCliRecIss	:= .F.						// Cliente Recolhe ISS ? 
Local nZ 			:= 0
Local cTipFor 		:= "" 

Local aFormasPag 	:= {}
Local lImpItem		:= .T.						// Verifica se a Forma de Pagamento esta configurada "MV_PAR08 -> Formas de Pgto"
Local nTotEstorn 	:= 0						// Guarda o Total de Estornos realizados

Private lVlrPisCof	:= SL1->(ColumnPos("L1_ABTOPCC")) > 0	// Define se o campo L1_ABTOPCC existe na SL1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros do relatorio: LJR075 ³
//³                                ³
//³MV_PAR01 -> Filial de          ?³
//³MV_PAR02 -> Filial ate         ?³
//³MV_PAR03 -> Data de            ?³
//³MV_PAR04 -> Data ate           ?³
//³MV_PAR05 -> Caixa de           ?³
//³MV_PAR06 -> Caixa ate          ?³
//³MV_PAR07 -> Considera Devolução?³
//³MV_PAR08 -> Formas de Pgto     ?³
//³MV_PAR09 -> Qual moeda         ?³
//³MV_PAR10 -> Outras Moedas      ?³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Inclui as "" para nao dar erro na geracao do relatorio
If !('"' $ MV_PAR08) .AND. !("'" $ MV_PAR08)
	MV_PAR08 := '"' + MV_PAR08 + '"' 
EndIf

If cPaisLoc == "BRA"
	cSimbMoeda := "R$"
Else
	cSimbMoeda := "$$"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zera estrutura das Arrays para soma dos totais.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFill( aTotCx,		0 )
aFill( aTotCxAux,	0 )
aFill( aTotDt , 0 )
aFill( aTotFi , 0 )
aFill( aTotGer, 0 )
aFill( aSangria, 0 )
aFill( aEstorno, 0 )

aFill( aTotCxDev ,0 )
aFill( aTotCxDevAux ,0 )
aFill( aTotDtDev ,0 )
aFill( aTotFiDev ,0 )
aFill( aTotGerDev,0 )

#IFDEF TOP
	If 	UPPER(TcGetDb()) <> "DB2"
		lUsaQuery := .T.
	Endif
#Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Geracao dos dados para impressao.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LJ075GeraTmp(lUsaQuery)

aPicts[01] := "@E 99,999,999.99"
aPicts[02] := "@E 99,999,999.99"
aPicts[03] := "@E 99,999,999.99"
aPicts[04] := "@E 99,999,999.99"
aPicts[05] := "@E 99,999,999.99"
aPicts[06] := "@E 99,999,999.99"
aPicts[07] := "@E 99,999,999.99"
aPicts[08] := "@E 99,999,999.99"
aPicts[09] := "@E 99,999,999.99"
aPicts[10] := "@E 99,999,999.99"
aPicts[11] := "@E 99,999,999.99"
aPicts[12] := "@E 99,999,999.99"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preparando as formas de pagamento                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( aFormas, { cSimbMoeda, "DINHEIRO", aPicts[01], DescriCabec( cSimbMoeda	, STR0022 ) })	//Dinheiro
AAdd( aFormas, { "CH"      , "CHEQUES" , aPicts[02], DescriCabec( "CH"			, STR0023 ) })	//Cheque
AAdd( aFormas, { "CC"      , "CARTAO"  , aPicts[03], DescriCabec( "CC"			, STR0024 ) })	//Cartao
AAdd( aFormas, { "CO"      , "CONVENIO", aPicts[04], DescriCabec( "CO"			, STR0025 ) })	//Convenio
AAdd( aFormas, { "VA"      , "VALES"   , aPicts[05], DescriCabec( "VA"			, STR0026 ) })	//Vales
AAdd( aFormas, { "FI"      , "FINANC"  , aPicts[06], DescriCabec( "FI"			, STR0027 ) })	//Financiamento
AAdd( aFormas, { "OU"      , "OUTROS"  , aPicts[07],                          	  STR0028   })	//Outros
AAdd( aFormas, { "CD"      , "VLRDEBI" , aPicts[12], DescriCabec( "CD"			, STR0029 ) })	//Debito
AAdd( aFormas, { "CR"      , "CREDITO" , aPicts[12], DescriCabec( "CR"			, STR0020 ) })	//Credito

If lL1VLRPGDG
    AAdd( aFormas, { "PD"  , "VLRPGDG" , aPicts[12], DescriCabec( "PD"			, "Pagto Digital" ) })	//Pagto Digital
	AAdd( aFormas, { "PX"  , "VLRPGPX" , aPicts[12], DescriCabec( "PX"			, "Pagto PIX" ) })		//Pagto PIX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limpando separadores de formas de pagamento.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cFormasImp := AllTrim(Upper(MV_PAR08))

aFormasPag := RetFormPag( cFormasImp ) // Array com as formas de pagamento do MV_PAR08

//escondemos todas as células, para habilitar somente as necessárias
oSection4:Cell("DINHEIRO"):Hide()
oSection4:Cell("CHEQUES"):Hide()
oSection4:Cell("CARTAO"):Hide()
oSection4:Cell("CONVENIO"):Hide()
oSection4:Cell("VALES"):Hide()
oSection4:Cell("FINANC"):Hide()
oSection4:Cell("OUTROS"):Hide()
oSection4:Cell("VLRDEBI"):Hide()

If lL1VLRPGDG
    oSection4:Cell("VLRPGDG"):Hide()
	oSection4:Cell("VLRPGPX"):Hide()
EndIf

lDados    := ( TRB->( RecCount() ) <> 0 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazenando na array aFormaImp as formas de pagamento p/ impressao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nX := 1 to Len( aFormasPag )
	
	cTipFor := aFormasPag[nX]
	
	If cTipFor == "VP" //Caso a forma de pagamento seja do tipo Vale Presente a mesma deve ser transformada em Vale	
		aFormasPag[nX] := "VA"
		cTipFor		 := "VA"
	Endif
	
	nScanForm := aScan( aFormas,{ |ExpA1| ExpA1[1] == cTipFor } )
	
	//Caso nao encontre a forma de pagamento na relacao de formas definidas no array, a mesma deve ser considerada como OUTROS
	If nScanForm == 0 .AND. aScan( aFormasPag,{ |x| x == 'OU' } ) == 0
		aFormasPag[nX] := "OU"
		cTipFor		 := "OU"
		nScanForm := aScan( aFormas,{ |ExpA1| ExpA1[1] == cTipFor } )
	EndIf
	
	If nScanForm > 0
		//Somente adiciona a Forma de Pagamento, se a mesma ainda nao existe, para nao adicionar novamente
		If Ascan( aFormaImp,{|x| x[1] == cTipFor} ) == 0 
			AAdd( aFormaImp, aFormas[nScanForm] )
		EndIf
	EndIf
Next nX

//habilitamos as células escolhidas no parametro do relatório
For nX := 1 to Len(aFormas)
	nScanForm := Ascan( aFormaImp,{|x| x[1] == aFormas[nX][1]} )
	If nScanForm > 0
		oSection4:Cell(aFormas[nX][2]):ShowHeader()
	Else
		oSection4:Cell(aFormas[nX][2]):Disable()
	EndIf
Next

If lLGPD
	If LjPDCmpPrt("LQ_NOMVEND")
		oSection4:Cell("NOME"):SetObfuscate(.T.)
	EndIf
	If LjPDCmpPrt("A1_NOME")
		oSection4:Cell("A1_NOME"):SetObfuscate(.T.)
	EndIf
EndIf

If Empty( aFormaImp ) .OR. Len( aFormaImp ) > 5
	
	If Len( aFormaImp ) > 5
		// "Foram escolhidas " // " formas de pagamento (" // "). Devido ao tamanho do relatório é permitida até 5 formas. Ajuste os parâmetros do relatório."
		MsgStop( STR0044 + Alltrim(Str(Len(aFormaImp))) + STR0045 + Alltrim( MV_PAR08 ) + STR0046 )
	Else
		Help(" ",1,"LOJR075001")
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Encerra arquivo temporario.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("TRB")
	dbCloseArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaurar as tabelas utilizadas e limpar os arquivos temporarios    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		DbSelectArea("SL1")
		RetIndex("SL1")
		
		DbSelectArea("SL2")
		RetIndex("SL2")
		
		DbSelectArea("SA1")
		RetIndex("SA1")
		
		DbSelectArea("SA3")
		RetIndex("SA3")
		
		DbSelectArea("SB1")
		RetIndex("SB1")
		
		DbSelectArea("SF4")
		RetIndex("SF4")
		
		DbSelectArea("SF1")
		RetIndex("SF1")
		
		DbSelectArea("SD1")
		RetIndex("SD1")
		
		DbSelectArea("SA2")
		RetIndex("SA2")
	#ELSE

        If( ValType(oTempTable) == "O")
          oTempTable:Delete()
          FreeObj(oTempTable)
          oTempTable := Nil
        EndIf		
		
	#Endif
	
	Return NIL
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea( "TRB" )
dbGotop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento do relatorio.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof()
	
	cFilAtu   := TRB->FILIAL //Quebra por filial
	lSubTotFil:= .F.
	nTotTrocFl:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia e imprime o conteudo da Secao1³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:Init()
	oSection1:Cell("FILIAL"):SetValue( TRB->FILIAL )
	oSection1:PrintLine()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera a barra de processamento. Inicia a Secao 2 e 3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:IncMeter()

	While !Eof() .AND. cFilAtu == TRB->FILIAL
		
		uDatAtu   := TRB->DTEMI //Quebra por data de emissao
		lSubTotDt := .F.
		nTotTrocDt:= 0
		oSection2:Init()
		oSection2:Cell("DTEMI"):SetValue( TRB->DTEMI )
		oSection2:PrintLine()

		While !Eof() .AND. cFilAtu == TRB->FILIAL .AND. uDatAtu == TRB->DTEMI
			cCaiAtu   := TRB->CAIXA //Quebra por caixa
			lSubTotCx := .F.
			nTotTrocCx:= 0
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inicia e imprime o conteudo da Secao2³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection3:Init()
			oSection3:Cell("CAIXA"):SetValue( TRB->CAIXA )
			oSection3:PrintLine()

			oSection4:Init()
			oSection4:Finish()
			oSection4:Init()

   			oSection4:Cell("SERIE"):Show()

			If cPaisLoc == "BRA"
				oSection4:Cell("VENDED"):Show()
			Endif

			oSection4:Cell("NOME"):Show()
			oSection4:Cell("A1_COD"):Show()
			oSection4:Cell("A1_NOME"):Show()

			oSection4:Cell("N_FISCAL"):ShowHeader()
			oSection4:Cell("SERIE"):ShowHeader()
			
			If cPaisLoc == "BRA"
				oSection4:Cell("VENDED"):ShowHeader()
			Endif

			oSection4:Cell("NOME"):ShowHeader()
			oSection4:Cell("A1_COD"):ShowHeader()
			oSection4:Cell("A1_NOME"):ShowHeader()
			For nX := 1 To Len(aFormaImp)
				oSection4:Cell(aFormaImp[nX][2]):ShowHeader()
			Next nX
			oSection4:Cell("RETENC"):ShowHeader()
			oSection4:Cell("DESCON"):ShowHeader()
			oSection4:Cell("ACRES"):ShowHeader()
			oSection4:Cell("CREDITO"):ShowHeader()
			oSection4:Cell("VLRTOT"):ShowHeader()

			While !Eof() .AND. cFilAtu == TRB->FILIAL .AND. uDatAtu == TRB->DTEMI .AND. cCaiAtu == TRB->CAIXA
				
				If cPaisLoc <> "BRA"
					nMoeda    := TRB->MOEDA
					If lUsaQuery .AND. mv_par10 == 2  //Nao Imprimir outras moedas
						If TRB->MOEDA <> mv_par09
							DbSkip()
							Loop
						Endif
					Endif
				Endif

				// Verifica se a forma de pagamento foi configurada "MV_PAR08 -> Formas de Pgto"
				lImpItem := Lj7ImprIt(aFormaImp)
				
				If !lImpItem
					TRB->(DbSkip())
					Loop
				EndIf

				lSubTotCx := .T.
				lSubTotDt := .T.
				lSubTotFil:= .T.
				nTotImps  := 0
				
				If cPaisLoc$"POR|EUA"
					lLayAway := TRB->LAYAWAY == "S"
				Else                                                            
					lLayAway := .F.
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se LDEV estiver vazio, se trata de orcamentos vendidos              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty( TRB->LDEV )
					lFirstDev := .T.
					lFirstEst := .T.
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Valor total da venda eh a soma dos valores de cada forma de pgto.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lLayAway
						    //Acumulador anterior, esta acumula o total de todas as formas de pagto 
						    //nao respeitando o filtro dos parametros. Comentado por Fábio Costa - 10/08/2015
						    
						    //nVlrTot := TRB->DINHEIRO + TRB->CHEQUES + TRB->CARTAO + TRB->CONVENIO
						    //nVlrTot += TRB->VALES + TRB->FINANC + TRB->OUTROS + TRB->CREDITO + TRB->VLRDEBI


                         //Nova forma de calcular o total das formas de pagto, a soma é efetuada conforme 
                         //o parametro informado no pergunte, ex. CH+CC = a soma dos dois apenas 
                         //e nao mais a soma de todos, deixando de dar diferencia na visualização para o usuario, Fábio Costa - 10/08/2015
                                  
                         nVlrTot := 0
                         
                         //Para NCC sempre é somado, pois é uma condição de pagamento que não consta na L4 e não tem filtro para essa forma de pagamento
                         nVlrTot += TRB->CREDITO //NCC
                         
						For nZ := 1 to Len(aFormasPag)
			                  
			                If aFormasPag[nZ] == "R$"
			                     nVlrTot += TRB->DINHEIRO
			                ElseIf aFormasPag[nZ] == "CH"    
			                     nVlrTot += TRB->CHEQUES
			                ElseIf aFormasPag[nZ] == "CC"
			                     nVlrTot += TRB->CARTAO 
			                ElseIf aFormasPag[nZ] == "CO"
			                     nVlrTot += TRB->CONVENIO 
			                ElseIf aFormasPag[nZ] == "VA"
			                     nVlrTot += TRB->VALES 
			                ElseIf aFormasPag[nZ] == "FI"
			                     nVlrTot += TRB->FINANC  
			                ElseIf aFormasPag[nZ] == "OU"
			                     nVlrTot += TRB->OUTROS 
			                ElseIf aFormasPag[nZ] == "CD"
			                     nVlrTot += TRB->VLRDEBI  
							ElseIf lL1VLRPGDG .And. aFormasPag[nZ] == "PD"
								nVlrTot += TRB->VLRPGDG  
							ElseIf lL1VLRPGDG .And. aFormasPag[nZ] == "PX"
								nVlrTot += TRB->VLRPGPX
			                EndIf
                  		
                  		Next
					Else
						nVlrTot := TRB->VLRTOT
					Endif
					
					If lVlrPisCof
						nVlrTot -= TRB->ABTOPCC
					Endif
					
					SA1->( DbSetOrder( 1 ) )
					SA1->( DbSeek( xFilial( "SA1" ) + TRB->CLIENTE + TRB->LOJA ) )
									
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes do Vendedor/Cliente/Nota fiscal                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:Cell("N_FISCAL"):SetValue( IIf( !Empty( TRB->N_FISCAL ),TRB->N_FISCAL,TRB->N_FISCPED ) )
					oSection4:Cell("SERIE"):SetValue( IIf( !Empty( TRB->SERIE ),TRB->SERIE,TRB->SERPED ) )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Nao imprime codigo do vendedor para Localizacoes devido ao ³
					//³tamanho do numero da nota fiscal(de 6 ateh 13 caracteres)  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cPaisLoc == "BRA"
						oSection4:Cell("VENDED"):SetValue( TRB->VENDED )
						oSection4:Cell("NOME"):SetValue( TRB->NOME )
					Else
						oSection4:Cell("NOME"):SetValue( Left(TRB->NOME, 12) )
					Endif

					SA1->( DbSetOrder( 1 ) )
					SA1->( DbSeek( xFilial( "SA1" ) + TRB->CLIENTE + TRB->LOJA ) )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao das formas de pagamento selecionadas no parametro.        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lLayAway
						For nX := 1 To Len(aFormaImp)
							oSection4:Cell(aFormaImp[nX][2]):Show()
							oSection4:Cell(aFormaImp[nX][2]):SetValue( Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,MV_PAR09,TRB->DTEMI,nDecs+1),nDecs) )
						Next nX
					Else
						For nX := 1 To Len(aFormaImp)
							If Trim(aFormaImp[nX][1]) == Trim(TRB->HISTOR) .OR. ;  //Valido para CH, CC, CD, FI, VA, etc
								(Trim(aFormaImp[nX][1])=="$$" .AND. IsMoney(TRB->HISTOR))  //Dinheiro
								oSection4:Cell("VLRTOT"):SetValue( Round(xMoeda(TRB->VLRTOT,nMoeda,MV_PAR09,TRB->DTEMI,nDecs+1),nDecs) )
							Else
								oSection4:Cell(aFormaImp[nX][2]):Show()
								oSection4:Cell(aFormaImp[nX][2]):SetValue( Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,MV_PAR09,TRB->DTEMI,nDecs+1),nDecs) )
							Endif
						Next nX
					Endif
					
					// Verifica se esta usando a nova configuracao para confirmar se o cliente recolhera o iss.
					If SuperGetMV("MV_LJRECIS",,.F.) .And. SL1->( ColumnPos ( "L1_RECISS" ) ) > 0 
						lCliRecIss := TRB->C_RECISS == "1" .AND. lMvDescISS
					Else
						lCliRecIss :=  ( SA1->A1_RECISS == "1" .AND. lMvDescISS )   					
					EndIf
										
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes de Impostos/Credito/Acrescimo/Desconto e Valor Total.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:Cell("RETENC"):SetValue( Round( xMoeda( ( IIf( lVlrPisCof, TRB->ABTOPCC, 0 ) + ;
					iIf( lCliRecIss, TRB->VALISS, 0 ) ), ;
					nMoeda, mv_par09, TRB->DTEMI, nDecs + 1 ), nDecs ) )

					oSection4:Cell("DESCON"):SetValue( Round(xMoeda(TRB->DESCON,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) )

					If cPaisLoc == "BRA"
						If TRB->ACRES > 0
							oSection4:Cell("ACRES"):SetValue(Round(xMoeda(TRB->ACRES,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs))
						Else
							oSection4:Cell("ACRES"):SetValue(0)
						EndIf
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Soma os impostos variaveis que incidem na NF³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lLayAway
							nTotImps  := LJ075Imps("SL1")
						Endif

						oSection4:Cell("ACRES"):SetValue( Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) )
					Endif
					
					If lTroco
						
						If lUsaQuery
							nVlrTroco  := 0
							If cPaisLoc == "BRA"
								nVlrTroco += Round(xMoeda(&("TRB->TROCO1"),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
							Else 
								For nX := 1 to MoedFin()
									nVlrTroco += Round(xMoeda(&("TRB->TROCO"+AllTrim(Str(nX))),nX,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
								Next nX
							EndIf
							nTotTrocCx  += nVlrTroco
							nTotTrocDt  += nVlrTroco
							nTotTrocFl  += nVlrTroco
							nVlrTot     -= nVlrTroco
						Else
							nTotTrocCx  += TRB->TROCO
							nTotTrocDt  += TRB->TROCO
							nTotTrocFl  += TRB->TROCO
							nVlrTot     -= TRB->TROCO
							nVlrTroco   := TRB->TROCO
						Endif
						
					Endif
					
					oSection4:Cell("CREDITO"):SetValue( Round(xMoeda(TRB->CREDITO,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) )
					oSection4:Cell("VLRTOT"):SetValue( Round(xMoeda(nVlrTot,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso LDEV estiver preenchido se trata de Orcamentos Devolvidos.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:PrintLine()
				Else
					If TRB->LDEV == '|'   /// se pipe é Devolucao , se + é estorno
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprimir indicacao de devolucoes caso for a primeira impressao.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lFirstDev
						oReport:SkipLine(1)
						oReport:PrintText( STR0032 )			//"*************** DEVOLUCOES ***************"
						oReport:SkipLine(1)
						lFirstDev := .F.
					Endif
					
					nVlrTot := TRB->VLRTOT //Valor total da Devolucao

					If cPaisLoc <> "BRA"
						If !lLayAway
							nTotImps  := LJ075Imps("SF1")
						Endif
						
						If ! ( TRB->(ColumnPos("VALPIS")) > 0 .AND. TRB->(ColumnPos("VALCOFI")) > 0 .AND. TRB->(ColumnPos("VALCSLL")) > 0 )
							nVlrTot := Round(xMoeda(TRB->VLRTOT,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) //Valor total da Devolucao
						Else
							nVlrTot := Round(xMoeda(TRB->VLRTOT+nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) //Valor total da Devolucao
						Endif
						
					Endif
					
					If lVlrPisCof
						nVlrTot -= TRB->ABTOPCC
					Endif
					
					SA1->(DbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes de devolucao                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:Cell("N_FISCAL"):SetValue( TRB->N_FISCAL )
					oSection4:Cell("SERIE"):SetValue( TRB->SERIE )

					If cPaisLoc == "BRA"
						oSection4:Cell("VENDED"):SetValue( TRB->VENDED )
					Endif

					oSection4:Cell("NOME"):SetValue( TRB->NOME )
					
					LJR075HideAll( oSection4 )					

					If cPaisLoc == "BRA" .OR. (cPaisLoc <> "BRA" .AND. lLayAway)
						oSection4:Cell("ACRES"):Hide()
					Else
						oSection4:Cell("ACRES"):Show()
						oSection4:Cell("ACRES"):SetValue(Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs))
					Endif 
					
					oSection4:Cell("N_FISCAL"):Show()
					oSection4:Cell("SERIE"):Show()
					If cPaisLoc == "BRA"
						oSection4:Cell("VENDED"):Show()
					EndIf
					oSection4:Cell("NOME"):Show()
					oSection4:Cell("A1_COD"):Show()
					oSection4:Cell("A1_NOME"):Show()
					oSection4:Cell("VLRTOT"):Show()
					oSection4:Cell("VLRTOT"):SetValue( (nVlrTot*-1))										
					oSection4:PrintLine()
					
				Else

//						Else ///// se | é devolucao,   se + estorno
					
					
					
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Imprimir indicacao de ESTORNO caso for a primeira impressao.     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lFirstEst
								oReport:SkipLine(1)
								oReport:PrintText( PadC(STR0057,39,"*") )		//"*************** ESTORNO ***************"
								oReport:SkipLine(1)
								lFirstEst := .F.
							Endif
							
							SA1->(DbSetOrder(1))
							SA1->(DbSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
							
		
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Informacoes de devolucao                                            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							oSection4:Cell("N_FISCAL"):SetValue( TRB->N_FISCAL )
							oSection4:Cell("SERIE"):SetValue( TRB->SERIE )
		
							If cPaisLoc == "BRA"
								oSection4:Cell("VENDED"):SetValue( TRB->VENDED )
							Endif
		
							oSection4:Cell("NOME"):SetValue( TRB->NOME )
							
							LJR075HideAll( oSection4 )					//// aqui desliga
		
							If cPaisLoc == "BRA" .OR. (cPaisLoc <> "BRA" .AND. lLayAway)
								oSection4:Cell("ACRES"):Hide()
							Else
								oSection4:Cell("ACRES"):Show()
								oSection4:Cell("ACRES"):SetValue(Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs))
							Endif 
							
							oSection4:Cell("N_FISCAL"):Show()
							oSection4:Cell("SERIE"):Show()
							If cPaisLoc == "BRA"							
								oSection4:Cell("VENDED"):Show()
							EndIf
							oSection4:Cell("NOME"):Show()
							oSection4:Cell("A1_COD"):Show()
							oSection4:Cell("A1_NOME"):Show()
							oSection4:Cell("VLRTOT"):Show()
							oSection4:Cell("VLRTOT"):SetValue( (VLRTOT*-1) )
							oSection4:PrintLine()
						
					
					Endif

				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Realiza soma dos valores selecionados para impressao de sub totais  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If TRB->LDEV <> '+'              //// se LDEV = + é estorno
				
					If Empty( TRB->LDEV )
						Lj075SomCx(	@aTotCx	, nVlrTot	, aFormaImp	, nMoeda, ;
									nDecs	, nTotImps	,lLayAway	, nVlrTroco )
					Else
						Lj075SomCx(	@aTotCxDev	, nVlrTot	, aFormaImp	, nMoeda, ;
									nDecs		, nTotImps	, lLayAway	, nVlrTroco)
					Endif      
				Endif
				
				DbSkip()
			End
			
			aTotCxAux    := aClone(aTotCx)
			aTotCxDevAux := aClone(aTotCxDev)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Repasso os valores do Caixa para a quebra por Data.                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lSubTotCx //Somente imprime os sub-totais caso haja registros impressos para o Caixa
				
				If lTroco
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Esconde as celulas nao utilizadas³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX := 1 to Len(oSection4:aCell)
						oSection4:Cell(oSection4:aCell[nX]:cName):Hide()
					Next nX

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ativa as celulas utilizadas³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:Cell("DINHEIRO"):Show()     

					For nX := 1 To Len(aFormaImp)
						If IsMoney(aFormaImp[nX][1]) .OR. Trim(aFormaImp[nX][1])=="$$"
							oReport:SkipLine(1)							                                                 
							oReport:Say(oReport:Row(),10,STR0039 + cCaiAtu)//"T R O C O           ---- > Caixa: "
							oSection4:Cell("DINHEIRO"):SetValue( nTotTrocCx )
							oSection4:PrintLine()
							oReport:SkipLine(1)						
						Endif
					Next nX

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Habilita as celulas desativadas³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX := 1 to Len(oSection4:aCell)
						oSection4:Cell(oSection4:aCell[nX]:cName):Show()
					Next nX
					
				Endif

				//ÚÄÄÄÄÄÄÄ¿
				//³Sangria³
				//ÀÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					LJ075SngTr(	xFilial("SE5")	, xFilial("SE5")	, uDatAtu	, 	cCaiAtu	,;
								cCaiAtu			, @aSangria			, @nTroco	, 	aFormaImp	)
					

                    ///// Reetorna Array com estornos por forma de pagamento.

					If lEstorno // Verifica se os campos D1_OPERADO, L1_STATUES e L4_OPERAES existem.
						LJ075Est(cFilAtu , uDatAtu , cCaiAtu, @aEstorno , aFormaImp)
					Endif	

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso exista Sangria ou entrada de troco, somar com dinheiro.        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX := 1 to Len( aSangria )
						aTotCx[nX] -= aSangria[nX]
						aTotDt[nX] -= aSangria[nX]
					Next nX
					
					////// caso exista Estorno , somar com Dinheiro.
					For nX := 1 to Len( aEstorno )
						aTotCx[nX] -= aEstorno[nX]
						aTotDt[nX] -= aEstorno[nX]
					Next nX       

					If nTroco > 0
						nPosMoed := aScan( aFormaImp,{|x| x[1] == cSimbMoeda} )
						If nPosMoed > 0
							aTotCx[nPosMoed] += nTroco
							aTotDt[nPosMoed] += nTroco
						Endif
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Efetuo o recalculo do total das formas.                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Len( aSangria ) > 0 .OR. nTroco > 0
						aTotCx[10] := 0
						For nX := 1 to Len( aTotCx ) - 1
							If ( AllTrim(Str(nX)) == "6" )              //-- Se for retenção, subtrai.
								aTotCx[10] -= aTotCx[nX]
							ElseIf ( ! AllTrim(Str(nX)) $ "7;8" )   //-- Adiciona se não for desconto/Acréscimo.
								aTotCx[10] += aTotCx[nX]
							Endif
						Next nX
					Endif
					
					oSection4:Cell("N_FISCAL"):SetValue( STR0060 ) //Estorno:
					oSection4:Cell("SERIE"):Hide()
					LJR075HideAll( oSection4 )

					For nX := 1 To Len(aFormaImp)
						oSection4:Cell(aFormaImp[nX][2]):Show()
						oSection4:Cell(aFormaImp[nX][2]):SetValue( aEstorno[nX]*(-1) )
						nTotEstorn += aEstorno[nX]
					Next nX   
					oReport:SkipLine(1)
					oSection4:PrintLine()
								
					oSection4:Cell("N_FISCAL"):SetValue( STR0042 )    /// STR0042      //// Sangria:
					oSection4:Cell("SERIE"):Hide()
					LJR075HideAll( oSection4 )
									
					For nX := 1 To Len(aFormaImp)     ///////////  Sangria
						oSection4:Cell(aFormaImp[nX][2]):Show()
						oSection4:Cell(aFormaImp[nX][2]):SetValue( aSangria[nX]*(-1) )
					Next nX
					
					oReport:SkipLine(1)
					oSection4:PrintLine()
					
					oSection4:Cell("SERIE"):Show()
					//Impressao da entrada de troco
					oReport:PrintText( STR0043 + Transform( nTroco , aPicts[nX] ))		//"Entrada de Troco: "
				Endif
				
				oSection4:Cell("A1_COD"):Hide()
				oSection4:Cell("A1_NOME"):HideHeader()
				
				oSection3:Finish()
				oSection4:Finish()
				oSection3:Init()
				oSection4:Init()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime os totais das formas de pagamento.                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSection4:Cell("N_FISCAL"):SetValue( STR0033 + cCaiAtu )	// "S U B  -  T O T A L ---- > Caixa: "

				For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
					oSection4:Cell(aFormaImp[nX][2]):Show()
					oSection4:Cell(aFormaImp[nX][2]):SetValue( aTotCx[nX] - aTotCxDev[nX] )
				Next nX

				oSection4:Cell("RETENC"):Show()
				oSection4:Cell("RETENC"):SetValue(aTotCx[6] - aTotCxDev[6])
				oSection4:Cell("DESCON"):Show()
				oSection4:Cell("DESCON"):SetValue(aTotCx[7] - aTotCxDev[7])
				oSection4:Cell("ACRES"):Show()
				oSection4:Cell("ACRES"):SetValue(aTotCx[8] - aTotCxDev[8])
				oSection4:Cell("CREDITO"):Show()
				oSection4:Cell("CREDITO"):SetValue(aTotCx[9] - aTotCxDev[9])
				oSection4:Cell("VLRTOT"):Show()
				oSection4:Cell("VLRTOT"):SetValue(aTotCx[10] - aTotCxDev[10])
				
				If cPaisLoc == "BRA"
					oSection4:Cell("VENDED"):Hide()
				EndIf
				oSection4:Cell("NOME"):Hide()
				oSection4:Cell("A1_COD"):Hide()

				oSection4:PrintLine()
			Endif

			If cPaisLoc == "BRA"
				oSection4:Cell("VENDED"):Show()
			EndIf
			oSection4:Cell("NOME"):Show()
			oSection4:Cell("A1_COD"):Show()

			oSection4:Cell("SERIE"):Show()
			If cPaisLoc == "BRA"
				oSection4:Cell("VENDED"):Show()
			EndIf
			oSection4:Cell("NOME"):Show()
			oSection4:Cell("A1_COD"):Show()
			oSection4:Cell("A1_NOME"):Show()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Totaliza no final senao mostra apenas    ³
			//³o total do ultimo caixa e nao total geral³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Lj075SomTot(@aTotDt,aTotCxAux,aFormaImp)
			Lj075SomTot(@aTotDtDev,aTotCxDevAux,aFormaImp)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Limpo os totais para nova concatenacao.                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aFill( aTotCx , 0 )
			aFill( aTotCxDev , 0 )
			aFill( aTotCxAux , 0 )
			aFill( aTotCxDevAux , 0 )
			aFill( aSangria, 0 )
			aFill( aEstorno, 0 )
			nTroco := 0
		End
		oSection2:Finish()
		oSection3:Finish()
		oSection4:Finish()
		oSection2:Init()
		oSection3:Init()
		oSection4:Init()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Repasso os valores do Caixa para a quebra por Data.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSubTotDt //Somente imprime os sub-totais caso haja registros impressos para a Data
			Lj075SomTot(@aTotFi,aTotDt,aFormaImp)
			Lj075SomTot(@aTotFiDev,aTotDtDev,aFormaImp)
			
			If lTroco
				//Impressao do troco
				oReport:Say(oReport:Row(),10,STR0040 + DtoC( uDatAtu ) )	  //"T R O C O           ---- > Data: "
				oReport:Say(oReport:Row(),oSection4:Cell("DINHEIRO"):ColPos()-20,Transform( nTotTrocDt, "@E 99,999,999.99" )  )
				oReport:SkipLine(1)
			Endif

			LJR075HideAll( oSection4 )			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime os totais das formas de pagamento.                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection4:Cell("N_FISCAL"):SetValue( STR0034 + DtoC( uDatAtu ) )	//"S U B  -  T O T A L ---- > Data: "

			For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
				oSection4:Cell(aFormaImp[nX][2]):Show()
				oSection4:Cell(aFormaImp[nX][2]):SetValue( aTotDt[nX] - aTotDtDev[nX] )
			Next nX

			oSection4:Cell("RETENC"):Show()
			oSection4:Cell("RETENC"):SetValue(aTotDt[6] - aTotDtDev[6])
			oSection4:Cell("DESCON"):Show()
			oSection4:Cell("DESCON"):SetValue(aTotDt[7] - aTotDtDev[7])
			oSection4:Cell("ACRES"):Show()
			oSection4:Cell("ACRES"):SetValue(aTotDt[8] - aTotDtDev[8])
			oSection4:Cell("CREDITO"):Show()
			oSection4:Cell("CREDITO"):SetValue(aTotDt[9] - aTotDtDev[9])
			oSection4:Cell("VLRTOT"):Show()
			oSection4:Cell("VLRTOT"):SetValue((aTotDt[10] - nTotEstorn) - aTotDtDev[10])
				
			oSection4:Cell("NOME"):Hide()
			oSection4:Cell("A1_COD"):Hide()
			If cPaisLoc == "BRA"
				oSection4:Cell("VENDED"):Hide()
			EndIf

			oSection4:PrintLine()

			oSection4:Cell("NOME"):Show()
			oSection4:Cell("A1_COD"):Show()
			If cPaisLoc == "BRA"
				oSection4:Cell("VENDED"):Show()
			EndIf
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Limpo os totais para nova concatenacao.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aFill( aTotDt , 0 )
		aFill( aTotDtDev , 0 )
	End
	oSection1:Finish()
	oSection2:Finish()
	oSection3:Finish()
	oSection4:Finish()
	oSection1:Init()
	oSection2:Init()
	oSection3:Init()
	oSection4:Init()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Repasso os valores do Caixa para a quebra por Filial.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSubTotFil //Somente imprime os sub-totais caso haja registros impressos para a Filial
		Lj075SomTot(@aTotGer,aTotFi,aFormaImp)
		Lj075SomTot(@aTotGerDev,aTotFiDev,aFormaImp)
		
		If lTroco
			oReport:Say(oReport:Row(),10,STR0041 + cFilAtu )	  //"T R O C O           ---- > Filial: "
			oReport:Say(oReport:Row(),oSection4:Cell("DINHEIRO"):ColPos()-20,Transform( nTotTrocFl, "@E 99,999,999.99" )  )
			oReport:SkipLine(1)
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esconde as celulas do relatorio³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		LJR075HideAll( oSection4 )
		oSection4:Cell("N_FISCAL"):SetValue( STR0035 + cFilAtu )	//"S U B  -  T O T A L ---- > Filial: "

		For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
			oSection4:Cell(aFormaImp[nX][2]):Show()
			oSection4:Cell(aFormaImp[nX][2]):SetValue( aTotFi[nX] - aTotFiDev[nX] )
		Next nX

		oSection4:Cell("RETENC"):Show()
		oSection4:Cell("RETENC"):SetValue(aTotFi[6] - aTotFiDev[6])
		oSection4:Cell("DESCON"):Show()
		oSection4:Cell("DESCON"):SetValue(aTotFi[7] - aTotFiDev[7])
		oSection4:Cell("ACRES"):Show()
		oSection4:Cell("ACRES"):SetValue(aTotFi[8] - aTotFiDev[8])
		oSection4:Cell("CREDITO"):Show()
		oSection4:Cell("CREDITO"):SetValue(aTotFi[9] - aTotFiDev[9])
		oSection4:Cell("VLRTOT"):Show()
		oSection4:Cell("VLRTOT"):SetValue((aTotFi[10] - nTotEstorn) - aTotFiDev[10])
			
		oSection4:Cell("NOME"):Hide()
		oSection4:Cell("A1_COD"):Hide()
		If cPaisLoc == "BRA"
			oSection4:Cell("VENDED"):Hide()
		EndIf

		oSection4:PrintLine()

		oSection4:Cell("NOME"):Show()
		oSection4:Cell("A1_COD"):Show()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpo os totais para nova concatenacao.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aFill( aTotFi , 0 )
	aFill( aTotFiDev , 0 )
End
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se existe registro na base de dados, imprimir o total geral.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lDados
	oSection1:Init()
	oSection2:Init()
	oSection3:Init()
	oSection4:Init()
	LJR075HideAll( oSection4 )

	oSection4:Cell("N_FISCAL"):SetValue( STR0036 )	//"T O T A L     G E R A L ---- > "

	For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
		oSection4:Cell(aFormaImp[nX][2]):Show()
		oSection4:Cell(aFormaImp[nX][2]):SetValue( aTotGer[nX] - aTotGerDev[nX] - aTotDt[nx])
	Next nX

	oSection4:Cell("RETENC"):Show()
	oSection4:Cell("RETENC"):SetValue(aTotGer[6] - aTotGerDev[6])
	oSection4:Cell("DESCON"):Show()
	oSection4:Cell("DESCON"):SetValue(aTotGer[7] - aTotGerDev[7])
	oSection4:Cell("ACRES"):Show()
	oSection4:Cell("ACRES"):SetValue(aTotGer[8] - aTotGerDev[8])
	oSection4:Cell("CREDITO"):Show()
	oSection4:Cell("CREDITO"):SetValue(aTotGer[9] - aTotGerDev[9])
	oSection4:Cell("VLRTOT"):Show()
	oSection4:Cell("VLRTOT"):SetValue((aTotGer[10] - nTotEstorn) - aTotGerDev[10])
	If cPaisLoc == "BRA"		
		oSection4:Cell("VENDED"):Hide()
	EndIf
	oSection4:Cell("NOME"):Hide()
	oSection4:Cell("A1_COD"):Hide()

	oSection4:PrintLine()

	oSection4:Cell("NOME"):Show()
	oSection4:Cell("A1_COD"):Show()
Endif
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra arquivo temporario.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaurar as tabelas utilizadas e limpar os arquivos temporarios    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsaQuery
	DbSelectArea("SL1")
	RetIndex("SL1")
	
	DbSelectArea("SL2")
	RetIndex("SL2")
	
	DbSelectArea("SA1")
	RetIndex("SA1")
	
	DbSelectArea("SA3")
	RetIndex("SA3")
	
	DbSelectArea("SB1")
	RetIndex("SB1")
	
	DbSelectArea("SF4")
	RetIndex("SF4")
	
	DbSelectArea("SF1")
	RetIndex("SF1")
	
	DbSelectArea("SD1")
	RetIndex("SD1")
	
	DbSelectArea("SA2")
	RetIndex("SA2")
Else
    If( ValType(oTempTable) == "O")
      oTempTable:Delete()
      FreeObj(oTempTable)
      oTempTable := Nil
    EndIf
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJR075HideAllºAutor  ³Hanna Caroline   º Data ³  11/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esconde as celulas do relatorio                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGALOJA                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJR075HideAll( oSection4 )
oSection4:Cell("SERIE"):Hide()
If cPaisLoc == "BRA"
	oSection4:Cell("VENDED"):Hide()
EndIf
oSection4:Cell("NOME"):Hide()
oSection4:Cell("A1_COD"):Hide()
oSection4:Cell("A1_NOME"):Hide()

oSection4:Cell("DINHEIRO"):Hide()
oSection4:Cell("CHEQUES"):Hide()
oSection4:Cell("CARTAO"):Hide()
oSection4:Cell("CONVENIO"):Hide()
oSection4:Cell("VALES"):Hide()
oSection4:Cell("FINANC"):Hide()
oSection4:Cell("OUTROS"):Hide()
oSection4:Cell("VLRDEBI"):Hide()

If lL1VLRPGDG
    oSection4:Cell("VLRPGDG"):Hide()
	oSection4:Cell("VLRPGPX"):Hide()
EndIf

oSection4:Cell("RETENC"):Hide()
oSection4:Cell("DESCON"):Hide()
oSection4:Cell("ACRES"):Hide()
oSection4:Cell("CREDITO"):Hide()
oSection4:Cell("VLRTOT"):Hide()

oSection4:Cell("N_FISCAL"):HideHeader()
oSection4:Cell("SERIE"):HideHeader()
If cPaisLoc == "BRA"
	oSection4:Cell("VENDED"):HideHeader()
EndIf
oSection4:Cell("NOME"):HideHeader()
oSection4:Cell("A1_COD"):HideHeader()
oSection4:Cell("A1_NOME"):HideHeader()

oSection4:Cell("DINHEIRO"):HideHeader()
oSection4:Cell("CHEQUES"):HideHeader()
oSection4:Cell("CARTAO"):HideHeader()
oSection4:Cell("CONVENIO"):HideHeader()
oSection4:Cell("VALES"):HideHeader()
oSection4:Cell("FINANC"):HideHeader()
oSection4:Cell("OUTROS"):HideHeader()
oSection4:Cell("VLRDEBI"):HideHeader()

If lL1VLRPGDG
    oSection4:Cell("VLRPGDG"):HideHeader()
	oSection4:Cell("VLRPGPX"):HideHeader()
EndIf

oSection4:Cell("RETENC"):HideHeader()
oSection4:Cell("DESCON"):HideHeader()
oSection4:Cell("ACRES"):HideHeader()
oSection4:Cell("CREDITO"):HideHeader()
oSection4:Cell("VLRTOT"):HideHeader()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFun‡„o	 ³DescriCabec  ºAutor  ³ Vendas Clientes º Data ³07/08/2000   º±±    
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca Descricao da forma de pagameto no SX5 pelo parametro  º±±
±±º          ³(Chv) se não encontrar retorna (Str)                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGALOJA                                                   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function DescriCabec( Chv, cStr )
Local aArea	:= GetArea()	// Area Atual

Default		Chv 	:= '$'
Default		cStr 	:= STR0022		//Dinheiro

DbSelectArea( "SX5" )

If DbSeek( xFilial( "SX5" ) + "24" + Chv )
   cStr	:= Capital( Alltrim( X5Descri() ) )
EndIf
RestArea( aArea )

Return cStr

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³LJ075Est  ºAutor  ³                    º Data ³ 19/01/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna as formas de pagamento dos ESTORNOS para  exibir   º±± 
±±º          ³ no relatório semelhante a Sangria                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpC1    -> Filial da tabela SL4                           º±±
±±º          ³ ExpD2 -> Data da consulta                                  º±±
±±º          ³ ExpC3 - Caixa da consulta                                  º±±
±±º          ³ ExpA4 -> Array de Estorno                                  º±±
±±º          ³ ExpA5 -> Pagamentos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LJ075Est( cFilAtu	, uDatAtu	, cCaiAtu	, aEstorno , aFormaImp)

Local lUsaQuery := .F. 			//Utiliza Query
Local cQuery    := ""  			//Query concatenada
Local aArea     := GetArea()	//Area atual  
Local nX		  := 0           //Variavel contadora        
Local lUsaNMov	:= Val(MV_PAR11) > 0 .AND. SL1->(ColumnPos("L1_NUMMOV")) > 0

Default cFilAtu := ""    
Default uDatAtu := Ctod("")
Default cCaiAtu := ""    
Default aEstorno := {}
Default aFormaImp := {}


If Empty(xFilial("SL4"))
	cFilAtu := xFilial("SL4")
EndIf

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lUsaQuery := .T.
	Endif
#Endif                                                    

If lUsaQuery     
	For nX := 1 To Len(aFormaImp)
	
		cQuery:= "SELECT SL4.L4_FORMA, SUM(L4_VALOR) AS L4_VALOR  FROM " +;
	   			RetSQLName("SL1") + " SL1 , " + RetSQLName("SL4") + " SL4 "
		cQuery:=cQuery+" WHERE SL4.L4_FILIAL = '" + cFilAtu + "'"+;
						" AND SL1.L1_EMISSAO = '" + DToS(uDatAtu) + "'"   
		If lUsaNMov
			cQuery:=cQuery+ " AND SL1.L1_NUMMOV = '" + MV_PAR11 + "' " 
		EndIf
		cQuery:=cQuery+ "  AND SL4.L4_OPERAES = '" + cCaiAtu + "' AND SL4.L4_ESTORN = 'S' "+;                                                                              
						" AND SL1.L1_STATUES <> ' ' " +;
						" AND SL1.L1_FILIAL = SL4.L4_FILIAL AND SL1.L1_NUM = SL4.L4_NUM "+;
						" AND SL4.L4_FORMA= '" + aFormaImp[nX,1] + ;
	   				   	"' AND SL1.D_E_l_E_T_  <> '*' AND SL4.D_E_l_E_T_  <> '*' "
		cQuery:=cQuery+" GROUP BY L4_FORMA " 
		                              		 	                              					
		 cQuery := ChangeQuery(cQuery)
		                            			 	
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'SE5TMP', .F., .T.)
		aEstorno[nX] += L4_VALOR       						   					
		DbSelectArea("SE5TMP")
		dbCloseArea()
	Next nX
Else       

	DbSelectArea("SL4") 
	DbSetOrder(1)
	DbSelectArea("SL1")  
	DbSetOrder(4)
	SL1->(DbSeek(cFilAtu + Dtos(uDatAtu)))
	Do While SL1->(!Eof() .and. (L1_FILIAL +  DtoS(L1_EMISSAO)  == cFilAtu + Dtos(uDatAtu)))
		If !Empty(SL1->L1_STATUES) .And. ( !lUsaNMov .OR. LJVldMov("SL1") ) .AND. SL4->(DbSeek(cFilAtu+SL1->L1_NUM)) 
			Do While SL4->(!Eof() .and. (L4_FILIAL + L4_NUM == cFilAtu + SL1->L1_NUM))
				If SL4->L4_OPERAES == cCaiAtu .And. SL4->L4_ESTORN == "S" .and. ( (nX := aScan(aFormaImp, {|f| Alltrim(f[1]) == Alltrim(SL4->L4_FORMA)})) > 0 )
					aEstorno[nX] += SL4->L4_VALOR 
				EndIf
				SL4->(DbSkip(1))
			EndDo
		EndIf
		SL1->(Dbskip(1))
	EndDo
Endif
RestArea(aArea)
Return Nil 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFUNCAO    ³LJVldMov  ºAutor  ³Vendas Clientes     º Data ³  08/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se Numero do Movimento foi criado e se foi          º±±
±±º          ³ informado em MV_PAR11                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJVldMov(cAliasMov)

Local lRet		:= .T.
Local cCampo	:= ""
Local cColumnPos := ""

DEFAULT cAliasMov:= "SL1

cCampo		:= cAliasMov +"->"+SubSTR(cAliasMov,2,3)+"_NUMMOV"
cColumnPos 	:= cAliasMov +"->(ColumnPos('"+SubSTR(cAliasMov,2,3)+"_NUMMOV'))"

If &(cColumnPos) > 0
	If MV_PAR11 > "00" .AND. &(cCampo) <> MV_PAR11
		lRet := .F.
	EndIf
EndIf

Return lReT

//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} RetFormPag
Retorna array com as formas de pagamento digitadas no parâmetro
@type function
@author João Marcos Martins
@since 23/01/2018
@version 12.1.17
@param cFormasImp, string, formas de pagamento digitaras no parâmetro da pergunta 
@return array, array com as formas de pagamento
/*/
//-------------------------------------------------------------------------------------------------
Static Function RetFormPag(cFormasImp)
Local aRet       := {}
Local aCaracter  := {'\','/',',',';','|','-','+','*','@','#','%','&','=',':','?','!','<','>','.'}
Local cSeparador := ''
Local nX         := 1

cFormasImp := StrTran(AllTrim(cFormasImp),' ','')
cFormasImp := StrTran(AllTrim(cFormasImp),'"','')
cFormasImp := StrTran(AllTrim(cFormasImp),"'",'')

For nX := 1 To Len(aCaracter)
    If At(aCaracter[nX],cFormasImp) > 0
       cSeparador :=  aCaracter[nX]
       exit
    EndIf
Next nX

aRet := StrTokArr( AllTrim(cFormasImp), cSeparador )

return aRet

//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Lj7ImprIt
Verifica a forma de pagamento do item e se foi configurada no parâmetro "MV_PAR08 -> Formas de Pgto"
@type function
@author Gilmar Costa
@since 20/05/2021
@version P12
@param aFormPgs - Formas de Pagamentos configuradas no parâmetro MV_PAR08
@return lRet - Retorna se o item será impresso no relatório
/*/
//-------------------------------------------------------------------------------------------------
Function Lj7ImprIt(aFormPgs)
Local lRet			:= .F.				// Retorno da Função

Default aFormPgs	:= {}				// Formas de Pagamentos configuradas no parâmetro "MV_PAR08 -> Formas de Pgto"

If Len(aFormPgs) > 0
	If TRB->DINHEIRO > 0 .AND. aScan( aFormPgs,{ |x| x[2] == "DINHEIRO" } ) > 0
		lRet := .T.
	ElseIf TRB->CHEQUES > 0 .AND. aScan( aFormPgs,{ |x| x[2] == "CHEQUES" } ) > 0	
		lRet := .T.
	ElseIf TRB->CARTAO > 0 .AND. aScan( aFormPgs,{ |x| x[2] == "CARTAO" } ) > 0
		lRet := .T.
	ElseIf TRB->VLRDEBI> 0 .AND. aScan( aFormPgs,{ |x| x[2] == "VLRDEBI" } ) > 0
		lRet := .T.	
	ElseIf TRB->CONVENIO > 0 .AND. aScan( aFormPgs,{ |x| x[2] == "CONVENIO" } ) > 0 
		lRet := .T.	
	ElseIf TRB->VALES>0 .AND. aScan( aFormPgs,{ |x| x[2] == "VALES" } ) > 0
		lRet := .T.	
	ElseIf TRB->FINANC>0 .AND. aScan( aFormPgs,{ |x| x[2] == "FINANC" } ) > 0
		lRet := .T.	
	ElseIf TRB->OUTROS>0 .AND. aScan( aFormPgs,{ |x| x[2] == "OUTROS" } ) > 0
		lRet := .T.
	ElseIf TRB->CREDITO>0 .AND. aScan( aFormPgs,{ |x| x[2] == "CREDITO" } ) > 0
		lRet := .T.
	ElseIf lL1VLRPGDG .AND. TRB->VLRPGDG>0 .AND. aScan( aFormPgs,{ |x| x[2] == "VLRPGDG" } ) > 0
		lRet := .T.
	ElseIf lL1VLRPGDG .AND. TRB->VLRPGPX>0 .AND. aScan( aFormPgs,{ |x| x[2] == "VLRPGPX" } ) > 0
		lRet := .T.		
	ElseIf TRB->LDEV == "|"  	// Registro de Devolução criado no Result Set
		lRet := .T.	
	ElseIf TRB->LDEV == "+"  	// Registro de Estorno criado no Result Set
		lRet := .T.			
	EndIf		
	// TRB->LDEV = "|" ou TRB->LDEV = "+", nehuma das formas de pagaemnto acima, será maior que zero.	
EndIf
	
Return lRet
