# sCAKE-and-LAKE

R and Python (v 2.7) scripts for implementing sCAKE and LAKE method for single document keyword Extraction.

sCAKE: semantic Connectivity Aware Keyword Extraction
LAKE: Language-Agnostic Keyword Extraction

Author: Swagata Duari

Acknowledgement: Rakhi Saxena, Vasudha Bhatnagar

Description:
============

The algorithms rank all the candidate keywords and present the output in descending order of SCScore. and does not define the number of candidates to be extracted as keywords.
Thus the user have to decide on the number of extracted keywords. sCAKE is designed for languages with support of sohisticated NLP tools, like English. This impementation of sCAKE is aimed for English language only. However, interested users may apply the appropriate NLP tools, if available, for the language of their interest. Alternatively, the user may work with LAKE which can be applied on documents of any language.

Pipeline:
=========
1. Run 'create-position-info-<algo-name>.R' (replace <algo-name> with sCAKE or LAKE as required)
2. For LAKE, run 'compute-sigma-index.R'. Skip this for sCAKE.
3. Run 'create-graph-<algo-name>.R' (creates graphs according the mentioned algorithm)
4. For both algorithms, run 'Convert-adjmat-to-edgelist.R'
5. For both algorithms, run Python script 'InfluenceEvaluation.py' using following command:
        python InfluenceEvaluation.py '/path/to/input/directory/Edgelist/'
   (Reformatted and reused this script. The Author of python script is my collegue.)
6. For both algorithms, run 'Word-score-with-PostionWeight.R'
