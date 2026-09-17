#INCLUDE "MATR005C.ch"
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ MATR005       บAutor  ณMicrosiga           บ Data ณ  16/08/10   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de log de produtos                            	       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum														   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum                                                          บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Function U_MATR005C()
Local olReport                  //Objeto TReport

//Valida็ใo de aviso/bloqueio do relat๓rio em Release 12.1.2510 ou superiores
	
/*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 ณ| mv_par01 - Data de?  - Data inicial do Log |ณ
 ณ| mv_par02 - Data at้? - Data final do Log   |ณ
 ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
If TRepInUse() .And. Pergunte("LOGPROD",.T.)
	olReport := FRELLOG()
	olReport:PrintDialog()
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ FRELLOG       บAutor  ณMicrosiga           บ Data ณ  16/08/10   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria o objeto TReport para a realiza็ใo do relatorio.   	       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum														   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Objeto do TReport                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function FRELLOG()
Local clNomProg		:= FunName() 									//Nome da fun็ใo
Local clTitulo 		:= STR0001		//Titulo do relatorio 			//"Log de produtos"
Local clDesc   		:= STR0002 		//Descri็ใo do relatorio 		//"Relatorio de log de produtos e complemento de produtos"

olReport:=TReport():New(clNomProg,clTitulo,"LOGPROD",{|olReport| FIMPLOGP(olReport)},clDesc)
olReport:lFooterVisible := .F.	// Nใo imprime rodap้ do protheus
olReport:lParamPage:=.F.		// Nใo imprime pagina de parametros
olReport:SetLandscape()			// Formato paisagem
	
Return olReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ FIMPLOGP      บAutor  ณMicrosiga           บ Data ณ  16/08/10   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo do relatorio de log de produtos.				       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ olReport = Objeto TReport para a impressใo do relatorio		   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum                                                          บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function FIMPLOGP(olReport)
Local alRegLog	:= {} //Array de registros para a impressao do relatorio
Local nlI		:= 0  //Contador de registros do alRegLog
Local nlLin		:= 0  //Posi็ใo da linha de impressใo
Local nlCol		:= 0  //Posi็ใo da coluna de impressใo
   
alRegLog := FRELTOP()

nlLin := 250
nlCol := 35

dbSelectArea("SDR")    
olReport:Say(nlLin,nlCol     ,RetTitle("DR_PRODUTO"),,,,)
olReport:Say(nlLin,nlCol+0250,RetTitle("DR_ALIAS"),,,,)
olReport:Say(nlLin,nlCol+0400,RetTitle("DR_CAMPO"),,,,)
olReport:Say(nlLin,nlCol+0600,RetTitle("DR_DATA"),,,,)
olReport:Say(nlLin,nlCol+0800,RetTitle("DR_HORA"),,,,)
olReport:Say(nlLin,nlCol+0950,RetTitle("DR_USUARIO"),,,,)
olReport:Say(nlLin,nlCol+1400,RetTitle("DR_VALANTE"),,,,)
olReport:Say(nlLin,nlCol+2200,RetTitle("DR_VALNOVO"),,,,)
    
olReport:Say (275,10,Replicate("_",250),,,,)
    
nlLin	:= 310
nlCol	:= 35 
    
For nlI:=1 to Len(alRegLog)   	
	olReport:Say(nlLin,nlCol     ,alRegLog[nlI][1],,,,)
	olReport:Say(nlLin,nlCol+0250,alRegLog[nlI][2],,,,) 
	olReport:Say(nlLin,nlCol+0400,alRegLog[nlI][3],,,,) 
	olReport:Say(nlLin,nlCol+0600,alRegLog[nlI][4],,,,) 
	olReport:Say(nlLin,nlCol+0800,alRegLog[nlI][5],,,,) 
	olReport:Say(nlLin,nlCol+0950,alRegLog[nlI][6],,,,) 
	olReport:Say(nlLin,nlCol+1400,alRegLog[nlI][7],,,,) 
	olReport:Say(nlLin,nlCol+2200,alRegLog[nlI][8],,,,)
	nlLin+=45    	
Next nlI
    
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ FRELTOP       บAutor  ณMicrosiga           บ Data ณ  16/08/10   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca registro de log de produtos via TOP.				       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum                                                    	   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum                                                          บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function FRELTOP()
Local clSql		:= ""			//Utilizada para query
Local nlPos		:= 0			//Posi็ใo do usuario na array de usuarios
Local alTop		:= {}			//Array com os registros a ser impresso
Local alUsers	:= FWSFAllUsers()	//Array com todos os usuarios do sistema

clSql := " SELECT DR_PRODUTO"
clSql += " ,      DR_ALIAS"
clSql += " ,      DR_CAMPO"
clSql += " ,      DR_DATA"
clSql += " ,      DR_HORA"
clSql += " ,      DR_USUARIO"
clSql += " ,      DR_VALANTE"
clSql += " ,      DR_VALNOVO"
clSql += " FROM " + RetSqlName("SDR") + " DR"
clSql += " WHERE DR_DATA BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'"
clSql += " AND DR_FILIAL = '" + xFilial("SDR") + "'"
clSql += " AND DR.D_E_L_E_T_ <> '*'"
clSql += " ORDER BY DR_DATA DESC"
clSql += " ,        DR_HORA DESC"
    
TcQuery clSql New Alias "TRB"
    
TCSetField("TRB","DR_DATA","D",08)
    
DbSelectArea("TRB")
TRB->(DbGotop())

While TRB->(!EOF())
	nlPos := aScan(alUsers,{|x| x[2] = AllTrim(TRB->DR_USUARIO)})
    	
   	aAdd(alTop,{	AllTrim(TRB->DR_PRODUTO),;
   		       		TRB->DR_ALIAS,;
   		       		AllTrim(TRB->DR_CAMPO),;
   		       		DtoC(TRB->DR_DATA),; 
   		       		AllTrim(TRB->DR_HORA),; 
   		       		Iif(nlPos > 0,AllTrim(alUsers[nlPos][3]),""),; 
   		       		AllTrim(TRB->DR_VALANTE),;
   		       		AllTrim(TRB->DR_VALNOVO) })
   	TRB->(DbSkip())
Enddo
    
TRB->(DbCloseArea())

Return alTop

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ FRELDBF       บAutor  ณMicrosiga           บ Data ณ  16/08/10   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca registro de log de produtos via DBF.				       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum                                                    	   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum                                                          บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function FRELDBF()
Local alDbf		:= {} 			//Array com os registros a ser impresso
Local nlPos		:= 0			//Posi็ใo do usuario na array de usuarios
Local alUsers	:= FWSFAllUsers()	//Array com todos os usuarios do sistema
Local aArea     := GetArea()  	//Posiciona na tabela

DbSelectArea("SDR")
SDR->(DbGotop())

While SDR->(!EOF())
	If SDR->DR_DATA >= mv_par01 .And. SDR->DR_DATA <= mv_par02
		nlPos := aScan(alUsers,{|x| x[2] = AllTrim(SDR->DR_USUARIO)})
    	
    	aAdd(alDbf,{	AllTrim(SDR->DR_PRODUTO)							,;
    		       		SDR->DR_ALIAS										,;
    		       		AllTrim(SDR->DR_CAMPO)								,;
    		       		DtoC(SDR->DR_DATA)									,; 
    		       		AllTrim(SDR->DR_HORA)								,; 
    		       		Iif(nlPos > 0,AllTrim(alUsers[nlPos][3]),"")	,; 
    		       		AllTrim(SDR->DR_VALANTE)							,;
    		       		AllTrim(SDR->DR_VALNOVO) 							})
  	Endif	 	
	SDR->(DbSkip())
Enddo

alDbf := aSort(alDbf,,,{|x,y| x[4] > y[4]})
alDbf := aSort(alDbf,,,{|x,y| x[5] > y[5]})

RestArea(aArea)

Return alDbf
