class Question < ApplicationRecord
    validates :text, presence: true
    
    belongs_to(
        :poll,
        class_name: 'Poll',
        foreign_key: :poll_id,
        primary_key: :id
    )

    has_many(
        :answer_choices,
        class_name: 'AnswerChoice',
        foreign_key: :question_id,
        primary_key: :id
    )

    has_many :responses,
    through: :answer_choices,
    source: :responses

    def results
        # n+1 
        # answer_hash = {}
        # all_choices = self.answer_choices.all
        # all_choices.each do |choice|
        #     answer_hash[choice.text] = choice.responses.length
        # end
        # answer_hash

        # using includes
        # answer_hash = {}
        # self.answer_choices.includes(:responses).each do |choice|
        #     answer_hash[choice.text] = choice.responses.length
        # end
        # answer_hash

        # 1 query - using SQL
        # acs = AnswerChoice.find_by_sql([<<-SQL, id])
        #     SELECT
        #         answer_choices.text, COUNT(responses.id) AS num_responses
        #     FROM
        #         answer_choices
        #         LEFT OUTER JOIN responses
        #         ON answer_choices.id = responses.answer_choice_id
        #     WHERE
        #         answer_choices.question_id = ?
        #     GROUP BY
        #         answer_choices.id
        # SQL

        # 1 query - using activerecord

        acs = self.answer_choices
        .left_outer_joins(:responses)
        .select("answer_choices.text, COUNT(responses.id) AS num_responses")
        .group("answer_choices.id")


        answer_hash = {}
        acs.each do |choice|
            answer_hash[choice.text] = choice.num_responses
        end
        answer_hash
    end

end