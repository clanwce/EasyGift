function onclickbttn(obj,likestatus)
{
	id= document.getElementById(obj);
	id= obj.id;
	var link = "/comments/"+id+"/"+likestatus;
	newText="";
	// alert(likestatus);

	if(likestatus == "like")
	{
	$.get( link, function() {
	})
	  .done(function(response) {
	  	newText="";
	  	$('#liketable').html("");
		$.each(response, function(index,value) {
		  $.each(value, function(k, v) {
			newText='<tr class="child"><td><div class="inline"><div style="background-color:#008080;width:45%"><img src="/images/user.png" width="80" heigth="80" class="inline"><button onclick="location.href=\'/users/'+k+'\'" class="inline btn" id="'+k+'">'+v+'</button></td></tr>';
	   		$('#liketable').append(newText);
	   		// alert(newText);
		  });
		});
	  })
	  .fail(function(data) {
	    //alert( data );
	  })

	}
	else
	{
	$.get( link, function() {
	})
	  .done(function(response) {
	  	newText="";
	  	$('#disliketable').html("");
		$.each(response, function(index,value) {
		  $.each(value, function(k, v) {
			newText='<tr class="child"><td><div class="inline"><div style="background-color:#008080;width:45%"><img src="/images/user.png" width="80" heigth="80" class="inline"><button onclick="location.href=\'/users/'+k+'\'" class="inline btn" id="'+k+'">'+v+'</button></td></tr>';
	   		$('#disliketable').append(newText);
		  });
		});
	  })
	  .fail(function(data) {
	    //alert( data );
	  })

	}
}

function onclicktagsearch()
{
		var link = "/tags/tag_search";
		data = {};
		tag = {};

		tag['keyword'] = $('#autocomplete_tag').val();
		if(tag['keyword']=="" || tag['keyword'] == null)
		{
			$("#divcontainer").html("<h4>No input given</h4>");
			return false;
		}

		tag['authenticity_token'] = $('#authenticity_token').val();
	    $.ajax({
		    type: "POST",
		    url: "/tags/tag_search",
		    data: tag,
		    success: function(tags) {
		    	$("#divcontainer").html("");
		    	var html = "<h4> Tag search for: &nbsp;<strong>"+$('#autocomplete_tag').val();
		    	var html = html + "</strong></h4><br><div class='table-responsive' style='background-color:white; padding-left:120px;'><table class='table'><br><tr>";
		     		
		    	i = 0;
		    	if(tags ==  null || tags == "")
		    	{
		    		$("#divcontainer").html("<h4>No tag found</h4>");
		    		return false;
		    	}
				$.each(tags, function(index,value) {

						if(i==4)
						{
							i==0;
	        				html = html + "</tr><tr>";
						}
						var id = value['id'];
						var tagname = value['name'];
						html = html + "<td class='tag-cell'><div class='excerpt'><h4 class='inline'>";
	            		html = html + "<a href='/tags/"+id+ "'"+"class='label label-info inline'>"+tagname+"</a></h4> x";
	            		html = html + " " +value['gift_request_count'] + "</div></td>";
	              		i++;

				});
				html = html + "</tr></table></div>";
				$("#divcontainer").html(html);
		    	
			},
		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	

}


function unfollow(userid, otherid)
{
		var link = "/unfollow/"+userid;
		data = {};

		data['id'] = userid;
		data['otherid'] = otherid;
		data['authenticity_token'] = $('#authenticity_token').val();
		// alert(data['authenticity_token']);

	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	location.reload();

			},
		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	

}

function follow(userid, otherid)
{
	var link = "/follow";
		data = {};

		data['id'] = userid;
		data['otherid'] = otherid;
		data['authenticity_token'] = $('#authenticity_token').val();
		// alert(data['authenticity_token']);

	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	location.reload();
			},
		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	
}