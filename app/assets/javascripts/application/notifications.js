function FBOptin(userHasFacebookAccount, appID) {
  this.userHasFacebookAccount = userHasFacebookAccount
  this.appID = appID
}

FBOptin.prototype.init = function() {
  var self = this
  $(document).on('turbolinks:load', function(event){
    self.removeFacebook()
  });

  jQuery(function() {
    if (! this.userHasFacebookAccount) {
      $(".m_optin-facebook-checkbox").on("change", function() {
        if ($(this).is(':checked')) {
          loadFacebookIntoPage();
          $(".modal").modal("show");
        }
      })
    }

    $("body").on("hidden.bs.modal", function(e) {
      self.removeFacebook()
    })
  })

  function loadFacebookIntoPage () {
    window.fbAsyncInit = function() {
      fbInit()
      FB.Event.subscribe('send_to_messenger', function(e) {
        if (e.event === "opt_in") {
          $("form").submit()
        }
       });
    };

    (function(d, s, id){
       var js, fjs = d.getElementsByTagName(s)[0];
       if (d.getElementById(id)) {return;}
       js = d.createElement(s); js.id = id;
       js.src = "//connect.facebook.net/en_US/sdk.js";
       fjs.parentNode.insertBefore(js, fjs);
     }(document, 'script', 'facebook-jssdk'));
  }

  function fbInit() {
    FB.init({
      appId      : this.appID,
      xfbml      : true,
      version    : 'v2.6'
    });
  }
}

FBOptin.prototype.removeFacebook = function () {
  $("#fb-root").remove()
  $("#facebook-jssdk").remove()
  FB = null
}

