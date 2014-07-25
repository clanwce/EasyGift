
// Type : like / dislike
// algo: comment/ gift request
// id: comment id / request id
// 
function postlikedislike(type, algo, )
{
	//document.getElementById("likeform").submit();

		var link = "/likes/create";
		like = {};data={};
		a = document.getElementById("like_userid").value;
		b = document.getElementById("like_giftrequest_id").value;
		c = document.getElementById("like_status").value;
		
		like['user_id'] = a;
		like['gift_request_id'] = b;
		like['status']= c
		data['authenticity_token'] = $('#authenticity_token').val();
		data['like']=like;

	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	alert("done");

			},
			
		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	

}

