
# ABSTRACT TARGET GROUPS - CANNOT BE USED AS TARGET

Generic = TargetGroup.new       "Generic"
Generic.sound_suffix            = '.amr'
Generic.sound_type              = 'audio/amr'
Generic.music_suffix            = '.mid'
Generic.music_type              = 'audio/midi'

Nokia = TargetGroup.new         "Nokia", "NOKIA"
Nokia.keycodes.leftsoft         = -6
Nokia.keycodes.rightsoft        = -7
Nokia.canvas_class              = 'com.nokia.mid.ui.FullCanvas'

Siemens = TargetGroup.new      "Siemens"
Siemens.keycodes.leftsoft      = -1
Siemens.keycodes.rightsoft     = -4

Siemens1 = TargetGroup.new      "Siemens1", "SIEMENS"
Siemens1.keycodes.leftsoft      = -1
Siemens1.keycodes.rightsoft     = -4
Siemens1.canvas_class           = 'com.siemens.mp.color_game.GameCanvas'

Motorola = TargetGroup.new     "Motorola"
Motorola.keycodes.leftsoft     = -21
Motorola.keycodes.rightsoft    = -22

Motorola1 = TargetGroup.new     "Motorola1"
Motorola1.keycodes.leftsoft     = -20
Motorola1.keycodes.rightsoft    = -21

Motorola2 = TargetGroup.new     "Motorola2"
Motorola2.keycodes.leftsoft     = 21
Motorola2.keycodes.rightsoft    = 22

Motorola3 = TargetGroup.new     "Motorola3"
Motorola3.keycodes.leftsoft     = -10
Motorola3.keycodes.rightsoft    = -11

SonyEricsson = TargetGroup.new  "SonyEricsson"
SonyEricsson.keycodes.leftsoft  = -6
SonyEricsson.keycodes.rightsoft = -7

SonyEricsson1 = TargetGroup.new  "SonyEricsson1"
SonyEricsson1.keycodes.leftsoft  = -7
SonyEricsson1.keycodes.rightsoft = -6

Sagem = TargetGroup.new         "Sagem"
Sagem.keycodes.leftsoft         = -6
Sagem.keycodes.rightsoft        = -7

LG = TargetGroup.new            "LG"
LG.keycodes.leftsoft            = -202
LG.keycodes.rightsoft           = -203
