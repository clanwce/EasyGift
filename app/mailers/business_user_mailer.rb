class BusinessUserMailer < ActionMailer::Base
  # # default from: "from@example.com"
  # def final_answer_notification(user)
  # 	recipients 	user.email
  # 	from		"easygift195@gmail.com"
  # 	subject		"New Business Opportunity!"
  # 	body		"#{user.name} is gay"
  # end
  default from: "easygift195@gmail.com"
  def final_answer_notification(user)
    @user = user
    mail(:to => user.email,
         :subject => "New Opportunity")
  end
end
