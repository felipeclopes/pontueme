# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Coupon.delete_all
Benefit.delete_all
UserBusinessPoints.delete_all
CardBusinessPoints.delete_all
Card.delete_all
Business.delete_all
User.delete_all

@b1 = Business.create(name: 'Mc Donalds', email: 'mcdonalds@gmail.com', password: '123', address: 'Logo ali', website: 'http://mcdonalds.com', category: 'Fast Food')
@bn11 = Benefit.create(name: 'BigMc Triplo', description: 'Ganhe um BigMc com 3 hamburguers', checkins_needed: 5, enabled: true, business: @b1 )
@bn12 = Benefit.create(name: 'Seu Mc', description: 'Crie um hamburger personalisado com qualquer ingrediente ja disponivel na cozinha do McDonalds', checkins_needed: 10, enabled: true, business: @b1 )
@bn13 = Benefit.create(name: 'Mc Festa', description: 'Escolha um combo para voce e mais quatro amigos', checkins_needed: 20, enabled: true, business: @b1 )
@bn11 = Benefit.create(name: 'BigMc Triplo', description: 'Ganhe um BigMc com 3 hamburguers', checkins_needed: 5, enabled: true, business: @b1 )
#@bn12 = Benefit.create(name: 'Seu Mc', description: 'Crie um hamburger personalisado com qualquer ingrediente ja disponivel na cozinha do McDonalds', checkins_needed: 10, enabled: true, business: @b1 )
#@bn13 = Benefit.create(name: 'Mc Festa', description: 'Escolha um combo para voce e mais quatro amigos', checkins_needed: 20, enabled: true, business: @b1 )

@b2 = Business.create(name: '21212', email: 'highspeed@21212.com', password: 'h1ghsp33d', address: 'Botafogo  Rio de Janeiro - RJ', website: 'http://21212.com', category: 'Startups')
@bn21 = Benefit.create(name: 'Mentor', description: 'Escolha um mentor da 21212 para continuar ajudando sua Startup, mesmo após o fim do ciclo de aceleração', checkins_needed: 30, enabled: true, business: @b2 )
@bn22 = Benefit.create(name: 'Sócio', description: 'Além da mentoria você pode escolher um dos sócios da 21212 para trabalhar na sua Startup', checkins_needed: 60, enabled: true, business: @b2 )

@c1 = Card.create(code:'code1')
@c2 = Card.create(code:'code2')

@u1 = User.create(email: 'felipelopes10@gmail.com', password: '123')

businesses = [@b1, @b2]
users = [@u1]
cards = [@c1, @c2]

dates = (Date.today.at_beginning_of_month..Date.today)

businesses.each do |b|
	users.each do |u|
		50.times do 
			Checkin.create(business: b, user: u, points: 1)
		end
	end
end

businesses.each do |b|
	cards.each do |c|
		20.times do 
			Checkin.create(business: b, card: c, points: 1)
		end
	end
end
