#INCLUDE "PCOR211C.ch"
#INCLUDE "PROTHEUS.ch"

Function U_PCOR211C(aOrigem,aComparado,cVersao1,cVersao2,aPerg)

//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
U_PCOR212C(aOrigem,aComparado,cVersao1,cVersao2,aPerg)

Return

Function U_PCOR212C(aOrigem,aComparado,cVersao1,cVersao2,aPerg)
Local aArea		:= GetArea()

//OBSERVACAO NAO TIRAR A LINHA ABAIXO POIS VARIAVEL SERA UTILIZADA NA CONSULTA PADRAO AKE1
Private M->AKR_ORCAME := Replicate("Z", Len(AKR->AKR_ORCAME))

DEFAULT aOrigem   	:= {}
DEFAULT aComparado	:= {}
DEFAULT cVersao1  	:= "0001"
DEFAULT cVersao2  	:= "0001"
DEFAULT aPerg  		:= {}

dbSelectArea("AK1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := ReportDef(aOrigem,aComparado,cVersao1,cVersao2,aPerg)

oReport:PrintDialog()

RestArea(aArea)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Paulo Carnelossi       ³ Data ³29/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
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
Static Function ReportDef(aOrigem,aComparado,cVersao1,cVersao2,aPerg)
Local cDesc1         := STR0001 //"Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := STR0002 //"de acordo com os parametros informados pelo usuario."
Local cDesc3         := STR0003 //"Diferencas entre Versoes"
Local cTitulo        := STR0003 //"Diferencas entre Versoes"
Local cPerg          := "PCR211"

Local aOrdem := {}
Local oReport
Local oPlanilha
Local oEntidade

DEFAULT aOrigem   	:= {}
DEFAULT aComparado	:= {}
DEFAULT cVersao1  	:= "0001"
DEFAULT cVersao2  	:= "0001"
DEFAULT aPerg  		:= {}

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

oReport := TReport():New("PCOR211",STR0003, cPerg, ;
			{|oReport| ReportPrint(oReport,aOrigem,aComparado,cVersao1,cVersao2,aPerg)},;
			STR0001+CRLF+STR0002+CRLF+STR0003 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Selecionadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PARAMETROS                                                             ³
//³ MV_PAR01 : Projeto ?	                                                ³
//³ MV_PAR02 : Versao De ?		                                             ³
//³ MV_PAR03 : Versao Ate ?												            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

If (Len(aOrigem) == 0) .Or. (Len(aComparado) == 0)
	If Len(aPerg) > 0
		aEval(aPerg, {|x, y| &("MV_PAR"+StrZero(y,2)) := x})
        oReport:ParamReadOnly()
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamado atraves do programa de comparacao de versoes.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Mv_Par01:= AK1->AK1_CODIGO
	Mv_Par02:= cVersao1
	Mv_Par03:= cVersao2
	oReport:ParamReadOnly()
EndIf

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
//adiciona ordens do relatorio

oPlanilha := TRSection():New(oReport,STR0010,{"AK1"}, aOrdem /*{}*/, .F., .F.)
oPlanilha:SetNoFilter({"AK1"})

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
TRCell():New(oPlanilha,	"AK1_CODIGO"	,"AK1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| (cAliasAF8)->AFE_PROJET }*/)
TRCell():New(oPlanilha,	"AK1_DESCRI"	,"AK1",/*Titulo*/,/*Picture*/,50/*Tamanho*/,/*lPixel*/,/*{|| (cAliasAF8)->AF8_DESCRI }*/)
oPlanilha:SetLineStyle()
oPlanilha:SetHeaderPage()
oReport:onPageBreak({||oPlanilha:PrintLine(),oReport:ThinLine()})

oEntidade := TRSection():New(oReport,STR0016,{}, aOrdem /*{}*/, .F., .F.)  //"Entidade"
TRCell():New(oEntidade,	"DESC_ALIAS"	,/*Alias*/,STR0016+" :"/*Titulo*/,/*Picture*/,50/*Tamanho*/,/*lPixel*/,/*{|| (cAliasAF8)->AFE_PROJET }*/)  //"Entidade"
TRCell():New(oEntidade,	"CONTEUDO"	,/*Alias*/,"-->"/*Titulo*/,/*Picture*/,TamSX3("AK3_DESCRI")[1]+15/*Tamanho*/,/*lPixel*/,/*{|| (cAliasAF8)->AFE_PROJET }*/)
oEntidade:SetLineStyle()
oEntidade:SetCharSeparator("")

oCompara := TRSection():New(oReport,STR0003,{}, aOrdem /*{}*/, .F., .F.)

TRCell():New(oCompara,	"CAMPO"	,/*Alias*/,STR0017/*Titulo*/,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| (cAliasAF8)->AFE_PROJET }*/)  //"Campos"
TRCell():New(oCompara,	"CVERSAO1"	,/*Alias*/,STR0019 /*Titulo*/,/*Picture*/,40/*Tamanho*/,/*lPixel*/,/*{|| (cAliasAF8)->AFE_PROJET }*/)
TRCell():New(oCompara,	"CVERSAO2"	,/*Alias*/,STR0020 /*Titulo*/,/*Picture*/,40/*Tamanho*/,/*lPixel*/,/*{|| (cAliasAF8)->AF8_DESCRI }*/)
oCompara:SetHeaderPage()

Return(oReport)

Static Function ReportPrint(oReport,aOrigem,aComparado,cVersao1,cVersao2,aPerg)
Local oPlanilha := oReport:Section(1)
Local oEntidade := oReport:Section(2)
Local oCompara 	:= oReport:Section(3)

Local aDestino:= {}
Local aDados  := {}
Local aAlias  := {	{"AK3",STR0006},; //"Contas Orcamentarias"
					{"AK2",STR0007}} //"Itens das CO"
Local nItem   := 0
Local nDados  := 0
Local cCodAnt := ""

oEntidade:Cell("DESC_ALIAS"):SetBlock( {|| aAlias[nIndice,2] + " (" + aDados[nDados,7] + ")" } )
oEntidade:Cell("CONTEUDO"):SetBlock( {|| aDados[nDados,3] } )

oCompara:Cell("CAMPO"):SetBlock( {|| Left(Posicione("SX3",2,aDados[nDados,4],"X3TITULO()") + Space(20),20) } )
oCompara:Cell("CVERSAO1"):SetBlock( {|| aDados[nDados,5] } )
oCompara:Cell("CVERSAO2"):SetBlock( {|| aDados[nDados,6] } )
oCompara:Cell("CVERSAO1"):SetTitle( STR0018+": "+mv_par02 )  //"Versao"
oCompara:Cell("CVERSAO2"):SetTitle( STR0018+": "+mv_par03 )  //"Versao"

If (Len(aOrigem) == 0) .Or. (Len(aComparado) == 0)

    If Len(aPerg) == 0
		If !Empty(oReport:uParam)
			Pergunte(oReport:uParam,.F.)
		EndIf
	EndIf	

	dbSelectArea("AK1")
	dbSetOrder(1)

	If !Empty(mv_par01) .And. dbSeek(xFilial("AK1") + Mv_Par01)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta um array com a estrutura do tree do projeto que sera utilizado ³
		//³como base na comparacao.                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa({||aOrigem := Pco120TreeEDT(Mv_Par02)},,STR0008) //"Selecionando Registros"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta um array com a estrutura do tree do projeto que sera utilizado ³
		//³como na comparacao.                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa({||aDestino := Pco120TreeEDT(Mv_Par03)},,STR0008) //"Selecionando Registros"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta um array com a estrutura do tree do projeto da comparacao entre³
		//³as versoes.				                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aComparado:= Pco120_Compara(aOrigem,aDestino)
	EndIf	
EndIf

If (Len(aComparado) > 0)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter(Len(aComparado))
    oPlanilha:Init()
    
	For nItem:= 1 To Len(aComparado)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Verifica o cancelamento pelo usuario...                             ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    If oReport:Cancel()
	      	Exit
	   	EndIf
	   	
	   	oReport:IncMeter()
	   	
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   	//³ Impressao do cabecalho do relatorio. . .                            ³
	   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    If (aComparado[nItem,6] <> "N")

			aDados:= R211Compara(aOrigem,aComparado,nItem)			

			oEntidade:Init()
			oCompara:Init()

			For nDados:= 1 To Len(aDados)
		
				If (aDados[nDados,1] + aDados[nDados,2] <> cCodAnt)
					cCodAnt:= aDados[nDados,1] + aDados[nDados,2]
					nIndice := Ascan(aAlias,{|x|x[1] == aDados[nDados,1]})

					oReport:ThinLine()
					oEntidade:PrintLine()
					oReport:ThinLine()
					
				EndIf

				oCompara:PrintLine()

			Next nDados

			oCompara:Finish()
			oEntidade:Finish()

	    EndIf
	    
	Next nItem
	
	oPlanilha:Finish()
	 
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³R211Comparaº Autor ³ Paulo Carnelossi      º Data ³  04/01/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica as diferencas entre as versoes						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP       		                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R211Compara(aOrigem,aComparado,nPosComp)
Local aCampos:= {}
Local aStrut := {}
Local aDados := {}
Local nCampo := 0
Local nPosOri:= 0
Local cAlias := ""
Local cChave := ""
Local cCampo := ""
Local cDesc  := ""
Local cTipo  := ""
Local cValor := ""
Local cCO    := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Analisa cada item das versoes do projeto para identificar as alteracoes.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias:= aComparado[nPosComp,1]
cChave:= aComparado[nPosComp,2]
cDesc := aComparado[nPosComp,3]
cTipo := aComparado[nPosComp,6]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o item existe no arquivo.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbSetOrder(1)
If dbSeek(cChave,.T.)
	aStrut:= &(cAlias + "->(dbStruct())")
	aDados:= Array(1,Len(aStrut))

	AEval(aStrut,{|cValue,nIndex| aDados[1,nIndex]:= {aStrut[nIndex,1],FieldGet(FieldPos(aStrut[nIndex,1]))}})
		                                 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Guarda conta orcamentaria para inclusão no aCampos e posterior impressao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosCO	:= aScan(aDados[1],{|x| AllTrim(Upper(x[1]))== cAlias + "_CO"})
	cCO		:= RTrim(aDados[1,nPosCO,2])

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o tipo da operacao I=Incluido M=Modificado e E=Excluido.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Item Incluido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case cTipo == "I"
			For	nCampo:= 1 To Len(aDados[1])	
				cCampo:= aDados[1,nCampo,1]
				cValor:= aDados[1,nCampo,2]
	
				If !("VERSAO" $ cCampo)
					Aadd(aCampos,{	cAlias,;
									cChave,;
									cDesc,;
									cCampo,;
									Space(40),;
									Left(AllTrim(Transform(cValor,PesqPict(cAlias,cCampo))) + Space(40),40),;
									cCO})
				EndIf
			Next
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Item Modificado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case cTipo == "M"                
			nPosOri:= Ascan(aOrigem,{|x| x[4] == aComparado[nPosComp,4]})
			If (nPosOri > 0) .And. dbSeek(aOrigem[nPosOri,2],.T.)
				For	nCampo:= 1 To Len(aDados[1])	
					cCampo:= aDados[1,nCampo,1]
					cValor:= aDados[1,nCampo,2]

					If !("VERSAO" $ cCampo) .And. (cValor <> FieldGet(nCampo))
							Aadd(aCampos,{	cAlias,;
											cChave,;
											cDesc,;
											cCampo,;
											Left(AllTrim(Transform(FieldGet(nCampo),PesqPict(cAlias,cCampo))) + Space(40),40),;
											Left(AllTrim(Transform(cValor,PesqPict(cAlias,cCampo))) + Space(40),40),;
											cCO})

					EndIf
				Next
        	EndIf
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Item Excluido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case cTipo == "E"                 
			nPosOri:= Ascan(aOrigem,{|x| x[4] == aComparado[nPosComp,4]})
			If (nPosOri > 0) .And. dbSeek(aOrigem[nPosOri,2],.T.)
				For	nCampo:= 1 To Len(aDados[1])	
					cCampo:= aDados[1,nCampo,1]
					cValor:= aDados[1,nCampo,2]

					If !("VERSAO" $ cCampo)

						Aadd(aCampos,{	cAlias,;
										cChave,;
										cDesc,;
										cCampo,;
										Left(AllTrim(Transform(cValor,PesqPict(cAlias,cCampo))) + Space(40),40),;
										Space(40),;
										cCO})
					 EndIf
				Next
			EndIf
	EndCase
EndIf
		
Return(aCampos)
