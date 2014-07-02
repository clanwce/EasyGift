$( document ).ready(function() {

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
		    	associate_tag_to_gift_request(response);
		    	$('#autocomplete_tag').val('');
		    }
	    });	
	});
	

});