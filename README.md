# GeoGameRails

Make your own location-based game with Ruby on Rails, Postgres, and Heroku. Keeps a list of players, their Instagram photos, and their scores.

<img src="http://i.imgur.com/l7VL1Fh.png"/>

## Origin

GeoGameRails is a generic fork of <a href="http://microboundaries.com/about">MicroBoundaries</a>.

## Concepts

* A <strong>Category</strong> is a special item which users are trying to collect or photograph. You should specify a memorable #hashtag for each Category.

* An <strong>Instagram User</strong> is any Instagram user who adds your game's #hashtags to public, geolocated photos.

* An <strong>Instagram Photo</strong> is any public, geotagged photo with your game's #hashtags. They are scored by the moment when they are scraped 

## Customization

### Add Categories

In /db/seeds.rb, replace categories <strong>test1</strong> and <strong>test2</strong> with your own categories. Use the same format:

    { name: 'Test One', tag: 'test1', description: "<p>Write a description here.</p><ul><li>use text</li><li>use HTML</li></ul>" },

In /app/assets/images/, put two images with each category's tag: TAGNAME-sm.png and TAGNAME.png

The name, hashtag, and description of this category appear several times on the site.

The categories will be created as part of running:

    rake db:setup

### Change Scoring

The score of a photo is calculated in /app/helpers/application_helper.rb. Look for

    def self.score_of( latlng, category_type, own_id=nil )

The scoring currently is based on an Instagram Photo's distance to the nearest photo in the same category ( units are miles ).

If you're more familiar with other languages, notice that Ruby implies a "return" of the last statement. For example, this function returns 10:

    def returns_10
      not_returned = 1
      not_returned
      10
    end

This function must return a number giving the score of this photo. The number can be 0.

### Value of Likes in Scoring

Likes are added to the score of recent photos in /app/helpers/application_helper.rb.

If you don't like this, remove or comment out these two blocks of code:

    unless photo.likes.nil?
      puts "adding likes: " + photo.likes.to_s
      score = score + photo.likes
    end

and

    if known_photo.likes != photo.likes[ :count ]
      if known_photo.likes != photo.likes[ :count ]
        known_photo.score = known_photo.score + photo.likes[ :count ] - known_photo.likes
      end
      known_photo.likes = photo.likes[ :count ]
      puts "adjusted to " + photo.likes[ :count ].to_s
      known_photo.save!
    end

### Enable Continuous Re-Scoring

One feature of MicroBoundaries is the ability for future photos to affect your previous photos' score.

You can re-enable this in /app/helpers/application_helper.rb by replacing 

    # recalculate_scores
    finished_instagram_load

with

    recalculate_scores
    finished_instagram_load

## Setting up GeoGameRails

### Local install

Download the code

    git clone git://github.com/mapmeld/geo-game-rails.git
    cd geo-game-rails

Install the gems

    bundle install

PostgreSQL must be installed and initialized. Set up the database for GeoGameRails:

    rake db:setup

Use an editor to create a .env file and specify an Instagram API token. At this time you do not need OAuth to read photos by tag, but you must <a href="http://instagram.com/developer/">get an API key</a> tied to your application.

    nano .env
    instagram_token = "your_instagram_api_key"

### Hosting on Heroku

Create an app with a cool new name. Type its name in place of APP_NAME.

    heroku create APP_NAME

Push your code online to the app

    git push heroku master --app APP_NAME

Initialize the database

    heroku run rake db:setup

Start looking for photos and view the homepage (the first load will take several seconds)

    heroku open --app APP_NAME