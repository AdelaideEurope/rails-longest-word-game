require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def score
    @word = params[:word]
    @points = @word.length
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = open(url).read
    dictionary_word = JSON.parse(word_serialized)
    letters_new = params[:letters_list].delete('\\"')
    if included?(@word.upcase, letters_new)
      if dictionary_word["found"] == true
        @result = "Congratulations, #{@word.upcase} is a valid English word! You have #{@points} points. 🏆"
      else
        @result = "Sorry but #{@word.upcase} does not seem to be a valid English word…"
      end
    else
      @result = "Sorry but #{@word.upcase} can't be built out of #{letters_new.delete('\[').delete('\]')}."
    end
  end
end
