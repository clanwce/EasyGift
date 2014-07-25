class BusinessUserMailer < ActionMailer::Base
  # default from: "from@example.com"
  def final_answer_notification(user)
  	recipients 	user.email
  	from		"easygift195@gmail.com"
  	subject		"New Business Opportunity!"
  	body		:user => user
  end
end
