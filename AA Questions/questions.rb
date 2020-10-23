require 'sqlite3'
require 'singleton'

class QuestionDBConnection < SQLite3::Database
    include Singleton
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Users
    attr_accessor :id, :fname, :lname

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        ids = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        ids.map {|id| Users.new(id)}
    end
end

class Questions
    attr_accessor :id, :title, :body, :author_id

    def initialize(options)
        @id = options['id']
        @title= options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def self.find_by_id(id)
        ids = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        ids.map {|id| Questions.new(id)}
    end
end

class QuestionFollows
    attr_accessor :id, :author_id, :question_id

    def initialize(options)
        @id = options['id']
        @author_id = options['author_id']
        @question_id = options['question_id']
    end

    def self.find_by_id(id)
        ids = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL
        ids.map {|id| QuestionFollows.new(id)}
    end
end

class Replies
    attr_accessor :id, :author_id, :question_id, :body, :parent_reply_id

    def initialize(options)
        @id = options['id']
        @author_id = options['author_id']
        @question_id = options['question_id']
        @body = options['body']
        @parent_reply_id = options['parent_reply_id']
    end

    def self.find_by_id(id)
        ids = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        ids.map {|id| Replies.new(id)}
    end
end

class QuestionLikes
    attr_accessor :id, :author_id, :question_id

    def initialize(options)
        @id = options['id']
        @author_id = options['author_id']
        @question_id = options['question_id']
    end

    def self.find_by_id(id)
        ids = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL
        ids.map {|id| QuestionLikes.new(id)}
    end
end