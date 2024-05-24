# require 'open-uri'
# require 'json'

class GamesController < ApplicationController
  def new
    @grid = generate_grid(10)
  end

  def score
    grid = params[:grid]
    attempt = params[:word]
    @result = run_game(attempt, grid)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    (("A".."Z").to_a * 2).sample(grid_size)
  end

  def run_game(attempt, grid)
    is_valid_word = validate_english_word(attempt)
    is_in_grid = validate_word_in_grid(attempt, grid)
    # puts "attempt: #{attempt}"
    # puts "grid: #{grid}"
    # puts "is_valid_word: #{is_valid_word}"
    # puts "is_in_grid: #{is_in_grid}"
    return "Sorry, <b>#{attempt}</b> is not in the grid #{grid}"  unless is_in_grid
    return "Sorry, <b>#{attempt}</b> is not an english word" unless is_valid_word
    "Well done, <b>#{attempt}</b> is a valid English word!"
  end

  def validate_english_word(word)
    endpoint = "https://dictionary.lewagon.com/#{word}"
    word_evaluation = JSON.parse(URI.open(endpoint).read)
    word_evaluation["found"]
  end

  def validate_word_in_grid(word, grid)
    word.upcase.chars.all? { |w| grid.include?(w) && grid.count(w) >= word.upcase.count(w) }
  end
end
