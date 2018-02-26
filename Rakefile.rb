# Remembering to build before I pushed to s3 was getting tedious

namespace :deploy do
  desc 'Builds and deploys all Jekyll sites with an s3_website.yml file'
  task :all do
    ['blog', 'photo'].each do |subfolder|
      fail "#{subfolder}/s3_website.yml does not exist" unless File.exists?("#{subfolder}/s3_website.yml")

      sh "cd #{ subfolder }; JEKYLL_ENV=production jekyll build; s3_website push"
    end
  end

  desc 'Builds and deploys my blog to downey.io on s3'
  task :blog do
    fail 'blog/s3_website.yml does not exist' unless File.exists?('blog/s3_website.yml')

    sh 'cd blog; JEKYLL_ENV=production jekyll build; s3_website push'
  end

  desc 'Builds and deploys my photo site to photo.downey.io on s3'
  task :photo do
    fail 'photo/s3_website.yml does not exist' unless File.exists?('photo/s3_website.yml')

    sh 'cd photo; JEKYLL_ENV=production jekyll build; s3_website push'
  end
end
