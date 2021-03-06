library("stringr")
library("ggplot2")
library("devtools")
load_all("../eQTLUtils/")


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
  dplyr::filter(hom_min_dist > 0.2)
write.table(best_matches, "metadata/BLUEPRINT/BLUEPRINT_mbv_best_match.txt", sep = "\t", quote = F, row.names = F)


a = mbv_results$S003P5B1_RNA
res = dplyr::transmute(a, mbv_genotype_id = SampleID, 
                       het_consistent_frac = n_het_consistent/n_het_covered, 
                       hom_consistent_frac = n_hom_consistent/n_hom_covered)
ggplot(res, aes(x = het_consistent_frac, y = hom_consistent_frac, label = mbv_genotype_id)) + geom_point() + geom_text()



#### GENCORD ####
#Get file names
mbv_files = list.files("processed/GENCORD/mbv/", full.names = T)

#Make sample names
sample_names = stringr::str_replace_all(basename(mbv_files), ".mbv_output.txt", "")
sample_list = setNames(mbv_files, sample_names)

#Import mbv files
mbv_results = purrr::map(sample_list, ~readr::read_delim(., delim = " ", col_types = "ciiiiiiiiii"))

#Find best matches
best_matches = purrr::map_df(mbv_results, mbvFindBestMatch, .id = "sample_id") %>%
  dplyr::filter(!is.na(het_consistent_frac))
write.table(best_matches, "metadata/GENCORD/GENCORD_mbv_best_match.txt", sep = "\t", quote = F, row.names = F)



#### Nedelec_2016 ####
#Get file names
mbv_files = list.files("processed/Nedelec_2016/mbv/", full.names = T)

#Make sample names
sample_names = stringr::str_replace_all(basename(mbv_files), ".mbv_output.txt", "")
sample_list = setNames(mbv_files, sample_names)

#Import mbv files
mbv_results = purrr::map(sample_list, ~readr::read_delim(., delim = " ", col_types = "ciiiiiiiiii"))

#Find best matches
best_matches = purrr::map_df(mbv_results, mbvFindBestMatch, .id = "sample_id") %>%
  dplyr::filter(!is.na(het_consistent_frac)) %>%
  dplyr::filter(het_consistent_frac > 0.75) %>%
  dplyr::filter(hom_consistent_frac > 0.8)
write.table(best_matches, "metadata/Nedelec_2016/Nedelec_2016_mbv_best_match.txt", sep = "\t", quote = F, row.names = F)


a = mbv_results$AF193_L2
res = dplyr::transmute(a, mbv_genotype_id = SampleID, 
                       het_consistent_frac = n_het_consistent/n_het_covered, 
                       hom_consistent_frac = n_hom_consistent/n_hom_covered)
ggplot(res, aes(x = het_consistent_frac, y = hom_consistent_frac, label = mbv_genotype_id)) + geom_point() + geom_text()



#### Quach_2016 ####
#Get file names
mbv_files = list.files("processed/Quach_2016/mbv/", full.names = T)

#Make sample names
sample_names = stringr::str_replace_all(basename(mbv_files), ".mbv_output.txt", "")
sample_list = setNames(mbv_files, sample_names)

#Import mbv files
mbv_results = purrr::map(sample_list, ~readr::read_delim(., delim = " ", col_types = "ciiiiiiiiii"))

#Find best matches
best_matches = purrr::map_df(mbv_results, mbvFindBestMatch, .id = "sample_id") %>%
  dplyr::filter(!is.na(het_consistent_frac))
write.table(best_matches, "metadata/Quach_2016/Quach_2016_mbv_best_match.txt", sep = "\t", quote = F, row.names = F)


a = mbv_results$SZTCLWMSGW_2
res = dplyr::transmute(a, mbv_genotype_id = SampleID, 
                       het_consistent_frac = n_het_consistent/n_het_covered, 
                       hom_consistent_frac = n_hom_consistent/n_hom_covered)
ggplot(res, aes(x = het_consistent_frac, y = hom_consistent_frac, label = mbv_genotype_id)) + geom_point() + geom_text()


#### TwinsUK ####
#Get file names
mbv_files = list.files("processed/TwinsUK/mbv/", full.names = T)

#Make sample names
sample_names = stringr::str_replace_all(basename(mbv_files), ".mbv_output.txt", "")
sample_list = setNames(mbv_files, sample_names)

#Import mbv files
mbv_results = purrr::map(sample_list, ~readr::read_delim(., delim = " ", col_types = "ciiiiiiiiii"))

#Find best matches
best_matches = purrr::map_df(mbv_results, mbvFindBestMatch, .id = "sample_id") %>%
  dplyr::filter(!is.na(het_consistent_frac)) %>%
  dplyr::filter(het_consistent_frac > 0.9) %>%
  dplyr::filter(het_min_dist > 0.4)
write.table(best_matches, "metadata/TwinsUK/TwinsUK_mbv_best_match.txt", sep = "\t", quote = F, row.names = F)

a = mbv_results$TWPID3509_F
res = dplyr::transmute(a, mbv_genotype_id = SampleID, 
                       het_consistent_frac = n_het_consistent/n_het_covered, 
                       hom_consistent_frac = n_hom_consistent/n_hom_covered)
ggplot(res, aes(x = het_consistent_frac, y = hom_consistent_frac, label = mbv_genotype_id)) + geom_point() + geom_text()
