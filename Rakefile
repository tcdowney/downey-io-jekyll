# frozen_string_literal: true

namespace :deploy do
  desc 'Builds and deploys all Jekyll sites with an s3_website.yml file'
  task :all do
    %w[blog photo].each do |subfolder|
      raise "#{subfolder}/s3_website.yml does not exist" unless File.exist?("#{subfolder}/s3_website.yml")

      sh "cd #{subfolder}; JEKYLL_ENV=production jekyll build; s3_website push"
    end
  end

  desc 'Builds and deploys my blog to downey.io on s3'
  task :blog do
    raise 'blog/s3_website.yml does not exist' unless File.exist?('blog/s3_website.yml')

    sh 'cd blog; JEKYLL_ENV=production jekyll build; s3_website push'
  end

  desc 'Builds and deploys my photo site to photo.downey.io on s3'
  task :photo do
    raise 'photo/s3_website.yml does not exist' unless File.exist?('photo/s3_website.yml')

    sh 'cd photo; JEKYLL_ENV=production jekyll build; s3_website push'
  end
end

namespace :test do
  desc 'Builds and all Jekyll sites'
  task :build do
    %w[blog photo].each do |subfolder|
      sh "cd #{subfolder}; JEKYLL_ENV=development jekyll build"
    end
  end
end
