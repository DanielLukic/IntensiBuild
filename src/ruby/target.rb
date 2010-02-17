
class TargetBase

  attr_reader :name
  attr_reader :symbols
  attr_reader :manifest
  attr_reader :keycodes

  attr_accessor :canvas_class
  attr_accessor :sound_suffix
  attr_accessor :sound_type
  attr_accessor :music_suffix
  attr_accessor :music_type

  def initialize( parent = nil, symbols_list = '' )
    if parent
      @name = parent.name
      @symbols = parent.symbols.dup
      @manifest = parent.manifest.dup
      @keycodes = Keycodes.new parent.keycodes
      @canvas_class = parent.canvas_class
      @sound_suffix = parent.sound_suffix
      @sound_type = parent.sound_type
      @music_suffix = parent.music_suffix
      @music_type = parent.music_type
    else
      @name = 'NONAME'
      @symbols = []
      @manifest = {}
      @keycodes = Keycodes.new
      @canvas_class = 'javax.microedition.lcdui.Canvas'
      @sound_suffix = '.amr'
      @sound_type = 'audio/amr'
      @music_suffix = '.mid'
      @music_type = 'audio/midi'
    end

    @symbols.concat symbols_to_ary( symbols_list )
    clean_up_symbols
  end

  def platform
    @platform.downcase
  end

  def platform=(value)
    @platform = value.downcase
  end

  def midp
    return '1.0' if symbols.index 'MIDP1'
    return '2.0' if symbols.index 'MIDP2'
    raise 'no MIDP version set'
  end

  def cldc
    return '1.0' if symbols.index 'CLDC10'
    return '1.1' if symbols.index 'CLDC11'
    raise 'no CLDC version set'
  end

  def libs
    my_symbols = symbols

    my_symbols.collect { |s| s + '.jar' }
  end

  private

  def symbols_to_ary( symbols_list )
    symbols_list.split( /\s*,\s*/ )
  end

  def clean_up_symbols
    @symbols.delete ''
    @symbols.compact!
    @symbols.uniq!
    @symbols.sort!
  end

end


class TargetGroup < TargetBase

  def initialize( name, symbols_list = '' )
    super( nil, symbols_list )
    @name = name
  end

end


class Target < TargetBase

  def initialize( group, symbols_list = '' )
    super( group, symbols_list )
    @name = group.name.dup
    @platform = group.name.dup.downcase
    @symbols.each { |s| @name << '/' ; @name << s }
  end

  def to_s
    symbols_list = symbols.join ','
    %{Target( '#{name}' '#{symbols_list}' )}
  end

end


class Keycodes

  attr_accessor :leftsoft
  attr_accessor :rightsoft

  def initialize( parent = nil )
    if parent
      @leftsoft = parent.leftsoft
      @rightsoft = parent.rightsoft
    else
      @leftsoft = -6
      @rightsoft = -7
    end
  end

end
