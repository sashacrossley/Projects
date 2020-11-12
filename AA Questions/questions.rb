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

    def save
        if self.id
            QuestionDBConnection.instance.execute(<<-SQL, self.fname, self.lname, self.id)
                UPDATE
                    users
                SET
                    fname = ?, lname = ?
                WHERE
                    id = ?
            SQL
        else
            QuestionDBConnection.instance.execute(<<-SQL, self.fname, self.lname)
                INSERT INTO
                    users (fname, lname)
                VALUES
                    (?, ?)
            SQL
            self.id = QuestionDBConnection.instance.last_insert_row_id
        end
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

    def followed_questions
        QuestionFollows.followed_questions_for_user_id(id)
    end

    def liked_questions
        QuestionLikes.liked_questions_for_user_id(id)
    end

    def average_karma
        QuestionDBConnection.instance.get_first_value(<<-SQL, self.id)
        SELECT
            CAST(COUNT(question_likes.id) AS FLOAT) /
            COUNT(DISTINCT(questions.id)) AS avg_karma
        FROM
            questions
        LEFT OUTER JOIN
            question_likes
        ON
            questions.id = question_likes.question_id
        WHERE
            questions.author_id = ?
        SQL
    end
    
    
    def subquery_average_karma
        QuestionDBConnection.instance.get_first_value(<<-SQL, self.id)
            SELECT
                AVG(likes) AS avg_karma
            FROM (
                SELECT
                    COUNT(question_likes.author_id) AS likes
                FROM
                    questions
                LEFT OUTER JOIN
                    question_likes ON questions.id = question_likes.question_id
                WHERE
                    questions.author_id = ?
                GROUP BY
                    questions.id
            )
        SQL
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

    def self.most_followed(n)
        QuestionFollows.most_followed_questions(n)
    end

    def self.most_liked(n)
        QuestionLikes.most_liked_questions(n)
    end
    
    def replies
        Replies.find_by_question_id(id)
    end

    def followers
        QuestionFollows.followers_for_question_id(id)
    end

    def likers
        QuestionLikes.likers_for_question_id(id)
    end

    def num_likes
        QuestionLikes.num_likes_for_question_id(id)
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

    def self.followers_for_question_id(question_id)
        follows_data = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                users.*
            FROM
                users
            JOIN
                question_follows ON users.id = question_follows.author_id
            WHERE
                question_follows.question_id = ?
        SQL
        follows_data.map {|follow| Users.new(follow)}
    end

    def self.followed_questions_for_user_id(user_id)
        questions_data = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_follows
            ON
                questions.id = question_follows.question_id
            WHERE
                question_follows.author_id = ?
        SQL
        questions_data.map {|questions| Questions.new(questions)}
    end

    def self.most_followed_questions(n)
        questions_data = QuestionDBConnection.instance.execute(<<-SQL, n)
            SELECT
            questions.*
            FROM
                questions
            JOIN
                question_follows
            ON
                questions.id = question_follows.question_id
            GROUP BY
                questions.id
            ORDER BY
                COUNT(*) DESC
            LIMIT
                ?
        SQL
        questions_data.map {|questions| Questions.new(questions)}
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

    def self.likers_for_question_id(question_id)
        authors = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                users.*
            FROM
                users
            JOIN
                question_likes
            ON
                users.id = question_likes.author_id
            WHERE
                question_id = ?
        SQL
        authors.map {|author| Users.new(author)}
    end

    def self.num_likes_for_question_id(question_id)
        ids = QuestionDBConnection.instance.get_first_value(<<-SQL, question_id)
            SELECT
                COUNT(*)
            FROM
                question_likes
            WHERE
                question_id = ?
        SQL
    end

    def self.liked_questions_for_user_id(user_id)
        questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes
            ON
                questions.id = question_likes.question_id
            WHERE
                question_likes.author_id = ?
        SQL
        questions.map {|question|Questions.new(question)}
    end

    def self.most_liked_questions(n)
        questions = QuestionDBConnection.instance.execute(<<-SQL, limit: n)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes
            ON
                questions.id = question_likes.question_id
            GROUP BY
                questions.id
            ORDER BY
                COUNT(*) DESC
            LIMIT
                :limit
        SQL
        
        questions.map{|question| Questions.new(question)}
    end
end