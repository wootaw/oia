class Bubbles

  class Bubble

    attr_accessor :r, :x, :y, :color

    def initialize(r, x, y)
      @r = r
      @x = x
      @y = y
      @color = (1..3).map { |e| "%02x" % Random.rand(255) }.join
    end

    def hash_code
      ["%02x" % @r, "%02x" % @x, "%02x" % @y, @color].join.to_i(16).to_s(36)
    end

    def command
      "fill ##{@color} circle #{@x},#{@y} #{@x - @r},#{@y}"
    end

  end

  def initialize(size)
    @size = size
    @list = []
  end

  def generate(mr)
    r = mr + Random.rand(@size / 4)
    if @list.size == 0
      x = r + Random.rand(@size - 2 * r)
      y = r + Random.rand(@size - 2 * r)
      @list << Bubble.new(r, x, y)
    else
      @list.each do |b|
        (1..360).each do |d|
          x = (b.x + (b.r + r + 1) * Math.cos(2 * Math::PI / 360 * d)).floor
          y = (b.y + (b.r + r + 1) * Math.sin(2 * Math::PI / 360 * d)).floor
          if x - r > 0 && x + r < @size && y - r > 0 && y + r < @size
            next if touch?(r, x, y, b)
            bubble = Bubble.new(r, x, y)
            @list << bubble
            return bubble
          end
        end
      end
    end
    nil
  end

  def touch?(r, x, y, cb)
    result = false
    @list.each do |b|
      next if b.x == cb.x && b.y == cb.y
      if Math.sqrt((x - b.x).abs ** 2 + (y - b.y).abs ** 2).floor <= r + b.r
        result = true
        break
      end
    end
    result
  end

  def shuffle
    count = 3 + Random.rand(2)
    i = 0
    while i < count
      i += 1 unless generate(@size / 15).nil?
    end
  end

  def save(dir)
    shuffle
    filename = "#{dir}/#{@list.map(&:hash_code).join('-')}.png"
    MiniMagick::Tool::Convert.new do |cvrt|
      cvrt.size "#{@size}x#{@size}"
      cvrt << 'xc:transparent'
      @list.each do |b|
        cvrt.draw b.command
      end
      cvrt << filename
    end
    filename
  end

end