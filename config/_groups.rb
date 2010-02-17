
# ABSTRACT TARGET GROUPS - CANNOT BE USED AS TARGET

ANDROID = TargetGroup.new       "ANDROID"
ANDROID.sound_suffix            = '.ogg'
ANDROID.sound_type              = 'audio/ogg'
ANDROID.music_suffix            = '.ogg'
ANDROID.music_type              = 'audio/ogg'

JAVA = TargetGroup.new          "JAVA"
JAVA.sound_suffix               = '.mp3'
JAVA.sound_type                 = 'audio/mp3'
JAVA.music_suffix               = '.mp3'
JAVA.music_type                 = 'audio/mp3'

J2ME = TargetGroup.new          "J2ME"
J2ME.sound_suffix               = '.amr'
J2ME.sound_type                 = 'audio/amr'
J2ME.music_suffix               = '.mid'
J2ME.music_type                 = 'audio/midi'

NOKIA = TargetGroup.new         "NOKIA", "NOKIA"
NOKIA.platform                  = "J2ME"
NOKIA.keycodes.leftsoft         = -6
NOKIA.keycodes.rightsoft        = -7
NOKIA.canvas_class              = 'com.nokia.mid.ui.FullCanvas'
