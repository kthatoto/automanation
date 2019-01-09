class Player
  attr_reader :hp, :max_hp
  def initialize(win)
    @win = win
    @height = @win.maxy
    @width = @win.maxx / 2
    @status = { code: :none, char: "  " }
    @max_hp = 10
    @hp = @max_hp
    @respawn_location = 'home'
  end
  def draw
    height = @win.maxy
    width = @win.maxx / 2
    $color.bg_green(@win, height / 2, width - width % 2, @status[:char])
  end

  def damage(amount)
    @hp = [@hp - amount, 0].max
    if @hp == 0
      handle_status(nil, :dead)
      $store.push(:menu, Action.new(:player_died))
      $logger.push(Log.new("死にました..."), 90)
    end
  end

  def input_key(key, **options)
    if survived?
      handle_status(key, nil)
    else
      options[:tposes] << {pos: options[:pos], priority: 100}
      case key
      when ?R
        respawn
      end
    end
  end

  def respawn
    @hp = @max_hp
    @status = { code: :none, char: "  " }
    $store.push(:map, Action.new(:respawn, location: @respawn_location))
    $store.push(:menu, Action.new(:respawn))
  end

  def survived?
    @hp > 0
  end

  private
  def handle_status(key, status)
    if !key.nil?
      case key
      when ?j
        @status = { code: :down, char: 'Ｖ' }
      when ?h
        @status = { code: :left, char: '＜' }
      when ?l
        @status = { code: :right, char: '＞' }
      when ?k
        @status = { code: :up, char: 'Ａ' }
      end
    elsif !status.nil?
      case status
      when :dead
        @status = { code: :dead, char: 'xx' }
      end
    end
  end
end
