class Card
	
	attr_accessor :suit, :face_value
	def initialize(s, fv)
		@suit = s
		@face_value = fv
	
	end
	
	def pretty_output
		puts "The #{face_value} of #{find_suit}"
	end

	def to_s
		pretty_output
	end

	def value
		@face_value
	end

	def find_suit

		ret_val = case suit
			when 'H' then 'Hearts'
			when 'D' then 'Diamonds'
			when 'S' then 'Spades'
			when 'C' then 'Clubs'
		end
		ret_val
	end

end


class Deck

	attr_accessor :cards
	def initialize

		@cards = []
		['H', 'D', 'S', 'C'].each do |suit|
			[2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].each do |v|
				@cards << Card.new(suit, v)
			end
		end
		scramble!
	end 

	def scramble!
		cards.shuffle!
	end

	def deal_one
		cards.pop
	end

	def size
		cards.size
	end
end

class Player
	attr_accessor :score, :hand, :name
	def initialize
		@score = 0
		@hand = []
		@name = ''
	end

end

class Dealer
	attr_accessor :score, :hand, :name
	def initialize
		@score = 0
		@hand = []
		@name = 'Dealer'
	end

end


class Blackjack

	attr_accessor :player, :dealer, :deck, :game_over
	def initialize
		@player = Player.new
		@dealer = Dealer.new
		@deck = Deck.new
		@game_over = false
		deck.scramble!
	end

	def deal_hand(person)
		person.hand << deck.deal_one
		person.hand << deck.deal_one
	end
	
	def deal_card(person)
		person.hand << deck.deal_one

	end
	
	def calculate_total(hand_array)

		arr = []
		arr = hand_array.map { |e| e.value }
		
		total = 0

		arr.each do |v|

			if v == 'A'
				total += 11
			elsif v.to_i == 0
				total += 10
			else
				total += v.to_i
			end
		end

		#Correct for Aces
		arr.select { |e| e == 'A'}.count.times do
			total -= 10 if total > 21
		end
		return total

	end	

	def display_hand(hand_array)
		
		hand_array.each do |v|
			v.pretty_output
		end
	end

	def hitorstay(person)

		while person.score < 21
			puts "What would you like to do 1) hit or 2) stay"
			hit_or_stay = gets.chomp.to_s
			
			if !['1','2'].include?(hit_or_stay)
				puts "Error: Please enter the number 1 or 2"
				next
			end

			if hit_or_stay == "2"
				puts "You choose to stay."
				break 
			end

			deal_card(person)
			person.score = calculate_total(person.hand)

			puts ""

			puts "#{person.name} hand is:"

			display_hand(person.hand)
			
			puts "total score: #{person.score}"

			if person.score == 21
				puts "Blackjack! You win!"
				game_over = true
				exit
			elsif person.score > 21
				puts "Sorry it looks like you busted."
				game_over = true
				exit
			end
		end
	end

	def dealer_game
		if game_over != true
			puts ""
			puts "Dealers hand is:"
			display_hand(dealer.hand)
			puts "total score: #{dealer.score}"

			if dealer.score == 21
				puts "Sorry dealer hit Blackjack, better luck next time."
				exit
			end

			while dealer.score < 17
				deal_card(dealer)
				dealer.score = calculate_total(dealer.hand)

				puts ''
				puts "Dealer updated hand is:"

				display_hand(dealer.hand)			
				puts "total score: #{dealer.score}"

				if dealer.score == 21
					puts "Sorry dealer hit Blackjack, better luck next time."
					exit
				elsif dealer.score > 21
					puts "You win! Dealer busted."
					exit
				end
			end
		end
	end


	def compare
		if dealer.score > player.score
			puts "Dealer wins, better luck next time."
		elsif dealer.score < player.score
			puts "You win!"
		else
			puts "You Tied!"
		end
		exit

	end

	def run
		puts "Welcome to Blackjack!"
		puts "What is your name?"
		player.name = gets.chomp
		
		puts "Welcome #{player.name}"
		
		deal_hand(player)
		deal_hand(dealer)

		player.score = calculate_total(player.hand)
		dealer.score = calculate_total(dealer.hand)

		puts ""
		puts "Your hand is:"
		display_hand(player.hand)
		puts "total score: #{player.score}"
			

		if player.score == 21
			puts "Blackjack! You win!"
			exit
		end
		
		hitorstay(player)
		dealer_game
		compare
	end
end

game = Blackjack.new

game.run















































































