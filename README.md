# LinguaBuddy

**LinguaBuddy** é um projeto para praticar vocabulário em inglês por meio de traduções e revisões de palavras e músicas. Ele utiliza Ruby, Bundler e Docker para fornecer um ambiente isolado e fácil de executar.

## Pré-requisitos

- Docker instalado em seu sistema.
- (Opcional) Make instalado para facilitar os comandos.

## Instruções

1. **Clone este repositório:**

    ```bash
    git clone https://github.com/seuusuario/linguabuddy.git
    cd linguabuddy
    ```

2. **Construa a imagem Docker** (isso também instalará as dependências via Bundler):

    Com Make:

    ```bash
    make build
    ```

    Sem Make:

    ```bash
    docker build -t linguabuddy .
    ```

3. **Rode o script principal `word.rb` para treinar palavras:**

    Com Make:

    ```bash
    make run-word
    ```

    Sem Make:

    ```bash
    docker run -it --rm linguabuddy ruby word.rb
    ```

4. **Rode o script `music.rb` para treinar músicas:**

    Com Make:

    ```bash
    make run-music
    ```

    Sem Make:

    ```bash
    docker run -it --rm linguabuddy ruby music.rb
    ```

## Funcionamento

### `word.rb`

Este script carrega um arquivo CSV com 80% das palavras mais usadas em diálogos em inglês e solicita que o usuário forneça a tradução para o português. Ele apresenta sua pontuação e faz revisões periódicas das palavras que você errou.

### `music.rb`

Este script permite que você pratique inglês através de músicas, aprimorando sua compreensão auditiva e vocabulário.

## Contribuições

Sinta-se à vontade para abrir Issues e Pull Requests.

## Licença

Este projeto está sob a licença MIT.

---

Com esses arquivos, você terá um projeto pronto para ser executado com Docker, utilizando Bundler para gerenciar as dependências Ruby.
