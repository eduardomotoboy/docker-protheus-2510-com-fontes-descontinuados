#Include "Protheus.Ch"
#Include "Report.Ch"
#Include "COMR043C.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMR043   ºAutor  ³Julio Saraiva       º Data ³  24/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Lista fornecedores de um item ou de uma familia de itens   º±±
±±º          ³ contendo ultimo preco e data do ultimo preco               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CNI                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                  

Function U_COMR043C()
Local oReport
Local cPerg1 := "C043P" // por produto
Local cPerg2 := "C043G" // por grupo
Local cPerg
Static nTpRel 			// Tipo de relatorio, 1=produto, 2=grupo

//Validação de aviso/bloqueio do relatório em Release 12.1.2510 e superiores
nTpRel := Aviso(STR0007,STR0008,{STR0009,STR0010}) // 0007 -Selecione: 0008 - Selecione o tipo de Relatório 0009 - Produto  0010 - Grupo 

If nTpRel==1
	cPerg := cPerg1 
	Pergunte( cPerg1, .T. )
else
	cPerg := cPerg2 
	Pergunte( cPerg2, .T. )
endif

oReport := DefCell(cPerg)
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DefCell   ºAutor  ³Julio Saraiva       º Data ³  25/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que define as celulas a serem exibidas no relatorio  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CNI                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DefCell(cPerg)
Local oReport	:= NIL
Local oSection1	:= NIL				
Local oSection2	:= NIL
Local cTitulo := STR0011 // Lista de fornecedores do item com preço e data do último preço
Local cAlias1 	:= GetNextAlias()	
Local cAlias2  	:= GetNextAlias()
Local lPageBreak := .T.

//Define o Relatorio - TReport

oReport := TReport():New("COMR043",cTitulo,cPerg,{|oReport| DefPrint(oReport,cPerg,cAlias1,cAlias2)},"Lista de Fornecedores do Item com preço e Data do último preço") 
oReport:SetLandscape()			// Escolhe o padrao de Impressao como Paisagem
oReport:nFontBody   := 9			// Tamanho da fonte inicial do Reltorio
oReport:nLineHeight := 40		// Largura da Linha 
//oReport:nColSpace  := 9

oSection1:=TRSection():New( oReport,"",{"SB1","SBM"})
oSection1:PageBreak (lPageBreak)
oSection1:SetLineStyle()

TRCell():New(oSection1,"B1_COD"    ,"SB1",STR0009/*Produto*/,,16,,,,,,,,,,,.T.)  // 16 = nr de caracteres do campo B1_COD   // .T. = negrito
TRCell():New(oSection1,"B1_DESC"   ,"SB1"," " 				,,40,,,,,,,,,,,.T.)  // 40 = nr de caracteres do campo B1_DESC  // .T. = negrito

oSection2:=TRSection():New( oSection1,"",{"SA5","SD1","SB1","SAD"} )
oSection2:PageBreak (lPageBreak)

//Alterado para buscar os dados direto do SX3
TRCell():New(oSection2,"A5_FORNECE","SA5","Código"   		,,TamSX3("A5_FORNECE")[1]/*06*/)
TRCell():New(oSection2,"LOJA"		,"SA5","Loja"     		,,TamSX3("A5_LOJA")[1]/*02*/)
TRCell():New(oSection2,"A5_NOMEFOR"	,"SA5","Nome"  	 		,,TamSX3("A5_NOMEFOR")[1]/*40*/)
TRCell():New(oSection2,"GRUPO"		,"SD1","Grupo"    		,,TamSX3("D1_GRUPO")[1]/*04*/)
TRCell():New(oSection2,"DESCRICAO"	,"SBM","Descrição"		,,TamSX3("BM_DESC")[1]/*30*/)
TRCell():New(oSection2,"D1_VUNIT"	,"SD1","Ultimo Preço"	,,TamSX3("D1_VUNIT")[1]/*16*/)
TRCell():New(oSection2,"DTEMIS"		,"SD1","Dt Ultimo Preço"	,,TamSX3("D1_EMISSAO")[1]/*16*/) 


Return( oReport )        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DefPrint  ºAutor  ³Julio Saraiva       º Data ³  25/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsavel por imprimir o relatorio                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CNI                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DefPrint(oReport,cPerg,cAlias1,cAlias2)
Local oSection1	 := oReport:Section(1)                    				  	/// Secao do Cabeçalho
Local oSection2	 := oReport:Section(1):Section(1)							/// Secao do Usuario
Local lFooter  	 := .T.														// Variavel para pular a pagina na quebra da secao 1
Local cAntForn	 
Local cAntProd	 
         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query com os resultados a serem exibidos na secao 1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

BEGIN REPORT QUERY oSection1 		 
If nTpRel==1
	BeginSQL alias cAlias1     // por Produto
		
		SELECT SB1.B1_COD, SB1.B1_DESC
		
		FROM   %Table:SB1% SB1				
		
		WHERE	SB1.B1_FILIAL	= %xFilial:SB1% AND
				SB1.B1_COD BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% 
				
		ORDER BY %ORDER:SB1%
		
	EndSQL

else
	BeginSQL alias cAlias1        // por grupo

		SELECT SB1.B1_COD, MAX(B1_DESC) AS B1_DESC
		FROM %Table:SAD% SAD
		JOIN %Table:SB1% SB1
		ON SB1.B1_GRUPO = SAD.AD_GRUPO
		WHERE AD_GRUPO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		GROUP BY B1_COD, AD_GRUPO
		ORDER BY B1_COD,AD_GRUPO

	EndSQL

endif

END REPORT QUERY oSection1 	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query com os resultados a serem exibidos na secao 2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

BEGIN REPORT QUERY oSection2

	BeginSQL alias cAlias2 
	  
		SELECT  SA5.A5_PRODUTO , SA5.A5_FORNECE , SA5.A5_LOJA AS LOJA, SA5.A5_NOMEFOR AS NOMEFOR ,;
				SD1.D1_GRUPO AS GRUPO, SBM.BM_DESC AS DESCRICAO, MAX(D1_EMISSAO) AS DTEMIS, SD1.D1_VUNIT   
		FROM %Table:SA5% SA5 
		JOIN %Table:SD1% SD1 
		ON SD1.D1_FORNECE = SA5.A5_FORNECE AND 
		SD1.D1_COD = SA5.A5_PRODUTO 
		JOIN %Table:SBM% SBM 
		ON SD1.D1_GRUPO = SBM.BM_GRUPO 
		WHERE A5_PRODUTO  = %report_param:(cAlias1)->B1_COD%		
		GROUP BY SA5.A5_FORNECE, SA5.A5_PRODUTO, SA5.A5_NOMEFOR, SA5.A5_LOJA, SD1.D1_GRUPO, SBM.BM_DESC, SD1.D1_VUNIT		 
		ORDER BY DTEMIS DESC	
       
	EndSQL

END REPORT QUERY oSection2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop de impressao das linhas do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	While !oReport:Cancel() .AND. (cAlias1)->(!Eof())   
		oSection1:Init()    
		/// Executa a query da secao 2
		oSection2:ExecSql()	
   
		If  !(cAlias2)->(Eof()) 
	
			oSection1:PrintLine() 	// imprime cabecalho (Secao 1)
		
	   		While !oReport:Cancel() .And. !(cAlias2)->(Eof()) 		// imprime Secao 2
	   			If !(cAntForn == (cAlias2)->A5_FORNECE .And. cAntProd == (cAlias2)->A5_PRODUTO)	   	
		   			cAntForn := (cAlias2)->A5_FORNECE 
			   		cAntProd := (cAlias2)->A5_PRODUTO 		   	
					oSection2:Init()
					oSection2:PrintLine()
				endif
								
				(cAlias2)->( DbSkip() )
			
			Enddo                              	
		
			oReport:SkipLine()//Pula uma linha
			oReport:SkipLine()//Pula uma linha
			oReport:SkipLine()//Pula uma linha
			oReport:FatLine() //Desenha uma Linha 
	
		EndIf
		oSection2:Finish()
		(cAlias1)->( DbSkip() )  
	ENDDO
oSection1:Finish()
Return