# define que esse script estende a classe base Node2D
extends Node2D # é heranca 

# 1. Referências aos nós visuais da cena
# o @onready garante que a var só busca o nó da árvore depois que a cena estiver carregada na memória
@onready var label_tempo: Label = $Label # o cifrao daqui equivale ao childNode do SpriteKit - busca nós
@onready var timer: Timer = $Timer
@onready var btn_a: Button = $ItemA
@onready var btn_b: Button = $ItemB
@onready var btn_c: Button = $ItemC

# 2. Variáveis de estado
var tempo_restante: int = 30 # controla os segundos restantes do contador (arcade)
var jogo_ativo: bool = true # bloqueia qualquer interacao quando o jogo acabar
var selecao: Array = [] # armazena os itens clicados para validar a receita do puzzle - base de dados temporária para minha lógica puzzle

# equivalente ao didMove(to:) do SpriteKit, ela roda uma única vez para quando a cena entra na tela, o jogo é aberto
func _ready() -> void:
	# Conecta o clique de cada botão a uma função
	# o Godot usa sistema de sinais para eventos 
	# o sinal é pressed , entao conectamos ele a uma funcao lambda, passando o identificador do botao correspondente
	btn_a.pressed.connect(func(): _ao_clicar_item("A"))
	btn_b.pressed.connect(func(): _ao_clicar_item("B"))
	btn_c.pressed.connect(func(): _ao_clicar_item("C"))
	
	# Conecta o sinal do temporizador para disparar a cada 1 segundo - liga a funcao de decremento do tempo
	timer.timeout.connect(_ao_passar_um_segundo)

# tratamento do clique dos itens
func _ao_clicar_item(nome_item: String) -> void:
	# validacao de seguranca - se o jogo acabou, interrompe a execucao e n registra nada
	if not jogo_ativo:
		print("Toque ignorado: O jogo já encerrou!")
		return
		
		
	selecao.append(nome_item) # adicona o item clicado a lista de selecao, criada como atributo da classe
	print("Selecionado: ", nome_item, " | Fila atual: ", selecao)
	
	# quando atinge o elemento máximo para ser combinado, a combinacao é validada (seja pro negativo ou positivo)
	if selecao.size() == 2:
		_validar_combinacao()

# validar a combinacao, pra ver se o usuário fez uma combinacao adequada ou nao
func _validar_combinacao() -> void:
	if "A" in selecao and "B" in selecao:
		print(">> SUCESSO: Combinacao valida gerada!")
	else:
		print(">> FALHA: Combinacao invalida!")
		
	selecao.clear() # prepara a memória para a próxima tentativa de combinacao

# para contabilizar tempo
func _ao_passar_um_segundo() -> void:
	if not jogo_ativo:
		return
		
	tempo_restante -= 1
	label_tempo.text = "Tempo: " + str(tempo_restante) + "s"
	
	# desabilita jogo após tempo acabar
	if tempo_restante <= 0:
		jogo_ativo = false
		timer.stop()
		label_tempo.text = "TEMPO ESGOTADO!"
		print(">> JOGO ENCERRADO: O tempo acabou.")
