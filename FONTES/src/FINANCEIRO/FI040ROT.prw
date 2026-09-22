/*/{Protheus.doc} FI040ROT
Ponto de Entrada em Funcoes Contas a Receber (FINA040)
Adiciona o botao "Limpar Ocorr. Gestor Fin." no menu "Outras Acoes" da tela de Contas a Receber,
permitindo ao usuario acionar diretamente a rotina U_AJFINA01().

@type function
@version 1.0
@author AJE Ind. de Acessorios Automotivos Ltda
@since 22/09/2026
@return array, aRotina
/*/
User Function FI040ROT()
	Local aRotina := {}

	If ValType(ParamIXB) == "A"
		aRotina := AClone(ParamIXB)
	EndIf

	// Sintaxe padrao do aRotina no Protheus:
	// { cTitulo, cNomeFuncao, nReservado, nOperacao, nAcesso, lHabilita }
	AAdd(aRotina, {"Limpar Ocorr. Gestor Fin.", "U_AJFINA01", 0, 4, 0, .F.})

Return(aRotina)
