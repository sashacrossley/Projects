class Visit < ApplicationRecord
    validates :user_id, presence:true
    validates :shortened_url_id, presence:true

  belongs_to :shortened_url

  belongs_to :visitor,
    class_name: :User,
    foreign_key: :user_id,
    primary_key: :id

    # will create a Visit object recording a visit from a User to the given ShortenedUrl.

def self.record_visit!(user, shortened_url)
    Visit.create!(
        user_id: user.id,
        shortened_url_id: shortened_url.id
    )
end


end