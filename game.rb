require 'gosu'
require_relative 'apple'
require_relative 'snake'

class GameWindow < Gosu::Window
  WIDTH = 900
  HEIGHT = 600
  SIZE = 15
  COLOR = Gosu::Color::GREEN
  APPLE_COLOR = Gosu::Color::RED
  INTERVAL = 100 # Lower INTERVAL will give faster snake
  
  def initialize
    super(WIDTH, HEIGHT)
    @snake = Snake.new(150, 150, SIZE, COLOR)
    @apple = Apple.new(rand(WIDTH / SIZE) * SIZE, rand(HEIGHT / SIZE) * SIZE, SIZE, APPLE_COLOR)
    @time = Gosu.milliseconds
    @finished = false
    @font = Gosu::Font.new(30)
  end

  def button_down(id)
    if id == Gosu::KbUp && @snake.direction != :DOWN
      @snake.direction = :UP
    elsif id == Gosu::KbDown && @snake.direction != :UP
      @snake.direction = :DOWN
    elsif id == Gosu::KbLeft && @snake.direction != :RIGHT
      @snake.direction = :LEFT
    elsif id == Gosu::KbRight && @snake.direction != :LEFT
      @snake.direction = :RIGHT
    elsif id == Gosu::KbSpace
      initialize()
    end
  end
  
  def update
    if !@finished
      if Gosu.milliseconds - @time > INTERVAL
        @snake.move()
        @time = Gosu.milliseconds
      end

      if @snake.bitten
        @finished = true
      end

      if @snake.head.x < 0
        @snake.head.x = WIDTH - SIZE
      elsif @snake.head.x >= WIDTH
        @snake.head.x = 0
      end

      if @snake.head.y < 0
        @snake.head.y = HEIGHT - SIZE
      elsif @snake.head.y >= HEIGHT
        @snake.head.y = 0
      end

      if @snake.head.x < @apple.x + @apple.size && @apple.x < @snake.head.x + @snake.size
        if @snake.head.y < @apple.y + @apple.size && @apple.y < @snake.head.y + @snake.size
          @apple = Apple.new(rand(WIDTH / SIZE) * SIZE, rand(HEIGHT / SIZE) * SIZE, SIZE, APPLE_COLOR)
          @snake.grow
        end
      end
    end
  end

  def draw
    if !@finished
      @snake.draw
      simple_draw(@apple)
    else
      @font.draw('Game Over!', 400, 300, 3)
      @font.draw('Press Spacebar to try again.', 200, 400, 3)
    end
  end

  def simple_draw(object)
    draw_quad(
      object.x, object.y, object.color, 
      object.x+object.size, object.y, object.color, 
      object.x, object.y+object.size, object.color, 
      object.x+object.size, object.y+object.size, object.color, 
      0, mode = :additive
    )
  end
end

GameWindow.new.show