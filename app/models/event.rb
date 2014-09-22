class Event < ActiveRecord::Base
  has_many :users_events
  has_many :users, through: :users_events
end
