function onclickbttn(obj,likestatus)
{
	id= document.getElementById(obj);
	id= obj.id;
	var link = "/comments/"+id+"/"+likestatus;
	// alert(likestatus);

	if(likestatus == "like")
	{
	$.get( link, function() {
	})
	  .done(function(response) {

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

		$.each(response, function(index,value) {
		  $.each(value, function(k, v) {
			newText='<tr class="child"><td><div class="inline"><div style="background-color:#008080;width:45%"><img src="/images/user.png" width="80" heigth="80" class="inline"><button onclick="location.href=\'/users/'+k+'\'" class="inline btn" id="'+k+'">'+v+'</button></td></tr>';
	   		$('#disliketable tbody').append(newText);
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
		tag['authenticity_token'] = $('#authenticity_token').val();
		alert(tag['keyword']);		
	    $.ajax({
		    type: "POST",
		    url: "/tags/tag_search",
		    data: tag,
		    success: function(tags) {
				$.each(tags, function(index,value) {
				  $.each(value, function(k, v) {
						
		   		  });
				});
			},
		    error: function(response) {
		    	// /alert(response.responseText);
		    }
	    });	

}