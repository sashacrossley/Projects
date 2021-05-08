class User < ApplicationRecord
    validates :email, uniqueness: true, presence: true
    validates :name, uniqueness: true, presence: true
end