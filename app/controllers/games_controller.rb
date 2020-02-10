class GamesController < ApplicationController

  require 'open-uri'
  require 'json'

  def new
    letter_grid = ('A'..'Z').to_a.sample(10)
    letter_grid.map! { ('A'..'Z').to_a.sample }
    @letters = letter_grid
  end

  def score
    if word_in_dictionnary(params[:word]) == false
      message = "sorry but #{params[:word]} does not seem to be a valid English word ..."
    elsif letter_in_the_grid(params[:word], params[:letters]) == false
      message = "sorry but #{params[:word]} can't be built out of #{params[:letters]} ..."
    elsif word_in_dictionnary(params[:word]) && letter_in_the_grid(params[:word], params[:letters])
      message = "Congratulation you win #{params[:word].length} points with your word #{params[:word]}"
    end
    @message = message
  end

private

  def word_in_dictionnary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    wagon_serialized = open(url).read
    result = JSON.parse(wagon_serialized)
    result['found']
  end

  def letter_in_the_grid(word, grid)
    word.upcase.chars.all? { |letter| grid.upcase.count(letter) >= word.upcase.chars.count(letter)}
  end
end
