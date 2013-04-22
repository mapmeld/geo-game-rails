# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

microbes = Microbe.create([
  { name: 'Geobacter sulfurrenducens', tag: 'mbgeo', description: "<p>Produces electricity and contains radioactive uranium! It usually resides underground, in a place with little to no oxygen and iron oxides.</p><p>It needs a place that:</p><ul><li>is deep/below the surface </li><li>takes your breath away</li><li>restrains toxins</li></ul>" },
  { name: 'Rhizobium leguminosarum', tag: 'mbrhizo', description: "<p>Fixes nitrogen in the soil for plant use! This bacteria usually resides in the soil, and has a symbiotic relationship with plants.</p><p>It needs a place that:</p><ul><li>has roots</li><li>is dirty</li><li>fixes your problems</li></ul>" },
  { name: 'Mycobacterium vaccae', tag: 'mbmyco', description: "<p>Studies of this bacteria conclude that playing in dirt makes you happier and smarter. Found naturally in soil!</p><p>It needs a place that:</p><ul><li>makes you happy</li><li>can be played with</li><li>keeps you on your toes</li></ul>" },
  { name: 'Shewanella oneidensis', tag: 'mbshewa', description: "<p>Produces electricity! It usually is found under deep water, in a place containing iron oxides.</p><p>It needs a place that:</p><ul><li>gives you energy</li><li>contains metals</li><li>is wet</li></ul>" },
  { name: 'Bacillus subtilis', tag: 'mbbacs', description: "<p>Used as a probiotic, to treat used to treat asthma, cancer, depression,leprosy, psoriasis, dermatitis, eczema and tuberculosis. Found both in the human gut, and in soil! </p><p>In needs a place that: </p><ul><li>has harsh conditions</li><li>is fairly hot</li><li>cures what ails you</li></ul>" }
])
