
# Header ------------------------------------------------------------------

# BD 3/13/2025
# render and move the .html file to docs 


# Render and move ---------------------------------------------------------

# input .qmd
in_qmd <- "./documentation/FEMA_report.qmd"

# output file and location 
out_html_final <- "./docs/"
new_name <- "index.html"

render_report <- function(x) {
  quarto::quarto_render(input = in_qmd)
  file.copy(from = "./documentation/FEMA_report.html", 
             to = paste0(out_html_final, new_name))
  file.remove("./documentation/FEMA_report.html")
}
# run
render_report()

