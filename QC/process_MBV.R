library("stringr")
library("ggplot2")
library("devtools")
load_all("../seqUtils/")


#### GEUVADIS ####
#Get file names
mbv_files = list.files("processed/GEUVADIS/mbv/", full.names = T)

#Make sample names
sample_names = stringr::str_replace_all(basename(mbv_files), ".mbv_output.txt", "")
sample_list = setNames(mbv_files, sample_names)

#Import mbv files
mbv_results = purrr::map(sample_list, ~readr::read_delim(., delim = " ", col_types = "ciiiiiiiiii"))

#Find best matches
best_matches = purrr::map_df(mbv_results, mbvFindBestMatch, .id = "sample_id") %>%
  dplyr::filter(!is.na(het_consistent_frac)) %>%
  dplyr::filter(het_consistent_frac > 0.9)
write.table(best_matches, "metadata/GEUVADIS/GEUVADIS_mbv_best_match.txt", sep = "\t", quote = F, row.names = F)


#### Fairfax ####
#Get file names
mbv_files = list.files("processed/Fairfax/mbv/", full.names = T)

#Make sample names
sample_names = stringr::str_replace_all(basename(mbv_files), ".mbv_output.txt", "")
sample_list = setNames(mbv_files, sample_names)

#Import mbv files
mbv_results = purrr::map(sample_list, ~readr::read_delim(., delim = " ", col_types = "ciiiiiiiiii"))

#Find best matches
best_matches = purrr::map_df(mbv_results, mbvFindBestMatch, .id = "sample_id") %>%
  dplyr::filter(!is.na(het_consistent_frac)) %>%
  dplyr::filter(het_consistent_frac > 0.9)
write.table(best_matches, "../Fairfax_monocytes/data/metadata/Fairfax_mbv_best_match.txt", sep = "\t", quote = F, row.names = F)


#### BLUEPRINT ####
#Get file names
mbv_files = list.files("processed/BLUEPRINT//mbv/", full.names = T)

#Make sample names
sample_names = stringr::str_replace_all(basename(mbv_files), ".mbv_output.txt", "")
sample_list = setNames(mbv_files, sample_names)

#Import mbv files
mbv_results = purrr::map(sample_list, ~readr::read_delim(., delim = " ", col_types = "ciiiiiiiiii"))

#Find best matches
best_matches = purrr::map_df(mbv_results, mbvFindBestMatch, .id = "sample_id") %>%
  dplyr::filter(!is.na(het_consistent_frac)) %>%
  dplyr::filter(het_consistent_frac > 0.9)
write.table(best_matches, "../Fairfax_monocytes/data/metadata/Fairfax_mbv_best_match.txt", sep = "\t", quote = F, row.names = F)


a = mbv_results$S003Q3B1_mRNA
res = dplyr::transmute(a, mbv_genotype_id = SampleID, 
                       het_consistent_frac = n_het_consistent/n_het_covered, 
                       hom_consistent_frac = n_hom_consistent/n_hom_covered)
ggplot(res, aes(x = het_consistent_frac, y = hom_consistent_frac, label = mbv_genotype_id)) + geom_point() + geom_text()