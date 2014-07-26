
// Type : like / dislike
// algo: comment/ gift request
// algoid: comment id / request id
// userid: userid

function postlikedislike(obj)
{
	document.getElementById(obj).submit();

		// var link = "/likes/create";
		// like = {};data={};
		// var a = algo+"userid";
		// var b = algo+"giftrequest_id";
		// var c = algo+"status";

		// like['user_id'] = document.getElementById(a).value;
		// like['gift_request_id'] = document.getElementById(b).value;
		// like['status']= document.getElementById(c).value;
		// data['authenticity_token'] = $('#authenticity_token').val();
		// data['like']=like;

	 //    $.ajax({
		//     type: "POST",
		//     url: link,
		//     data: data,
		//     success: function(resp) {
		//     	alert(resp.responseText);

		// 	},

		//     error: function(response) {
		//     	alert(response.responseText);
		//     }
	 //    });	

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