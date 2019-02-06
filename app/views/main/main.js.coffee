$('#posts .data').append('<%= j render @posts %>')
$('#pagination').html('<%= j will_paginate @posts %>')
<% unless @post.next_page %>
$('#pagination').remove()
<% end %>
window.loading = false