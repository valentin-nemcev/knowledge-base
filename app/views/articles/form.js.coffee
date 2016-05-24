$('.article-revisions').html('<%=j render("revisions", model: @article) %>')
$('.article-preview').html('<%=j render("article_contents") %>')
