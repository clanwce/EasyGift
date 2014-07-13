$( document ).ready(function() {

	var tags_on_page = [];
    

	$('#add_tag_to_gift_request').click(function(e) {
		e.preventDefault();
		create_tag_and_associate_to_gift_request($('#autocomplete_tag').val());
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
	    $.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/tags/create?authenticity_token="+ $('#new_gift_request_authenticity_token').val(),
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
			$('#tag_holder').append('<p class="inline">' + tag.name + '(' + tag.gift_request_count + ')' + '  <input type="button" class="inline btn  remove_tag_from_new_gift_request" value="Remove" data-tag=' + tag.name + '> </p>');
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
		gift_request['public']= $('input[name=gift_request_public]:checked', '#new_gift_request_form').val()
		data['gift_request'] = gift_request;
		data['tags'] = tags_on_page;
	    $.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/gift_requests?authenticity_token=" + $('#new_gift_request_authenticity_token').val(),
		    data: data,
		    success: function(response) {
				FB.api(
				  'me/objects/easy-gift:gift_request',
				  'post',
				  {
				    object: {"app_id":563804037067616,"url":"http:\/\/samples.ogp.me\/331257847005141","title":"\"Sample Opinion\"","image":"https:\/\/s-static.ak.fbcdn.net\/images\/devsite\/attachment_blank.png","description":"\"\""}
				  },
				  function(response) {
				    // handle the response
				  }
				);
		    	
		  //   	FB.api(
				//   'me/objects/easy-gift:gift_request',
				//   'post',
				//   {
				//     app_id: 563804037067616,
				//     encodeURI(uri);
				//     // type: "easy-gift:gift_request",
				//     url: "/gift_requests/' + response.id",
				//     title: gift_request['title']
				//   },
				//   function(response) {
			 //         if (!response) {
			 //           alert('Error occurred.');
			 //         } else if (response.error) {
			 //             alert('Facebook share error: ' + response.error.message);
			 //         } else {
			 //         	alert(response.id);
			 //         	window.location.replace('/gift_requests/' + response.id);
			 //         }
				//   }
				// );
		    },
		    error: function(response) {
		    	alert(response.responseText);
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
		 //alert(gift_request);
	    $.ajax({
		    type: "PUT",
		    dataType: 'json',
		    url: "/gift_requests/"+data['id']+"?authenticity_token="+ $('#new_gift_request_authenticity_token').val(),
		    data: data,
		    success: function(response) {
		    	window.location.replace('/gift_requests/');
		    },
		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	
	});
});