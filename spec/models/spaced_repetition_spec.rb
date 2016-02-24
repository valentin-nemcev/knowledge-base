require 'rails_helper'

RSpec.describe 'Spaced repetition' do

  context 'new article' do
    subject { Article.create! }
    it('has no next review date') { expect(subject.next_review_at).to be_nil }
  end

  let(:start_date) { Date.parse '2016-01-01' }

  context 'article with reviews' do
    let(:article) { Article.create! }

    def match_reviews(expected)
      actual = expected.map do |delay, response_quality, expected_interval|
        review_time = article.next_review_at || start_date
        article.reviews.create!(
          reviewed_at: review_time + delay.days,
          response_quality: response_quality
        )
        [delay, response_quality,
         ((article.next_review_at - article.last_reviewed_at) / 1.day).round]
      end
      expect(actual).to eq(expected)
    end

    specify 'minimum good marks' do
      match_reviews([
        [0, 3,  1],
        [0, 3,  6],
        [0, 3, 13],
        [0, 3, 28],
        [0, 3, 54],
        [0, 3, 97],
      ])
    end

    specify 'various good marks' do
      match_reviews([
        [0, 5,   1],
        [0, 3,   6],
        [0, 4,  15],
        [0, 5,  36],
        [0, 3,  93],
        [0, 4, 225],
        [0, 3, 544],
      ])
    end

    specify 'reset after bad marks' do
      match_reviews([
        [0, 3,  1],
        [0, 3,  6],
        [0, 1,  1],
        [0, 2,  1],
        [0, 4,  6],
        [0, 5,  8],
        [0, 5, 12],
        [0, 5, 19],
      ])
    end

    specify 'positive delays with reset' do
      match_reviews([
        [ 0, 3,  1],
        [ 6, 3, 17],
        [ 0, 3, 37],
        [10, 2,  1],
        [ 0, 3,  6],
        [ 0, 3, 10],
      ])
    end

    #TODO: Negative delay
  end
end
