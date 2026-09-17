#INCLUDE "CTBR076C.CH"
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "REPORT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo    ณ CTBR076  ณ Autor ณ Danilo Dias             ณ Data ณ 14/12/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa de Impressใo da tabela de hist๓ricos de altera็๕es	ณฑฑ
ฑฑณ          ณ das entidades contแbeis (CW8).                             	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ U_CTBR076C() 		                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SIGACTB                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                       ณฑฑL
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Function U_CTBR076C()   
Local oReport
Private cAlias := ""
Private cPerg  := "CTR076"						// Nome do grupo de perguntas

//Valida็ใo de aviso/bloqueio do relat๓rio em Release 12.1.2510 e superiores
//Captura a แrea de acordo com a conexใo
cAlias := GetNextAlias()	//Para TopConnection

If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MsgAlert( OemToAnsi(STR0028) )//"Relatorio disponํvel apenas em TReport."
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDef  Autor ณ Danilo Dias           ณ Data ณ 14/12/10 ณฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Defini็ใo do objeto do relat๓rio personalizแvel e das      บฑฑ
ฑฑบ          ณ se็๕es que serใo utilizadas                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACTB                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()

Local oReport
Local oSecaoCW8
Local cReport		:= "CTBR076"					// Nome do Relatorio
Local cTitulo		:= STR0004 						// "Hist๓rico de Altera็๕es"
Local cDesc			:= STR0001 + " " +;				// "Este programa irแ imprimir o Cadastro CW8-Hist๓rico de Altera็๕es."
					   STR0002 + " " + ;		    // "Serแ impresso de acordo com os parโmetros solicitados pelo"
					   STR0003						// "usuแrio."                                                                  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         						ณ
//ณ mv_par01		// Data Inicial.                             						ณ
//ณ mv_par02		// Data Final.                               						ณ
//ณ mv_par03		// Entidade Contabil ( Conta, C. Custo, Cl. Valor ou It. Contabil )	ณ
//ณ mv_par04		// Considera Bloqueios ( Sim ou Nใo ).      	 					ณ 
//ณ mv_par05		// Considera Opera็๕es ( Altera็ใo, Inclusใo, Exclusใo ou Todas ).  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Pergunte( cPerg, .F. )

DEFINE REPORT oReport NAME cReport TITLE cTitulo PARAMETER cPerg ACTION {|oReport| PrintReport( oReport )}  DESCRIPTION cDesc

	DEFINE SECTION oSecaoCW8 OF oReport TITLE cTitulo TABLE "CW8"

		DEFINE CELL NAME "CW8_TABELA" OF oSecaoCW8 ALIAS cAlias TITLE STR0007 	SIZE 16 LINE BREAK BLOCK({||TabDesc( (cAlias)->CW8_TABELA )})	//Title: "Entidade"
		DEFINE CELL NAME "CW8_CODIGO" OF oSecaoCW8 ALIAS cAlias TITLE STR0018	SIZE 14				//Title: "C๓d. Entidade"
		DEFINE CELL NAME "CW8_CAMPO"  OF oSecaoCW8 ALIAS cAlias TITLE STR0019 	SIZE 14				//Title: "Campo Alterado"
		DEFINE CELL NAME "CW8_SEQ"    OF oSecaoCW8 ALIAS cAlias TITLE STR0020	SIZE 9				//Title: "Seq. Alt." 
		DEFINE CELL NAME "CW8_TIPCPO" OF oSecaoCW8 ALIAS cAlias TITLE STR0021 	SIZE 4				//Title: "Tipo"
		DEFINE CELL NAME "CW8_TITULO" OF oSecaoCW8 ALIAS cAlias TITLE STR0022	SIZE 14				//Title: "Tit. do Campo"
		DEFINE CELL NAME "CW8_VALANT" OF oSecaoCW8 ALIAS cAlias TITLE STR0023 	SIZE 25 LINE BREAK	//Title: "Conte๚do Ant." 
		DEFINE CELL NAME "CW8_VALNOV" OF oSecaoCW8 ALIAS cAlias TITLE STR0024 	SIZE 25 LINE BREAK	//Title: "Conte๚do Atual"
		DEFINE CELL NAME "CW8_DATA"   OF oSecaoCW8 ALIAS cAlias TITLE STR0025	SIZE 10 			//Title: "Dt. Alt."
		DEFINE CELL NAME "CW8_HORA"   OF oSecaoCW8 ALIAS cAlias TITLE STR0026	SIZE 5				//Title: "Hora"
		DEFINE CELL NAME "CW8_OPC"    OF oSecaoCW8 ALIAS cAlias TITLE STR0027	SIZE 9				//Title: "Op็ใo"
				
	oReport:SetLandscape()		//Configura impressใo do relat๓rio como Paisagem por padrใo
			
Return oReport      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBR076Top  Autor ณ Danilo Dias        ณ Data ณ 10/12/2010 ณฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Impressใo do relat๓rio de acordo com o tipo de BD          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTBR076                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport( oReport, oSecaoCW8 )

Local bCondicao := {|| (((cAlias)->CW8_DATA >= mv_par01) .And. ((cAlias)->CW8_DATA <= mv_Par02)) .And. AllTrim((cAlias)->CW8_FILIAL) == AllTrim(XFILIAL('CW8')) .And. (cAlias)->CW8_TABELA == cEntidade }
Local cCondicao :=    "(((cAlias)->CW8_DATA >= mv_par01) .And. ((cAlias)->CW8_DATA <= mv_Par02)) .And. AllTrim((cAlias)->CW8_FILIAL) == AllTrim(XFILIAL('CW8')) .And. (cAlias)->CW8_TABELA == cEntidade"
Local cPart     := ""
Local cEntidade := ""
Local cOperacao := ""
Local cTabela   := ""		//Tabela que sofreu altera็ใo para capturar a descri็ใo

//Filtra a tabela
If ( mv_par03 == 1 )
	cEntidade := "CT1"		//Plano de Contas
ElseIf ( mv_par03 == 2 )
	cEntidade := "CTT"		//Centro de Custos
ElseIf ( mv_par03 == 3 )
	cEntidade := "CTD"		//Item Contแbil
ElseIf ( mv_par03 == 4 )
	cEntidade := "CTH"		//Classe de Valor
EndIf

cTabela := TabDesc( cEntidade )
    
//Considera Bloqueios?
If ( mv_par04 == 2 )
	cPart := "%'CT1_BLOQ','CTT_BLOQ','CTD_BLOQ','CTH_BLOQ'%"		//Sim
Else
	cPart := "%''%"													//Nใo
EndIf
	
//Considera as opera็๕es
If ( mv_par05 == 1 )
	cOperacao := "%'3'%"				//Inclusใo
ElseIf ( mv_par05 == 2 )
	cOPeracao := "%'4'%"				//Altera็ใo
ElseIf ( mv_par05 == 3 )
	cOPeracao := "%'5'%"				//Exclusใo
Else
	cOPeracao := "%'3', '4', '5'%"		//Todas
End If
	
MakeSqlExp( oReport:uParam )
oReport:Section(1):BeginQuery()
	
BeginSql Alias cAlias
		
	Column CW8_DATA As Date
	
	SELECT CW8_DATA,
		   CW8_HORA,
		   CW8_TABELA,
		   CW8_CODIGO,
		   CW8_CAMPO,
		   CW8_SEQ,
		   CW8_TIPCPO,
		   CW8_TITULO,
		   CW8_OPC,
		   CW8_VALANT,
		   CW8_VALNOV
	  FROM %Table:CW8% CW8
	 WHERE CW8_FILIAL = %xFilial:CW8%
	   AND CW8_TABELA = %exp:cEntidade%
	   AND CW8_DATA BETWEEN %exp:mv_par01% AND %exp:mv_par02%
	   AND CW8_OPC IN ( %exp:cOperacao% )
	   AND CW8_CAMPO NOT IN ( %exp:cpart% )
	   AND CW8.%notdel%
			
EndSql
	
oReport:Section(1):EndQuery()
oReport:Section(1):Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบFun็ใo    ณ TabDesc     Autor ณ Danilo Dias        ณ Data ณ 14/12/2010 ณฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Captura a descri็ใo da tabela de acordo com o idioma       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cTabela: Nome da tabela para capturar a descri็ใo          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTBR076                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TabDesc( cTabela )
           
Local cTabDesc := ""
Local aArea    := GetArea()		//Guarda แrea atual

dbSelectArea("SX2")				//Seleciona dicionแrio SX2 (Tabelas)
dbSetOrder(1)              

If dbSeek( cTabela )           	//Procura Tabela no dicionแrio
	cTabDesc := X2Nome()		//Se encontrar, pega a descri็ใo
EndIf

RestArea(aArea)					//Restaura แrea
         
Return cTabDesc
