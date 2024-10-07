require 'ruby2d'

class Bird
  attr_accessor :x_speed, :y_speed, :velocity

  def initialize
    @pigeon = Square.new(color: 'red', size: 25, x: 119, y: 242.5)
    @velocity = 0
    @gravity = 0.01
    @x_speed = 0
    @y_speed = 0
  end

  def update
    @velocity += @gravity

    @pigeon.y += @velocity

    if @pigeon.y + @pigeon.size > Window.height
      @pigeon.y = Window.height - @pigeon.size
      @velocity = 0
    elsif @pigeon.y < 0
      @pigeon.y = 0
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
    # when 'a'
    #   @pigeon.x_speed = -2
    # when 'd'
    #   @pigeon.x_speed = 2
    when 'w', 'space', 'up'
      @pigeon.y_speed = -10
    when 's', 'down'
      @pigeon.y_speed = 10
    else
      puts "ERROR"
    end
  end

  def handle_key_up(event)
    case event.key
    # when 'a', 'd'
    #   @pigeon.x_speed = 0
    when 'w', 's', 'space', 'up', 'down'
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
    @obstacles = []
    create_obstacles

    Window.on :key_held do |event|
      @controller.handle_key_held(event)
    end

    Window.on :key_up do |event|
      @controller.handle_key_up(event)
    end
  end

  def update
    @pigeon.update
    update_obstacles
    check_collision
  end

  def show
    Window.update do
      update
    end

    Window.show
  end

  private

  def create_obstacles
    gap_size = 200
    obstacle_width = 50
    obstacle_spacing = 350

    (0..Window.width).step(obstacle_spacing) do |x|
      gap_y = rand(Window.height - gap_size)
      top_obstacle = Rectangle.new(
        x: x, y: 0,
        width: obstacle_width, height: gap_y,
        color: 'green'
      )
      bottom_obstacle = Rectangle.new(
        x: x, y: gap_y + gap_size,
        width: obstacle_width, height: Window.height - gap_y - gap_size,
        color: 'green'
      )
      @obstacles << top_obstacle
      @obstacles << bottom_obstacle
    end
  end

  def update_obstacles
    @obstacles.each do |obstacle|
      obstacle.x -= 2
      if obstacle.x + obstacle.width < 0
        obstacle.x = Window.width
        if obstacle.y == 0
          gap_y = rand(Window.height - 150)
          obstacle.height = gap_y
        else
          obstacle.y = @obstacles.find { |o| o.y == 0 }.height + 100
          obstacle.height = Window.height - obstacle.y
        end
      end
    end
  end

  def check_collision
    @obstacles.each do |obstacle|
      if @pigeon.bird.contains?(obstacle.x, obstacle.y) ||
         @pigeon.bird.contains?(obstacle.x + obstacle.width, obstacle.y) ||
         @pigeon.bird.contains?(obstacle.x, obstacle.y + obstacle.height) ||
         @pigeon.bird.contains?(obstacle.x + obstacle.width, obstacle.y + obstacle.height)
        Window.close
      end
    end
  end
end

game = GameWindow.new
game.show
