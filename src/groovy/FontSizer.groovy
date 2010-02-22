import java.awt.image.BufferedImage
import javax.imageio.ImageIO

class FontSizer
{
  public static def DEFAULT_EXTENSION = ".dst"
  public static int DEFAULT_ALPHA_THRESHOLD = 128

  public int cellsPerRow
  public int cellsPerColumn
  public int cellWidth
  public int cellHeight

  public static void main(String[] aArguments)
  {
    new File('res').eachFileRecurse {
      def fontFileName = it.path
      if ( fontFileName.endsWith('font.png') )
      {
        def dstFileName = fontFileName.replaceAll('.png', '.dst')
        def dst = new File(dstFileName)
        if ( it.lastModified() > dst.lastModified() ) process(it, dst)
      }
      if ( fontFileName.endsWith('.bfm') )
      {
        def dstFileName = fontFileName.replaceAll('.bfm', '.dst')
        fontFileName = fontFileName.replaceAll('.bfm', '.png')
        def png = new File(fontFileName)
        def dst = new File(dstFileName)
        if ( png.lastModified() > dst.lastModified() ) process(png, dst)
      }
    }
  }

  public static void process(aInputFile, aOutputFile)
  {
    def sizer = new FontSizer(16, 8)

    sizer.prepare(aInputFile)
    println "processing ${aInputFile} into ${aOutputFile}"

    def sizes = sizer.determineSizes()

    def output = new DataOutputStream(new FileOutputStream(aOutputFile))
    output.write(sizes)
    output.flush()
    output.close()

    println "wrote ${aOutputFile.size()} bytes"
  }

  public FontSizer(aCellsPerRow, aCellsPerColumn)
  {
    cellsPerRow = aCellsPerRow
    cellsPerColumn = aCellsPerColumn
    myAlphaThreshold = DEFAULT_ALPHA_THRESHOLD
  }

  public void prepare(aInputFile)
  {
    myInputImage = ImageIO.read(aInputFile)

    int imageWidth = myInputImage.width
    int imageHeight = myInputImage.height

    cellWidth = imageWidth / cellsPerRow
    if ( imageWidth != (cellsPerRow * cellWidth) )
    {
      fail("bad input image width ${imageWidth} for ${cellsPerRow} cells per row")
    }

    cellHeight = imageHeight / cellsPerColumn;
    if ( imageHeight != (cellsPerColumn * cellHeight) )
    {
      fail("bad input image height ${imageHeight} for ${cellsPerColumn} cells per column")
    }

    myZeroSize = cellWidth * 2 / 3
    myCharOffset = Math.max(1, cellWidth / 8)

    myPixelBuffer = new int[cellWidth * cellHeight]
  }

  public byte[] determineSizes()
  {
    def sizes = new byte[cellsPerRow * cellsPerColumn]

    for ( int y = 0; y < cellsPerColumn; y++ )
    {
      for ( int x = 0; x < cellsPerRow; x++ )
      {
        def code = x + y * cellsPerRow;
        def width = myZeroSize
        if ( code != 0 )
        {
          int inputX = x * cellWidth
          int inputY = y * cellHeight
          myInputImage.getRGB(inputX, inputY, cellWidth, cellHeight, myPixelBuffer, 0, cellWidth)
          width = findWidth(myPixelBuffer, cellWidth, cellHeight) + myCharOffset
        }
        sizes[ code ] = Math.min(cellWidth, width)
      }
    }
    return sizes
  }

  // Implementation

  private void fail(aMessage)
  {
    throw new RuntimeException(aMessage)
  }

  private int findWidth(aBuffer, aWidth, aHeight)
  {
    for ( int x = aWidth - 1; x >= 0; x-- )
    {
      def columnInUse = false
      for ( int y = aHeight - 1; y >= 0; y-- )
      {
        def dataPos = x + y * aWidth
        def alphaValue = ( ( aBuffer[ dataPos ] & 0xFF000000 ) >> 24 ) & 0xFF
        if ( alphaValue > myAlphaThreshold ) columnInUse = true
      }
      if ( columnInUse ) return Math.min(x + 1, aWidth)
    }
    return 0
  }

  private BufferedImage myInputImage
  private int myZeroSize
  private int myCharOffset
  private int myAlphaThreshold
  private int[] myPixelBuffer
}
