
var loadmorecount = 0;
function loadmoreconversations()
{
	var data = {};
	var link = "/loadmore/conversations";
		data['count']=loadmorecount;
		// alert(data['count']);
		data['authenticity_token'] = $('#authenticity_token').val();
	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	html = "";
		    	 $.each(resp.unreadlist, function(k, v) {

						if (typeof(v["id"]) != "undefined")
			    	 	{
			    	 		var message = v["last_message"];
			    	 		if(v["last_message"].length >= 100)
			    	 		message = v["last_message"].substr(0, 100)+"...";
			    	 	html = html + '<li id="li_'+v["id"]+'"  data-id="'+v["id"] +'" class="new_conversation" style="padding-left:20px;padding-right:20px;padding-bottom:30px;">';
			    	 	html = html + '<div id="conv_'+v["id"]+'" style="word-wrap:break-word;" > <b><a style="text-decoration:none;background:transparent;color:#333" href="/conversations/'+v["id"]+'">';
			    	 	html = html + v["username"]+' </a></b>';
			    	 	html = html + '<div style="float:right" class="inline"><button id="button_conv_unread_'+v["id"]+'" onclick="return decider(\''+v["id"]+'\');" class="glyphicon glyphicon-eye-open" style="background:none;padding: 0;border: none;">';
			    	 	html = html + '</button>&nbsp;&nbsp;<button onclick="return conversationunremove();" class="glyphicon glyphicon-remove-circle" style="background:none;padding: 0;border: none;"></button></div>';
			    	 	html = html + '<br>'+message+'</div></li>';
						loadmorecount ++;
						}

					});

		    	 $.each(resp.readlist, function(k, v) {
			    	 	if (typeof(v["id"]) != "undefined")
			    	 	{	
			    	 		var message = v["last_message"];
			    	 		if(v["last_message"].length >= 100)
			    	 		message = v["last_message"].substr(0, 100)+"...";
			    	 	html = html +  '<li id="li_'+v["id"]+'"  data-id="'+v["id"] +'" class="" style="padding-left:20px;padding-right:20px;padding-bottom:30px;">';
			    	 	html = html + '<div id="conv_'+v["id"]+'" style="word-wrap:break-word;" > <b><a style="text-decoration:none;background:transparent;color:#333" href="/conversations/'+v["id"]+'">';
			    	 	html = html + v["username"]+' </a></b>';
			    	 	html = html + '<div style="float:right" class="inline"><button id="button_conv_read_'+v["id"]+'" onclick="return decider(\''+v["id"]+'\');" class="glyphicon glyphicon-eye-open" style="background:none;padding: 0;border: none;">';
			    	 	html = html + '</button>&nbsp;&nbsp;<button onclick="return conversationunremove();" class="glyphicon glyphicon-remove-circle" style="background:none;padding: 0;border: none;"></button></div>';
			    	 	html = html + '<br>'+message+'</div></li>';
						loadmorecount ++;
						}
					});

		    	 var button = $('#conversation_ul li').last().html();
		    	 button = "<li>"+button +"</li>";
		    	 // alert(html);
		    	 $('#conversation_ul li').last().remove();
		    	 $('#conversation_ul').append(html);
		    	 $('#conversation_ul').append(button);

			},

		    error: function(response) {
		    	alert('error');
		    	alert(responseText.responseText);
		    }
	    });	
}

function decider(conversation_id)
{
	if($( '#li_'+conversation_id).hasClass( "new_conversation"))
	{
		mark_read(conversation_id);
	}
	else
	{
		mark_unread(conversation_id);
	}
}

function mark_unread(conversation_id){
		token = $('#authenticity_token').val();
		data = {};
		data['id']=conversation_id;
		data['authenticity_token'] = token;
		$.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/conversations/mark_as_unread",
		    data: data,
		    success: function(response) {
		    	// alert(response.flag);
		    	if(response.flag)
		    	{
			    	$('#li_'+conversation_id).addClass("new_conversation");
			    	new_count = parseInt($('#conversation_count').attr("data-count")) + 1;
			    	$('#conversation_count').attr("data-count", new_count);
			    	$('#conversation_count').html(new_count);
		    	}
		    },
		    error: function(response) {
		    	alert('System Error: Cannot mark conversation as unread at this time.');
		    }
	    });	
	}

function mark_read(conversation_id){
		token = $('#authenticity_token').val();
		data = {};
		data['id']=conversation_id;
		data['authenticity_token'] = token;
		$.ajax({
		    type: "POST",
		    dataType: 'json',
		    url: "/conversations/mark_as_read",
		    data: data,
		    success: function(response) {
		    	// alert(response.flag);
		    	if(response.flag)
		    	{
			    	$('#li_'+conversation_id).removeClass("new_conversation");
			    	new_count = parseInt($('#conversation_count').attr("data-count")) - 1;
			    	// alert(new_count);
			    	if(new_count>0)
			    	{
			    	$('#conversation_count').html(new_count);
			    	}
			    	else
			    	{
			    	$('#conversation_count').html("");			    		
			    	}
			    	$('#conversation_count').attr("data-count", new_count);
		    	}
		    },
		    error: function(response) {
		    	alert('System Error: Cannot mark conversation as unread at this time.');
		    }
	    });	
	}
