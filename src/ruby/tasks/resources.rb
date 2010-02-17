namespace :resources do

  def font_image_files
    Dir.glob('res/**/*font.png').sort
  end

  def font_sizer(image_file)
    run "jruby #{INTENSIBUILD_FOLDER}/src/jruby/font_sizer.rb #{image_file}"
  end

  desc "Create the font-size data files for all font images."
  task :font_size_files => [ 'check:jruby' ] do
    font_image_files.each do |image_file|
      dst_file = image_file.sub '.png', '.dst'
      font_sizer image_file unless uptodate?(dst_file, image_file)
    end
  end

end
