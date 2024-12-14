require 'csv'
require 'colorize'
require 'i18n'
require 'timeout'

# Configurar I18n para remover acentos
I18n.enforce_available_locales = false

def escolher_musica
  # Obter todos os arquivos CSV na pasta musics
  music_files = Dir.glob("musics/*.csv")

  if music_files.empty?
    puts "Nenhum arquivo de música encontrado na pasta 'musics/'."
    exit
  end

  # Listar as músicas encontradas
  puts "Músicas disponíveis:"
  music_files.each_with_index do |file_path, idx|
    music_name = File.basename(file_path, '.csv')
    puts "#{idx + 1}) #{music_name}"
  end
  puts
  puts "Selecione o número da música que deseja treinar. Você tem 10 segundos..."

  chosen_index = nil

  begin
    # Dá ao usuário 10 segundos para escolher
    Timeout.timeout(10) do
      print "Opção: "
      input = gets.chomp
      if input == '&exit'
        puts "Saindo..."
        exit
      end

      chosen_index = input.to_i - 1
      # Valida se a opção é válida
      if chosen_index < 0 || chosen_index >= music_files.size
        puts "Opção inválida. Será selecionada a primeira música."
        chosen_index = 0
      end
    end
  rescue Timeout::Error
    puts "\nTempo esgotado! Selecionando automaticamente a primeira música."
    chosen_index = 0
  end

  chosen_file = music_files[chosen_index]
  puts "Você escolheu: #{File.basename(chosen_file, '.csv')}".colorize(:yellow)
  puts "Carregando a música, aguarde..."

  sleep(1)
  chosen_file
end

def treinar_musica(file_path)
  total_palavras = 0
  total_acertos = 0

  # Ler linhas da música selecionada
  lines = CSV.read(file_path, headers: true, col_sep: ';', header_converters: :symbol).map do |row|
    { english: row[:english], portuguese: row[:portuguese] }
  end

  puts "\nEsta música tem #{lines.size} linhas. Vamos lá!\n\n"

  lines.each_with_index do |line, index|
    puts "Linha #{index + 1}/#{lines.size}:".colorize(:light_blue)
    puts "Inglês: " + line[:english].colorize(:light_blue)
    print "Digite a tradução: "
    resposta = gets.chomp
    if resposta == '&exit'
      break
    end

    # Normalizar resposta e tradução
    resposta = resposta.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    line_portuguese = line[:portuguese].encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    resposta_normalizada = I18n.transliterate(resposta.downcase)
    traducao_normalizada = I18n.transliterate(line_portuguese.downcase)

    # Dividir em palavras
    resposta_palavras = resposta_normalizada.split
    traducao_palavras = traducao_normalizada.split

    # Ajustar arrays para comparar
    max_length = [resposta_palavras.size, traducao_palavras.size].max
    while resposta_palavras.size < max_length
      resposta_palavras << ""
    end
    while traducao_palavras.size < max_length
      traducao_palavras << ""
    end

    # Comparar palavra a palavra, exibindo em duas linhas:
    # Linha 1: palavras do usuário (verde se certa, vermelho se errada)
    # Linha 2: palavras corretas abaixo das erradas
    user_line = []
    correct_line = []
    acertos_linha = 0
    total_palavras_linha = max_length

    (0...max_length).each do |i|
      user_word = resposta_palavras[i]
      correct_word = traducao_palavras[i]

      if user_word == correct_word
        # Palavra correta
        user_line << user_word.colorize(:green)
        correct_line << (" " * user_word.length) # espaços para alinhamento
        acertos_linha += 1
      else
        # Palavra incorreta
        user_line << user_word.colorize(:red)
        if correct_word.empty?
          correct_line << (" " * user_word.length)
        else
          correct_line << correct_word.colorize(:green)
        end
      end
    end

    user_str = user_line.join(" ")
    correct_str = correct_line.join(" ")

    puts "Resultado:"
    puts user_str
    puts correct_str
    puts "Linha correta: " + line[:portuguese].colorize(:green)
    puts "Acertos nesta linha: #{acertos_linha}/#{total_palavras_linha}"
    total_acertos += acertos_linha
    total_palavras += total_palavras_linha

    puts "Score parcial: #{total_acertos}/#{total_palavras} (#{((total_acertos.to_f/total_palavras)*100).round(2)}%)"
    puts "----------------------------------------------------------"

    sleep(1.5)
  end

  percentual_final = ((total_acertos.to_f / total_palavras) * 100).round(2)
  puts "Você finalizou a música!"
  puts "Seu percentual de acertos: #{percentual_final}%"
  puts "Score final: #{total_acertos}/#{total_palavras}"
  puts "----------------------------------------------------------"
end

# Loop principal para permitir escolher música, treinar e perguntar se deseja outra
loop do
  system("clear") || system("cls")

  puts "Bem-vindo ao Treino de Tradução de Músicas!".colorize(:blue)
  puts "Você verá linhas em inglês e deverá traduzi-las para o português."
  puts "Digite '&exit' a qualquer momento para encerrar."
  puts "----------------------------------------------------------"

  chosen_file = escolher_musica
  treinar_musica(chosen_file)

  puts "Gostaria de traduzir outra música? (s/n) Você tem 10 segundos..."
  begin
    Timeout.timeout(10) do
      print "Opção: "
      input = gets.chomp.downcase
      if input == 's' || input == 'sim'
        # Continua o loop para escolher nova música
        next
      else
        # Qualquer outra resposta sai
        puts "Saindo..."
        break
      end
    end
  rescue Timeout::Error
    puts "\nTempo esgotado! Saindo..."
    break
  end

  # Se chegou aqui sem next ou break, significa que o usuário não quer continuar
  break
end
