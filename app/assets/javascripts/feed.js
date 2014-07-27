
// Type : like / dislike
// algo: comment/ gift request
// algoid: comment id / request id
// userid: userid

//function postlikedislike(obj)
function postlikedislike(type,algo,algoid, userid)
{
	//document.getElementById(obj).submit();

		var link = "/likes/feed/create";
		like = {};data={};
		var a = type+"_userid";
		var b = type+"_giftrequest_id";
		var c = type+"_status";
		like['user_id'] = document.getElementById(a).value;
		like['gift_request_id'] = document.getElementById(b).value;
		like['status']= document.getElementById(c).value;
		data['authenticity_token'] = $('#authenticity_token').val();
		data['like']=like;
		// alert(algoid);
		// return false;
	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	
		    	alert(resp.temp.status);
		    	$( "#note" ).html("");
		    	$( "#note" ).html("<p>like</p>");
		    	// document.getElementById('note').style.paddingTop='10px';
		    	// document.getElementById("note").innerHTML = "<p>like</p>";
		    	//$( "#note" ).html("");
		    	
		    	//var obj = JSON.parse(resp);

		    	//alert(obj.name);

			},

		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	

}

function onclickbttnfeed(obj,likestatus)
{
	id= document.getElementById(obj);
	id= obj.id;
	var link = "/comments/"+id+"/"+likestatus;
	newText="";

	if(likestatus == "like")
	{
	$.get( link, function() {
	})
	  .done(function(response) {
	  	newText="";
	  	$('#likecommenttable').html("");
		$.each(response, function(index,value) {
		  $.each(value, function(k, v) {
			newText='<tr class="child"><td><div class="inline"><div style="background-color:#008080;width:45%"><img src="/images/user.png" width="80" heigth="80" class="inline"><button onclick="location.href=\'/users/'+k+'\'" class="inline btn" id="'+k+'">'+v+'</button></td></tr>';
	   		$('#likecommenttable').append(newText);
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
	  	$('#dislikecommenttable').html("");
		$.each(response, function(index,value) {
		  $.each(value, function(k, v) {
			newText='<tr class="child"><td><div class="inline"><div style="background-color:#008080;width:45%"><img src="/images/user.png" width="80" heigth="80" class="inline"><button onclick="location.href=\'/users/'+k+'\'" class="inline btn" id="'+k+'">'+v+'</button></td></tr>';
	   		$('#dislikecommenttable').append(newText);
		  });
		});
	  })
	  .fail(function(data) {
	    //alert( data );
	  })

	}
}