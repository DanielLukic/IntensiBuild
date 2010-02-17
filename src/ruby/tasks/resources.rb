namespace :resources do

  desc "Create the font-size data files for all font images."
  task :font_size_files => [ 'check:groovy' ] do
    run %Q[groovy #{INTENSIBUILD_FOLDER}/src/groovy/FontSizer.groovy]
  end

end
