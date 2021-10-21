class Snake
  attr_accessor :size, :color, :direction, :body, :head

  def initialize(x, y, size, color)
    @color = color
    @size = size
    @direction = :LEFT
    @body = [SnakeSegment.new(x, y)]
    @head = @body[0]
  end

  def bitten
    i = 1
    while i < @body.length
      if @head.x == @body[i].x && @head.y == @body[i].y
        return true
      end
      i += 1
    end
    return false
  end

  def grow
    if @direction == :UP
      @body.unshift(SnakeSegment.new(@head.x, @head.y - @size))
    elsif @direction == :DOWN
      @body.unshift(SnakeSegment.new(@head.x, @head.y + @size))
    elsif @direction == :LEFT
      @body.unshift(SnakeSegment.new(@head.x - @size, @head.y))
    elsif @direction == :RIGHT
      @body.unshift(SnakeSegment.new(@head.x + @size, @head.y))
    end
    @head = @body[0]
  end

  def move
    @body.pop()

    if @direction == :UP
      @head = SnakeSegment.new(@head.x, @head.y - @size)
    elsif @direction == :DOWN
      @head = SnakeSegment.new(@head.x, @head.y + @size)
    elsif @direction == :LEFT
      @head = SnakeSegment.new(@head.x - @size, @head.y)
    elsif @direction == :RIGHT
      @head = SnakeSegment.new(@head.x + @size, @head.y)
    end

    @body.unshift(@head)
  end

  def draw
    @body.each do |segment|
      Gosu.draw_quad(
        segment.x, segment.y, @color,
        segment.x + @size, segment.y, @color,
        segment.x, segment.y + @size, @color,
        segment.x + @size, segment.y + @size, @color
      )
    end
  end
end

class SnakeSegment
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end