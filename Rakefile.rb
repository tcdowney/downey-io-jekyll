# Remembering to build before I pushed to s3 was getting tedious

namespace :site do
  desc 'Builds and deploys all Jekyll sites with an s3_website.yml file'
  task :deploy do
    subfolders = Dir.glob('*').select { |f| File.directory? f }

    subfolders.each do |subfolder|
      if File.exists?(subfolder + '/s3_website.yml')
        sh "cd #{ subfolder }; jekyll build; s3_website push --headless"
      end
    end
  end
end
