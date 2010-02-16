import net.intensicode.tools.FontSizer

SUFFIX_PATTERN = /\.[a-zA-Z0-9]+$/

project.references.res_font_images.each
{
  targetFileName = it.name.replaceFirst(SUFFIX_PATTERN, FontSizer.DEFAULT_EXTENSION)

  imageFile = new File(it.name)
  sizeFile = new File(targetFileName)

  if ( imageFile.lastModified() > sizeFile.lastModified() )
  {
    println "Updating font size file ${sizeFile}"
    try
    {
      FontSizer.process(imageFile, sizeFile)
    }
    catch (Throwable t)
    {
      t.printStackTrace()
      exit(10)
    }
  }
}
