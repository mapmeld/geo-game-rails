# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([
  { name: 'Test One', tag: 'test1', description: "<p>Write a description here.</p><ul><li>use text</li><li>use HTML</li></ul>" },
  { name: 'Test Two', tag: 'test2', description: "<p>Write a description here.</p>" }
])
