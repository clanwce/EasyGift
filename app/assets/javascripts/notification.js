$( document ).ready(function() {

	Pusher.log = function(message) {
      if (window.console && window.console.log) {
        window.console.log(message);
      }
    };

    var pusher = new Pusher('ae0c513bd7bc7a412781');
    var user_channel_name = 'user' + $('#user_navigation_bar').data('user-id') + '_channel';
    var user_channel = pusher.subscribe(user_channel_name);
    user_channel.bind('new_notification', function(data) {
    	addNotificationToNav(data);

    });

    function addNotificationToNav(data) {
    	$('#user_notification_ul').prepend("<a href='" + data["url"] +"' style='text-decoration:none;background:transparent;color:#333'><li data-id=" + data["user_notification_id"] + " class='new_notification' style='padding-left:20px;padding-right:20px;padding-bottom:30px;' ><div style='word-wrap:break-word;'> " + data["message"] + "</div></li></a><hr>");
    	new_count = $('#navigation_count').data("count") + 1;
    	$('#navigation_count').data("count", new_count);
    	$('#navigation_count').html(new_count);
    }

	// $('#user_notification_dropdown').on("click", function(e) {
	// 	ids = [];
	// 	$( ".new_notification" ).each(function( index ) {
	// 	  ids.push($(this).data("id"));
	// 	});
	// 	data = {};
	// 	data["ids"] = ids;
	// 	if(ids.length > 0) {
	// 		$.ajax({
	// 		    type: "POST",
	// 		    dataType: 'json',
	// 		    url: "/user_notifications/batch_read",
	// 		    data: data,
	// 		    success: function(response) {
	// 		    	//clean count & mark read
	// 		    	$( ".new_notification" ).each(function( index ) {
	// 					$(this).removeClass("new_notification");
	// 				});
	// 				$('#navigation_count').data("count", 0);
	// 				$('#navigation_count').html("");
	// 		    },
	// 			error: function(response) {
	// 		    	alert(response.responseText);
	// 		    }	    
	// 		});
	// 	}
	// });

	$('.new_notification').on("mouseover", function(e) {
		e.preventDefault();
		var li_element = $(this);
		var redirect_url = $(this).children()[0].href;
		data = {};
		data["id"] = $(this).data("id");
			$.ajax({
			    type: "POST",
			    dataType: 'json',
			    url: "/user_notifications/create",
			    data: data,
			    success: function(response) {
			    	//clean count & mark read
					li_element.removeClass("new_notification");
					new_count = $('#navigation_count').data("count") - 1;
	    			$('#navigation_count').data("count", new_count);
	    			if (new_count > 0) {
						$('#navigation_count').html(new_count);
					}
					else {
						$('#navigation_count').html("");
					}
					// window.location.replace(redirect_url);
			    },
				error: function(response) {
	            	$('#custom_notice_container').html('<div id="note" align = "center" style="">' +
	                                      '<div class="inline">' +                      
	                                        '<p id="flash_alert">' + response.responseText + '</p>' +
	                                      '</div>' +
	                                    '</div>');
			    }	    
			});
	});
	

    user_channel.bind('new_message', function(data) {
    	addMessageToConversation(data);
//do ajax call here, check if user is on window location '/conversations/id'

    });

    user_channel.bind('new_conv', function(data) {
    	addConvToList(data);
    });

    function addConvToList(data)
    {	
    	html = "";
    	if($("#conv_"+data['conv_id']).length > 0)
    	{
    		if($('#li_'+data['conv_id']).hasClass("new_conversation"))
    		{
    		}
    		else
    		{
    		new_count = parseInt($('#conversation_count').attr("data-count")) + 1;
			$('#conversation_count').attr("data-count", new_count);
			$('#conversation_count').html(new_count);
    		}
    		message = data["message"];
			if(data["message"].length >= 100)
				message = data["message"].substr(0, 100)+"...";

			lihtml=$('#li_'+data['conv_id']).html();
			$('#li_'+data['conv_id']).remove();
			lihtml = "<li>"+lihtml + "</li>";
			html = html + '<li id="li_'+data["conv_id"]+'" data-id="'+data["conv_id"] +'" class="new_conversation" style="padding-left:20px;padding-right:20px;padding-bottom:30px;">';
			html = html + '<div id="conv_'+data["conv_id"]+'" style="word-wrap:break-word;" > <b><a style="text-decoration:none;background:transparent;color:#333" href="/conversations/'+data["conv_id"]+'">';
			html = html + data["from"]+' </a></b>';
			html = html + '<div style="float:right" class="inline"><button id="button_conv_read_'+data["conv_id"]+'" onclick="return decider(\''+data["conv_id"]+'\');" class="glyphicon glyphicon-eye-open" style="background:none;padding: 0;border: none;">';
			html = html + '</button>&nbsp;&nbsp;<button onclick="return conversationunremove();" class="glyphicon glyphicon-remove-circle" style="background:none;padding: 0;border: none;"></button></div>';
			html = html + '<br>'+message+'</div></li>';

    		$('#conversation_ul').prepend(html);
    	}
    	else
    	{
    		message = data["message"];
			if(data["message"].length >= 100)
				message = data["message"].substr(0, 100)+"...";
			html = html + '<li id="li'+data["conv_id"]+'" data-id="'+data["conv_id"] +'" class="new_conversation" style="padding-left:20px;padding-right:20px;padding-bottom:30px;">';
			html = html + '<div id="conv_'+data["conv_id"]+'" style="word-wrap:break-word;" > <b><a style="text-decoration:none;background:transparent;color:#333" href="/conversations/'+data["conv_id"]+'">';
			html = html + data["from"]+' </a></b>';
			html = html + '<div style="float:right" class="inline"><button id="button_conv_read_'+data["conv_id"]+'" onclick="return decider(\''+data["conv_id"]+'\');" class="glyphicon glyphicon-eye-open" style="background:none;padding: 0;border: none;">';
			html = html + '</button>&nbsp;&nbsp;<button onclick="return conversationunremove();" class="glyphicon glyphicon-remove-circle" style="background:none;padding: 0;border: none;"></button></div>';
			html = html + '<br>'+message+'</div></li>';

			//loadmorecount ++;
	    	new_count = parseInt($('#conversation_count').attr("data-count")) + 1;
			$('#conversation_count').attr("data-count", new_count);
			$('#conversation_count').html(new_count);
    		
    		$('#conversation_ul').prepend(html);
    		// alert('not');
    	}
    }

    Date.prototype.format = function(format) //author: meizz
	{
	  var o = {
	    "M+" : this.getMonth()+1, //month
	    "d+" : this.getDate(),    //day
	    "h+" : this.getHours(),   //hour
	    "m+" : this.getMinutes(), //minute
	    "s+" : this.getSeconds(), //second
	    "q+" : Math.floor((this.getMonth()+3)/3),  //quarter
	    "S" : this.getMilliseconds() //millisecond
	  }

	  if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
	    (this.getFullYear()+"").substr(4 - RegExp.$1.length));
	  for(var k in o)if(new RegExp("("+ k +")").test(format))
	    format = format.replace(RegExp.$1,
	      RegExp.$1.length==1 ? o[k] :
	        ("00"+ o[k]).substr((""+ o[k]).length));
	  return format;
	}

    function ConvertUTCTimeToLocalTime(UTCDateString)
    {
        var convertdLocalTime = new Date(UTCDateString);

        var hourOffset = convertdLocalTime.getTimezoneOffset() / 60;

        convertdLocalTime.setHours( convertdLocalTime.getHours() + hourOffset ); 

        return convertdLocalTime;
    }

    function formatted_date(date) {
    	day = date.getDate();
    	month_number = date.getMonth() + 1;
    	year = date.getFullYear();
    	hour = date.getHours() % 12;
    	if(hour < 10) {
    		hour = "0" + hour;
    	}
    	minutes = date.getMinutes();
    	if(minutes < 10) {
    		minutes = "0" + minutes;
    	}
    	meridian = "AM";
    	if(date.getHours() > 12) {
    		meridian = "PM";
    	}
    	month = "Jan";
    	if(month_number == 2) {
    		month = "Feb";
    	}
    	else if(month_number == 3) {
    		month = "March";
    	}
    	else if(month_number == 4) {
    		month = "Mar";
    	}
    	else if(month_number == 5) {
    		month = "Apr";
    	}
    	else if(month_number == 6) {
    		month = "Jun";
    	}
    	else if(month_number == 7) {
    		month = "Jul";
    	}
    	else if(month_number == 8) {
    		month = "Aug";
    	}
    	else if(month_number == 9) {
    		month = "Sep";
    	}
    	else if(month_number == 10) {
    		month = "Oct";
    	}
    	else if(month_number == 11) {
    		month = "Nov";
    	}
    	else if(month_number == 12) {
    		month = "Dec";
    	}
    	return month + " " + day + ", " + year + " " + hour + ":" + minutes + " " + meridian;
    }

 	function addMessageToConversation(data) {
 		// $('#user_notification_ul').prepend("<a href='" + data["url"] +"' style='text-decoration:none;background:transparent;color:#333'><li data-id=" + data["user_notification_id"] + " class='new_notification' style='padding-left:20px;padding-right:20px;padding-bottom:30px;' ><div style='word-wrap:break-word;'> " + data["message"] + "</div></li></a><hr>");
   //  	new_count = $('#navigation_count').data("count") + 1;
   //  	$('#navigation_count').data("count", new_count);
   //  	$('#navigation_count').html(new_count);

 		pst_created = ConvertUTCTimeToLocalTime(data["created_at"]);
 		$('#conversation_list').append(
 			data["from"] + "<br>" + data["message"] + "===> Sent At: " + formatted_date(new Date(data["created_at"])) + "<br><br>"
 		);
 	}

 	$('#send_message_from_user_page_submit').click(function(e) {
		e.preventDefault();
		message = $('#send_message_from_user_page').val();
		user_to = $('#send_message_from_user_page').data('user-to');
		data = {};
		data['id'] = user_to;
		data['message'] = message;
		data['authenticity_token'] = $('#send_message_from_user_page_submit_authenticity_token').val();
	    $.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/conversations",
		    data: data,
		    success: function(response) {
				window.location.replace('/conversations/' + response.id);
		    },
		    error: function(response) {
		    	// $('#message_modal').modal('hide');
	            $('#custom_notice_container').html('<div id="note" align = "center" style="">' +
	                                      '<div class="inline">' +                      
	                                        '<p id="flash_alert">' + response.responseText + '</p>' +
	                                      '</div>' +
	                                    '</div>');
		    }
	    });	
	});

 	$('#conversation_message_submit').click(function(e) {
		e.preventDefault();
		message = $('#conversation_message').val();
		user_to = $('#conversation_message').data('user-to');
		data = {};
		data['id'] = user_to;
		data['message'] = message;
		data['authenticity_token'] = $('#send_message_from_converation_page_authenticity_token').val();
	    $.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/conversations",
		    data: data,
		    success: function(response) {
		    	$('#conversation_message').val('');
				// window.location.replace('/conversations/' + response.id);
		    },
		    error: function(response) {
		    	// $('#message_modal').modal('hide');
	            $('#custom_notice_container').html('<div id="note" align = "center" style="">' +
	                                      '<div class="inline">' +                      
	                                        '<p id="flash_alert">' + response.responseText + '</p>' +
	                                      '</div>' +
	                                    '</div>');
		    }
	    });	
	});

});