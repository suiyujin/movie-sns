class AjaxTest < ActiveRecord::Base
  belongs_to :user
  attr_accessor :keywords
end
