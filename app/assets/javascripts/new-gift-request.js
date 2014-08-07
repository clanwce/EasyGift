 function cleartext()
 {
 	$("#whitelistkeyword").val("");
 	$("#blacklistkeyword").val("");
 }

var whitelist=[];
var blacklist=[];

$( document ).ready(function() {
	   $("#alluserscheckbox").change(function() {
	    if(this.checked) {
	    	$("#followerscheckbox").attr("disabled", true);
	    	$("#followingcheckbox").attr("disabled", true);
	    	$('#followerscheckbox').attr('checked', false); // Checks it
			$('#followingcheckbox').attr('checked', false); // Checks it
	    	$("#whitelistkeyword").val("");

	    	$("#whitelistkeyword").attr("disabled", true);
	        // alert('chech');
	    }
	    else
	    {
	    	// alert('not');
	    	$("#followerscheckbox").removeAttr("disabled");
	    	$("#followingcheckbox").removeAttr("disabled");
	    	$("#whitelistkeyword").removeAttr("disabled");
	    }
	});
});

function addusers(list,searchdiv, usersdiv,modaldiv)
{
	var selected_names = [];
	var selected_values = [];
	html = "";
	var flag=0;
	var inputElements = document.getElementById(searchdiv).getElementsByTagName("input");
	for(var i=0; i< inputElements.length; i++){
	      if(inputElements[i].checked){
	      	if(($.inArray(inputElements[i].value,whitelist)==-1) && ($.inArray(inputElements[i].value,blacklist)==-1))			
	      	{
		      	if(list=="whitelist")
				{
				whitelist.push(inputElements[i].value);				
				}
				else
				{
				blacklist.push(inputElements[i].value);				
				}

		      	selected_values.push(inputElements[i].value);
		      	selected_names.push(inputElements[i].name);
	      	}
	      	else
	      	{
	      		flag=1;
	      	}
	      }
	}
	if(flag==1)
	{
		alert('You cannot add same users in view and blocked list');
		return;
	}

	for(var i=0; i< selected_values.length; i++){
			html = html + "<tr>";
			html = html + "<td><label>";
	        html = html + "<div class='inline' name='"+selected_names[i]+"' id='"+selected_values[i]+"' >"+selected_names[i]+"</div>";
	        html = html + "</label></td></tr>";
	}
	$("#"+usersdiv).append(html);

	$(modaldiv).click();
}

function savechanges()
{

	if($('#followingcheckbox').prop('checked'))	
	{
		if(($.inArray($('#followingcheckbox').val(),whitelist)==-1))
		{
			whitelist.push($('#followingcheckbox').val());
		}		
	}

	if($('#followerscheckbox').prop('checked'))	
	{
		if(($.inArray($('#followerscheckbox').val(),whitelist)==-1))
		{
			whitelist.push($('#followerscheckbox').val());
		}		
	}

	if($('#alluserscheckbox').prop('checked'))	
	{
		if(($.inArray($('#alluserscheckbox').val(),whitelist)==-1))
		{
			whitelist.push($('#alluserscheckbox').val());
		}		
	}

	if(whitelist.length==0 && blacklist.length ==0)
	{
		alert("No privacy settings changed. Please add Users");
		return;
	}
	$("#white_list").val(whitelist);	
	$("#black_list").val(blacklist);


	// alert($("#black_list").val());
	// alert($("#white_list").val());	
	$("#mainmodalclose").click();
}

function onclickusersearch(div,key)
{
		var link = "/user/user_search";
		user = {};

		user['keyword'] = $('#'+key+'listkeyword').val();
		user['key']=key;
		user['authenticity_token'] = $('#new_gift_request_authenticity_token').val();
	    $.ajax({
		    type: "POST",
		    url: link,
		    data: user,
		    success: function(response) {
		    	users = response.users;
			  	key = response.key;
			  	html ="";
			  	$("#"+key+"usersearchtable").html("");
		    	if(users ==  null || users == "")
		    	{
		    		$("#"+key+"listerror").html("<h4>No User found</h4>");
		    		return false;
		    	}

				$.each(users, function(index,value) {
						html = html + "<tr><div class='checkbox'>";
						html = html + "<td><label>";
	            		html = html + "<input type='checkbox' name='"+value.username+"' value='"+value.id+"' >   "+value.username;
	            		html = html + "</label></td></div></tr>";

				});
				// alert(html);
				 $("#"+key+"usersearchtable").html(html);
		    	
			 },
		    error: function(response) {
	            // $('#custom_notice_container').html('<div id="note" align = "center" style="">' +
	            //                           '<div class="inline">' +                      
	            //                             '<p id="flash_alert">' + response.responseText + '</p>' +
	            //                           '</div>' +
	            //                         '</div>');
		    }
	    });	

}
