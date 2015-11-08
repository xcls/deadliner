require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  describe 'validations' do

    describe '#slug' do
      it "only allows alphanumeric chars, dashes or underscores" do
        [
          ['lol', true],
          ['lol123', true],
          ['lol/lol', false],
          ['lol\lol', false],
          ['lol lol', false],
          ['lol-lol', true],
          ['lol_lol', true],
        ].each do |(slug, valid)|
          dash = build(:dashboard, slug: slug)
          expect(dash.valid?).to eq(valid),
            "Expected #{slug.inspect} to return valid? == #{valid.inspect}"
        end
      end
    end
  end
end
