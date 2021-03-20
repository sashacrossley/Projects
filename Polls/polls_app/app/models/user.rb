class User < ApplicationRecord
    validates :username, uniqueness: true, presence: true
    has_many(
        :authored_polls, 
        class_name: 'Poll',
        foreign_key: :author_id,
        primary_key: :id
    )

    has_many(
        :responses, 
        class_name: 'Response',
        foreign_key: :respondent_id,
        primary_key: :id
    )

end