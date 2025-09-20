for i in *.jpg *.png; do convert $i -quality 50% $i-50p.jpg; done;
