require 'rails_helper'

RSpec.describe 'Spaced repetition' do

  context 'new article' do
    subject { Card.create!(article: Article.create!, path: 'test') }
    it('has no next review date') { expect(subject.next_review_at).to be_nil }
  end

  let(:start_date) { Date.parse '2016-01-01' }

  context 'article with reviews' do
    let(:card) { Card.create!(article: Article.create!, path: 'test') }

    def match_reviews(expected)
      actual = expected.map do |delay, grade, expected_interval|
        review_time = card.next_review_at || start_date
        card.reviews.create!(
          reviewed_at: review_time + delay.days,
          grade: grade
        )
        [delay, grade,
         ((card.next_review_at - card.last_reviewed_at) / 1.day).round]
      end
      expect(actual).to eq(expected)
    end

    specify 'minimum good marks' do
      match_reviews([
        [0, :good,  1],
        [0, :good,  6],
        [0, :good, 13],
        [0, :good, 28],
        [0, :good, 54],
        [0, :good, 97],
      ])
    end

    specify 'various good marks' do
      match_reviews([
        [0, :easy,   1],
        [0, :good,   6],
        [0, :easy,  14],
        [0, :easy,  33],
        [0, :good,  79],
        [0, :hard, 175],
        [0, :good, 333],
      ])
    end

    specify 'reset after bad marks' do
      match_reviews([
        [0, :good,  1],
        [0, :good,  6],
        [0, :again, 1],
        [0, :good,  6],
        [0, :easy,  9],
        [0, :easy,  14],
      ])
    end

    specify 'positive delays with reset' do
      match_reviews([
        [ 0, :good,   1],
        [ 6, :good,  17],
        [ 0, :good,  37],
        [10, :again,  1],
        [ 0, :good,   6],
        [ 0, :good,   8],
      ])
    end

    #TODO: Negative delay
  end
end
