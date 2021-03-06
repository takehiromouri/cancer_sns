# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TREATMENTS = %w(手術療法 抗がん剤（化学療法） 放射線療法 ホルモン療法 先進医療 漢方 その他被保険療法)
TREATMENTS.each do |treatment|
  Treatment.create(name: treatment, default: true)
end if Treatment.count == 0
 
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if AdminUser.count == 0

TAG_NAMES = %w(治療法 心の悩み お金の悩み 家族 こども 友人 仕事 病院 性の悩み 楽しいこと 悲しいこと 腹立たしいこと 生活のこと)

TAG_NAMES.each do |name|
  PostTag.create(name: name)
end if PostTag.count == 0