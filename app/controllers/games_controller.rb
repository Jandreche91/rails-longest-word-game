require 'time'
require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def home
    dictionary = ('a'..'z').to_a
    @sample_letters = []
    9.times { @sample_letters << dictionary.sample }
    @sample_letters
  end

 def run_game(attempt, grid, strt_t)
    # TODO: runs the game and return detailed hash of result
   file_path = 'https://wagon-dictionary.herokuapp.com/' << attempt.downcase
   dico = open(file_path).read
   answer = JSON.parse(dico)
    if attempt.chars.all? { |l| grid.count(l) >= attempt.chars.count(l) } == false
      { time: Time.now - strt_t, score: 0, message: "Your word is not in the grid" }
    elsif answer['found']
      { time: Time.now - strt_t, score: (answer['length'] / (Time.now - strt_t) * 1000).floor, message: "Well done!" }
    else
      { time: Time.now - strt_t, score: 0, message: "Your word is not an English word" }
    end
  end

  def score
    time_start = Time.parse(params[:start_time])
    @letters_array = params[:letters_array].chars
    @letters_array.delete(' ')
    @attempt = params[:user_guess].strip.downcase
    @results = run_game(@attempt, @letters_array, time_start)
  end
end
