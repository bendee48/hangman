class Display
  attr_accessor :head, :body, :legs

  def initialize(head="   |    ", body="   |    ", legs="   |    ")
    @head = head
    @body = body
    @legs = legs
  end

  def show_gallows
    puts "  ________"
    puts "   |/   |"
    puts head, body, legs 
    puts "   |"
    puts " ==========="
  end

  def add_to_gallows(tries)
    case tries
    when 5
      head << "O"
    when 4
      body << "|"
    when 3
      body[7] = "/"
    when 2
      body[9] = "\\"
    when 1
      legs[7] = "/"
    when 0
      legs << " \\"
    end
  end

end