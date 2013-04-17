module ApplicationHelper

  # on setup, load instagram photos
  @@next_load_instagram = Time.new(0)

  def self.next_load_instagram
    @@next_load_instagram
  end

  def self.finished_instagram_load
    @@next_load_instagram = Time.now + 10.minutes
  end

end
