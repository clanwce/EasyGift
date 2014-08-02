$( document ).ready(function() {

	// Pusher.log = function(message) {
 //    if (window.console && window.console.log) {
 //        window.console.log(message);
 //      }
 //    };

 //    var pusher = new Pusher('ae0c513bd7bc7a412781');
 //    var user_channel_name = 'user' + $('#user_navigation_bar').data('user-id') + '_channel';
 //    var user_channel = pusher.subscribe(user_channel_name);
 //    user_channel.bind('new_notification', function(data) {
 //    	addNotificationToNav(data);
 //    });

 //    function addNotificationToNav(data) {
 //    	$('#user_notification_ul').prepend("<a href='" + data["url"] +"' style='text-decoration:none;background:transparent;color:#333'><li data-id=" + data["user_notification_id"] + " class='new_notification' style='padding-left:20px;padding-right:20px;padding-bottom:30px;' ><div style='word-wrap:break-word;'> " + data["message"] + "</div></li></a><hr>");
 //    	new_count = $('#navigation_count').data("count") + 1;
 //    	$('#navigation_count').data("count", new_count);
 //    	$('#navigation_count').html(new_count);
 //    }

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

});