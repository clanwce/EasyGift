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
    });

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

 	function addMessageToConversation(data) {
 		pst_created = ConvertUTCTimeToLocalTime(data["created_at"]);
 		$('#conversation_list').append(
 			data["from"] + "<br>" + data["message"] + "===> Sent At:" + pst_created.format("MM-dd-yyyy") + "<br><br>"
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