# Help Tab Content
div(
  id = "tab-help", class = "tab-content", style = "display: none;",
  tags$div(id = "help-content-container"),
  tags$script("
    $(document).ready(function() {
      if (typeof getAboutOrdinContent === 'function') {
        $('#help-content-container').html(getAboutOrdinContent());
      }
    });
  ")
)
