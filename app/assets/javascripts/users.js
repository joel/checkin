// $(document).ready(function() {
// 	jQuery.each($("p.checkin"), function (){
// 		var p_checkin_id = $(this).attr('id');
// 		var intervalID = window.setInterval(function() { 
// 			$.getJSON("/users/" + p_checkin_id + "/checkin_label.json",
// 				function(data) {
// 					console.debug ("/users/" + p_checkin_id + "/checkin_label.json")
// 					if (data.treated == 1) {
// 						console.debug ("ok " + data.treated + " update field #" + data.user_id)
// 						$("#" + data.user_id).html(data.checkin_label);
// 						// $("#" + data.user_id).effect("highlight", {}, 3000); // jQuery UI seems not to be load correctly :-/
// 						$("#" + data.user_id).addClass("highlight").delay(3000).removeClass("highlight");
// 						clearInterval(intervalID);
// 						console.debug ('interval end')
// 					}
// 					else {
// 						console.debug (data.treated)
// 					}
// 				})
// 			}, 5000)
// 	}) 
// });