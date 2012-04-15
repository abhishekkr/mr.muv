require File.join File.dirname(File.expand_path __FILE__), "imdb_rating.rb"

namespace :movie do
  namespace :rating do
    desc <<-IMDB
        imdb movie rating
        eg: MDIR=./MyMoviesDir rake movie:rating:imdb
        eg: MUV="Any Movie Name" rake movie:rating:imdb
     IMDB
    task :imdb do
      if !ENV['MUV'].nil?
        IMDBRating.movie ENV['MUV']
      elsif !ENV['MDIR'].nil?
        IMDBRating.movie_dir ENV['MDIR']
      end
    end
  end
end
