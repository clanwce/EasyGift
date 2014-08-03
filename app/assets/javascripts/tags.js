$( document ).ready(function() {

	var tags_on_page = [];
    

	$('#add_tag_to_gift_request').click(function(e) {
		e.preventDefault();
		tag = $('#autocomplete_tag').val().toLowerCase();
		create_tag_and_associate_to_gift_request(tag);
	});

	// $('.remove_tag_from_new_gift_request').click(function(e) {
	// 	e.preventDefault();
	// 	remove_tag_from_page(tag_name, e);
	// });

	$( document).on( "click", ".remove_tag_from_new_gift_request", function(e) {
		tag_name = $(this).data('tag');
		e.preventDefault();
		remove_tag_from_page(tag_name, e);
	});


	function create_tag_and_associate_to_gift_request(tag_name) {
		data = {}
		tag = {}
		tag['name'] = tag_name
		data['tag'] = tag
		data['authenticity_token'] = $('#new_gift_request_authenticity_token').val();
	    $.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/tags/create",
		    data: data,
		    success: function(response) {
		    	associate_tag_to_gift_request(response);
		    	$('#autocomplete_tag').val('');
		    }
	    });		
	}

	function associate_tag_to_gift_request(tag) {
		if(!is_tag_on_page(tag.name) && tags_on_page.length < 5) {
			tags_on_page.push(tag.name);
			$('#tag_holder').append('&nbsp;&nbsp;<p class="inline">' + tag.name + '(' + tag.gift_request_count + ')' + ' <button class="inline btn btn-danger glyphicon glyphicon-trash remove_tag_from_new_gift_request"  data-tag=' + tag.name + '></button></p>');
			//<input type="button" class="inline btn btn-danger glyphicon glyphicon-trash remove_tag_from_new_gift_request"  data-tag=' + tag.name + '>
		}
	}

	function is_tag_on_page(tag_name) {
		result = false;
		for(i=0; i<tags_on_page.length; i++) {
			if(tags_on_page[i] == tag_name) {
				result = true;
			}
		}
		return result;
	}

	function remove_tag_from_page(tag_name, e) {
		$(e.target).parent().remove();
		for(i=0; i<tags_on_page.length; i++) {
			if(tags_on_page[i] == tag_name) {
				tags_on_page.splice(i, 1);
			}
		}		
	}

	$('#create_gift_request_button').click(function(e) {
		e.preventDefault();
		data = {}
		gift_request = {}
		gift_request['user_id'] = $('#new_gift_request_current_user_id').val();
		gift_request['title'] = $('#new_gift_request_title').val();
		gift_request['description'] = $('#new_gift_request_description').val();
		gift_request['public']= $('#public').val();
		gift_request['black_list'] = $('#black_list').val();
		gift_request['white_list'] = $('#white_list').val();
		data['gift_request'] = gift_request;
		data['tags'] = tags_on_page;
		data['authenticity_token'] = $('#new_gift_request_authenticity_token').val();
	    $.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/gift_requests",
		    data: data,
		    success: function(gift_request) {
				window.location.replace('/gift_requests/' + gift_request.id);
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

	$('#edit_gift_request_button').click(function(e) {
		
		e.preventDefault();
		data = {}
		gift_request = {}
		id = $('#id_token').val();
		//gift_request['user_id'] = $('#new_gift_request_current_user_id').val();
		gift_request['title'] = $('#new_gift_request_title').val();
		gift_request['description'] = $('#new_gift_request_description').val();
		//gift_request['public']= $('input[name=gift_request_public]:checked', '#new_gift_request_form').val()
		data['id'] = id;
		data['gift_request'] = gift_request;
		data['authenticity_token'] = $('#new_gift_request_authenticity_token').val();
		 //alert(gift_request);
	    $.ajax({
		    type: "PUT",
		    dataType: 'json',
		    url: "/gift_requests/"+data['id'],
		    data: data,
		    success: function(response) {
		    	window.location.replace('/gift_requests/');
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
});