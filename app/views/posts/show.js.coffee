$('#posts').prepend('<%= j render @post %>')

#clear post input after new post
$('#post_body').val('')