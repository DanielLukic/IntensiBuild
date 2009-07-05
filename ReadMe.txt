Das auf IntensiGame spezialisierte Build System.

= Description =

IntensiBuild is a light weight build system for creating J2ME applications. It uses a small set of Ruby scripts with a generic Ant build file to create device-specific builds.

It is usually enough to have the IntensiBuild snapshot in your project under the relative path {{{modules/IntensiBuild}}} and create a small build.xml in you project root that imports the main build.xml from the IntensiBuild snapshot:
{{{
<project name="QiroClientV2" default="build">
    <import file="modules/IntensiBuild/build.xml"/>
</project>
}}}

For creating IntensiBuild releases of your application, you have to create configuration files. At least one file should be present under for example {{{config/QiroClientV2.rb}}}:
{{{
# Name of the resulting jar/jad bundle (no special chars).
@name = "QiroClientV2"

# Possible targets are defined in file _targets.rb.
@targets = [ Generic_MIDP2, Nokia_MIDP2 ]

# Possible sizes correspond to the image folders in the res directory.
# You may use arbitrary folder names (no spaces or special chars) here -
# as long as they exist.
@sizes = [ "Default" ]

# Use this to activate global - not target-specific - settings. Used
# primarly for debug output and effects.
@symbols = []
}}}

The build system assumes there is a resource folder available with a structure matching the values given in the configuration file. If you name your project "QiroClientV2" and build for a screen size "Default", the resource folder would need to look like:
{{{
res/QiroClientV2/Default/
}}}

Finally you need to define some default build.properties:
{{{
# Projektname wenn keine explizite Release gebaut wird. (Basispfad in res Verzeichnis).
project.name = QiroClientV2

# Basisname fuer die resultierende .jar Datei.
output.name = QiroClientV2

# Hersteller fuer MIDlet Info.
vendor.name = Qiro GmbH

# Default Wert fuer Bildschirmgroesse.
screen.size = Default

# Konfigurationssymbole fuer primaere Konfiguration.
defined_symbols = MIDP2,CLDC11,RUNME

# Hauptklasse bleibt gleich - ueber alle Konfigurationen hinweg.
midlet.class = qiro.Qiro

# Primaere Konfiguration fuer normalen Ant Build.
release.configurations = QiroClientV2

# Eigenes JAD file mit speziellen Permissions verwenden.
jad.template = QiroClientV2.jad
}}}

Override the WTK location in env.properties if necessary:
{{{
wtk.home = /usr/local/wtk
}}}

Create a release.sh script:
{{{
ruby -Imodules/IntensiBuild/scripts modules/IntensiBuild/scripts/release.rb $*
}}}

Create the JAD template:
{{{
MIDlet-Icon: /icon.png
MIDlet-Version: ${version}
MIDlet-Name: ${project.name}
MIDlet-Vendor: ${vendor.name}
MIDlet-Jar-URL: ${project.name}.jar
MIDlet-1: ${project.name}, /icon.png, ${midlet.class}
MIDlet-Permissions: javax.microedition.io.Connector.http,javax.microedition.io.Connector.https,javax.microedition.io.Connector.bluetooth.client,javax.microedition.io.Connector.comm,javax.microedition.io.Connector.socket,javax.microedition.io.Connector.datagram
}}}

If you want to create a signed WebStart version using RunMe, you need to create a proper signing.properties file:
{{{
signing.keytool = /usr/local/jdk/bin/keytool
signing.alias = qiro
signing.keypass = password
signing.storepass = password
signing.keystore = ${dir.intensibuild}/keystore.bin
signing.dname = CN=qiro, OU=it, O=qiro, C=DE
}}}

Make sure you ran {{{ant update_certificate}}}.

= Using the build system =

Creating a debug/development build: {{{ant build}}}

Creating a default configuration release build: {{{ant release}}}

Creating a specific release: {{{./release.sh config/QiroClientV2.rb}}}
