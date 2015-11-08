require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  describe '#password_enabled?' do
    it "is true when password isn't blank" do
      [
        ['lol', true],
        ['', false],
        [nil, false],
      ].each do |(pass, enabled)|
        dash = build(:dashboard, password: pass)
        expect(dash.password_enabled?).to eq(enabled),
          "#{pass.inspect} => #{enabled.inspect}"
      end
    end
  end

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
