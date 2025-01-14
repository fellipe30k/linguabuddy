# 🌟 LinguaBuddy

**LinguaBuddy** é um projeto incrível para praticar vocabulário em inglês através de traduções e revisões de palavras e músicas! 🎶📚 Ele utiliza **Ruby**, **Bundler** e **Docker** para criar um ambiente isolado e super fácil de usar. 🚀

## ✅ Pré-requisitos

- 🐋 **Docker** instalado no seu sistema.
- 🛠️ (Opcional) **Make** para facilitar a execução dos comandos.

## 📝 Instruções

1. **Clone este repositório:** 📥

    ```bash
    git clone https://github.com/seuusuario/linguabuddy.git
    cd linguabuddy
    ```

2. **Construa a imagem Docker** 🏗️ (isso também instalará as dependências via Bundler):

    **Com Make:**

    ```bash
    make build
    ```

    **Sem Make:**

    ```bash
    docker build -t linguabuddy .
    ```

3. **Rode o script principal `word.rb` para treinar palavras:** ✍️

    **Com Make:**

    ```bash
    make run-word
    ```

    **Sem Make:**

    ```bash
    docker run -it --rm linguabuddy ruby word.rb
    ```

4. **Rode o script `music.rb` para treinar músicas:** 🎵

    **Com Make:**

    ```bash
    make run-music
    ```

    **Sem Make:**

    ```bash
    docker run -it --rm linguabuddy ruby music.rb
    ```

---

## 🛠️ Funcionamento

### 📝 `word.rb`

Este script carrega um arquivo CSV com **80% das palavras mais usadas em diálogos em inglês** e pede que você forneça a tradução para o português. 🇬🇧➡️🇧🇷  
🎯 Ele mostra sua pontuação e revisa as palavras que você errou. 

### 🎧 `music.rb`

Treine seu inglês com músicas! 🕺💃 Melhore sua **compreensão auditiva** e aumente seu **vocabulário** enquanto se diverte. 🎙️

---

## 🤝 Contribuições

Adoramos contribuições! 🌟 Sinta-se à vontade para abrir **Issues** e **Pull Requests**. 💻✨

---

## 📜 Licença

Este projeto está sob a licença **MIT**. 📝
