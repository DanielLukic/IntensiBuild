Build system specialized for building IntensiGame-based applications.

h1. Description

IntensiBuild is a light weight build system for creating J2ME applications. It uses a small set of Ruby scripts with a generic Ant build file to create device-specific builds.

It is usually enough to have the IntensiBuild snapshot in your project under the relative path <pre>modules/IntensiBuild</pre> and create a small build.xml in you project root that imports the main build.xml from the IntensiBuild snapshot:
<pre>
<project name="Example" default="build">
    <import file="modules/IntensiBuild/build.xml"/>
</project>
</pre>

For creating IntensiBuild releases of your application, you have to create configuration files. At least one file should be present under for example <pre>config/Example.rb</pre>:
<pre>
# Name of the resulting jar/jad bundle (no special chars).
@name = "Example"

# Possible targets are defined in file _targets.rb.
@targets = [ Generic_MIDP2, Nokia_MIDP2 ]

# Possible sizes correspond to the image folders in the res directory.
# You may use arbitrary folder names (no spaces or special chars) here -
# as long as they exist.
@sizes = [ "Default" ]

# Use this to activate global - not target-specific - settings. Used
# primarly for debug output and effects.
@symbols = []
</pre>

The build system assumes there is a resource folder available with a structure matching the values given in the configuration file. If you name your project "Example" and build for a screen size "Default", the resource folder would need to look like:
<pre>
res/Example/Default/
</pre>

Finally you need to define some default build.properties:
<pre>
# Project name for when building a default release.
project.name = Example

# Base name for the resulting .jar file.
output.name = Example

vendor.name = The.Berlin.Factor

screen.size = Default

# Symbols for the primary configuration.
defined_symbols = MIDP2,CLDC11,RUNME

# Main class - stays the same for all configurations.
midlet.class = net.intensicode.Main

# Primary configuration for normal Ant build.
release.configurations = Example

# Use this JAD file with - for example - a list of special MIDlet permissions.
jad.template = Example.jad
</pre>

Override the WTK location in env.properties if necessary:
<pre>
wtk.home = /usr/local/wtk
</pre>

Create a release.sh script for convenience:
<pre>
ruby -Imodules/IntensiBuild/scripts modules/IntensiBuild/scripts/release.rb $*
</pre>

Create the JAD template:
<pre>
MIDlet-Icon: /icon.png
MIDlet-Version: ${version}
MIDlet-Name: ${project.name}
MIDlet-Vendor: ${vendor.name}
MIDlet-Jar-URL: ${project.name}.jar
MIDlet-1: ${project.name}, /icon.png, ${midlet.class}
MIDlet-Permissions: javax.microedition.io.Connector.http,javax.microedition.io.Connector.https,javax.microedition.io.Connector.bluetooth.client,javax.microedition.io.Connector.comm,javax.microedition.io.Connector.socket,javax.microedition.io.Connector.datagram
</pre>

If you want to create a signed WebStart version using RunMe, you need to create a proper signing.properties file:
<pre>
signing.keytool = /usr/local/jdk/bin/keytool
signing.alias = intensicode
signing.keypass = password
signing.storepass = password
signing.keystore = ${dir.intensibuild}/keystore.bin
signing.dname = CN=intensicode, OU=it, O=intensicode, C=DE
</pre>

Make sure you ran <pre>ant update_certificate</pre>.

h1. Using the build system

Creating a debug/development build: <pre>ant build</pre>

Creating a default configuration release build: <pre>ant release</pre>

Creating a specific release: <pre>./release.sh config/Example.rb</pre>

h1. License

This is open source software. See the gpl.txt file for more infomation.

Note that some files are included for which different licenses may apply.

Note that for all files that are probably 'mine', the GPL applies.

