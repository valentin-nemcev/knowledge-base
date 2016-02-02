$('.article-revisions').replaceWith('<%=j render('revisions') %>')
$('.article-preview').html('<%=j @article.body_html %>')
