$( document ).ready(function() {

  // You probably don't want to use globals, but this is just example code
  var fbAppId = '563804037067616';

  /*
   * This is boilerplate code that is used to initialize
   * the Facebook JS SDK.  You would normally set your
   * App ID in this code.
   */

  // Additional JS functions here
  window.fbAsyncInit = function() {
    FB.init({
      appId      : fbAppId, // App ID
      status     : true,    // check login status
      cookie     : true,    // enable cookies to allow the
                            // server to access the session
      xfbml      : true,     // parse page for xfbml or html5
                            // social plugins like login button below
      version        : 'v2.0',  // Specify an API version
    });

    // Put additional init code here
  };

  // Load the SDK Asynchronously
  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));

  /*
   * This function makes a call to the og.likes API.  The
   * object argument is the object you like.  Other types
   * of APIs may take other arguments. (i.e. the book.reads
   * API takes a book= argument.)
   *
   * Because it's a sample, it also sets the privacy
   * parameter so that it will create a story that only you
   * can see.  Remove the privacy parameter and the story
   * will be visible to whatever the default privacy was when
   * you added the app.
   *
   * Also note that you can view any story with the id, as
   * demonstrated with the code below.
   *
   * APIs used in postLike():
   * Call the Graph API from JS:
   *   https://developers.facebook.com/docs/reference/javascript/FB.api
   * The Open Graph og.likes API:
   *   https://developers.facebook.com/docs/reference/opengraph/action-type/og.likes
   * Privacy argument:
   *   https://developers.facebook.com/docs/reference/api/privacy-parameter
   */

  function popupCenter(url, width, height, name) {
    var left = (screen.width/2)-(width/2);
    var top = (screen.height/2)-(height/2);
    wndw = window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
    // link = $('#hacky_facebook_fix');
    // link.href = url;
    // link.target = name; 
    // link.click(); 
  }

  $("a.popup").click(function(e) {
    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
    e.stopPropagation(); return false;
  });

//    $('.facebook_login_button').on('click', function(e) {
//       FB.login(function(response) {
//        if (response.authResponse) {

//        } else {
//          console.log('User cancelled login or did not fully authorize.');
//        }
//       });
//     // var src = $(this).attr('data-src');
//     // var height = $(this).attr('data-height') || 300;
//     // var width = $(this).attr('data-width') || 400;
    
//     // $("#myModal iframe").attr({'src':src,
//     //                     'height': height,
//     //                     'width': width});
// });

  function post_gift_request(gift_request_id) {
    uri = window.location.href;
    encoded_uri = encodeURI(uri);
    image = "https://dl.dropboxusercontent.com/u/70856403/gift.png";
    image_uri = encodeURI(image);
    FB.api(
      'me/easy-gift:post',
      'post',
      {
        "gift_request": gift_request_id,
        "fb:explicitly_shared": true
      },
      function(facebook_response) {
         if (!facebook_response) {
           alert('Error occurred.');
         } else if (facebook_response.error) {
             // alert('Facebook share error: ' + facebook_response.error.message);
            if(facebook_response.error.code == 2500) {
              $('#notice').html("Please connect to facebook first");
              $('#facebook_login_button').removeAttr('style');
              // popupCenter($('#facebook_login_url').data("url"), 600, 400, "authPopup");
              // shareGiftRequest();
            }
            else {
              alert('Facebook share error: ' + facebook_response.error.message);
            }
         } else {
            $('#custom_notice_container').html('<div id="note" align = "center" style="">' +
                                                      '<div class="inline">' +                      
                                                        '<p id="flash_alert">Shared with facebook</p>' +
                                                      '</div>' +
                                                    '</div>');
         }
      }
    );
  }

  function shareGiftRequest(e) {
    uri = window.location.href;
    encoded_uri = encodeURI(uri);
    image = "https://dl.dropboxusercontent.com/u/70856403/gift.png";
    image_uri = encodeURI(image);
    FB.api(
      'me/objects/easy-gift:gift_request',
      'post',
      {
        object: {"app_id":563804037067616,
        "url": encoded_uri,
        "title":$('#gift_request_title').data('title'),
        "image": image_uri,
        "fb:explicitly_shared": true}
      },
      function(facebook_response) {
           if (!facebook_response) {
             alert('Error occurred.');
           } else if (facebook_response.error) {
               // alert('Facebook share error: ' + facebook_response.error.message);
              if(facebook_response.error.code == 2500) {
                $('#custom_notice_container').html('<div id="note" align = "center" style="">' +
                                                      '<div class="inline">' +                      
                                                        '<p id="flash_alert">Please connect to facebook first</p>' +
                                                      '</div>' +
                                                    '</div>');
                $('#facebook_login_button').removeAttr('style');
                // popupCenter($('#facebook_login_url').data("url"), 600, 400, "authPopup");
                // shareGiftRequest();
              }
              else {
                alert('Facebook share error: ' + facebook_response.error.message);
              }
           } else {
              post_gift_request(facebook_response.id);
           }
      }
    );
  }

	$('#facebook_share').click(function(e) {
		e.preventDefault();
		shareGiftRequest(e);
	});

});