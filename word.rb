def read_and_score_sentences(total_words)
  sentences = []
  puts 'Digite até 10 frases. Quando terminar, aperte Enter.'
  10.times do
    print 'Frase #{sentences.size + 1}: '
    sentence = gets.chomp
    break if sentence.empty?
    sentences << sentence
  end
  correct_answers = 0
  missed_words = []
  sentences.each do |sentence|
    result_missed = ask_word(sentence)
    show_feedback(result_missed, sentence)
    if result_missed[:correct]
      correct_answers += 1
    else
      missed_words << sentence
    end
  end
  percentual_acertos = (correct_answers.to_f / sentences.size * 100).round(2)
  puts 'Você acertou #{correct_answers} de #{sentences.size} frases.'
  puts 'Seu percentual de acertos é: #{percentual_acertos}%'
  return correct_answers, sentences.size
end

# Embaralhar as palavras
words.shuffle!

# Limpar o console
system("clear")

puts "Bem-vindo ao Treino de Inglês! Traduz o que está em inglês para português.".colorize(:blue)
puts "Digite '&exit' a qualquer momento para sair e ver seu percentual de acertos.".colorize(:yellow)

total_words = words.size
correct_answers = 0
missed_words = []  # Lista de palavras erradas

def ask_word(word)
  puts "Qual é a tradução de: #{word[:english]}?".colorize(:light_blue)

  start_time = Time.now
  resposta = gets.chomp

  return :exit if resposta == '&exit'

  # Forçar codificação da resposta para UTF-8 e substituir caracteres inválidos.
  resposta = resposta.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

  end_time = Time.now
  time_taken = end_time - start_time

  begin
    normalized_resposta = I18n.transliterate(resposta.downcase)
  rescue ArgumentError => e
    puts "Ocorreu um problema ao processar sua resposta. Por favor, tente novamente sem caracteres especiais."
    return { correct: false, time_taken: time_taken, resposta: resposta }
  end

  # Conjunto de respostas válidas (traduções + sinônimos)
  valid_answers = (word[:portuguese] + word[:synonyms]).map do |translation|
    I18n.transliterate(translation.gsub(/\s*\(.*?\)\s*/, '').downcase)
  end

  correct = valid_answers.include?(normalized_resposta)

  {
    correct: correct,
    time_taken: time_taken,
    resposta: resposta
  }
end

def show_feedback(result, word)
  if result[:correct]
    puts "Correto!".colorize(:green)
  else
    all_answers = (word[:portuguese] + word[:synonyms]).uniq
    puts "Errado. As traduções corretas são: #{all_answers.join(', ')}".colorize(:red)
  end
  puts "Tempo de resposta: #{result[:time_taken].round(2)} segundos".colorize(:magenta)
end

words.each_with_index do |word, index|
  system("clear")

  result = ask_word(word)
  if result == :exit
    break
  end

  if result[:correct]
    correct_answers += 1
  else
    missed_words << word
  end

  show_feedback(result, word)
  tentativas = index + 1
  puts "Score atual: #{correct_answers}/#{tentativas}".colorize(:cyan)

  # Repetir palavras erradas após 3 ou 5 palavras novas
  if ((tentativas % 5 == 0 || tentativas % 6 == 0) && !missed_words.empty?)
    puts "\nAgora, vamos revisar as palavras que você errou:".colorize(:yellow)
    # Revisar cada palavra errada
    missed_words.dup.each do |missed_word|
      puts
      result_missed = ask_word(missed_word)
      if result_missed == :exit
        # Se o usuário sair no meio da revisão, interrompemos o processo
        break
      end

      show_feedback(result_missed, missed_word)

      if result_missed[:correct]
        # Se o usuário acertou agora, remove a palavra da lista de erradas
        missed_words.delete(missed_word)
        correct_answers += 1
      else
        # Se continuar errando, a palavra permanece na lista
      end

      # Mostrar score atualizado após revisar uma palavra errada
      puts "Score atual (incluindo correções): #{correct_answers}/#{tentativas}".colorize(:cyan)
      sleep(1)
    end
  end

  sleep(1.5)
end

percentual_acertos = (correct_answers.to_f / total_words * 100).round(2)
puts "\nVocê acertou #{correct_answers} de #{total_words} palavras.".colorize(:blue)
puts "Seu percentual de acertos é: #{percentual_acertos}%".colorize(:blue)
puts "Seu score final é: #{correct_answers}/#{total_words}".colorize(:blue)
puts "Parabéns por praticar!".colorize(:green)
