# Remembering to build before I pushed to s3 was getting tedious

namespace :deploy do
  desc 'Builds and deploys all Jekyll sites with an s3_website.yml file'
  task :all do
    subfolders = Dir.glob('*').select { |f| File.directory? f }

    subfolders.each do |subfolder|
      if File.exists?(subfolder + '/s3_website.yml')
        sh "cd #{ subfolder }; jekyll build; s3_website push --headless"
      end
    end
  end

  desc 'Builds and deploys my blog to downey.io on s3'
  task :blog do
    if File.exists?('blog' + '/s3_website.yml')
      sh 'cd blog; jekyll build; s3_website push --headless'
    end
  end

  desc 'Builds and deploys my photo site to photo.downey.io on s3'
  task :photo do
    if File.exists?('photo' + '/s3_website.yml')
      sh 'cd photo; jekyll build; s3_website push --headless'
    end
  end
end
