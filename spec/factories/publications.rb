# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :publication do
    publishable { |p| p.association(:text_post) }
  end

  factory :non_it_publication, class: Publication do
    association :publishable, factory: :non_it_text_post
  end
end
