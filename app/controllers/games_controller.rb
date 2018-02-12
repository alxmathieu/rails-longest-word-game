require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    if session[:score].nil? then session[:score] = 0 end
    if included?(params[:guess].upcase, params[:grid])
      if english_word?(params[:guess])
        @score = (params[:guess].length) * (params[:guess].length)
        @message = "Well done, '#{params[:guess].upcase}' is a valid word!"
      else
        @message = "Sorry, but '#{params[:guess].upcase}' is not an english word"
        @score = 0
      end
    else
      @score = 0
      @message = "Sorry, but '#{params[:guess].upcase}' cannot be built out of #{params[:grid]}"
    end
    session[:score] += @score
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end




