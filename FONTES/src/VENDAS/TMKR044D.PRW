#INCLUDE "TMKR044D.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKR044D  ºAutor  ³Armando M. Tessaroliº Data ³  18/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta funcao ira pesquisar os dados do chamado tecnico reali-º±±
±±º          ³zados para o contato e a entidade selecionados.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMKR044D(lEnd,wnrel,cString,nomeprog,Titulo,oExplorer,aEmpCont)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao Do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nLi		:= 0			// Linha a ser impressa
Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio
Local cCabec1	:= "" 			// Label dos itens
Local cCabec2	:= "" 			// Label dos itens

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis especificas para este relatorio      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nI		:= 0					// Controle de loop
Local nJ		:= 0					// Controle de loop
Local aAB2_Tipo	:= TkSx3Box("AB2_TIPO")	// Busca as opcoes do campo no dicionario
Local aArray	:= {}					// Dados específicos
Local aPDFields	:= {"A1_NOME"}

If Type("aDados") == "A"
	aArray := aDados[7]
EndIf

If ValType(aArray) == "A" .And. Len(aArray) > 0

	FATPDLoad(/*cUserPDA*/, /*aAlias*/, aPDFields)
	
	// Atendimentos do contato
	TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000		PSay __PrtFatLine()
	
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi,000		PSay STR0001 //"C H A M A D O S   N A   A S S I S T Ê N C I A   T É C N I C A"
	
	DbSelectArea("AB1")
	DbSetOrder(1)
	For nJ := 1 to Len(aArray)
		MsSeek(xFilial("AB1") + aArray[nJ][1])
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay __PrtFatLine()
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay PadR(STR0002,25) //"Número do Chamado"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_NRCHAM,8)
		@ nLi,Limite/3	PSay PadR(STR0003,25) //"Data do Chamado"
		@ nLi,PCol()+1	PSay PadR(DtoC(AB1->AB1_EMISSA),10)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay PadR(STR0004,25) //"Código / Loja Cliente"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_CODCLI + " / " + AB1->AB1_LOJA ,45)
		@ nLi,Limite/3	PSay PadR(STR0005,25) //"Nome do Cliente"
		@ nLi,PCol()+1	PSay PadR(FATPDObfuscate(Posicione("SA1",1,xFilial("SA1")+AB1->AB1_CODCLI,"A1_NOME"),"A1_NOME"),45)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay PadR(STR0006,25) //"Hora Inicial"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_HORA,45)
		@ nLi,Limite/3	PSay PadR(STR0007,25) //"Hora Final"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_HORAF,45)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay PadR(STR0008,25) //"Telefone"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_TEL,45)
		@ nLi,Limite/3	PSay PadR(STR0009,25) //"Contato"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_CONTAT,45)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay PadR(STR0010,25) //"Atendente"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_ATEND,45)
		@ nLi,Limite/3	PSay PadR(STR0011,25) //"Status"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_STATUS,45)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay PadR(STR0012,25) //"Situação"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_OK,45)
		@ nLi,Limite/3	PSay PadR(STR0013,25) //"Região"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_REGIAO,45)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay PadR(STR0014,25) //"Chamado TELEMARKETING"
		@ nLi,PCol()+1	PSay PadR(AB1->AB1_NUMTMK,45)
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nli,000		PSay  __PrtFATLine()
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,000		PSay STR0015 //"Item  Situação      Class  Produto/Eqto     Nr.Série              Ocorr.  O.S.      Orçam.    Fabric  Lj  Chamado   Client  Lj  Emissão   Baixa     Baixa  H.Desk  Histórico"
		
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nli,000		PSay  __PrtFATLine()
		
		DbSelectArea("AB2")
		DbSetOrder(1)
		MsSeek(xFilial("AB2") + AB1->AB1_NRCHAM)
		While	!Eof()								.AND.;
				AB2->AB2_FILIAL == xFilial("AB2")	.AND.;
				AB2->AB2_NRCHAM == AB1->AB1_NRCHAM
			
			TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
			@ nLi,000		PSay AB2->AB2_ITEM
			@ nLi,PCol()+4	PSay PadR(IIF(!Empty(AB2->AB2_TIPO),aAB2_Tipo[Val(AB2->AB2_TIPO)],""),12)
			@ nLi,PCol()+2	PSay AB2->AB2_CLASSI
			@ nLi,PCol()+4	PSay AB2->AB2_CODPRO
			@ nLi,PCol()+2	PSay AB2->AB2_NUMSER
			@ nLi,PCol()+2	PSay AB2->AB2_CODPRB
			@ nLi,PCol()+2	PSay AB2->AB2_NUMOS
			@ nLi,PCol()+2	PSay AB2->AB2_NUMORC
			@ nLi,PCol()+2	PSay AB2->AB2_CODFAB
			@ nLi,PCol()+2	PSay AB2->AB2_LOJAFA
			@ nLi,PCol()+2	PSay AB2->AB2_NRCHAM
			@ nLi,PCol()+2	PSay AB2->AB2_CODCLI
			@ nLi,PCol()+2	PSay AB2->AB2_LOJA
			@ nLi,PCol()+2	PSay AB2->AB2_EMISSA
			@ nLi,PCol()+2	PSay AB2->AB2_BXDATA
			@ nLi,PCol()+2	PSay AB2->AB2_BXHORA
			@ nLi,PCol()+2	PSay AB2->AB2_NUMHDE
			
			If !Empty(AB2->AB2_MEMO)
				aLinhas := TkMemo(AB2->AB2_MEMO, 60)
				For nI := 1 to Len(aLinhas)
					If nI > 1
						TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
					Endif
					@ nLi,163 PSay aLinhas[nI]
				Next nI
			Endif
			
			DbSelectArea("AB2")
			DbSkip()
		End
		TkIncLine(@nLi,2,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		
	Next nJ
	FATPDUnload()
Endif

aSize(aPDFields, 0)
FATPDLogUser("TMKR044D")

Return(.T.)

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} FATPDLoad
    @description
    Inicializa variaveis com lista de campos que devem ser ofuscados de acordo com usuario.
	Remover essa função quando não houver releases menor que 12.1.27

    @type  Function
    @author Squad CRM & Faturamento
    @since  05/12/2019
    @version P12.1.27
    @param cUser, Caractere, Nome do usuário utilizado para validar se possui acesso ao 
        dados protegido.
    @param aAlias, Array, Array com todos os Alias que serão verificados.
    @param aFields, Array, Array com todos os Campos que serão verificados, utilizado 
        apenas se parametro aAlias estiver vazio.
    @param cSource, Caractere, Nome do recurso para gerenciar os dados protegidos.
    
    @return cSource, Caractere, Retorna nome do recurso que foi adicionado na pilha.
    @example FATPDLoad("ADMIN", {"SA1","SU5"}, {"A1_CGC"})
/*/
//-----------------------------------------------------------------------------------
Static Function FATPDLoad(cUser, aAlias, aFields, cSource)
	Local cPDSource := ""

	If FATPDActive()
		cPDSource := FTPDLoad(cUser, aAlias, aFields, cSource)
	EndIf

Return cPDSource

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} FATPDUnload
    @description
    Finaliza o gerenciamento dos campos com proteção de dados.
	Remover essa função quando não houver releases menor que 12.1.27

    @type  Function
    @author Squad CRM & Faturamento
    @since  05/12/2019
    @version P12.1.27
    @param cSource, Caractere, Remove da pilha apenas o recurso que foi carregado.
    @return return, Nulo
    @example FATPDUnload("XXXA010") 
/*/
//-----------------------------------------------------------------------------------
Static Function FATPDUnload(cSource)    

    If FATPDActive()
		FTPDUnload(cSource)    
    EndIf

Return Nil

//-----------------------------------------------------------------------------
/*/{Protheus.doc} FATPDObfuscate
    @description
    Realiza ofuscamento de uma variavel ou de um campo protegido.
	Remover essa função quando não houver releases menor que 12.1.27

    @type  Function
    @sample FATPDObfuscate("999999999","U5_CEL")
    @author Squad CRM & Faturamento
    @since 04/12/2019
    @version P12
    @param xValue, (caracter,numerico,data), Valor que sera ofuscado.
    @param cField, caracter , Campo que sera verificado.
    @param cSource, Caractere, Nome do recurso que buscar dados protegidos.
    @param lLoad, Logico, Efetua a carga automatica do campo informado

    @return xValue, retorna o valor ofuscado.
/*/
//-----------------------------------------------------------------------------
Static Function FATPDObfuscate(xValue, cField, cSource, lLoad)
    
    If FATPDActive()
		xValue := FTPDObfuscate(xValue, cField, cSource, lLoad)
    EndIf

Return xValue

//-----------------------------------------------------------------------------
/*/{Protheus.doc} FATPDLogUser
    @description
    Realiza o log dos dados acessados, de acordo com as informações enviadas, 
    quando a regra de auditoria de rotinas com campos sensíveis ou pessoais estiver habilitada
	Remover essa função quando não houver releases menor que 12.1.27

   @type  Function
    @sample FATPDLogUser(cFunction, nOpc)
    @author Squad CRM & Faturamento
    @since 06/01/2020
    @version P12
    @param cFunction, Caracter, Rotina que será utilizada no log das tabelas
    @param nOpc, Numerico, Opção atribuída a função em execução - Default=0

    @return lRet, Logico, Retorna se o log dos dados foi executado. 
    Caso o log esteja desligado ou a melhoria não esteja aplicada, também retorna falso.

/*/
//-----------------------------------------------------------------------------
Static Function FATPDLogUser(cFunction, nOpc)

	Local lRet := .F.

	If FATPDActive()
		lRet := FTPDLogUser(cFunction, nOpc)
	EndIf 

Return lRet  

//-----------------------------------------------------------------------------
/*/{Protheus.doc} FATPDActive
    @description
    Função que verifica se a melhoria de Dados Protegidos existe.

    @type  Function
    @sample FATPDActive()
    @author Squad CRM & Faturamento
    @since 17/12/2019
    @version P12    
    @return lRet, Logico, Indica se o sistema trabalha com Dados Protegidos
/*/
//-----------------------------------------------------------------------------
Static Function FATPDActive()

    Static _lFTPDActive := Nil
  
    If _lFTPDActive == Nil
        _lFTPDActive := ( GetRpoRelease() >= "12.1.027" .Or. !Empty(GetApoInfo("FATCRMPD.PRW")) )  
    Endif

Return _lFTPDActive