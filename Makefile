IMAGE_NAME=linguabuddy

.PHONY: build run-word run-music help

build: ## Construir a imagem docker
	docker build -t $(IMAGE_NAME) .

run-word: ## Executar o script word.rb no container
	docker run -it --rm $(IMAGE_NAME) ruby word.rb

run-music: ## Executar o script music.rb no container
	docker run -it --rm $(IMAGE_NAME) ruby music.rb

help: ## Mostrar ajuda
	@echo "Comandos disponíveis:"
	@echo "  make build      - Construir a imagem Docker do projeto"
	@echo "  make run-word   - Rodar o word.rb dentro do container"
	@echo "  make run-music  - Rodar o music.rb dentro do container"
