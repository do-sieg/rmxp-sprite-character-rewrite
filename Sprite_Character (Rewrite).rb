#==============================================================================
# ** Sprite_Character (Rewrite)
#------------------------------------------------------------------------------
#  By Siegfried (http://saleth.fr)
#------------------------------------------------------------------------------
#  This script rewrites some methods of Sprite_Character, the class used to
#  display characters on a map.
#  It divides the update method to make it easier to alias.
#==============================================================================

class Sprite_Character < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :character                # character
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport  : viewport
  #     character : character (Game_Character)
  #--------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    super(viewport)
    @character = character
    update
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_bitmap
    update_src_rect
    update_position
    update_other
    update_animation
  end
  #--------------------------------------------------------------------------
  # * Update Bitmap
  #--------------------------------------------------------------------------
  def update_bitmap
    if graphic_changed?
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_hue = @character.character_hue
      if @tile_id >= 384
        set_tile_bitmap
      else
        set_character_bitmap
      end
      self.ox = @cw / 2
      self.oy = @ch
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Graphic Changed
  #--------------------------------------------------------------------------
  def graphic_changed?
    # If tile ID, file name, or hue are different from current ones
    return true if @tile_id != @character.tile_id
    return true if @character_name != @character.character_name
    return true if @character_hue != @character.character_hue
    return false
  end
  #--------------------------------------------------------------------------
  # * Set Tile Bitmap
  #--------------------------------------------------------------------------
  def set_tile_bitmap
    self.bitmap = RPG::Cache.tile($game_map.tileset_name,
          @tile_id, @character.character_hue)
    self.src_rect.set(0, 0, 32, 32)
    @cw = 32
    @ch = 32
  end
  #--------------------------------------------------------------------------
  # * Set Character Bitmap
  #--------------------------------------------------------------------------
  def set_character_bitmap
    self.bitmap = RPG::Cache.character(@character.character_name,
      @character.character_hue)
    @cw = bitmap.width / 4
    @ch = bitmap.height / 4
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Rectangle
  #--------------------------------------------------------------------------
  def update_src_rect
    # If graphic is character
    if @tile_id == 0
      # Set rectangular transfer
      sx = @character.pattern * @cw
      sy = (@character.direction - 2) / 2 * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Position
  #--------------------------------------------------------------------------
  def update_position
    self.x = @character.screen_x
    self.y = @character.screen_y
    self.z = @character.screen_z(@ch)
  end
  #--------------------------------------------------------------------------
  # * Update Other
  #--------------------------------------------------------------------------
  def update_other
    self.opacity = @character.opacity
    self.blend_type = @character.blend_type
    self.bush_depth = @character.bush_depth
    self.visible = !@character.transparent
  end
  #--------------------------------------------------------------------------
  # * Update Animation Effect
  #--------------------------------------------------------------------------
  def update_animation
    if @character.animation_id != 0
      animation = $data_animations[@character.animation_id]
      animation(animation, true)
      @character.animation_id = 0
    end
  end
end
