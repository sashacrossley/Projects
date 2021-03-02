def eighties_b_movies
  Movie
    .select(:id, :title, :yr, :score)
    .where(yr: (1980..1989))
    .where(score: (3..5))
  # List all the movies from 1980-1989 with scores falling between
  # 3 and 5 (inclusive).
  # Show the id, title, year, and score.

end

def bad_years
  Movie
    .group(:yr)
    .having('MAX(score) < 8')
    .pluck(:yr)
  # List the years in which a movie with a rating above 8 was not released.

end

def cast_list(title)
  Actor
    .select(:id, :name)
    .joins(:movies)
    .where(movies:{title:title})
    .order('ord ASC')
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.

end

def vanity_projects
  Movie
    .select('movies.id, movies.title, actors.name')
    .joins(:actors)
    .where('director_id = actors.id')
    .where('castings.ord = 1')

  # List the title of all movies in which the director also appeared
  # as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.

end

def most_supportive
  Actor
  .select('actors.id, actors.name, COUNT(castings.actor_id) AS roles')
  .joins(:castings)
  .group(:id)
  .where.not('castings.ord = 1')
  .order('COUNT(castings.actor_id) DESC')
  .limit(2)

    
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name and number of supporting roles.

end
