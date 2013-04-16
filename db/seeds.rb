# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

microbes = Microbe.create([
  { name: 'Geobacter sulfurrenducens', tag: 'mbgeo' },
  { name: 'Rhizobium leguminosarum', tag: 'mbrhizo' },
  { name: 'Mycobacterium vaccae', tag: 'mbmyco' },
  { name: 'Shewanella oneidensis', tag: 'mbshewa' },
  { name: 'Bacillus subtilis', tag: 'mbbacs' }
])
