require 'ruby2d'

class Bird
  attr_accessor :x_speed, :y_speed, :velocity

  def initialize
    @pigeon = Square.new(color: 'red', size: 25, x: 119, y: 242.5)
    @velocity = 0
    @gravity = 0.5
    @x_speed = 0
    @y_speed = 0
  end

  def update
    @velocity += @gravity
    @pigeon.y += @velocity

    if @pigeon.y + @pigeon.size > Window.height #lock
      @pigeon.y = Window.height - @pigeon.size
      @velocity = 0
    end

    if @pigeon.x + @pigeon.size > Window.width
      @pigeon.x = Window.width - @pigeon.size
      @velocity = 0
    end

    @pigeon.x += @x_speed

    @pigeon.y += @y_speed
  end

  def bird
    @pigeon
  end
end

class Controller
  def initialize(bird)
    @pigeon = bird
  end

  def handle_key_held(event)
    case event.key
    when 'a'
      @pigeon.x_speed = -2
    when 'd'
      @pigeon.x_speed = 2
    when 'w'
      @pigeon.y_speed = -10
    when 's'
      @pigeon.y_speed = 10
    else
      puts "ERROR"
    end
  end

  def handle_key_up(event)
    case event.key
    when 'a', 'd'
      @pigeon.x_speed = 0
    when 'w', 's'
      @pigeon.y_speed = 0
    else
      puts "ERROR"
    end
  end
end

class GameWindow
  def initialize
    Window.set(
      title: 'Flappy Pigeon',
      width: 800,
      height: 800,
      resizable: false,
      background: 'blue'
    )
    @pigeon = Bird.new
    @controller = Controller.new(@pigeon)


    Window.on :key_held do |event|
      @controller.handle_key_held(event)
    end

    Window.on :key_up do |event|
      @controller.handle_key_up(event)
    end
  end

  def update
    @pigeon.update

  end

  def show
    Window.update do
      update
    end

    Window.show
  end
end

game = GameWindow.new
game.show