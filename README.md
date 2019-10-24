# sCAKE-and-LAKE
[![DOI:10.1016/j.ins.2018.10.034](https://zenodo.org/badge/DOI/10.1016/j.ins.2018.10.034.svg)](https://doi.org/10.1016/j.ins.2018.10.034) [![Generic badge](https://img.shields.io/badge/Full%20Article-ScienceDirect-orange.svg)](http://www.sciencedirect.com/science/article/pii/S0020025518308521) [![Generic badge](https://img.shields.io/badge/Preprint-arXiv-orange.svg)](https://arxiv.org/pdf/1811.10831.pdf) [![made-with-r](https://img.shields.io/badge/Made%20with-R-blue.svg)](https://www.r-project.org/) [![made-with-Python](https://img.shields.io/badge/Made%20with-Python-blue.svg)](https://www.python.org/) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/SDuari/sCAKE-and-LAKE)

R and Python (v 2.7) scripts for implementing sCAKE and LAKE method for single document keyword Extraction.

sCAKE: semantic Connectivity Aware Keyword Extraction

LAKE: Language-Agnostic Keyword Extraction

Author: Swagata Duari

Acknowledgement: Rakhi Saxena, Vasudha Bhatnagar

Article DOI: https://doi.org/10.1016/j.ins.2018.10.034

Article Link: http://www.sciencedirect.com/science/article/pii/S0020025518308521, https://arxiv.org/pdf/1811.10831.pdf

Citation:
=========
```tex
@article{DUARI2019100,
        title = "sCAKE: Semantic Connectivity Aware Keyword Extraction",
        journal = "Information Sciences",
        volume = "477",
        pages = "100 - 117",
        year = "2019",
        issn = "0020-0255",
        doi = "https://doi.org/10.1016/j.ins.2018.10.034",
        url = "http://www.sciencedirect.com/science/article/pii/S0020025518308521",
        author = "Swagata Duari and Vasudha Bhatnagar",
        keywords = "Automatic Keyword Extraction, Text Graph, Semantic Connectivity, Parameterless, Language Agnostic"
}
```

Description:
============

The algorithms rank all the candidate keywords and present the output in descending order of SCScore. and does not define the number of candidates to be extracted as keywords.
Thus the user have to decide on the number of extracted keywords. sCAKE is designed for languages with support of sohisticated NLP tools, like English. This impementation of sCAKE is aimed for English language only. However, interested users may apply the appropriate NLP tools, if available, for the language of their interest. Alternatively, the user may work with LAKE which can be applied on documents of any language.

Pipeline:
=========
1. Run 'create-position-info-algoname.R' (replace 'algoname' with sCAKE or LAKE as required)
2. For LAKE, run 'compute-sigma-index.R'. Skip this for sCAKE.
3. Run 'create-graph-algoname.R' (creates graphs according the mentioned algorithm)
4. For both algorithms, run 'Convert-adjmat-to-edgelist.R'
5. For both algorithms, run Python script 'InfluenceEvaluation.py' using following command:
        
        python InfluenceEvaluation.py '/path/to/input/directory/Edgelist/'
   
   (Reformatted and reused this script. The Author of python script is my collegue.)
6. For both algorithms, run 'Word-score-with-PostionWeight.R'
