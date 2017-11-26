# sCAKE-and-LAKE

R Scripts for implementing sCAKE and LAKE method for single document keyword Extraction.

sCAKE: semantic Connectivity Aware Keyword Extraction
LAKE: Language-Agnostic Keyword Extraction

Author: Swagata Duari

pipeline-lake.R: The script contains the pipeline and instructions to execute LAKE method
pipeline-scake.R: The script contains the pipeline and instructions to execute sCAKE method

The algorithms rank all the candidate keywords and does not define as to how many candidates are to be extracted as keywords.
Thus the user have to decide on the number of extracted keywords. sCAKE is designed for languages with support of sohisticated NLP tools, like English. This impementation of sCAKE is aimed for English language only. However, interested users may apply the appropriate NLP tools, if available, for the language of their interest. Alternatively, the user may work with LAKE which can be applied on documents of any language.
