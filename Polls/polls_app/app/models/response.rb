class Response < ApplicationRecord
    validate :not_duplicate_response
    validate :respondent_is_not_poll_author

    belongs_to(
        :answer_choice,
        class_name: 'AnswerChoice',
        foreign_key: :answer_choice_id,
        primary_key: :id
    )

    belongs_to(
        :respondent,
        class_name: 'User',
        foreign_key: :respondent_id,
        primary_key: :id
    )

    has_one :question,
    through: :answer_choice,
    source: :question


    def sibling_responses
        self.question.responses.where.not(id: self.id)
    end

    def respondent_already_answered?
        sibling_responses.exists?(respondent_id: self.respondent_id)
    end

    def not_duplicate_response
        if respondent_already_answered?
            errors[:respondent_id] << 'cannot vote twice for question'
        end
    end

    def respondent_is_not_poll_author
        poll_author_id = self.answer_choice.question.poll.author_id
        if poll_author_id == self.respondent_id
            errors[:respondent_id] << 'cannot be poll author'
        end
    end
end