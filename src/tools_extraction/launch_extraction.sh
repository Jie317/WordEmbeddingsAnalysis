 #! usr/bin/bash
 echo "A shell to extract the specific sentences or paragrahs from wiki dump html file. Please run this shell with following parameters:
 
 	[1] path of the original dump file of wikipedia
 	[2] path of the result file ()
 	[3] extract by sentence or by paragraph?
 	put 0 to extract sentences, put 1 to extract paragraphs
 	
 	* Please note that the parameters of filter are available in the following line which starts with the variable FILTER. The bacslash and pipe should be kept between two words.
 "
 FILTER='fragrance\|smell\|aroma\|aura\|balm\|bouquet\|essence\|fragrance\|incense\|odorize\|perfume\|pheromone\|redolence\|whiff\|stench\|stink\|deodorize\|doggy\|lemon\|lemony\|lilac\|lime\|mildewed\|mint\|minty\|moldy\|pine\|plastic\|rose\|skunky\|woodsy\|acid\|acrid\|airy\|biting\|clean\|crisp\|dirty\|earthy\|faint\|feminine\|fetid\|fishy\|fresh\|floral\|flowery\|light\|loamy\|masculine\|moist\|musty\|nauseating\|perfumed\|pungent\|putrid\|rancid\|redolent\|repulsive\|rotten\|sharp\|sour\|spicy\|spoiled\|stale\|stinking\|sweaty\|sweet\|tart\|wispy\|taste\|tastes\|odor\|odour\|flavour\|flavor\|osmyl'
 
 echo "Remove tags in xml file >>>"
 
 init=$1
 mid1=corpus_markupRe.txt
 mid2=corpus_markupRm_spl.txt
 mid3=corpus_markupRm_spl_tokenized.txt
 mid4=corpus_markupRm_spl_tokenized_punct_Rm.txt
 final=$2
 
 sed -e 's/<[^>]*>//g' init > $mid1
 if $3 == 0; then
 	echo "Detect sentences (One sentence per line) >>>"
 	python sentenceDetector.py $mid1 $mid2
 	
 	echo "Tokenize sentences (lowcase words replace numbers with 0s) >>>"
 	java -cp tools_extraction/stanford-corenlp.jar edu.stanford.nlp.process.PTBTokenizer -preserveLines $mid2 >  $mid3
 	
 	echo "Remove punctuations >>>"
 	cat $mid3 | tr -d '[:punct:]' > $mid4
 	
 	echo "Apply the filter >>>"
	echo -e "The filter is:\n\t"$FILTER
	grep -w "$FILTER"  $mid4 > $2 
fi


 if $3 == 1; then
 	echo "Apply the filter >>>"
	echo -e "The filter is:\n\t"$FILTER
	grep -w "$FILTER"  $mid4 > $2 
	
 	echo "Detect sentences (One sentence per line) >>>"
 	python sentenceDetector.py $mid1 $mid2
 	
 	echo "Tokenize sentences (lowcase words replace numbers with 0s) >>>"
 	java -cp tools_extraction/stanford-corenlp.jar edu.stanford.nlp.process.PTBTokenizer -preserveLines $mid2 >  $mid3
 	
 	echo "Remove punctuations >>>"
 	cat $mid3 | tr -d '[:punct:]' > $mid4
fi

rm $mid1 $mid2 $mid3 $mid4

exit


