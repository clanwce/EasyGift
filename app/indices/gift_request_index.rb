ThinkingSphinx::Index.define :gift_request, :with => :real_time do #:with => :active_record do #:with => :real_time do
#:with => :active_record do
  # fields
  indexes title
  indexes description

  # attributes
  #has created_at, :type => :datetime
end