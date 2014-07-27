class BusinessUserMailer < ActionMailer::Base
  # # default from: "from@example.com"
  # def final_answer_notification(user)
  # 	recipients 	user.email
  # 	from		"easygift195@gmail.com"
  # 	subject		"New Business Opportunity!"
  # 	body		"#{user.name} is gay"
  # end
  default from: "easygift195@gmail.com"
  def final_answer_notification(user, post)
    @user = user
    @post = post
    @poster = post.user
    mail(:to => user.email,
         :subject => "New Business Opportunity from Easy Gift")
  end
end
