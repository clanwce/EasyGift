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
      //var newtext = document.createTextNode("new text");
  //     	var spanXyz = document.getElementById("notify");
		// //spanXyz.appendChild(newtext);
		// // var elem = document.getElementById('notify');
		// // var li =document.createElement("li");
		// // var p = document.createTextNode(data.message);
		// alert(data);
		// // li.appendChild(p);
		// $("#notify").append("<li>" + data.message + "</li><hr>");
		// // elem.insertBefore(li, elem.getElementsByTagName("li")[0]);
		// setTimeout(function() {

		// 	$("#notify").empty();
		// 	// var li = $("#notify").closest('li')
		// 	// li.fadeOut('slow', function() { li.empty(); });
		// }, 5000);
    	addNotificationToNav(data);

    });

    function addNotificationToNav(data) {
    	$('#user_notification_ul').prepend("<li data-id=" + data["user_notification_id"] + " class='new_notification' ><a href='" + data["url"] + "'>" + data["message"] + "</a></li><hr>");
    	new_count = $('#navigation_count').data("count") + 1;
    	$('#navigation_count').html(new_count);
    }

	$('#user_notification_dropdown').on("click", function(e) {
		e.preventDefault();
		ids = [];
		$( ".new_notification" ).each(function( index ) {
		  ids.push($(this).data("id"));
		});

		data = {};
		data["ids"] = ids;
		$.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/user_notifications/batch_read",
		    data: data,
		    success: function(response) {
		    	//clean count & mark read
		    	$( ".new_notification" ).each(function( index ) {
					$(this).removeClass("new_notification");
				});
				$('#navigation_count').html("");
		    }
	    });
	});
	

});