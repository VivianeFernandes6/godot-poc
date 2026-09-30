extends Node2D

# 1. Referências aos nós visuais da cena
@onready var label_tempo: Label = $Label
@onready var timer: Timer = $Timer
@onready var btn_a: Button = $ItemA
@onready var btn_b: Button = $ItemB
@onready var btn_c: Button = $ItemC

# 2. Variáveis de controle da POC
var tempo_restante: int = 30
var jogo_ativo: bool = true
var selecao: Array = []

func _ready() -> void:
	# Conecta o clique de cada botão a uma função
	btn_a.pressed.connect(func(): _ao_clicar_item("A"))
	btn_b.pressed.connect(func(): _ao_clicar_item("B"))
	btn_c.pressed.connect(func(): _ao_clicar_item("C"))
	
	# Conecta o sinal do temporizador para disparar a cada 1 segundo
	timer.timeout.connect(_ao_passar_um_segundo)

func _ao_clicar_item(nome_item: String) -> void:
	if not jogo_ativo:
		print("Toque ignorado: O jogo já encerrou!")
		return
		
	selecao.append(nome_item)
	print("Selecionado: ", nome_item, " | Fila atual: ", selecao)
	
	if selecao.size() == 2:
		_validar_combinacao()

func _validar_combinacao() -> void:
	if "A" in selecao and "B" in selecao:
		print(">> SUCESSO: Combinacao valida gerada!")
	else:
		print(">> FALHA: Combinacao invalida!")
		
	selecao.clear()

func _ao_passar_um_segundo() -> void:
	if not jogo_ativo:
		return
		
	tempo_restante -= 1
	label_tempo.text = "Tempo: " + str(tempo_restante) + "s"
	
	if tempo_restante <= 0:
		jogo_ativo = false
		timer.stop()
		label_tempo.text = "TEMPO ESGOTADO!"
		print(">> JOGO ENCERRADO: O tempo acabou.")
