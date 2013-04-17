# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

microbes = Microbe.create([
  { name: 'Geobacter sulfurrenducens', tag: 'mbgeo', description: 'Produces electricity and contains radioactive uranium!' },
  { name: 'Rhizobium leguminosarum', tag: 'mbrhizo', description: 'Fixes nitrogen in the soil for plant use!' },
  { name: 'Mycobacterium vaccae', tag: 'mbmyco', description: 'Found naturally in soil!' },
  { name: 'Shewanella oneidensis', tag: 'mbshewa', description: 'Produces electricity, was originally discovered isolated from sediments from Lake Oneida in New York' },
  { name: 'Bacillus subtilis', tag: 'mbbacs', description: 'Used as a probiotic, to treat' }
])
