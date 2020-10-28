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

    def self.all
        users = QuestionDBConnection.instance.execute('SELECT * FROM users')
        users.map { |user| Users.new(user)}
    end
    
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


    def self.find_by_name(fname, lname)
        users_data = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        users_data.map {|user| Users.new(user)}
    end

    def authored_questions
        Questions.find_by_author_id(id)
    end

    def authored_replies
        Replies.find_by_user_id(id)
    end
end

class Questions
    attr_accessor :id, :title, :body, :author_id
    
    def self.all
        questions = QuestionDBConnection.instance.execute('SELECT * FROM questions')
        questions.map { |question| Questions.new(question)}
    end


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

    def self.find_by_author_id(author_id)
        ids = QuestionDBConnection.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL
        ids.map {|id| Questions.new(id)}
    end

    def replies
        Replies.find_by_question_id(id)
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

    def self.all
        replies = QuestionDBConnection.instance.execute('SELECT * FROM replies')
        replies.map { |reply| Replies.new(reply)}
    end
    
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

    def self.find_by_user_id(author_id)
        users = QuestionDBConnection.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                replies
            WHERE
                author_id = ?
        SQL
        users.map{|user| Replies.new(user)}
    end

    def self.find_by_question_id(question_id)
        replies_data = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        replies_data.map {|reply| Replies.new(reply)}
    end

    def self.find_by_parent_id(parent_reply_id)
        replies_data = QuestionDBConnection.instance.execute(<<-SQL, parent_reply_id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        replies_data.map {|reply| Replies.new(reply)}
    end

    def parent_reply
        Replies.find_by_id(parent_reply_id)
    end

    def child_replies
        Replies.find_by_parent_id(id)
    end

    def author
        Users.find_by_id(author_id)
    end

    def question
        Questions.find_by_id(question_id)
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