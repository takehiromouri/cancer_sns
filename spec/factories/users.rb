FactoryGirl.define do
  factory :user do
    first_name "山本"    
		last_name "太郎"
		sequence :email do |n|
      "random#{n}@email.com"
    end
    password "password"
    password_confirmation "password"
    is_public true
    birthday DateTime.now - 40.years
    gender :男性
    partner_age 40
    cancer_type "脳腫瘍"
    cancer_stage "ステージ０"
    treatment "治療法"
  end

  factory :incomplete_user, class: 'User' do
  	first_name "山本"    
		last_name "太郎"
		sequence :email do |n|
      "random#{n}@email.com"
    end
    password "password"
    password_confirmation "password"
  end  
end
