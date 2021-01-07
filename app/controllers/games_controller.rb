require 'net/http'
require 'json'


class GamesController < ApplicationController
    
    def new
      @letters = []
        10.times do
          letter = ('a'..'z').to_a.sample
          if !@letters.include?(letter)
          @letters << letter
          end
        end  
    end
    
    def score
      @word = params[:score]
      @letters_string = params[:letters]
      @letters_array = @letters_string.split(" ")
      

      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      @results = JSON.parse(response)


      @matching_chars = []
      @not_matching_chars = []
   
      @letters_array.each do |char|
        if @word.include?(char) 
          @matching_chars << char  
        else
          @not_matching_chars << char
        end
      end 
 
      if @results["found"] == false
        @message =  "Sorry but #{@word} does not seem to be a valid English word.."
      elsif @results["found"] == true && @word.length != @matching_chars.length
        @message = "Sorry but #{@word} can't be built out of #{@letters_array.join(", ")}.. You're missing #{@word.length - @matching_chars.length} characters."
      else
        @message = "Congratulations! #{@word} can be built!  You've got #{@word.length} points!"
      end
    end
    
end
    