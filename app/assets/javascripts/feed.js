
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

