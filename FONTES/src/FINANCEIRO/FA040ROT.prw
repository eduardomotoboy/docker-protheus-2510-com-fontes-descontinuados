/*/{Protheus.doc} FA040ROT
Ponto de Entrada em Funcoes Contas a Receber (FINA040)
Adiciona o botao "Limpar Ocorr. Gestor Fin." no menu "Outras Acoes" da tela de Contas a Receber,
permitindo ao usuario acionar diretamente a rotina U_AJFINA01().

@type function
@version 1.0
@author AJE Ind. de Acessorios Automotivos Ltda
@since 22/09/2026
@return array, aBotoes
/*/
User Function FA040ROT()
	Local aBotoes := {}

	// aAdd( aRotina, { cTitulo, cAcao, nReservado, nOperacao } )
	// Operacao 4 = Alteracao / Processamento customizado
	AAdd(aBotoes, {"Limpar Ocorr. Gestor Fin.", "U_AJFINA01()", 0, 4})

Return(aBotoes)
