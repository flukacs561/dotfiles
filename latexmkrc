$pdflatex = "pdflatex -halt-on-error %O %S && cp %D %R.pdf";
$pdf_mode = 1;
$postscript_mode = $dvi_mode = 0;
$preview_continuous_mode = 1;

$view = 'none';
$recorder = 1;