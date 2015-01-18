function y = umbralizacion_adaptativa(x)

	y = im2bw(x,graythresh(x));