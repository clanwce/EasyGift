function unsubscribedtag(tagid)
{
		var link = "/b2b/tags/unsubscribe";
		data={};
		data['tag_id']=tagid;
		data['authenticity_token'] = $('#authenticity_token').val();

	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	if(resp.flag==true)
		    	$("#tag"+resp.id).remove();
		    	else
		    	{
		    	$("#note").html("");
		    	$("#note").html("<p>Error occurred. Refresh the page and try again. Otherwise, Contact the administrator!!!</p>");
		    	document.getElementById('note').style.paddingTop='10px';
		    	window.setInterval(function(){$("#note").html("");}, 5000);
		    	}
			},

		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	

}

function subscribedtag(tagid, buttonname)
{
		var link = "/b2b/tags/subscribe";
		data={};
		data['tag_id']=tagid;
		// alert(data['tag_id']);
		// return false;
		// alert('h');
		data['authenticity_token'] = $('#authenticity_token').val();

	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	// alert(resp.id);
		    	if(resp.flag==true)
		    	{
		    	$("#pbutton"+resp.id).remove();
			    $("#nbutton"+resp.id).remove();
			    $("#nnbutton"+resp.id).remove();
				}
		    	else
		    	{
		    	$("#note").html("");
		    	$("#note").html("<p>Error occurred. Refresh the page and try again. Otherwise, Contact the administrator!!!</p>");
		    	document.getElementById('note').style.paddingTop='10px';
		    	window.setInterval(function(){$("#note").html("");}, 5000);
		    	}
			},

		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	

}

function upgradeuser()
{
		if(document.getElementById('upgradecheckbox').checked)
		{
		var link = "/b2b/upgrade";
		data={};
		data['authenticity_token'] = $('#authenticity_token').val();

	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	if(resp.flag==true)
		    	    location.reload();
			},
		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	
	    }
	    else
	    {
	    	alert("Kindly agree to the agreement first");
	    	return false;
	    }
}

function downgradeuser()
{
		if(document.getElementById('downgradecheckbox').checked)
		{
		var link = "/b2b/downgrade";
		data={};
		data['authenticity_token'] = $('#authenticity_token').val();

	    $.ajax({
		    type: "POST",
		    url: link,
		    data: data,
		    success: function(resp) {
		    	if(resp.flag==true)
		    	    location.reload();
			},
		    error: function(response) {
		    	alert(response.responseText);
		    }
	    });	
	    }
	    else
	    {
	    	alert("Kindly agree to the terms and agreement first");
	    	return false;
	    }
}