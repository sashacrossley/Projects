class ShortenedUrl < ApplicationRecord

# Write a method, ShortenedUrl::random_code that uses SecureRandom::urlsafe_base64 to generate a random 16-byte string (NOTE: 16 bytes != 16 characters. Eight bits make up one byte, but depending on the encoding, one character might take up more than one byte). SecureRandom::urlsafe_base64 will return a 22 character long string and we'll use this string for our short_url purposes. Handle the vanishingly small possibility that a code has already been taken: keep generating codes until we find one that isn't the same as one already stored as the short_url of any record in our table. Return the first unused random code. You may wish to use the ActiveRecord exists? method; look it up :-)

def self.random_code
    loop do
        random = SecureRandom.urlsafe_base64
        unless ShortenedUrl.exists?(short_url: random)
            return random
        end
    end
end

# Write a factory method that takes a User object and a long_url string and create!s a new ShortenedUrl.

def self.create_shorturl(user, long_url)
    ShortenedUrl.create!(
        submitter_id: user.id,
        short_url: ShortenedUrl.random_code,
        long_url: long_url
    )
end
    
# Along with adding these database level constraints remember to add uniqueness and presence validations on the model level as well.

validates :short_url, :long_url, :submitter_id, presence: true
validates :short_url, uniqueness: true

# Write submitter and submitted_urls associations to ShortenedUrl and User.

belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
)
# Now write visitors and visited_urls associations on ShortenedUrl and User. These associations will have to traverse associations in Visit.

has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :shortened_url_id,
    primary_key: :id
)


has_many :visitors,
-> {distinct}, 
through: :visits,
source: :visitor

# ShortenedUrl#num_clicks should count the number of clicks on a ShortenedUrl.
def num_clicks
    visits.count
end

def num_uniques
    visitors.count
end

def num_recent_uniques
    visitors.where('visits.created_at > ?', 10.minutes.ago).count
end
end